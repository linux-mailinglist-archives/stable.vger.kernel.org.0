Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59013F28B3
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 10:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhHTIxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 04:53:10 -0400
Received: from 8bytes.org ([81.169.241.247]:37976 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231992AbhHTIxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 04:53:10 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id CB105309; Fri, 20 Aug 2021 10:52:31 +0200 (CEST)
Date:   Fri, 20 Aug 2021 10:52:26 +0200
From:   'Joerg Roedel' <joro@8bytes.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/efi: Restore Firmware IDT in before
 ExitBootServices()
Message-ID: <YR9tSuLyX8QHV5Pv@8bytes.org>
References: <20210820073429.19457-1-joro@8bytes.org>
 <e43eb0d137164270bf16258e6d11879e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e43eb0d137164270bf16258e6d11879e@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 08:43:47AM +0000, David Laight wrote:
> Hmmm...
> If Linux needs its own IDT then temporarily substituting the old IDT
> prior to a UEFI call will cause 'grief' if a 'Linux' interrupt
> happens during the UEFI call.

This is neede only during very early boot before Linux called
ExitBootServices(). Nothing that causes IRQs is set up by Linux yet. Of
course the Firmware could have set something up, but Linux runs with
IRQs disabled when on its own IDT at that stage.

Regards,

	Joerg
