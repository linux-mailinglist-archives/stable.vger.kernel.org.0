Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5514F2DA6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242832AbiDEJiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbiDEJFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:05:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F772FE75;
        Tue,  5 Apr 2022 01:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 209C7614E4;
        Tue,  5 Apr 2022 08:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3F3C385A1;
        Tue,  5 Apr 2022 08:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148957;
        bh=kseVb9iJ6OvlNooBTvY7IHJklc5qGVwqkw1XALp37OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZ+7/W8joFhwWZdR/hgjXDim5CiWEgTJhLrFPuMafS1gGOcrQxYk4kRwVVeIHl4Bu
         ex0ZDVCXZG1HRgEptFL7PYzuCKBCoExF7oQ14qTcI2S9c0OXZ00Laqxs/yaF2OAl/m
         XA+1BlKZMi5ZhD9EmIMJ355oefTkvPS3Br8FMqF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0541/1017] net: dsa: realtek-smi: fix kdoc warnings
Date:   Tue,  5 Apr 2022 09:24:14 +0200
Message-Id: <20220405070410.347730704@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit 0f0c6da03ba37739901ca5db4361c1ef1ae9463f ]

Removed kdoc mark for incomplete struct description.
Added a return description for rtl8366rb_drop_untagged.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek-smi-core.h | 4 ++--
 drivers/net/dsa/rtl8366rb.c        | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index 5bfa53e2480a..faed387d8db3 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -25,7 +25,7 @@ struct rtl8366_mib_counter {
 	const char	*name;
 };
 
-/**
+/*
  * struct rtl8366_vlan_mc - Virtual LAN member configuration
  */
 struct rtl8366_vlan_mc {
@@ -74,7 +74,7 @@ struct realtek_smi {
 	void			*chip_data; /* Per-chip extra variant data */
 };
 
-/**
+/*
  * struct realtek_smi_ops - vtable for the per-SMI-chiptype operations
  * @detect: detects the chiptype
  */
diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 03deacd83e61..2a523a33529b 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1251,6 +1251,8 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
  * @smi: SMI state container
  * @port: the port to drop untagged and C-tagged frames on
  * @drop: whether to drop or pass untagged and C-tagged frames
+ *
+ * Return: zero for success, a negative number on error.
  */
 static int rtl8366rb_drop_untagged(struct realtek_smi *smi, int port, bool drop)
 {
-- 
2.34.1



