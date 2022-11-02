Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8978D61584A
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiKBCs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiKBCs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:48:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1828011C04
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA122617C5
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA2CC433C1;
        Wed,  2 Nov 2022 02:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357336;
        bh=LQUSguNb4s72nbwz+/vxTpotbeOZaB1Y695Etx28mII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHPUcpiFfB2M8Jx6+PpU+ZAdPv0eF6k4GSUoe4JPc71turtMqFzCJZTwmt6/Zt44i
         VTYnzDg2fiw6zUCAKabsKZke2kOoy+lyh67pe+uRQWZJSRHt24kp0OH3+YOVnZPF7O
         FD+XHAe0smMt4Oj/x9HDalI+uZilUsZ+NopG4r9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 124/240] media: cedrus: Add a Kconfig dependency on RESET_CONTROLLER
Date:   Wed,  2 Nov 2022 03:31:39 +0100
Message-Id: <20221102022114.187544821@linuxfoundation.org>
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

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 26686b0da9f3fd042578c1093862c853f8e4ff1b ]

The driver relies on the reset controller API to work, so add
RESET_CONTROLLER as one of its Kconfig dependencies.

Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/sunxi/cedrus/Kconfig b/drivers/staging/media/sunxi/cedrus/Kconfig
index 21c13f9b6e33..621944f9907a 100644
--- a/drivers/staging/media/sunxi/cedrus/Kconfig
+++ b/drivers/staging/media/sunxi/cedrus/Kconfig
@@ -2,6 +2,7 @@
 config VIDEO_SUNXI_CEDRUS
 	tristate "Allwinner Cedrus VPU driver"
 	depends on VIDEO_DEV
+	depends on RESET_CONTROLLER
 	depends on HAS_DMA
 	depends on OF
 	select MEDIA_CONTROLLER
-- 
2.35.1



