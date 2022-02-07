Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F68E4AC235
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiBGO7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 09:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345017AbiBGOkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 09:40:09 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF169C0401C1
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 06:40:08 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2D1285C0060;
        Mon,  7 Feb 2022 09:40:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 07 Feb 2022 09:40:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; bh=MwgjByp8L/r9vsxzvj9y0Vr3uinPawkqeXxlIYpGDN0=; b=R3vio
        RdFz7BKNt2S9UNWHua2RfG+NRLiN4lRdssTx0a+uxidZdwU98enMo7HpwU8DVluT
        BhE2Qu58OcS8IzyWqHWQ5HR50/XiILPLA4aJfJjrxzDz+MPCv8jrMXrRqp4yI6VM
        Emcijf0wi84y8NpQyKubNQXUnpn8oX2R9FOXtw1/q/6kqVIQfiKBQq94MD4ZWqW9
        rYI2RLjrMyIVIQR2wE+NMhktEh1THriRsDL0oKmWUIWXI7vjRr6o7Fvw/hEia0TG
        53B7bUZx+U1FNbnedE5fnpGIl1i8HpnSc0Et6ZA01j4VpBC92Ht+5EOZb3pQIkbo
        YrjWICmQYHOp0ke8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=MwgjByp8L/r9vsxzvj9y0Vr3uinPa
        wkqeXxlIYpGDN0=; b=L7l3m6NfGM6imI0o87AxrmLKZ9abCBhK5NUb/GDot6JzK
        a1CW9S12SGolDtuWU+SEJ0MIRVmuWHaXchw3bsjfb4MDLSxEnasdKDlDkLbrPSBF
        TKDmISvf99UPDaifYqEg6utlGodfHPlK8rB9zCfR36Uadqa/pXVXkfnnBr0KAxFn
        3sIKr8ytMFnY+bzAJy6oyqbXcKRUml1oxeqaIl+Hyv5dOKYkYRPLhadkpZeOUXpR
        rN+DtDNi+VyoSBJg4r3j6qX58xIPN8GaSWPDkSKU729Qw/DR13mPZ8qoNSO32I2W
        zKbM4CxS44SQ053CnPrBZaYW2sdRAxKm2hEWhy5KA==
X-ME-Sender: <xms:Ry8BYsvWC-cRH3Nrj5YWTZe-3larbaPfZmPwhmd3SBvG22YXTKM62g>
    <xme:Ry8BYpfyHlhwFDvzewrzqgmfdIbIZ1wlTo7JnvAM-xcpdxbxsFqJKq7aFSedKXzMB
    wg7peQksI5KZn7euwo>
X-ME-Received: <xmr:Ry8BYnxMtd-irKVrp1-m2KqIbwjDEf1soXD7rUdDwTtGtpbK6UivdXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheehgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhl
    hihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhephfejtdektdeuhedtieefteekve
    ffteejteefgeekveegffetvddugfeliefhtddunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrth
    drtghomh
X-ME-Proxy: <xmx:SC8BYvNkHHKTTigCaX7LtlyXK6VFElf_KRmy199HA7U9F_Fc-Ghgkg>
    <xmx:SC8BYs8RER-P0TqT5ylsrQNIaBVh0iXaPHdVN5S-l0RZWqJ0PVRuXQ>
    <xmx:SC8BYnUr__3bLXiN1df0ozDWUK4vmhODyBPDkNWWXxYr_Gk9HJkB9A>
    <xmx:SC8BYqn70ff_xILxxSViNMgSdipcrQ8BiAnnINfflToHkLjJVBNLCg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Feb 2022 09:40:07 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH for-4.14 0/2] Backport SUBLEVEL access macros
Date:   Mon,  7 Feb 2022 14:39:55 +0000
Message-Id: <20220207143957.235063-1-jiaxun.yang@flygoat.com>
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

For stable-4.14.

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

