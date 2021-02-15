Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409D131BD41
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhBOPnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231322AbhBOPiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F383064EFB;
        Mon, 15 Feb 2021 15:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403286;
        bh=JKDRT1aG4NKmi0QJGTdK3fJt/hWYLn3Nnfvi7OxVZT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPbwLW3UkRVHZhjqHBN+4iKJimVHsmk4SZLprfrLx/TyKUO/x8s+x6VTxvPK/Ag37
         6KknqTRly4M5LIosju2vn6QedkYhtlDB7WGpJZFZU1Tv0cISzQjTU2ml0BtgxaHrUq
         MiXeT1s4B6jYCf7lEUvFrQdLzGqK141jj/1MNB00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 098/104] switchdev: mrp: Remove SWITCHDEV_ATTR_ID_MRP_PORT_STAT
Date:   Mon, 15 Feb 2021 16:27:51 +0100
Message-Id: <20210215152722.633343806@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

commit 059d2a1004981dce19f0127dabc1b4ec927d202a upstream.

Now that MRP started to use also SWITCHDEV_ATTR_ID_PORT_STP_STATE to
notify HW, then SWITCHDEV_ATTR_ID_MRP_PORT_STAT is not used anywhere
else, therefore we can remove it.

Fixes: c284b545900830 ("switchdev: mrp: Extend switchdev API to offload MRP")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/switchdev.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -41,7 +41,6 @@ enum switchdev_attr_id {
 	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
 	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
-	SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
 	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
 #endif
 };
@@ -60,7 +59,6 @@ struct switchdev_attr {
 		bool vlan_filtering;			/* BRIDGE_VLAN_FILTERING */
 		bool mc_disabled;			/* MC_DISABLED */
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
-		u8 mrp_port_state;			/* MRP_PORT_STATE */
 		u8 mrp_port_role;			/* MRP_PORT_ROLE */
 #endif
 	} u;


