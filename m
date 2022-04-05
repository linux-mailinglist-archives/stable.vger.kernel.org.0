Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D635A4F2C95
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240217AbiDEJfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiDEIOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:14:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33551986F5;
        Tue,  5 Apr 2022 01:03:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBF22617D4;
        Tue,  5 Apr 2022 08:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076E4C385A0;
        Tue,  5 Apr 2022 08:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145789;
        bh=xKmTIuWGghxPlamgA+4jpkdwdalBgdMukXmT3MDoh0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxGEe6a4fcS3d+6/+KsRtIL6YAqBqahdLlk/gTc+ga04568xBkRg5cFBG6uAWwOSw
         XJTVQYUOB1JoAfm2QxGyOSDqe6JZIvoBEQ31LCmTeEUHqO8H2FtpOXPAveYk/7MN75
         +tW/UjScEPdmr5T0mlEnsYA9FyNHJyzJz9Wk3TxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0530/1126] cxl/core: Fix cxl_probe_component_regs() error message
Date:   Tue,  5 Apr 2022 09:21:17 +0200
Message-Id: <20220405070423.188083070@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit d621bc2e7282f9955033a6359877fd4ac4be60e1 ]

Fix a '\n' vs '/n' typo.

Fixes: 08422378c4ad ("cxl/pci: Add HDM decoder capabilities")
Acked-by: Ben Widawsky <ben.widawsky@intel.com
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/164298418268.3018233.17790073375430834911.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
index e37e23bf4355..cdc0b75d94f2 100644
--- a/drivers/cxl/core/regs.c
+++ b/drivers/cxl/core/regs.c
@@ -49,7 +49,7 @@ void cxl_probe_component_regs(struct device *dev, void __iomem *base,
 
 	if (FIELD_GET(CXL_CM_CAP_HDR_ID_MASK, cap_array) != CM_CAP_HDR_CAP_ID) {
 		dev_err(dev,
-			"Couldn't locate the CXL.cache and CXL.mem capability array header./n");
+			"Couldn't locate the CXL.cache and CXL.mem capability array header.\n");
 		return;
 	}
 
-- 
2.34.1



