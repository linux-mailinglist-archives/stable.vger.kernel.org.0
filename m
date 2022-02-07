Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64684AC241
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353415AbiBGO7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbiBGOiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:38:25 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D434BC0401C2
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 06:38:24 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3BF755C0126;
        Mon,  7 Feb 2022 09:38:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 07 Feb 2022 09:38:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; bh=7zrm7cYueGouqjPVEPzY/ecS/7T5etNY5dPkqBJQVYo=; b=EVzs7
        +IkTf8vqA5tvD6I67BzksX7FbRlpQQjlbd7pBOMwbRfeMWouMzr2ld5wakQpA9Fd
        JlU0yudJ/UCXw/mzySsXcg/4zuFK828StvqArgs4VS3wjoVjijE6GNUDfPht9OsR
        IRmeVYNZiw3xHnq4VmdjbqtJNMkS1kdyhOn5S3PVE8zDdmqSkx0zgb1M9WjrUEii
        67t6d9sgNHBBnhaxBkYhdcVWxXe8XUjnbxBxyjG1/Rpy8JZmEaZM8P2fO3rOVvVB
        IvFhyL/4HUArU9Ax1wOHyKJqXcZRwVTIuuDhE3hS9H1SWdqzOlBUDoNcVS+akB5p
        dK13nwMW/VKINj8tA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=7zrm7cYueGouqjPVEPzY/ecS/7T5e
        tNY5dPkqBJQVYo=; b=dO3KYnPT/MaQYW2Z95pap75BhqxNpgzttlT4fL1IwtaYa
        dy7TmXetheSB1woAHSNDUwMX8SGwVJI5QD7Wa6goG+MrrdNk2URCgHz1GfKAjpEE
        4tLBuqLlk+yk8zXL3bTo+J4E1sjL/UDqzH17Juta7Bw+d0JnnhuyeM0Ma/u6NPoo
        T3hFqxUja32a8gS2ruQhornAUlaBejO9M/2Xw6f9LASRAvuDiTk8PgLJ4f4gYvHz
        8vxotAwTkjrxI4hDSUGB6Q2rA3gjfZbMpAnDA7OTcdlUnYbh6BSC72wDsVsyZ4OC
        aILJ3uKzEad32WFAmYUTTVaI7pp7oEKEcM4I8cgaw==
X-ME-Sender: <xms:3y4BYpn1Djd8TZWp0gcpJLH4Kt_Mtm29kHIqBralhwloxoNlzoOXog>
    <xme:3y4BYk0kCEHjgjOQIsRMVhYy2kWH-Ymyt7utafLuQ9uLafg28ch1PpKK4kDu-pW0M
    RzFGXIrUPntAl1b8Rk>
X-ME-Received: <xmr:3y4BYvr6cDXYLuyISFXhtABfYHphoGUpSeY5dlzCeOqRw1M67CgSGXo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhl
    hihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhephfejtdektdeuhedtieefteekve
    ffteejteefgeekveegffetvddugfeliefhtddunecuvehluhhsthgvrhfuihiivgepuden
    ucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrth
    drtghomh
X-ME-Proxy: <xmx:3y4BYpnk8rGz-e5UWu5uB6U23x4KugVOOkI_tlvPCJ7d_DKFYaAjTg>
    <xmx:3y4BYn2PHKXy-Qoj92wJ2EIMSbw2hgajO_wrJT6UFqpBZxZjazUuxw>
    <xmx:3y4BYosCNiT1gQiv1V3X_dNvyFZjuJa1sxASJnPa_I0kSNkFNKlQUA>
    <xmx:4C4BYg-KvvjkXhJgNk2Y1NzCTXJv_rPlXUXbyiGVFe7chQkJPFdppQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 09:38:23 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH for-4.19 0/2] Backport SUBLEVEL access macros
Date:   Mon,  7 Feb 2022 14:38:12 +0000
Message-Id: <20220207143814.234615-1-jiaxun.yang@flygoat.com>
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

For stable-4.19.

Sasha Levin (2):
  kbuild: clamp SUBLEVEL to 255
  kbuild: simplify access to the kernel's version

 Makefile                                       | 15 ++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |  4 ++--
 drivers/scsi/gdth.c                            |  6 +++---
 drivers/usb/core/hcd.c                         |  4 ++--
 include/linux/usb/composite.h                  |  4 ++--
 kernel/sys.c                                   |  2 +-
 6 files changed, 22 insertions(+), 13 deletions(-)

-- 
2.35.1

