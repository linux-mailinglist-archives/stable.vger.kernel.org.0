Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C4D4C48C7
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242043AbiBYP0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241963AbiBYP0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:26:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA3A1E7468
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:25:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC3E261532
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4434C340F0;
        Fri, 25 Feb 2022 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645802757;
        bh=Y42ZRIA7r4IXrNcBJY/lRt53U4sLcctM1vldhrLJKO0=;
        h=Subject:To:Cc:From:Date:From;
        b=sLkwFUvwVwDHo7kGhrZ4/lckxUBfwLP/5NNy9SBMfd953r4Wc3dQmxpT2eM6CCzqo
         oxDb/DcxyYXEvPUA+WtWHQ2s3zJEACvbtO25X6/kAHvK3WpS/HxmMrJtK0Bihp0B4+
         lxDD6TlH9GnMN0BslqwW+p7BRTTtY36gu8kGJJS0=
Subject: FAILED: patch "[PATCH] net/mlx5: Update the list of the PCI supported devices" failed to apply to 5.10-stable tree
To:     meirl@nvidia.com, gal@nvidia.com, saeedm@nvidia.com,
        tariqt@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:25:37 +0100
Message-ID: <1645802737199145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f908a35b22180c4da64cf2647e4f5f0cd3054da7 Mon Sep 17 00:00:00 2001
From: Meir Lichtinger <meirl@nvidia.com>
Date: Mon, 10 Jan 2022 10:14:41 +0200
Subject: [PATCH] net/mlx5: Update the list of the PCI supported devices

Add the upcoming BlueField-4 and ConnectX-8 device IDs.

Fixes: 2e9d3e83ab82 ("net/mlx5: Update the list of the PCI supported devices")
Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2c774f367199..13f913c13a2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1840,10 +1840,12 @@ static const struct pci_device_id mlx5_core_pci_table[] = {
 	{ PCI_VDEVICE(MELLANOX, 0x101e), MLX5_PCI_DEV_IS_VF},	/* ConnectX Family mlx5Gen Virtual Function */
 	{ PCI_VDEVICE(MELLANOX, 0x101f) },			/* ConnectX-6 LX */
 	{ PCI_VDEVICE(MELLANOX, 0x1021) },			/* ConnectX-7 */
+	{ PCI_VDEVICE(MELLANOX, 0x1023) },			/* ConnectX-8 */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d2) },			/* BlueField integrated ConnectX-5 network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d3), MLX5_PCI_DEV_IS_VF},	/* BlueField integrated ConnectX-5 network controller VF */
 	{ PCI_VDEVICE(MELLANOX, 0xa2d6) },			/* BlueField-2 integrated ConnectX-6 Dx network controller */
 	{ PCI_VDEVICE(MELLANOX, 0xa2dc) },			/* BlueField-3 integrated ConnectX-7 network controller */
+	{ PCI_VDEVICE(MELLANOX, 0xa2df) },			/* BlueField-4 integrated ConnectX-8 network controller */
 	{ 0, }
 };
 

