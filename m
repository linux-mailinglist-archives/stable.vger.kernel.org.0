Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B273313811
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhBHPgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:36:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233867AbhBHPay (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:30:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B36FF64ECE;
        Mon,  8 Feb 2021 15:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797439;
        bh=Dnz1EKO/fIwdEaON3Ijcwh0Nt6RSKDXAYSLBSHRb/SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iq+uVMhc/jfTfidecTFIn+4jjCNlnuc01FHW03y8WBqssRVljcDPLDLk2GatV2/9C
         qFezp2301ElHmlmO1gcz47R7VYFsSlxa+aisWhdcaaTo7D/ri1JxCkZrUTxtR90qFk
         EJfI9e6031VA0QxZz8EwoB0u8hKfuMdd/KfXAF38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 111/120] Input: goodix - add support for Goodix GT9286 chip
Date:   Mon,  8 Feb 2021 16:01:38 +0100
Message-Id: <20210208145822.805409748@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

commit 2dce6db70c77bbe639f5cd9cc796fb8f2694a7d0 upstream.

The Goodix GT9286 is a capacitive touch sensor IC based on GT1x.

This chip can be found on a number of smartphones, including the
F(x)tec Pro 1 and the Elephone U.

This has been tested on F(x)Tec Pro1 (MSM8998).

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20210109135512.149032-2-angelogioacchino.delregno@somainline.org
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/goodix.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -157,6 +157,7 @@ static const struct goodix_chip_id goodi
 	{ .id = "5663", .data = &gt1x_chip_data },
 	{ .id = "5688", .data = &gt1x_chip_data },
 	{ .id = "917S", .data = &gt1x_chip_data },
+	{ .id = "9286", .data = &gt1x_chip_data },
 
 	{ .id = "911", .data = &gt911_chip_data },
 	{ .id = "9271", .data = &gt911_chip_data },
@@ -1445,6 +1446,7 @@ static const struct of_device_id goodix_
 	{ .compatible = "goodix,gt927" },
 	{ .compatible = "goodix,gt9271" },
 	{ .compatible = "goodix,gt928" },
+	{ .compatible = "goodix,gt9286" },
 	{ .compatible = "goodix,gt967" },
 	{ }
 };


