Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D3D4EEFDA
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347105AbiDAObf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347192AbiDAOan (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:30:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7737286F64;
        Fri,  1 Apr 2022 07:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7451461C19;
        Fri,  1 Apr 2022 14:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4674BC2BBE4;
        Fri,  1 Apr 2022 14:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823254;
        bh=JsYgHBNMMGGDkT6RyF3xvDVWNM/IpQ6TT1R5Sk0yN6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRLeII3RzPGE/Hx6Wur7frs3kZhLLGBxghWEZmGGTbAfZqBd3S/Lwu90FIA8fHWz5
         SZRI6jYSG4kRzkGr9e5KcsJA1c2ft2EDNI+c7tcvi2ljRP+N1OnosPbAun20hk7EOx
         XSiY/Feo17Deq3SfGiRM5qOFK8vKxcLkbUsECkLORJ/CwuhUqVknJTaAjUZ4V7dsEG
         f8C3m4kvNdJjNOe+XBo+jn1gnP4MWJsTie6B4RgfrCtbIKtau2+gR0TzWrQ76Qrm31
         r1SP7H58Q2DEYpwYKW4H5XonxPdkn7M9HAdUJvQENOTe+p7s562FVVWHUqJpoJSlfT
         O4+k8lqE2474A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        john.garry@huawei.com, bvanassche@acm.org, yuyufen@huawei.com,
        himanshu.madhani@oracle.com, thunder.leizhen@huawei.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 035/149] scsi: mvsas: Replace snprintf() with sysfs_emit()
Date:   Fri,  1 Apr 2022 10:23:42 -0400
Message-Id: <20220401142536.1948161-35-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yang Guang <yang.guang5@zte.com.cn>

[ Upstream commit 0ad3867b0f13e45cfee5a1298bfd40eef096116c ]

coccinelle report:
./drivers/scsi/mvsas/mv_init.c:699:8-16:
WARNING: use scnprintf or sprintf
./drivers/scsi/mvsas/mv_init.c:747:8-16:
WARNING: use scnprintf or sprintf

Use sysfs_emit() instead of scnprintf() or sprintf().

Link: https://lore.kernel.org/r/c1711f7cf251730a8ceb5bdfc313bf85662b3395.1643182948.git.yang.guang5@zte.com.cn
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mvsas/mv_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index dcae2d4464f9..44df7c03aab8 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -696,7 +696,7 @@ static struct pci_driver mvs_pci_driver = {
 static ssize_t driver_version_show(struct device *cdev,
 				   struct device_attribute *attr, char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%s\n", DRV_VERSION);
+	return sysfs_emit(buffer, "%s\n", DRV_VERSION);
 }
 
 static DEVICE_ATTR_RO(driver_version);
@@ -744,7 +744,7 @@ static ssize_t interrupt_coalescing_store(struct device *cdev,
 static ssize_t interrupt_coalescing_show(struct device *cdev,
 					 struct device_attribute *attr, char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%d\n", interrupt_coalescing);
+	return sysfs_emit(buffer, "%d\n", interrupt_coalescing);
 }
 
 static DEVICE_ATTR_RW(interrupt_coalescing);
-- 
2.34.1

