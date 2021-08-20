Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380703F2810
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 10:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhHTIC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 04:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhHTICR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 04:02:17 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AAFC061575;
        Fri, 20 Aug 2021 01:01:40 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id BE13D309; Fri, 20 Aug 2021 10:01:38 +0200 (CEST)
Date:   Fri, 20 Aug 2021 10:01:37 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Uros Bizjak <ubizjak@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fabio Aiuto <fabioaiuto83@gmail.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/efi: Restore Firmware IDT in before
 ExitBootServices()
Message-ID: <YR9hYdsZgUylR/ur@8bytes.org>
References: <20210820073429.19457-1-joro@8bytes.org>
 <CAMj1kXGTxt8Ln58F9dNb-Jkzhvj-RRXrPZmoeNZ4dguhvrx=iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGTxt8Ln58F9dNb-Jkzhvj-RRXrPZmoeNZ4dguhvrx=iQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 09:41:12AM +0200, Ard Biesheuvel wrote:
> On Fri, 20 Aug 2021 at 09:34, Joerg Roedel <joro@8bytes.org> wrote:
> 
> Acked by: Ard Biesheuvel <ardb@kernel.org>

Thanks.
> 
> > -       subq    $32, %rsp
> > +       subq    $64, %rsp
> 
> Any reason in particular for the increase by 32?

Just wanted it to be a power of two, like before. Before it was 32
bytes, of which 30 were used. Now its 64, of which 40 are used.

Regards,

	Joerg
