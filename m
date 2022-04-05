Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522174F31EC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbiDEIh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238055AbiDEISi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23C0B8239;
        Tue,  5 Apr 2022 01:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63FC0B81A37;
        Tue,  5 Apr 2022 08:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4FCC385A1;
        Tue,  5 Apr 2022 08:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146077;
        bh=eJrefJQk4zVnwzJreJENCV/Yc4osiJG3XfaSFOpJCWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzKlOalw9581ClKFYFT4zirB1Ss9HCrBk5DWOS999JZ0M348aeFDUzZCUqL2oxyOs
         Jzmqv4hdhJGmM05RIV3N+CR108dABnDjxtAycfyztzJM50/z4Ty/eFCn9TJLFGZzT4
         5C4Twzj9f/IwAXocpPx9ofziuYh/v2pOsZ16z+QY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0596/1126] net: dsa: realtek-smi: fix kdoc warnings
Date:   Tue,  5 Apr 2022 09:22:23 +0200
Message-Id: <20220405070425.128618793@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index ecc19bd5115f..4f8c06d7ab3a 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1252,6 +1252,8 @@ rtl8366rb_port_bridge_leave(struct dsa_switch *ds, int port,
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



