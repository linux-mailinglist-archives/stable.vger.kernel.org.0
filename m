Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6CE4F2272
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 07:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiDEFLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 01:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiDEFLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 01:11:37 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C95E33A21
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 22:09:36 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DD1435C0145;
        Tue,  5 Apr 2022 01:09:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 05 Apr 2022 01:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; bh=oFQH6v2f03F10A
        WfSSsjWzOCq3T8E6k+hO9OtQWg+T4=; b=ERdd4dg12M+tV5Nzh64Z1gaVZGHC/x
        sWUpVOrEB/KEZN530+2hOmK1RNvWBZ+I8dGQHqM9dYzEhSV22gvEyphA8XPfzrcT
        ussEoSvc58+W+lLaU3fFxCWOyMKVl31oXgvM+bdkZi5Wp5wRrticABdELge4idsN
        MD0fYYLWKsicr+M48tk9SdFXXRTUHRLfUAGyAK5CsBqCwZrzm7UH08bTkyntOx6F
        XqOR4cuZ+RpMEOltH1gjj8nLR1df7tO6354JKNrpwdK0LSK1tJJwGQJK3zyrU599
        QxU5vhc2GQWItL4wSIJsVnL9xyduF0hvqdRg7j/o7CpeT6EGM40wpOhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=oFQH6v2f03F10AWfSSsjWzOCq3T8E6k+hO9OtQWg+
        T4=; b=BojfwKMTeBE75AtBvd9KZSaagpT+nYrdvVI24PXiO1XJEC9KGnE2jpniE
        0RdkAedJ2KY2eXFnG9RvMNl3HxKZjRwDsQh1dRUkd48dt13KAe+ZpTbuEI35v0nw
        D1vBcr49/7Z3T3joexE+S248WqQt3onJnixVOcvmYMbZuRw4B+benXZxF0NCIum3
        93OGyFjDstkPXY5bOU/NeQxsTX7AiJs1PMrJv/9sx/qe+4iwy9x3x8H8hL5vaG51
        6boEBkID2hnSoaDmw60qmeDBudv6ASPXaME2lZuLB5a3roZsphGhc21ezc++EnuG
        GmmfKEhW47lpIwWHRBBLkgo8tuN5Q==
X-ME-Sender: <xms:DM9LYndG5421r370fwTl4uCnI-IUcp8zvPuJsSGVp2bcxA-q2DdSfw>
    <xme:DM9LYtMGcqQQW_sL2lkcwnN6TiA8bJgG-IQF_3zZttk_7GJls1hWKRIFWBkLaY_RB
    DtxnxBvCdbiXA>
X-ME-Received: <xmr:DM9LYgjSkrIUmAwiyjG5INP2uYWQyyyqSjW25lOg-8c98Qk7bKhE07TyCQuygKuleoyXP3aPR6CUaXyK9puyWIH61KPO13EP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudejfedgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepvedtie
    elueetgeeggfeufefhvefgtdetgfetgfdtvdegjeehieduvddtkeffheffnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:DM9LYo8JesVToHsxLwzHwbbdX4KnqfRSBcbs8qpX70_v5XKUw7B6Gw>
    <xmx:DM9LYjtQpMehu5S3O8GsjRF_k2aSKu52Uk3YR5V6eRoDdzRImn2Pvw>
    <xmx:DM9LYnHHVUIrPQRtNKpB22qEGaclC3cRx3vvCPOMzM1GAABPyDcrAw>
    <xmx:DM9LYtIigwJ0V0qjn88xB8spfWKRxD1aB8NFPnjw4JRImP1A6RAB7g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Apr 2022 01:09:32 -0400 (EDT)
Date:   Tue, 5 Apr 2022 07:09:30 +0200
From:   Greg KH <greg@kroah.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: Re: swiotlb fixes for 5.15.y
Message-ID: <YkvPCsOxCbTyXf8t@kroah.com>
References: <BL1PR12MB5157CD6B2C9D6B8525CFAD0EE2E59@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL1PR12MB5157CD6B2C9D6B8525CFAD0EE2E59@BL1PR12MB5157.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 04, 2022 at 08:45:57PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> A patch series of 7 swiotlb fixes was accepted into 5.16.
> This series is needed to prevent warnings from swiotlb when hotplugging untrusted NVME devices on 5.15.y.
> 
> The first 2 commits are already applied in 5.15.y.
> The last 5 are still needed.  Can you please backport these to 5.15.y as well?
> 
> commit ee9d4097cc145dcaebedf6b113d17c91c21333a0
> commit 9b49bbc2c4dfd0431bf7ff4e862171189cf94b7e
> commit 2e727bffbe93750a13d2414f3ce43de2f21600d2
> commit e81e99bacc9f9347bda7808a949c1ce9fcc2bbf4
> commit 2cbc61a1b1665c84282dbf2b1747ffa0b6248639
> 
> With the whole series the warnings are gone.

Now queued up, thanks.

greg k-h
