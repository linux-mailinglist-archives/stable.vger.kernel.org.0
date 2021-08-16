Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B87F3ED925
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 16:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhHPOrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 10:47:36 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:55023 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhHPOrd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 10:47:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 03B1B3200956;
        Mon, 16 Aug 2021 10:46:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 16 Aug 2021 10:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=gngd3q55EZGSZShx/0MxyaGo89J
        meeFQa5pogUBe51Q=; b=sBT3Wtti2e4yh9J/SvPUEj2iHJP2xD6ScrhDXtRmwK/
        tXqIFrFRv0rwf13mjZsgmkxS9SgIld/FQWBBiXG1tMDC81OIFdNUd2tW+3kKYr9y
        S2U4sdJgRvL/TSxgccwfZlImc6Yj0rquMXmN4+rxLLVMSrT1PLQTaf15aVTLx+vI
        X1IdS4oXqFJCH/ShWJc0JabzT1cpiOZnqF1BG8Fq2EpVhSSJOOmkObDmGV+yUEuw
        h7XeaBHz3Fj+5WgZKODFHCdFTBZfn/hYrlba7DL3HOq9xRIAmBVXMZCkLkr6eC1q
        NzTlj21g5d4mkfjlvKuBmi70fmTMZyn0t5gpaDI3rTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=gngd3q
        55EZGSZShx/0MxyaGo89JmeeFQa5pogUBe51Q=; b=umenRCFM5dI0JnNRZ14i/R
        qZ+7A+VC7ceZbev9AgYgMwsh4n2YcQyCywVNyprzx9fqP33rtEYUQQ9pbes5gQMF
        zmgassAnNsvlY5IziWmUsCgMeVpU0epOmM6U6xhFm9nOgMKk9Tve4kYeiD+q7BVr
        BwYBf4DvF/9K1/j2y95QxxRVtWnJPXhayaeqNQE7uiApudHrBo5oIGQm1O4pF3Z6
        Orxkxgyz3z6Ptt8TKmcnNc7oX7VDVB9h2adMDdpht8KenuLFZpmV5XSU1jO24vRb
        U1uCmGs3DDV88tVeMco7Vb7eHduYIY+8qJ9QzVhq7F8R8YufRscsdB0RlV8x48TQ
        ==
X-ME-Sender: <xms:YXoaYZfgsPpTBRlNgi02JYqSb2pJe-tJL8HteFDLQ5Loo9QxywEUZQ>
    <xme:YXoaYXNmQexK8dR_yewaw-75Bn28iRXx_0YGHWI_qkZK1rF_dznxqsGe9PKshY-9_
    Ty3zxzWKnPsIQ>
X-ME-Received: <xmr:YXoaYShJSH3r6SC7GVYG2mzLWhRv1L0dqbF88l6Ki55uI2cc4N3jyJ0QkYw402dWGf24z_xHInKh60ifmDbR0EA-ODqXX04J>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrledugdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:YXoaYS-CRK9CbeIhnan93MaGpa6wwTrmS2EfA0xLT3gTTxIxtusLpg>
    <xmx:YXoaYVtsuS48VWCVwLKPFfcoSLbXXc-wbPLnUIqkvpuyY_3IDPIq0g>
    <xmx:YXoaYRGBF8uKQFCKW1dDbA0nHoTyEkEXYViRK7GFkD1yoCJfeKC_Mg>
    <xmx:YXoaYbDLu72TugndILg6E8P7iNi6Y3WHi9LaWUJqgr01wfacD_Ww7Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Aug 2021 10:46:57 -0400 (EDT)
Date:   Mon, 16 Aug 2021 16:46:55 +0200
From:   Greg KH <greg@kroah.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 4.14.y] KVM: nSVM: always intercept VMLOAD/VMSAVE when
 nested (CVE-2021-3656)
Message-ID: <YRp6X3sV50Q94+2/@kroah.com>
References: <20210816140240.11399-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816140240.11399-8-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 04:02:36PM +0200, Paolo Bonzini wrote:
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

Ah, missed this down here, I read top-to-bottom and stopped at the
second line :)

Anyway, will wait for Linus to pick these up first.

thanks,

greg k-h
