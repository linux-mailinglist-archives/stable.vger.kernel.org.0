Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 747B2B2066
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390219AbfIMNV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390827AbfIMNV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:21:28 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5A120717;
        Fri, 13 Sep 2019 13:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380888;
        bh=gjzFRXAqiMorqpExW6XZ3MrQJzRAdD16aRLBvFb9r/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jy/2h6KBvG9zwp8d9I1I2RuvNGv3ujfxYf+6luA2yeUscdZvOFPyYjJtZ7wFPTXMJ
         fgx+TM2XdM6A2V6rXbDjSHIQ2tZ9sAMZAjHo6SYadxCG8wQlw72lVp4/P1x3mk8MVH
         DsSzVyVY2Vxqx7dr3FWB8MAyvOXgQ6GrfbG+G/fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 5.2 10/37] drm/nouveau/sec2/gp102: add missing MODULE_FIRMWAREs
Date:   Fri, 13 Sep 2019 14:07:15 +0100
Message-Id: <20190913130513.757861608@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

commit 55f7e5c364dce20e691fda329fb2a6cc3cbb63b6 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: stable@vger.kernel.org [v5.2+]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gp102.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gp102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/secboot/gp102.c
@@ -190,6 +190,9 @@ MODULE_FIRMWARE("nvidia/gp102/nvdec/scru
 MODULE_FIRMWARE("nvidia/gp102/sec2/desc.bin");
 MODULE_FIRMWARE("nvidia/gp102/sec2/image.bin");
 MODULE_FIRMWARE("nvidia/gp102/sec2/sig.bin");
+MODULE_FIRMWARE("nvidia/gp102/sec2/desc-1.bin");
+MODULE_FIRMWARE("nvidia/gp102/sec2/image-1.bin");
+MODULE_FIRMWARE("nvidia/gp102/sec2/sig-1.bin");
 MODULE_FIRMWARE("nvidia/gp104/acr/bl.bin");
 MODULE_FIRMWARE("nvidia/gp104/acr/unload_bl.bin");
 MODULE_FIRMWARE("nvidia/gp104/acr/ucode_load.bin");
@@ -210,6 +213,9 @@ MODULE_FIRMWARE("nvidia/gp104/nvdec/scru
 MODULE_FIRMWARE("nvidia/gp104/sec2/desc.bin");
 MODULE_FIRMWARE("nvidia/gp104/sec2/image.bin");
 MODULE_FIRMWARE("nvidia/gp104/sec2/sig.bin");
+MODULE_FIRMWARE("nvidia/gp104/sec2/desc-1.bin");
+MODULE_FIRMWARE("nvidia/gp104/sec2/image-1.bin");
+MODULE_FIRMWARE("nvidia/gp104/sec2/sig-1.bin");
 MODULE_FIRMWARE("nvidia/gp106/acr/bl.bin");
 MODULE_FIRMWARE("nvidia/gp106/acr/unload_bl.bin");
 MODULE_FIRMWARE("nvidia/gp106/acr/ucode_load.bin");
@@ -230,6 +236,9 @@ MODULE_FIRMWARE("nvidia/gp106/nvdec/scru
 MODULE_FIRMWARE("nvidia/gp106/sec2/desc.bin");
 MODULE_FIRMWARE("nvidia/gp106/sec2/image.bin");
 MODULE_FIRMWARE("nvidia/gp106/sec2/sig.bin");
+MODULE_FIRMWARE("nvidia/gp106/sec2/desc-1.bin");
+MODULE_FIRMWARE("nvidia/gp106/sec2/image-1.bin");
+MODULE_FIRMWARE("nvidia/gp106/sec2/sig-1.bin");
 MODULE_FIRMWARE("nvidia/gp107/acr/bl.bin");
 MODULE_FIRMWARE("nvidia/gp107/acr/unload_bl.bin");
 MODULE_FIRMWARE("nvidia/gp107/acr/ucode_load.bin");
@@ -250,3 +259,6 @@ MODULE_FIRMWARE("nvidia/gp107/nvdec/scru
 MODULE_FIRMWARE("nvidia/gp107/sec2/desc.bin");
 MODULE_FIRMWARE("nvidia/gp107/sec2/image.bin");
 MODULE_FIRMWARE("nvidia/gp107/sec2/sig.bin");
+MODULE_FIRMWARE("nvidia/gp107/sec2/desc-1.bin");
+MODULE_FIRMWARE("nvidia/gp107/sec2/image-1.bin");
+MODULE_FIRMWARE("nvidia/gp107/sec2/sig-1.bin");


