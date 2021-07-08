Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB7D3C1918
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbhGHSVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:21:12 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:35061 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229768AbhGHSVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 14:21:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3E6785803DA;
        Thu,  8 Jul 2021 14:18:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 08 Jul 2021 14:18:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=T+XhYe7z3WJJDz18pJThjlU9F0a
        4TfDCfqwWRxunIks=; b=weKqmB+wGUltgVl/D6vH53a8jBN2jMilQNj647YA9Vp
        8hviWXj6PDzIPosTomp78csww/vuEJ8OxOI4IM0rTDJrHksSJd0HAFSCA2yvXT6q
        gY/PP+PwgEi9Y7KIwsJGlWZDBZ7Eir7nShiZYmuDpL5hSwNSnaSH0z0MaqhIkhuq
        wt4/n2iOF/jWBm1xULoWZm4qj/xnLI9yOCmpcwhWX7ntI8RcD2ky6rqtuIPjGIh6
        04kqJcUL3pTq1g9f4V3BnD93ygx1FG5D+eXKMUr58DRQ7CtxhsWom4qGK81gFXbY
        JhyCESQleJjy2K5M9zGrv0ap3GzzUZbKfDq4KJRIr9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=T+XhYe
        7z3WJJDz18pJThjlU9F0a4TfDCfqwWRxunIks=; b=Z1zPA1ZKCGE/pZZAH7BKLF
        FHuodgx2iBABcQuZwjV9dCUK+1gA3Wkmg0PLpQzp4NFgd3bEKQmC2J46Ap1PPv0g
        3I1+qW0O8bg0brVfYt44js2RHJlu6dcGVsWJ7xJ5S0CBN1ZQaiESOW8rloIsmYkQ
        1A1a64MB6FDZnF5NhH0MkugyabZW7e/3oqFboDH7lakBP8uaWqU05xv6J8aF0Mhe
        qO3aEV2JPqUYmdRDzFi8fH8qw8Zg8+iGthdEfV6G1lGaXh6jzNpv+A81GNPpXbrZ
        OTSE2ULiKUqcR2yBaeYv3FuHKxVfoM0mCJhO991SX5rodlqEhdhUDsMdHDVdYphg
        ==
X-ME-Sender: <xms:dUHnYM2TBVbz2NJi87UUcDiTqMEvGqTsN2m5NtuK_I1_kW96LZGNMw>
    <xme:dUHnYHE4HPIelhYadoBORU0W3oWeZnafWqIJrp4_CO7UquMRLfJbwZIkWgDZO9EyW
    5U_cb85EJF8SQ>
X-ME-Received: <xmr:dUHnYE7mRW5HWdOjinteEQgbjjvFmbhsUwVo5sJYInc9zL1TP6VsVq2L9Bq8lDFk1sjA37NYBz3KCqBBEua0ZkSG-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdeggdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueejff
    dvudehhffggfdvieevleefgeefheeflefhgedtuedtueevteehvdegjeenucffohhmrghi
    nhepfeefrdhsohenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dUHnYF2PePl4Tg58N2jmoYxedQIp85_2JcRYifbe8kVKx6nCQHEujg>
    <xmx:dUHnYPFcIpWrUNh_yIZRRGLXowYyOBxpEh6UDwq5uDbeBgANp5EM2A>
    <xmx:dUHnYO-0NIzOoq0kh0maP3amruIRVhvUkq4Cul_ufulZlto7CwzyFg>
    <xmx:dkHnYH8NDjAxCVcy6Rv7scf1dLnw4yGifZthYWtYrr5w9kP11AJlVg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jul 2021 14:18:29 -0400 (EDT)
Date:   Thu, 8 Jul 2021 20:18:27 +0200
From:   Greg KH <greg@kroah.com>
To:     Georgy Yakovlev <gyakovlev@gentoo.org>
Cc:     stable@vger.kernel.org, paulus@ozlabs.org, farosas@linux.ibm.com,
        kernel@gentoo.org, dist-kernel@gentoo.org
Subject: Re: please include KVM: PPC: Book3S HV: Save and restore FSCR in the
 P9 path
Message-ID: <YOdBc4PwHmCLBROL@kroah.com>
References: <20210708064002.hzkjvvzhjticalzm@cerberus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210708064002.hzkjvvzhjticalzm@cerberus>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 07, 2021 at 11:40:02PM -0700, Georgy Yakovlev wrote:
> Hi,
> 
> I'd like to propose the following patch for inclusion into 5.10 LTS
> 
> commit: 25edcc50d76c834479d11fcc7de46f3da4d95121
> subject: [PATCH] KVM: PPC: Book3S HV: Save and restore FSCR in the P9 path
> 
> Without this patch qemu does not work on POWER9 on modern glibc,
> so I think it should be included in at least 5.10 lts branch.
> 
> I cannot test on older LTS versions unfortunately, only 5.10.
> 
> Started Virtual Machine qemu-2-gentoo-ppc64-stable.
> Facility 'SCV' unavailable (12), exception at 0x7fff9f81d4b0, MSR=900000000280f033
> CPU 0/KVM[2914766]: illegal instruction (4) at 7fff9f81d4b0 nip 7fff9f81d4b0 lr 13e6048e0 code 1 in libc-2.33.so[7fff9f6f0000+200000]
> CPU 0/KVM[2914766]: code: e8010010 7c0803a6 4e800020 60420000 7ca42b78 4bffedb5 60000000 38210020
> CPU 0/KVM[2914766]: code: e8010010 7c0803a6 4e800020 60420000 <44000001> 4bffffb8 60000000 60420000

Now queued up, thanks.

greg k-h
