Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE1259475E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353915AbiHOXmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354228AbiHOXll (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CD960D1;
        Mon, 15 Aug 2022 13:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 374BDB81135;
        Mon, 15 Aug 2022 20:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0A1C433D6;
        Mon, 15 Aug 2022 20:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594274;
        bh=CNC3RHZtr4Vx0ECyRUs2YPM5WBx6e2DmCYMF7MiujFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXIN2ilr6pfr6eJHmLDcvYd+JnWm1YLklqEBP8eTbdAndzYgM4TQUSg06tMe5spiL
         0utEjqNaf3aGLZ/RTmX+/I095pvj3rDcdPB/9dvXnedBsul3s0dTgL3N8nj0Q5wa/5
         zFFAaaMXcv+bVzCe0ycvCyJBjaafy+qFCEGMSKTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0376/1157] media: imx-jpeg: Correct some definition according specification
Date:   Mon, 15 Aug 2022 19:55:32 +0200
Message-Id: <20220815180454.765446069@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 5a601f89e846c1b6005ab274d039e5036fc22015 ]

the register CAST_NOMFRSIZE_LO should be equal to CAST_STATUS16
the register CAST_NOMFRSIZE_HI should be equal to CAST_STATUS17
the register CAST_OFBSIZE_LO should be equal to CAST_STATUS18
the register CAST_OFBSIZE_HI should be equal to CAST_STATUS19

Fixes: 2db16c6ed72ce ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h
index d838e875616c..5f64cbbe0fa9 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-hw.h
@@ -53,10 +53,10 @@
 #define CAST_REC_REGS_SEL		CAST_STATUS4
 #define CAST_LUMTH			CAST_STATUS5
 #define CAST_CHRTH			CAST_STATUS6
-#define CAST_NOMFRSIZE_LO		CAST_STATUS7
-#define CAST_NOMFRSIZE_HI		CAST_STATUS8
-#define CAST_OFBSIZE_LO			CAST_STATUS9
-#define CAST_OFBSIZE_HI			CAST_STATUS10
+#define CAST_NOMFRSIZE_LO		CAST_STATUS16
+#define CAST_NOMFRSIZE_HI		CAST_STATUS17
+#define CAST_OFBSIZE_LO			CAST_STATUS18
+#define CAST_OFBSIZE_HI			CAST_STATUS19
 
 #define MXC_MAX_SLOTS	1 /* TODO use all 4 slots*/
 /* JPEG-Decoder Wrapper Slot Registers 0..3 */
-- 
2.35.1



