Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4682A3EDC22
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 19:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhHPRPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 13:15:01 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:43095 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229699AbhHPRPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 13:15:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B238D32009DE;
        Mon, 16 Aug 2021 13:14:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Aug 2021 13:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=/HTlGkabB/BIP39T99zfZW3JtPz
        6MwBmR5jcO/la8Ag=; b=uZA9QiFsFlFRmD9lNbwTiKaOQICBhx+g2a/gwCHLx/K
        RCXfYAIcWeQGoN+fUS2SWtrt5Bfq+1cV99622LtqSsfcCoR/WJCIslJSbfNG+LJU
        tpqE+cATfiZuVXMgNb1gQxUnSRJ4Ju2AAt9Q3XX+h60/IUJZdNE1NLIvxvg64dcO
        GVvET4rSm92crSNz1jxM9b1sexj+LK2or6uKblQNgJTz8U0Um4cxf/WTaCjx0zb1
        cXQLZHgYEKv1o4CmdAZ2RXH41nGJQYmP4SjaoZ+VdyuVuJI9jO8LtG0ayoLSzGXd
        LO6/loHuxwg+r0U5QDWApDwFsP688QTWctBe7auVt/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/HTlGk
        abB/BIP39T99zfZW3JtPz6MwBmR5jcO/la8Ag=; b=swfP3RJ6I9pcCRB/hhAV8e
        JEeyxE0Cs6NPCvvFZhui8MIgr5e3hBnGOxhNwJxLoMjJyolEbFwWyH+2LBvV/igB
        JQ1sKqm/cG5+zIZ8cxPW1Joe1kjWrWd1+Phrr6QhUjKv5GRekTgGUvL4kbArc4ur
        a8IJTQbIPJC4AqR5FvSwtcmQ2zB8aau/V9lmGvmYZxnZESWpzjna3aG5Ys2ccI/t
        zzHbFK7hJjRqEJmpOA6dS8a+EhAzPGDys71ajPJRNcBaT5Eroa3TTCMDOPcyTA2W
        IEjVeDyKeVowONgkJp8SDZR0RTjSh0iZiGdrxbjMKYFcj1BHpSW5XRV+kq/L7wSQ
        ==
X-ME-Sender: <xms:9JwaYaNY3EeGzpXZSJl4GkoQ3YzKpt8TC9xJihkxpfCIAjO6VmnFEg>
    <xme:9JwaYY9LrughdHE3DRLjO84DORNXnJUe1rp7kL7aUmT8chwx2mHvzWlXbkXX8AUAr
    wGSFEm3dJEp0Q>
X-ME-Received: <xmr:9JwaYRT-TEuMw7UQxfCyMYATVrKpSnefaZlwvqwWHCDEyRbwd4hDgzMUX3ahPHrRM5IQrXioVOeyENKtd6PHF0m6FvhVIdp->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrledugdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:9JwaYauSYROPea-Djp_AYTc6hi_69pbad0Z876r715FzKkY58FkCfg>
    <xmx:9JwaYSfZOKbZ8FGSXDT3beeP8e-ftoA3JoKfiNj7q2ufQdpJWAfqGw>
    <xmx:9JwaYe0bKFwM88miRyUsuc9QQTYYQ7jXQxadf4tuK22Hg21wIh-IPQ>
    <xmx:9JwaYZyTR5Fn_vSKM5qrJLTejpOENhu8drGiotrfRLo0-saA8MJc7A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Aug 2021 13:14:27 -0400 (EDT)
Date:   Mon, 16 Aug 2021 19:14:20 +0200
From:   Greg KH <greg@kroah.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 5.4.y] KVM: nSVM: always intercept VMLOAD/VMSAVE when
 nested (CVE-2021-3656)
Message-ID: <YRqc7IUh6CLa2TkU@kroah.com>
References: <20210816140240.11399-12-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816140240.11399-12-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 04:02:40PM +0200, Paolo Bonzini wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ upstream commit c7dfa4009965a9b2d7b329ee970eb8da0d32f0bc ]
> 
> If L1 disables VMLOAD/VMSAVE intercepts, and doesn't enable
> Virtual VMLOAD/VMSAVE (currently not supported for the nested hypervisor),
> then VMLOAD/VMSAVE must operate on the L1 physical memory, which is only
> possible by making L0 intercept these instructions.
> 
> Failure to do so allowed the nested guest to run VMLOAD/VMSAVE unintercepted,
> and thus read/write portions of the host physical memory.
> 
> Fixes: 89c8a4984fc9 ("KVM: SVM: Enable Virtual VMLOAD VMSAVE feature")
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	The above upstream SHA1 is still on its way to Linus
> 
>  arch/x86/kvm/svm.c | 3 +++
>  1 file changed, 3 insertions(+)

5.4, 5.10, and 5.13 versions now queued up and I'll do a new -rc release
with them in it.  I'll get to the others after dinner...

thanks,

greg k-h
