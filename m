Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55723341605
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 07:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhCSGit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 02:38:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233756AbhCSGia (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 02:38:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2B0764F6E;
        Fri, 19 Mar 2021 06:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616135909;
        bh=WReteb2mCylWusAoTA8szB/y6Qt2E2GZ2/ED476EScY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lFxSb+v7lajn1iZEpoxQY8+KE98fsREmDgQBnE4AAoVlJ41wU+a8ftARuwtCQujHo
         2KN3DTR/b42JyuFm6D07DEmFOeJKeN8D7q8NZs8FG6uoz7GgzopZ6tbka4NzOSaquT
         AvyTmCWug8Unr+Hr36NZS4O7YBRqb3PdxSHsvk/s=
Date:   Fri, 19 Mar 2021 07:38:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Isaku Yamahata <isaku.yamahata@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, brijesh.singh@amd.com,
        tglx@linutronix.de, bp@alien8.de, isaku.yamahata@gmail.com,
        thomas.lendacky@amd.com,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] X86: __set_clr_pte_enc() miscalculates physical address
Message-ID: <YFRG4maiL0CeFhGM@kroah.com>
References: <81abbae1657053eccc535c16151f63cd049dcb97.1616098294.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81abbae1657053eccc535c16151f63cd049dcb97.1616098294.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 01:26:57PM -0700, Isaku Yamahata wrote:
> __set_clr_pte_enc() miscalculates physical address to operate.
> pfn is in unit of PG_LEVEL_4K, not PGL_LEVEL_{2M, 1G}.
> Shift size to get physical address should be PAGE_SHIFT,
> not page_level_shift().
> 
> Fixes: dfaaec9033b8 ("x86: Add support for changing memory encryption attribute in early boot")
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/mm/mem_encrypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
