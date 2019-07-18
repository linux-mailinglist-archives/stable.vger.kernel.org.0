Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D11606C3DC
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 02:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbfGRArI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 20:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbfGRArI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 20:47:08 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50209217F4;
        Thu, 18 Jul 2019 00:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563410828;
        bh=W75bCKZNMgpUlO+V+opZiBCph5GTZ6ObUVcMIHF/NkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MuqZ1hdyNcp2wA0D3+/Pg9o8mYORG7g0K6HNTysmfymA35uJH9+qa68CxtuUZbPzU
         XX8XkGbz5PVwwBFZWjfrZdEoD97D98qZZq88OffMU6dzNLtxx5EtpdgViqnj0cwTXW
         wo9JPYbqADfbInEGyafrxvyGZUYKuEtHOr4VfRlk=
Date:   Thu, 18 Jul 2019 09:47:05 +0900
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/purgatory: add -mno-sse, -mno-mmx, -mno-sse2 to
 Makefile
Message-ID: <20190718004705.GA31085@kroah.com>
References: <20190718000206.121392-1-vaibhavrustagi@google.com>
 <20190718000206.121392-2-vaibhavrustagi@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718000206.121392-2-vaibhavrustagi@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 05:02:05PM -0700, Vaibhav Rustagi wrote:
> Compiling the purgatory code with clang results in using of mmx
> registers.
> 
> $ objdump -d arch/x86/purgatory/purgatory.ro | grep xmm
> 
>      112:	0f 28 00             	movaps (%rax),%xmm0
>      115:	0f 11 07             	movups %xmm0,(%rdi)
>      122:	0f 28 00             	movaps (%rax),%xmm0
>      125:	0f 11 47 10          	movups %xmm0,0x10(%rdi)
> 
> Add -mno-sse, -mno-mmx, -mno-sse2 to avoid generating SSE instructions.
> 
> Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> ---
>  arch/x86/purgatory/Makefile | 1 +
>  1 file changed, 1 insertion(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
