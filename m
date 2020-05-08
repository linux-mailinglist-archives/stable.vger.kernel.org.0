Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF891CAF90
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgEHMmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728895AbgEHMmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4030C2496A;
        Fri,  8 May 2020 12:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941722;
        bh=DvjZJjC6hXBataYmPYgmjY2MhEvL1FcSHqgk5n3/LY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jf1tj9grcAoFGLgNlj24LIiSzWKYFpPmep84C2+OWlz4MosBofDf3FH06R6gOceDP
         I6n57RUX0DF7XZhdlH/UEj6cdlvtSVZcqZ0AulIbSHS42lJ64ArPAWxLVnyieO5c/A
         PWg9VesdWiJn7oYw2FClOONDJ5h/NxhIcWfQlaAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 108/312] mlxsw: spectrum: Indicate support for autonegotiation
Date:   Fri,  8 May 2020 14:31:39 +0200
Message-Id: <20200508123132.089687441@linuxfoundation.org>
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

commit c3f1576810affced47684e04a08c1ffa845144c9 upstream.

The device supports link autonegotiation, so let the user know about it
by indicating support via ethtool ops.

Fixes: 56ade8fe3fe1 ("mlxsw: spectrum: Add initial support for Spectrum ASIC")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1104,7 +1104,8 @@ static int mlxsw_sp_port_get_settings(st
 
 	cmd->supported = mlxsw_sp_from_ptys_supported_port(eth_proto_cap) |
 			 mlxsw_sp_from_ptys_supported_link(eth_proto_cap) |
-			 SUPPORTED_Pause | SUPPORTED_Asym_Pause;
+			 SUPPORTED_Pause | SUPPORTED_Asym_Pause |
+			 SUPPORTED_Autoneg;
 	cmd->advertising = mlxsw_sp_from_ptys_advert_link(eth_proto_admin);
 	mlxsw_sp_from_ptys_speed_duplex(netif_carrier_ok(dev),
 					eth_proto_oper, cmd);


