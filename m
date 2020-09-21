Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0642726F5
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgIUO1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:27:45 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42951 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726341AbgIUO1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 10:27:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id A323C5C022F;
        Mon, 21 Sep 2020 10:27:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 21 Sep 2020 10:27:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=z
        HXv4stfrnHrMz8pGyM2eYNo2NJ2/IjRPZ1DJoKC6ws=; b=DbzVzAkV4+o3GvPGT
        Jp6Dqb46ANFI1O3XvZmMoFApYd6WSHnlLyGGlNj7mlDkOpgbp/9OLODzA+sW3On8
        4OXdXHLB6CrUfYbMT2vX8w6/f6lg4lHY/njbWm61eo7WsuQMlMm6qUizBFHxOXLp
        RV1fT0R5VDqbBQp8wr3u6yPoqpwCc3SwX20BlPt9B48N1xBMZtfvYi1mFjsNo17o
        Xv8D1hZfEUWFwR0NhRA8OxTXMN53j6spxThG7sY0jbpwo7VIYtvsfKhVpa7K7umr
        zD+m0F9fzbAvZt4IAVY6P5PHUkEJ454K/AV5Zplgh/iOHKYuBqMJiwBsCHlfu89W
        lPN+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=zHXv4stfrnHrMz8pGyM2eYNo2NJ2/IjRPZ1DJoKC6
        ws=; b=FoCkTtqTgjW7BObcIkQg+qZpcB9/AhvRLNrURMg8RCmFbtTAltP4PiCPO
        ncnlzOK1GSgyJzvBoT2xCVGcNsrb1zjNscepDKlan2r4TGtAQorIQ5kCnF5SjuXR
        /pCK085mPzX4lJtDlWvDgGIC7YyUJGWPffPYDAX85g/W26zCxh3Ih1RrRPr8BDHE
        Mco80k42qinv1Y89plz3Br6XPf0MH5soPqqCF8QP7CwogH1Q+rlbqrHAUWczg3sj
        pXZ20o2KPzmkqjwDyXDyYpfm29QHacSeCkPKab6Ug1/F/orXWbBLdYMBBc3PIetK
        m5NNGTQFUQ9p7ZKgweaaJoGJ/LPMw==
X-ME-Sender: <xms:X7hoX3wNyoR2-sfS3XvMdpLm9_VARiOJaQubmBhGHgqh6Qs4CVcObw>
    <xme:X7hoX_RBa1DpLXWa8rvm_hAoP5w80i6gFpA4WBRD23Yu4HOPI6vujyQ8cHijUreKH
    3j6j-bdmLf22w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegieejue
    dvffeuvdfftdetfeeuhfekhefgueffjeevtedtlefgueduffffteeftdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:X7hoXxWlPPere1Lk1tNe2zp2sKTNd2HPzpGj5usEL5W7VxYVtWYzzQ>
    <xmx:X7hoXxiUYmt9K1VoFiY-pLkGBSLS9ww3n4M7Lb4orKuQuWGBeJ7coQ>
    <xmx:X7hoX5BiatwOk9QaooqnpLu2LFtv39SUakp8Nc-_ntQc7dSfHJNDhg>
    <xmx:X7hoX24Kf3xvz_TgBlmclfKFKhM6IMUsOU-zup3-Dbb_N_a0ifgKyg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 230B83280060;
        Mon, 21 Sep 2020 10:27:43 -0400 (EDT)
Date:   Mon, 21 Sep 2020 16:28:07 +0200
From:   Greg KH <greg@kroah.com>
To:     =?utf-8?B?bGloYWl3ZWko5p2O5rW35LyfKQ==?= <lihaiwei@tencent.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "KVM: Check the allocation of pv cpu mask" has been added
 to the 5.8-stable tree
Message-ID: <20200921142807.GA643426@kroah.com>
References: <20200921104234.9C539216C4@mail.kernel.org>
 <EE2DABCA-2B97-4D46-8AFB-7F94DED675F8@tencent.com>
 <20200921132850.GM2431@sasha-vm>
 <E0D58EE6-0CA2-4594-877B-FDE2C1806272@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E0D58EE6-0CA2-4594-877B-FDE2C1806272@tencent.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 02:14:41PM +0000, lihaiwei(李海伟) wrote:
> 
> > On Sep 21, 2020, at 21:28, Sasha Levin <sashal@kernel.org> wrote:
> > 
> > On Mon, Sep 21, 2020 at 10:54:38AM +0000, lihaiwei(李海伟) wrote:
> >> 
> >>> On Sep 21, 2020, at 18:42, Sasha Levin <sashal@kernel.org> wrote:
> >>> 
> >>> This is a note to let you know that I've just added the patch titled
> >>> 
> >>>   KVM: Check the allocation of pv cpu mask
> >>> 
> >>> to the 5.8-stable tree which can be found at:
> >>>   http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >>> 
> >>> The filename of the patch is:
> >>>    kvm-check-the-allocation-of-pv-cpu-mask.patch
> >>> and it can be found in the queue-5.8 subdirectory.
> >>> 
> >>> If you, or anyone else, feels it should not be added to the stable tree,
> >>> please let <stable@vger.kernel.org> know about it.
> >>> 
> >> 
> >> This patch is not a correct version, so please don’t add this to the stable tree, thanks.
> > 
> > What's wrong with it? That's what landed upstream.
> > 
> 
> The patch landed upstream is the v1 version. There are some mistakes and shortcomings. The message discussed is
> 
> https://lore.kernel.org/kvm/d59f05df-e6d3-3d31-a036-cc25a2b2f33f@gmail.com/
> 
> Then, a revert commit was pushed. Here, 
> 
> https://lore.kernel.org/kvm/CAB5KdObJ4_0oJf+rwGXWNk6MsKm1j0dqrcGQkzQ63ek1LY=zMQ@mail.gmail.com/

What is the git commit id of the revert in Linus's tree?

thanks,

greg k-h
