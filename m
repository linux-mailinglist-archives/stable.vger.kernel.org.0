Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1FB3418C0
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 10:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhCSJtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 05:49:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:39633 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229870AbhCSJte (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 05:49:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 94D475C016C;
        Fri, 19 Mar 2021 05:49:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 19 Mar 2021 05:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Ng0nFiGEVMvEryWs2w8rhUsr+WC
        YrQP0KMiTjlelp2Q=; b=lVcyggtu5yQy1Y6ZCsD9zN9DjjFE5oDMxWdp1q2Ps9V
        M5cwdzUaqDCaxxUTUHMLTIRN+jL/AV/2YnnjHCOptVl9R1S8STParzum/AgcbDJ/
        1uJZpT3Bwu4/pcbJDp+nk1w7wi0DKnsyQkxjkAbJAAJneN3EsJAPXSykVwqmqZeO
        Lj1e1RfHMOtbUj6baK/1XSTufufUYcbyAQUrCg+eEetTh4wLb95q84CUcmQs24Ww
        RvHqxhHMMrL1ifisMVS/m5lpZBElxJkvsAQH4YLSq2OpvxDrc4X0HZ+j1q4v6uAU
        qlKpNZiHMHgNlZUmhxEw6K2ik/Pc30R7HTaNUDgS4sA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ng0nFi
        GEVMvEryWs2w8rhUsr+WCYrQP0KMiTjlelp2Q=; b=bvnXb97x+Pz7IDwBq65ihQ
        xE5GgbFPfVB4OEmtaEF2ZY6mC+tDL4/9fQhPR0YI4zEYKQIM88aEpDT63uBGXOnM
        dZbR7kEBp/h1oz2HsZ7J7KvjWMpBtK2lPXpXzcfiWpo1liXIePHQdMirpvunly7m
        n95cG4zlJJO8Dd2DgVAiS8+rt0UGECTvdMk0GbYNtezrkSyUaU2JaSepvkP00swJ
        GguLqG3EJ36qGtahRKqqKA1JYcW89iJor8Xbc0sK/eJgNAOuv8QxdxyuUOR63CN3
        qFYguMFbdgsYChBmfTgT4IktEJoe7U937TxV8ekt28awJLilJu+7+oToSF1jz6Ow
        ==
X-ME-Sender: <xms:rXNUYNrxLPCcsWjfmT7WSZ4LV-doSot7NmBgcWrG0y1YyFqM7CvkfA>
    <xme:rXNUYPrxWu1bxLDK0lNmVdXL_aDfSIyS4zK9FqXvF_wQpg10Pn_-y5p4P0g9BV2qu
    1vKnh5em2J2mQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefkedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevhefgje
    eitdfffefhvdegleeigeejgeeiffekieffjeeflefhieegtefhudejueenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:rXNUYKP795qjSz4j7PWF1QZinQjoWPe0bQjeNqYM5GxyBFNi05eTEw>
    <xmx:rXNUYI4C0mC952M2tWnOpQj_jP0Tm2zK5HW-bbi1DFPDGAHCdHWq0g>
    <xmx:rXNUYM5u4qIRECPaB3lkGV1zMjrUFps5GxV8ZTsTOkLNUM-s6rt6CQ>
    <xmx:rXNUYMFHk1RVVpdyYUDrveVJ79J94q9z1jwp8_zBoX7jFZyQjaVzcA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B162324005A;
        Fri, 19 Mar 2021 05:49:32 -0400 (EDT)
Date:   Fri, 19 Mar 2021 10:49:30 +0100
From:   Greg KH <greg@kroah.com>
To:     Yi Zhang <yi.zhang@redhat.com>
Cc:     stable@vger.kernel.org, jgg@nvidia.com,
        Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] RDMA/srp: Fix support for unpopulated and unbalanced
 NUMA nodes
Message-ID: <YFRzqoqcieMeyQNq@kroah.com>
References: <20210317074532.26312-1-yi.zhang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317074532.26312-1-yi.zhang@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 03:45:34PM +0800, Yi Zhang wrote:
> From: Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>
> 
> This patch fixed one kernel NULL pointer issue with blktests srp/005

Now queued up to 5.11.y and 5.10.y, if you want it in older kernels,
please provide a working backport.

thanks!

greg k-h
