Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF0225139E
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 09:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgHYHxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 03:53:43 -0400
Received: from out28-99.mail.aliyun.com ([115.124.28.99]:33571 "EHLO
        out28-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHYHxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 03:53:42 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08760107|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00823021-0.000331364-0.991438;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03297;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.INWxsBw_1598342001;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.INWxsBw_1598342001)
          by smtp.aliyun-inc.com(10.147.42.198);
          Tue, 25 Aug 2020 15:53:39 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     tsbogend@alpha.franken.de
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, zhenwenjin@gmail.com,
        sernia.zhou@foxmail.com, yanfei.li@ingenic.com,
        rick.tyliu@ingenic.com, aric.pzqi@ingenic.com,
        dongsheng.qiu@ingenic.com, krzk@kernel.org, hns@goldelico.com,
        ebiederm@xmission.com, paul@crapouillou.net
Subject: [PATCH 1/1] MIPS: CI20: Update defconfig for EFUSE.
Date:   Tue, 25 Aug 2020 15:52:39 +0800
Message-Id: <20200825075239.17133-2-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200825075239.17133-1-zhouyanjie@wanyeetech.com>
References: <20200825075239.17133-1-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 19c968222934 ("MIPS: DTS: CI20: make DM9000 Ethernet
controller use NVMEM to find the default MAC address") add EFUSE
node for DM9000 in CI20, however, the EFUSE driver is not selected,
which will cause the DM9000 to fail to read the MAC address from
EFUSE, causing the following issue:

[FAILED] Failed to start Raise network interfaces.

Fix this problem by select CONFIG_JZ4780_EFUSE by default in the
ci20_defconfig.

Fixes: 19c968222934 ("MIPS: DTS: CI20: make DM9000 Ethernet
controller use NVMEM to find the default MAC address").

Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
---
 arch/mips/configs/ci20_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/configs/ci20_defconfig b/arch/mips/configs/ci20_defconfig
index 0a46199fdc3f..050ee6a17e11 100644
--- a/arch/mips/configs/ci20_defconfig
+++ b/arch/mips/configs/ci20_defconfig
@@ -131,6 +131,7 @@ CONFIG_MEMORY=y
 CONFIG_JZ4780_NEMC=y
 CONFIG_PWM=y
 CONFIG_PWM_JZ4740=m
+CONFIG_JZ4780_EFUSE=y
 CONFIG_EXT4_FS=y
 # CONFIG_DNOTIFY is not set
 CONFIG_PROC_KCORE=y
-- 
2.11.0

