Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA6110BB04
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732796AbfK0VIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732791AbfK0VIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:08:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 463EE21774;
        Wed, 27 Nov 2019 21:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888925;
        bh=qatBiUoJgLVyhApb5IdaSM3wrONFuruow8EtSDXjdT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qKb5C0ykDuXK0U4RDJgl0ZeUUvnlntTtjKMOpsgziYPXnUeryvYlL60pPrKmTDWi6
         ihlL5ewvutLiZCRReV/tfxGWaAAeiUIfJLFfC/556Ml9KQMppRaGW5ea9N/ue8O+qH
         0djCSB3xBPpsUXISkTSLQpbSkt4yxZGt+e+8CP94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shani Shapp <shanish@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 17/95] net/mlx5: Update the list of the PCI supported devices
Date:   Wed, 27 Nov 2019 21:31:34 +0100
Message-Id: <20191127202850.297706293@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shani Shapp <shanish@mellanox.com>

[ Upstream commit b7eca940322f47fd30dafb70da04d193a0154090 ]

Add the upcoming ConnectX-6 LX device ID.

Fixes: 85327a9c4150 ("net/mlx5: Update the list of the PCI supported devices")
Signed-off-by: Shani Shapp <shanish@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1552,6 +1552,7 @@ static const struct pci_device_id mlx5_c
 	{ PCI_VDEVICE(MELLANOX, 0x101c), MLX5_PCI_DEV_IS_VF},	/* ConnectX-6 VF */
 	{ PCI_VDEVICE(MELLANOX, 0x101d) },			/* ConnectX-6 Dx */
 	{ PCI_VDEVICE(MELLANOX, 0x101e), MLX5_PCI_DEV_IS_VF},	/* ConnectX Family mlx5Gen Virtual Function */
+	{ PCI_VDEVICE(MELLANOX, 0x101f) },			/* ConnectX-6 LX */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */


