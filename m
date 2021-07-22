Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4E43D28E6
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhGVP77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232850AbhGVP6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44E3060FDA;
        Thu, 22 Jul 2021 16:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971958;
        bh=qXdloxuoC0qo6en3pYbiKjKSZIYDaP0adUh8xTtlz54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPgV59eycKI/AyhNFXbSPbju6bG7bwjY7QkhuP4/0CSg/PM9wx67MIXcC15zV2qWN
         45bvNJhwup5ZEJdG1FPdE0F9vSSFedYWyggbKhRS+b3NRp/xMiBfjmTeXBvey/z4r+
         JRK8hbJtZ7lpXe4Mi7zCSIf6Vj46jRnSkUJYB/90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 093/125] net: dsa: mv88e6xxx: enable devlink ATU hash param for Topaz
Date:   Thu, 22 Jul 2021 18:31:24 +0200
Message-Id: <20210722155627.782321095@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit c07fff3492acae41cedbabea395b644dd5872b8c upstream.

Commit 23e8b470c7788 ("net: dsa: mv88e6xxx: Add devlink param for ATU
hash algorithm.") introduced ATU hash algorithm access via devlink, but
did not enable it for Topaz.

Enable this feature also for Topaz.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: 23e8b470c7788 ("net: dsa: mv88e6xxx: Add devlink param for ATU hash algorithm.")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3418,6 +3418,8 @@ static const struct mv88e6xxx_ops mv88e6
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -4186,6 +4188,8 @@ static const struct mv88e6xxx_ops mv88e6
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,


