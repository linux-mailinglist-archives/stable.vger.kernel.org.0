Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FC0615810
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiKBCov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKBCou (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:44:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CE61BEAF
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87205CE1F1D
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2430FC433C1;
        Wed,  2 Nov 2022 02:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357087;
        bh=2reCW8qY7VCLP0DggSZ1mAfVF1eILFVfy4OmNNC6pdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Re76np/00KtRLMSssf/xa9GthUR5p5GocRr1mZLGHgJf6zqLIX5lYKW0p/24ooFBT
         erVUKaF+DxkRiT2QbWtWpVncPm8kW+/RZvDFxdddxKV79Kc0PoVnrbM5khHrTM6an6
         vuocp8eY2Qyq4m2xHLFx12+13rSOfbUy79tg5jcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 110/240] media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation
Date:   Wed,  2 Nov 2022 03:31:25 +0100
Message-Id: <20221102022113.876748824@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit bb9ea2c31fa11b789ade4c3abcdda3c5370a76ab ]

The doc says the I²C device's name is used if devname is NULL, but
actually the I²C device driver's name is used.

Fixes: 0658293012af ("media: v4l: subdev: Add a function to set an I²C sub-device's name")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/media/v4l2-common.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index b708d63995f4..2ae2be4c87e5 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -175,7 +175,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
  *
  * @sd: pointer to &struct v4l2_subdev
  * @client: pointer to struct i2c_client
- * @devname: the name of the device; if NULL, the I²C device's name will be used
+ * @devname: the name of the device; if NULL, the I²C device drivers's name
+ *           will be used
  * @postfix: sub-device specific string to put right after the I²C device name;
  *	     may be NULL
  */
-- 
2.35.1



