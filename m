Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6398B2BA807
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgKTLEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:04:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgKTLEJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:04:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB7102245A;
        Fri, 20 Nov 2020 11:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870248;
        bh=0y8pARHSu06BzIOetLFWR+XIxZY/Sk47qNXdJ+ZBZY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qFZSN/CQxjbk8IwNU9JJMTx6a4PMB00QMtdJNFX2zd/i0CCbux2PRv/00vnQWw6b
         ASW10q6YqFv24A4R2A9o/h9xTiUtpebHc1o5GpU5XTaUIOc70/bwh/YNozuMWYcixT
         QxZmxzDObj4KSGYyIy4oJbhm2cPSG607/sdA4GOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Looijmans <mike.looijmans@topic.nl>,
        Peter Rosin <peda@axentia.se>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4.9 11/16] i2c: mux: pca954x: Add missing pca9546 definition to chip_desc
Date:   Fri, 20 Nov 2020 12:03:16 +0100
Message-Id: <20201120104540.289446648@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.706905067@linuxfoundation.org>
References: <20201120104539.706905067@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Looijmans <mike.looijmans@topic.nl>

commit dbe4d69d252e9e65c6c46826980b77b11a142065 upstream.

The spec for the pca9546 was missing. This chip is the same as the pca9545
except that it lacks interrupt lines. While the i2c_device_id table mapped
the pca9546 to the pca9545 definition the compatible table did not.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
Signed-off-by: Peter Rosin <peda@axentia.se>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/muxes/i2c-mux-pca954x.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/i2c/muxes/i2c-mux-pca954x.c
+++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
@@ -96,6 +96,10 @@ static const struct chip_desc chips[] =
 		.nchans = 4,
 		.muxtype = pca954x_isswi,
 	},
+	[pca_9546] = {
+		.nchans = 4,
+		.muxtype = pca954x_isswi,
+	},
 	[pca_9547] = {
 		.nchans = 8,
 		.enable = 0x8,
@@ -113,7 +117,7 @@ static const struct i2c_device_id pca954
 	{ "pca9543", pca_9543 },
 	{ "pca9544", pca_9544 },
 	{ "pca9545", pca_9545 },
-	{ "pca9546", pca_9545 },
+	{ "pca9546", pca_9546 },
 	{ "pca9547", pca_9547 },
 	{ "pca9548", pca_9548 },
 	{ }


