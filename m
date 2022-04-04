Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D114F16AD
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 16:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355979AbiDDOEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 10:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358744AbiDDOEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 10:04:44 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676CB3335E;
        Mon,  4 Apr 2022 07:02:48 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id F11D132008FD;
        Mon,  4 Apr 2022 10:02:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 04 Apr 2022 10:02:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=6KOpj6HHf7ZdB/fmMbJ1eNtVMkAmnCG9g1i8uG
        nnAxw=; b=Ep8uRukAD+PvFuRP3HUgmxLUnNuZN+8on28NTktsQbQoBO7NYQRStn
        4ObvWEk4uma4CE/Dua8gmWTsQJPjkLm8bsyRbBfD5xK8TKWz5GdLN9Nx6dhdfjxP
        mKIPJ4NEPKR8posPN7ZtH+wNTZmMso3evm6X8o1ejBg2lDel1SDG1bIB+acdVgN5
        B65u9hLpb69+Y3vwBNiv+TFdOyeMEl0oC/5/CDkTc52t3MbTMaUl5w9L19tqlF2o
        xHYrdFfj9fr6vBO4xK7ym/Fd1vLNoqjArqTeVl9xSLfM3RsUPCxIz+u1epbYFPQW
        hESgvNX7vtemhvZt1/4tiVcsUmRJYN0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6KOpj6HHf7ZdB/fmM
        bJ1eNtVMkAmnCG9g1i8uGnnAxw=; b=gmxdqIrmKPq6asef4ARj1i7AgGlEko5ri
        RKq3hc9S0d3GmTbBA18cdqEVwDRIRPEI3IBqEv5obDTEL3x81ySRxjcxAkwpTxaV
        DV8lxEMZ7Dqz/y+V62F4Wwa+7OMgp29Ej6EGVLHSUcpl58/S/U0fL1uoaAK4kRf8
        Wwz/em2nYSFLuZZV1N0bMtpagGyUufTjoxvV25BFy5RfdNQIzChjIM7qukM/Tg6e
        zJr0LI5LXOmOPXoz/erlrc0NLszRwhp/pfU2ykrLtn5DGy+PxFm2sX9PQFwMmLOv
        h0deFPurXdqM3HNIkR1kQzMaUer4EwiQ2hPC+rVvWHFHOrG5jK9Jg==
X-ME-Sender: <xms:g_pKYtTK17tecqsSQJLT5t0OoMnwrwcNrieVtSbaj2SnAqINQ9e0Wg>
    <xme:g_pKYmzwgfal3FN8e1yqwT8MRM7c1e3ZltWv-H7VB4uQWoJyC1fY5bdDjlQk--VT-
    WFkGLPc0AgK4w>
X-ME-Received: <xmr:g_pKYi2-RPbaLRzpPTkLW2YG1nIo817xfEjVCx-9zlw07xB485126jt0QKzvh3WvFtfoPH6zcnE47M_MC2YZBWONtMaUjJ5M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudejvddgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:g_pKYlDTgDqR65f_Sjjk4S3U8SHqaS-r-Ku-XTWWCUEF5iVOij2z2Q>
    <xmx:g_pKYmidtxAWOyQTUm5B6Ka2UsoXJ8pIlmvN4n4kjEMojHo75nhKgQ>
    <xmx:g_pKYpoRYOJnQ50UemFTIv44MIEcWshECIxFBmQTt3Bak65YXNS17w>
    <xmx:hPpKYvaLNvfa1nFKM1pA96u2Mwj9eN1F1fpe9qr2MgTJtVUaFXiV8A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Apr 2022 10:02:42 -0400 (EDT)
Date:   Mon, 4 Apr 2022 16:02:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Qiuhao Li <qiuhao@sysec.org>,
        Gaoning Pan <pgn@zju.edu.cn>, Yongkang Jia <kangel@zju.edu.cn>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 5.4] KVM: x86/mmu: do compare-and-exchange of gPTE via
 the user address
Message-ID: <Ykr6gA6o+oLqDXMi@kroah.com>
References: <20220404134141.427397-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404134141.427397-4-pbonzini@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 09:41:41AM -0400, Paolo Bonzini wrote:
> commit 2a8859f373b0a86f0ece8ec8312607eacf12485d upstream.
> 
> FNAME(cmpxchg_gpte) is an inefficient mess.  It is at least decent if it
> can go through get_user_pages_fast(), but if it cannot then it tries to
> use memremap(); that is not just terribly slow, it is also wrong because
> it assumes that the VM_PFNMAP VMA is contiguous.
> 
> The right way to do it would be to do the same thing as
> hva_to_pfn_remapped() does since commit add6a0cd1c5b ("KVM: MMU: try to
> fix up page faults before giving up", 2016-07-05), using follow_pte()
> and fixup_user_fault() to determine the correct address to use for
> memremap().  To do this, one could for example extract hva_to_pfn()
> for use outside virt/kvm/kvm_main.c.  But really there is no reason to
> do that either, because there is already a perfectly valid address to
> do the cmpxchg() on, only it is a userspace address.  That means doing
> user_access_begin()/user_access_end() and writing the code in assembly
> to handle any exception correctly.  Worse, the guest PTE can be 8-byte
> even on i686 so there is the extra complication of using cmpxchg8b to
> account for.  But at least it is an efficient mess.
> 
> Reported-by: Qiuhao Li <qiuhao@sysec.org>
> Reported-by: Gaoning Pan <pgn@zju.edu.cn>
> Reported-by: Yongkang Jia <kangel@zju.edu.cn>
> Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
> Debugged-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/paging_tmpl.h | 77 ++++++++++++++++++--------------------
>  1 file changed, 37 insertions(+), 40 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 97b21e7fd013..13b5c424adb2 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -34,9 +34,8 @@
>  	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
>  	#ifdef CONFIG_X86_64
>  	#define PT_MAX_FULL_LEVELS 4
> -	#define CMPXCHG cmpxchg
> +	#define CMPXCHG "cmpxchgq"
>  	#else
> -	#define CMPXCHG cmpxchg64
>  	#define PT_MAX_FULL_LEVELS 2
>  	#endif
>  #elif PTTYPE == 32
> @@ -52,7 +51,7 @@

This chunk does not apply, are you sure you made this against 5.4.y?

thanks,

greg k-h
