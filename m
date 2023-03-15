Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573966BAA67
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjCOIFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbjCOIFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:05:39 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B011ABD6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 01:05:37 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5076C5C0AA7;
        Wed, 15 Mar 2023 04:05:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Mar 2023 04:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1678867536; x=1678953936; bh=g+
        TxP06PhPru2Ljrocma2nkm+hCRmW6eXJnbz35e1Zk=; b=pJFZ3EERMo5hSdqwHm
        PN+nAmqOyQVCROH+HuFn87fuJNrRap5/J5j8Je4lqeIlEBd/sMcHGDabrVaDnu9f
        FZ1TZPXAso5WgrakiX/I6BsY2TINIUcZFK/9IKfBvBE0N/snuDNDts0OIlaVF/K8
        EVMhHfMwMjcYeJn4bopCavVZd3RTCp3nqnEFjB1jpArAnPEbc7Ur37j3SfJzCpM+
        hLttb801VdBPxj8BuWzEttlMjT1e9XRgFjvRFy6tXYXDy2EDOYxGVOmUsvhbLSrM
        Ri8Cwn5HdPEuv8VUWhpx+jSLSZROnba+LdmBxXSQ7fEF7gbd89jBO+o48D6sf27Z
        6Wdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1678867536; x=1678953936; bh=g+TxP06PhPru2
        Ljrocma2nkm+hCRmW6eXJnbz35e1Zk=; b=MpgyieRViINEoXYBPG5fC0IG15zPh
        JIDor6kQ0R6KeRWJnT/RCm2IDCBVHtmyS0ruGu8P+xZAylWJc2jYmncJmRkC0Bon
        Uh8rvSRAAmiCMU12unbEvAJX+s+FZvy4l8Rr6Nb82Hw6darRfW3RWw51tcZel7Bu
        kXRPxrPOPTOIoo7jKG7kM2BuMQWmcu4k6pcgYB/XmSApY1Le71u+b1+P27rmBGfN
        XnAj+5zM7JlC/HHQYwuoCwVPrOtx12ZTBoL6GehJbulJ85TFZop6ZfT8TfcdCuEz
        w7t3Hhfq7C0ac+roP5jj/3KDhmgWks6Pj95IZL4ijrJhGWM6ZvdLiaITg==
X-ME-Sender: <xms:UHwRZHi0s__PqbvXa3Dz1l-N-uF151tWjG_cjcCbezRFG7VWNsBv_Q>
    <xme:UHwRZEDDPQqAoPvcbrWcgJWTE3bqDr_lyw8mkEGDYv6QFlRfSGLyzYqMS2Ho7Osqx
    JZG1z_lkheSGQ>
X-ME-Received: <xmr:UHwRZHH6F1Cz4dJK37hUGg40lYJ7PSbq5sEMlKkRQEt4EhyXj9vn_w4YP3rF0CYcDQyAyWx4qKiE9BsabzX31XGpJpWFs1q8jBsycA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvjedgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:UHwRZESURsgpdtFy3biLerwCvKne8jwq4s0Z7e7yQvQ4wuWNcszoWw>
    <xmx:UHwRZEz9NZIQ0HBSTAO3uWBetf26wMJ4PfEE40ffosuq9mwFIIVS3A>
    <xmx:UHwRZK69ha06TCkzNFJR_UelgaNQjq7yoQrmi8_sf11p5KaWdYQkIQ>
    <xmx:UHwRZDlh7pj5HZ4hTMRF_2zxdmN9HCOFl2_Um_1TozfBfPoRtcG3Gg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Mar 2023 04:05:35 -0400 (EDT)
Date:   Wed, 15 Mar 2023 09:05:17 +0100
From:   Greg KH <greg@kroah.com>
To:     Qais Yousef <qyousef@layalina.io>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH 00/10] Backport uclamp vs margin fixes into 5.10.y
Message-ID: <ZBF8PeGrxVJmlQ8P@kroah.com>
References: <20230308161305.2881766-1-qyousef@layalina.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308161305.2881766-1-qyousef@layalina.io>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 04:12:55PM +0000, Qais Yousef wrote:
> Commit 2ff401441711 ("sched/uclamp: Fix relationship between uclamp and
> migration margin") was cherry-picked into 5.10 kernels but missed the rest of
> the series.
> 
> This ports the remainder of the fixes.
> 
> Based on 5.10.172.
> 
> Build tested on x86 with and without uclamp config enabled.

Now queued up, thanks.

greg k-h
