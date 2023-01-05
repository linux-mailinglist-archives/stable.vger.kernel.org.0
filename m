Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0118565EA49
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 13:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjAEMBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 07:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbjAEMBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 07:01:52 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E31C57925;
        Thu,  5 Jan 2023 04:01:52 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 8934832009F6;
        Thu,  5 Jan 2023 07:01:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 05 Jan 2023 07:01:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1672920107; x=1673006507; bh=OWPTotGBIK
        0NCyif6u4muL+R0k3cNiuOI36HmT5rpRs=; b=cPscQ2tw/LxmVl4CO4ElCMzE/N
        hSlOslb5q1lZoXZIfyQ8MPhcmwFo0T+jolZ8eiQqRCFiGKgpkLW2vH5jtAC5VFPT
        pj/INu4bWc7YS2voPhhu/ydDHnlzBfUsyUx14vhXeRGbOQMLw+ZQLR9a2Z7Wr3CT
        j4oO/fPimZ9DoMnU8jLn2pDwDgy3Hp4ugfj8u2GL/VCUYA/gAj0mFJ7nJuU/A6B9
        OR35OsWP0niRC6e0WRSsflyDZI7vDrR+KuVTvq8z1P3Xvz0K47HjUTYShFLP/O3t
        539/h+qNgCsfHPEo2QJlMTlOoZMKPQFdKO7cnUy+QtSOyH2/kVdKpFx35t6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1672920107; x=1673006507; bh=OWPTotGBIK0NCyif6u4muL+R0k3c
        NiuOI36HmT5rpRs=; b=Yezk1DsNExVqX2Ifl9QGwT+yTuHIhGlFBnS0CBraSt4Y
        AbL/eHlxDj5P0Co5KLy3TJ/46sVfSjHT7aj33KrkBqpBt9HSQjnKSkUADPwuXIFY
        PZnDhMuA3LAss4CQ5BgEd5IrAwvvB6gJ/7r7vuoe5USuVyPARyBejFGMNOoPR3Jm
        ivkXT56CGa+CqFnbK59Dc7Nl4OGp6tNkvTNC+XWrEXGj4fPiyBRJ0JoOQqZeZbUk
        S0fAX+IFva/SJUBdmRbOrxfkur0iHME7fllrTUxu4CdrcCrO9uGlSM88fmnr/BdC
        DF9e7Gcb+OEbuBOQOAgWqpSeY/1q3QO9ACQeXxpD4A==
X-ME-Sender: <xms:Kry2Y1RdyHRTqs9FMT9tVq2sZ66Kflr7EHa-wOX-YR_87jYZWscxtg>
    <xme:Kry2Y-xQj-YiUsEiF5zj56kcqUy5ngMv_0B1mFu2xDNR8UlaZreFS1xJrNU9log4y
    Kif5DobxLkWnw>
X-ME-Received: <xmr:Kry2Y63UqSaPJdVCPUdu6nUrYGpX8u7u7NVsLgvXiMBaGFvzq_ceyyOio4KvcNuZtFHKwx-8PUK2ccOzJirtLNt7z7Hwl_ufIDl1hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrjeekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Kry2Y9BnwmVtaZZw86XVCI5sOIfmpXyJH_osLDsFi4WaLyJUAwnLFw>
    <xmx:Kry2Y-jXDk3TefOkKaQStiYhdKYw4qZELxZmy_zS8LYwjnUB2isWig>
    <xmx:Kry2Yxr6EuBjotcM2PcG5E3Lglz_iLgDixLCd1JcmrpdPQ7Z0bqy-g>
    <xmx:K7y2Y2e0KJn0_IxFI04s4ycLfv2AsKZM3wVeITJR8dP5T2JaDa9O3w>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Jan 2023 07:01:46 -0500 (EST)
Date:   Thu, 5 Jan 2023 13:01:11 +0100
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 5.15 00/10] ext4 fast-commit fixes for 5.15-stable
Message-ID: <Y7a8B2+AjwxpmTfh@kroah.com>
References: <20230105071359.257952-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105071359.257952-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 11:13:49PM -0800, Eric Biggers wrote:
> This series backports 6 commits with 'Cc stable' that had failed to be
> applied, and 4 related commits that made the backports much easier.
> Please apply this series to 5.15-stable.
> 
> I verified that this series does not cause any regressions with
> 'gce-xfstests -c ext4/fast_commit -g auto'.  There is one test failure
> both before and after (ext4/050).

All now queued up, thanks.

greg k-h
