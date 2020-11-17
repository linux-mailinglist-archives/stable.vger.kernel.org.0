Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDC52B63E0
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733008AbgKQNlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:41:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732391AbgKQNlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C90E4207BC;
        Tue, 17 Nov 2020 13:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620463;
        bh=qABi8Z2Sw8PXTMh6ugHDVS9zVeQESYovPOrcGYIVp6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHTPV5YAoHHhHOnUxgAKNzDaGqT/Wx0eOJe3UIq+fFWUrnbMJKcOLj9LCeK1QLirq
         oPeHlt4tX+7GXfnCZK8maXya/JhiUR669SLyLi8Ccpbq5Hquak0qWvHkKgPxKjUr+C
         RlojEmjkVS5tjZnknaFt/xEEEDaELdIBioqYlkzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 228/255] drm/amd/display: Add missing pflip irq
Date:   Tue, 17 Nov 2020 14:06:08 +0100
Message-Id: <20201117122150.031951638@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>

commit a422490a595600659664901b609aacccdbba4a5f upstream.

If we have more than 4 displays we will run
into dummy irq calls or flip timout issues.

Signed-off-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/irq/dcn30/irq_service_dcn30.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/irq/dcn30/irq_service_dcn30.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn30/irq_service_dcn30.c
@@ -306,8 +306,8 @@ irq_source_info_dcn30[DAL_IRQ_SOURCES_NU
 	pflip_int_entry(1),
 	pflip_int_entry(2),
 	pflip_int_entry(3),
-	[DC_IRQ_SOURCE_PFLIP5] = dummy_irq_entry(),
-	[DC_IRQ_SOURCE_PFLIP6] = dummy_irq_entry(),
+	pflip_int_entry(4),
+	pflip_int_entry(5),
 	[DC_IRQ_SOURCE_PFLIP_UNDERLAY0] = dummy_irq_entry(),
 	gpio_pad_int_entry(0),
 	gpio_pad_int_entry(1),


