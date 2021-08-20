Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04043F2A06
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 12:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238857AbhHTKUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 06:20:36 -0400
Received: from 8bytes.org ([81.169.241.247]:38046 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232572AbhHTKUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 06:20:36 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 0BD9F309; Fri, 20 Aug 2021 12:19:56 +0200 (CEST)
Date:   Fri, 20 Aug 2021 12:19:50 +0200
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
Message-ID: <YR+Bxgq4aIo1DI8j@8bytes.org>
References: <20210820073429.19457-1-joro@8bytes.org>
 <e43eb0d137164270bf16258e6d11879e@AcuMS.aculab.com>
 <YR9tSuLyX8QHV5Pv@8bytes.org>
 <f68a175362984e4abbb0a1da2004c936@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f68a175362984e4abbb0a1da2004c936@AcuMS.aculab.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 09:02:46AM +0000, David Laight wrote:
> So allocate and initialise the Linux IDT - so entries can be added.
> But don't execute 'lidt' until later on.

The IDT is needed in this path to handle #VC exceptions caused by CPUID
instructions. So loading the IDT later is not an option.

Regards,

	Joerg
