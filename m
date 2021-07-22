Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A10E3D2A57
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhGVQK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233567AbhGVQIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:08:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10AE561DBB;
        Thu, 22 Jul 2021 16:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972508;
        bh=9JxbWpZnpb1n82uEG5CJzta3GX1lqw+YDx9gr2/Qvqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u0Oux6e3IprC5wmKVTew80EFYoHSKQWiBKyybPrcASrAEdpMVENAspOWqq7hDboUr
         7B0NhVLUhjqDVLW0q+HuDAmDahJ6Tk7N7zPv/ultiHbhOnA4YJLxObtFmiDBgKMvvD
         XS6h8/YYCe1pRafv5IMw/yEBIjXFJtXiux5yJj+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 112/156] net: dsa: mv88e6xxx: enable devlink ATU hash param for Topaz
Date:   Thu, 22 Jul 2021 18:31:27 +0200
Message-Id: <20210722155631.996636458@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
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
@@ -3608,6 +3608,8 @@ static const struct mv88e6xxx_ops mv88e6
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,
@@ -4410,6 +4412,8 @@ static const struct mv88e6xxx_ops mv88e6
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
 	.rmu_disable = mv88e6390_g1_rmu_disable,
+	.atu_get_hash = mv88e6165_g1_atu_get_hash,
+	.atu_set_hash = mv88e6165_g1_atu_set_hash,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_power = mv88e6390_serdes_power,


