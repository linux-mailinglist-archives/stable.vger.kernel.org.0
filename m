Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8A038894F
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 10:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbhESIZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 04:25:23 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:44627 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237523AbhESIZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 04:25:23 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id EFD2B138F;
        Wed, 19 May 2021 04:24:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 19 May 2021 04:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=0SETtIoHoSLRFxXXnzA6YE1GPr8
        GujCyHaH8e/QgHPw=; b=hY/Nq5O95Dc8JehlHpmNDbro8HW8Cb+fg86jFv+XgMq
        V2JQzZ4tI7os8riZbecQW4jLdqdfBx78/Bg7Q08WAeKZtuAgg/+k3bsoZZPqOOOh
        Y50xtDJ48RtyZq1QcsdLu0HAFbwB5ZSpzv2ErSm5ME0LhbBMoDcGMfVXOpn1+iiG
        Qn6gmzq+wt9ZQSyBfGkfatgzTmXKv/bnN18C0itB4S+TbKQlo+tlBoUnK90RalkK
        kvLQGZhk+G8iLc/tML4mn0Ro/NzaEWyG5OAHYjc09y9cM2RfITHlwncHSQRmbpIc
        0IXnDPwGjwrR6qtiv5EMmkIRw2gzNA3LcWiS31lfRyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0SETtI
        oHoSLRFxXXnzA6YE1GPr8GujCyHaH8e/QgHPw=; b=KIdR8VKzjoWWBVh4UJIfKl
        9IyVFOgxfSzgSJ4QNQETYmZPKXM/qudwutpM4SqqNNele+xb0VzhiRMOD3cSGVHE
        Indli67jnHrVaypwU4neMXk/YTUc2oft/qpW036FVuBWWUkB2epB9RXtPR/gecEb
        23bY2jSBEy44n0TOUGbuWKkDzMJGngsjSAUHR8ykxb9SHVIKfccl3i8C5U81C5Fb
        zNjn+09B1toPtJrwalRkGql6meJnR1MpbNvbq3JL0+uJYVlZPzf2ArQOy5zB0jjc
        vzQdD85SvuHYC9IqiEfVvuEHCb54q5cHITqXGAF6RWdtmKkykBxVHc1hRkUR1Ywg
        ==
X-ME-Sender: <xms:IMukYF9XY0nczE2Uhsmj57ssDDknb1rY5JhSkt0r6CmO8tEJUUnIew>
    <xme:IMukYJupVbVunz67hytUpbdhta1virt4BjvfDBSHHhUexrDW5fNgs9x54W68YlM8S
    XsRMLob_MKzBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiledgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevhefgje
    eitdfffefhvdegleeigeejgeeiffekieffjeeflefhieegtefhudejueenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:IMukYDDRHujoX71qbuh-B_b7JUT6O1EEnJp3kqmj8v2YYHztQBrQIA>
    <xmx:IMukYJedM0LON_i_MQhtM_97Juw2U1_7HOFWEyh0uSTvKIqV9c0CKA>
    <xmx:IMukYKOHBwVFYK0hsGvmeRr9Jya6mAmVFR133CndRV59PmKJHHijfg>
    <xmx:IsukYJfQuKKLcSpds_LRO-Mv2-KUxUPwIJD_mPZLiLnG2QfIYLUERQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 19 May 2021 04:24:00 -0400 (EDT)
Date:   Wed, 19 May 2021 10:23:58 +0200
From:   Greg KH <greg@kroah.com>
To:     "Anatoli N.Chechelnickiy" <Anatoli.Chechelnickiy@m.interpipe.biz>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "sashal@kernel.org" <sashal@kernel.org>
Subject: Re: regressions in iommu system with 5.10.37
Message-ID: <YKTLHuWCdIhEIObv@kroah.com>
References: <8893cfb2-d4e8-f3e9-e0b9-bbacf1220dca@m.interpipe.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8893cfb2-d4e8-f3e9-e0b9-bbacf1220dca@m.interpipe.biz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 08:01:29AM +0000, Anatoli N.Chechelnickiy wrote:
> Hi
> 
> I'm sorry to report about regression in 5.10.37
> 
> with
> 
> CONFIG_IOMMU_IOVA=y
> CONFIG_IOMMU_API=y
> CONFIG_IOMMU_SUPPORT=y
> CONFIG_OF_IOMMU=y
> CONFIG_INTEL_IOMMU=y
> CONFIG_INTEL_IOMMU_SVM=y
> CONFIG_INTEL_IOMMU_DEFAULT_ON=y
> CONFIG_INTEL_IOMMU_FLOPPY_WA=y
> 
> and iommu=on in grub.cfg
> 
> 
> All my dell r340 and all lenovo servers won't boot any more. Just black
> screen at once.
> 
> 
> with intel_iommu=on iommu=pt DELL R240 and Lenovo SR350 cat boot
> 
> Older Lenovo cannot boot even with "intel_iommu=on iommu=pt" only with
> iommu=off in grub
> 
> With iommu=off in grub all servers are booting well
> 
> With 5.4.36 do not have this problem
> 
> 
> tested last 4 days with 10+ different servers(

Should be fixed with 5.10.38.  If not, please let us know.

thanks,

greg k-h
