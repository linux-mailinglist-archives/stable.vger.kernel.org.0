Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148595551A
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 18:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfFYQt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 12:49:26 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39011 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfFYQtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 12:49:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so3668399wma.4
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 09:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BpBEtYSgqrBi7j4SiCT1m6YSPtNFJxDP5oog1k2Dp/E=;
        b=eDnM5SmroyDBRGWomt4zm7VTbV4K8ugQm9G7mQkVjtkKKrgpPXvluSKc0vRgU+BNb1
         VpUb13atGzKgtE48uLL+hhQvMBm9nrkO/hshQUUBPnbzeI7eO2oFXOu/PfLFTvmUSWv+
         x7u4OqYLiuvEApl5clWFxy/edonhHNOkVcoa6DL6GKCw3W95w+/vY9iMBQZEbF4R2QRS
         lLKqTq8JHXN2kSAZndjbq6Wix02hiVIb2mJT5MSoSkAUY3hR43RXrZcC4LYzVLDMMY5A
         1zedhzJ1Y2ZuXVSUI//I5AgEyxzZ5K9tcypa/cdU1QDNyLXJkXuoQLX+foMyOZZwbDMF
         CA5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BpBEtYSgqrBi7j4SiCT1m6YSPtNFJxDP5oog1k2Dp/E=;
        b=sIxJxRkP+6eAPEqHH2L4v4NNnzSr9gFSoY+4/HQqmLeghZhmDGbJBwZe6VeC6dqpGI
         MTpyjUw46B3SDLr+L/+hP5YixqJc/N0dRHLDBxcfldKpJJHuK0ombRi8h5EIhD/3REDU
         2+GVC6YrQiR5g5tuOmklL3mz3IwXqOX6LMxPd2odlqRMzum9FBNBDBXS+saDLYpc5FU/
         fCkUETPQwOJGXB5vJpdP9NuugrzKnYR//jI0Try8AuBgSD3wKl+E2Rq/OCjPsPTW+ftE
         bOOrH7pJRdmD9juM3wO/MYNdI4OJ5f+5hOTTmve6A5CkM4ONWnddMEn1qIOa3q1stbrY
         P81g==
X-Gm-Message-State: APjAAAU2oZRcpJYPJOF6zqsYwkbNojYmgfVBJakhQji0nRE+n+QdKvd3
        PtWYJEIT2BlNzmWbX6PTt4Jjcw==
X-Google-Smtp-Source: APXvYqyVBBSlo04QiVVJZul9HxR3AfR32ezyhijOC6RrdMyx1+Q4KkR7gbPOK8c8SM4hhdG5xjAAig==
X-Received: by 2002:a1c:23c4:: with SMTP id j187mr20851213wmj.176.1561481363562;
        Tue, 25 Jun 2019 09:49:23 -0700 (PDT)
Received: from debian-brgl.home ([2a01:cb1d:af:5b00:6d6c:8493:1ab5:dad7])
        by smtp.gmail.com with ESMTPSA id h14sm3078652wro.30.2019.06.25.09.49.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 09:49:23 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ARM: davinci: omapl138-hawk: add missing regulator constraints for OHCI
Date:   Tue, 25 Jun 2019 18:49:15 +0200
Message-Id: <20190625164915.30242-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190625164915.30242-1-brgl@bgdev.pl>
References: <20190625164915.30242-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

We need to enable status changes for the fixed power supply for the USB
controller.

Fixes: 1d272894ec4f ("ARM: davinci: omapl138-hawk: add a fixed regulator for ohci-da8xx")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm/mach-davinci/board-omapl138-hawk.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-davinci/board-omapl138-hawk.c b/arch/arm/mach-davinci/board-omapl138-hawk.c
index db177a6a7e48..5390a8630cf0 100644
--- a/arch/arm/mach-davinci/board-omapl138-hawk.c
+++ b/arch/arm/mach-davinci/board-omapl138-hawk.c
@@ -306,6 +306,9 @@ static struct regulator_consumer_supply hawk_usb_supplies[] = {
 static struct regulator_init_data hawk_usb_vbus_data = {
 	.consumer_supplies	= hawk_usb_supplies,
 	.num_consumer_supplies	= ARRAY_SIZE(hawk_usb_supplies),
+	.constraints    = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
 };
 
 static struct fixed_voltage_config hawk_usb_vbus = {
-- 
2.21.0

