Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C134AC23E
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345163AbiBGO7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241676AbiBGOlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:41:05 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D71C0401C2
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 06:41:02 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3F3DE5C0118;
        Mon,  7 Feb 2022 09:41:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 07 Feb 2022 09:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; bh=Ul2nh6g0/3cZydELo0NPtCJi+ebuVpM5td9BHcte0fM=; b=wO3jw
        lvQmuCjSgSWg9aDXo4D1/d86URcZbEIIMv89dT4JGI690UlPemfYVZWYFUbpehiH
        xPmk9bChvRpWTBPagPg4DcNUYkH7tXdJSTJ4EvHHj1IQ/akKGCkd0yqrjjxMpevq
        urr8PWYiVfYhDItBvZu98rs4nrT/Cr6/KCdJFOrbo+WJLfM5itP/kRQifgrDBhuP
        RkGuv+kNk3FWehIJoBlm0mBUtCnTm9xi3yiD9BnzzabiawFi8qHZpgF5sk6ugJyF
        pLObqPaAVufzU99F5Xc7NRIhz7LSJQeWlHiFamjeBIKXly+jjyIWgSOtAldvmo7o
        og5lpa0nSScAhCiQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=Ul2nh6g0/3cZydELo0NPtCJi+ebuV
        pM5td9BHcte0fM=; b=JMef7OZppD0DNvu3JEifI6IpW2pHPeH5PoyfpkYc4WnUN
        /WkliAsTynyAM1CGeVu73BhKAbDy0fwm6mFJlpS2Fv7SpD9OShzp+BXj80MT3ahS
        gV0phY0lljK3Es8xiqzhkKDLmmv17HEQC+M3415Misl3l5PUj4erE7G+ocDbZd4I
        RpC3T9GEBcR476ytWeoGHdCvfj1rJoPh2EHfTGFMaZPKZgMTmMAxkkuSVQZRULKN
        PhY9FSZvZhfR/n05LAAlVJ1qozUXHfjawREGGICgYRaDcDqiSRxLYAWXxPmRjaMw
        kxqJ7/plWC3hTSszCryTzuo+V+wXgMnozuVdBGVqg==
X-ME-Sender: <xms:fi8BYgHqPHXKCS8bGZundT7dHO9bqH1RGiyfke--fsK0BM43fUPdGA>
    <xme:fi8BYpWkDoQJQYdeApTXCa4xfngjNeznAMRGklb_AXLnDPKfV9bLvrlENtHksab8H
    GyknQMmapUnemyCs60>
X-ME-Received: <xmr:fi8BYqJJ1khU6EQRbq0fvzftwipagVJLS1f4rxUo6F77rQMbLNDfK5I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhl
    hihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhephfejtdektdeuhedtieefteekve
    ffteejteefgeekveegffetvddugfeliefhtddunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrth
    drtghomh
X-ME-Proxy: <xmx:fi8BYiFSoCspfdNiQfBHP1RAWbrC7_IGQmj3stabl4fQN1VSdAaARg>
    <xmx:fi8BYmVivC2M5sUqLNYrKxVF93mrhhwSuKtQ3M1x2Izse2cB3sKg2w>
    <xmx:fi8BYlM_n4Wlufk8bgb6XmFUD1sgNhJ7UWVxR6JNWrQAfa6uvfE-TQ>
    <xmx:fi8BYpcgyasRswFRPFEjHfDxbkgRzkIhGBKMWeXJIWfWRs3G--3Xtw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 09:41:01 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH for-4.9 0/2] Backport SUBLEVEL access macros
Date:   Mon,  7 Feb 2022 14:40:50 +0000
Message-Id: <20220207144052.235533-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For stable-4.9.

Sasha Levin (2):
  kbuild: clamp SUBLEVEL to 255
  kbuild: simplify access to the kernel's version

 Makefile                      | 15 ++++++++++++---
 drivers/scsi/gdth.c           |  6 +++---
 drivers/usb/core/hcd.c        |  4 ++--
 include/linux/usb/composite.h |  4 ++--
 kernel/sys.c                  |  2 +-
 5 files changed, 20 insertions(+), 11 deletions(-)

-- 
2.35.1

