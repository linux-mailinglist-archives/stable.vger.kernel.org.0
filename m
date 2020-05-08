Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385C51CAFE3
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgEHNVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728104AbgEHMkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48E5C2495F;
        Fri,  8 May 2020 12:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941620;
        bh=UP2Bv7dw35R4X6LSQRa4HJ+u34hOteqbu6GSF2rZSOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8m5Nvy1JLFdVR05fyD2Oq94oj/JrFhubjXNw/Pb3TskNtRQmr5Cri2j5AHh9FyXC
         wZ1loi1936WzEUHpkmIt2jadcIzeK7FozRBlhlGZam/d5fX30tBBGgimHXuqHMoTzh
         +3YjSJuhlgRvrLQHyQQgFutEbiEd78DyTugAHNU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 065/312] mlxsw: Treat local port 64 as valid
Date:   Fri,  8 May 2020 14:30:56 +0200
Message-Id: <20200508123129.126274302@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

commit 1e5ad30c649a82a062ce79a87c1296e6c6f328c2 upstream.

MLXSW_PORT_MAX_PORTS represents the maximum number of local ports, which
is 65 for both ASICs (SwitchX-2 and Spectrum) supported by this driver.

Fixes: 93c1edb27f9e ("mlxsw: Introduce Mellanox switch driver core")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/port.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/port.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/port.h
@@ -49,7 +49,7 @@
 #define MLXSW_PORT_MID			0xd000
 
 #define MLXSW_PORT_MAX_PHY_PORTS	0x40
-#define MLXSW_PORT_MAX_PORTS		MLXSW_PORT_MAX_PHY_PORTS
+#define MLXSW_PORT_MAX_PORTS		(MLXSW_PORT_MAX_PHY_PORTS + 1)
 
 #define MLXSW_PORT_DEVID_BITS_OFFSET	10
 #define MLXSW_PORT_PHY_BITS_OFFSET	4


