Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F993829D5
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhEQKd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:33:29 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:54817 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230248AbhEQKd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 06:33:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id EBD36B2C;
        Mon, 17 May 2021 06:32:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 May 2021 06:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=YaPN4L1dtV8Of4WdWwzIZAL0PBh
        1OCG8f7LH45YDgkU=; b=LXulyIIE1zsxRAifFExzIbVuCQbIeD/dka0fBGHsmhr
        A2kEelDKXuEO4GmbSXBJSuZTmcuZkfcdGSA3cPRMzIMnxTNcr6vFclVB91bv08mY
        iKUA+LLHrDySlAsbxa8AAt6j5uGatefa95dACLbCCTWL/i5uR4MJLg7u3Dr1zYIu
        G9tm155cx92exQ1einb9Q+qNvV4hxlwX6taWIXV0uhAa3L2JHhzSQVXRCUs2+XDn
        mi0BFTbLaXPb/1Bx+ThL6ynRYPK1kZwHprK7Z09XHjWa7n0ZtOf1hSRRlPaDoFOs
        ykS12+NMzgxMQQrIgo3b23jv/m/NK0c4U6kb0REkTYg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YaPN4L
        1dtV8Of4WdWwzIZAL0PBh1OCG8f7LH45YDgkU=; b=G6PKJCLGuMEKHHPY6L6ow2
        6GgT18yyhVil2kB5gGNr/cJeY2NHiKJSVwCyHNp9IVMaLEPHfriFM+1EPMgZwwdo
        s3693Qq5FxsJ3GKXi8iG5ikiajePLuKIWtrCnKNgaV272oFJBQF7NP+ZN7DE0M+M
        cdsRCzGQTmSCxbGFYsBJumt7/HateeVqRPs/Jh2mu58yTRHjjB1u6FuXKOQMy/n3
        F0+UgvOAsk4W1qHks2qcymEernD03VLPxRH5OAVFGGpJpRTEn2h3O6fusFY069jr
        Qiz+VhmD+emqq9zS9/CZzXp3pCz38P3E/Cc/qgB4MsHgsbTHHQw0kV4CwlBaubOQ
        ==
X-ME-Sender: <xms:KkaiYNW_QlJRqrTWJLxQFZdkdycrTPlJuKw3GcCPGYhA_IfdrT1Q9g>
    <xme:KkaiYNknF9V6tl5K0F3evFnMfkc6jfovfVqF1MjPCF2C3p56wX3yrpnKjWRXjUPRA
    Nl4CGtCBEYkmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:KkaiYJZFFWpuwyLryKwIidNy82z9Q6H9ZE1Xs7Y-XbWsLZtJOoeNvQ>
    <xmx:KkaiYAXRvsZ0P1wZIdK_a53xstW5X2O07C3N3Vyk81fdGrcf5ighPA>
    <xmx:KkaiYHlB6VEoHnJ1m3zW8d2-IxHF0gFTF9qHGhd4oxfLKvg89p29wg>
    <xmx:KkaiYFepijXNBz_7PlzMtNdMocMflVqTxw38CmsM4Kl1GEVGak8pUzq8ZNk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 06:32:09 -0400 (EDT)
Date:   Mon, 17 May 2021 12:32:07 +0200
From:   Greg KH <greg@kroah.com>
To:     Tony Lindgren <tony@atomide.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [Backport for linux-5.10.y PATCH 2/2]
 clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940
Message-ID: <YKJGJ+0XwK+7oowD@kroah.com>
References: <20210517082244.17447-1-tony@atomide.com>
 <20210517082244.17447-2-tony@atomide.com>
 <YKIsckQwullhruX+@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKIsckQwullhruX+@atomide.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 11:42:26AM +0300, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [210517 08:23]:
> > Upstream commit 25de4ce5ed02994aea8bc111d133308f6fd62566 for stable
> > linux-5.10.y. Depends on backported upstream commit
> > 3efe7a878a11c13b5297057bfc1e5639ce1241ce.
> > 
> > There is a timer wrap issue on dra7 for the ARM architected timer.
> > In a typical clock configuration the timer fails to wrap after 388 days.
> 
> FYI, these patches also apply to linux-5.11.y and linux-5.12.y. This
> patch applies with fuzz to the related device tree changes though,
> so please let me know if separate patches are needed.

All now queued up, thanks.

greg k-h
