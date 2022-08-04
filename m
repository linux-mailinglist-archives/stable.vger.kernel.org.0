Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF5B589BB3
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 14:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbiHDM36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 08:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiHDM35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 08:29:57 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AE52C66A
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 05:29:56 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lz7Js5Xq3zlVtS;
        Thu,  4 Aug 2022 20:27:09 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 20:29:54 +0800
Received: from mdc.huawei.com (10.175.112.208) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 20:29:54 +0800
From:   Chen Jun <chenjun102@huawei.com>
To:     <stable@vger.kernel.org>, <deller@gmx.de>, <geert@linux-m68k.org>,
        <b.zolnierkie@samsung.com>, <gregkh@linuxfoundation.org>
CC:     <xuqiang36@huawei.com>
Subject: [PATCH stable 4.14 v3 0/3] add fix patches for CVE-2021-33655
Date:   Thu, 4 Aug 2022 12:27:31 +0000
Message-ID: <20220804122734.121201-1-chenjun102@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v3: modify git message.

v2: add patch d48de54a9dab ("printk: Export is_console_locked") to fix a build error
caused by v1 if CONFIG_FB = m.
        ERROR: "is_console_locked" [drivers/video/fbdev/core/fb.ko] undefined!

v1: https://lore.kernel.org/stable/20220729031140.21806-1-chenjun102@huawei.com/

Hans de Goede (1):
  printk: Export is_console_locked

Helge Deller (2):
  fbcon: Prevent that screen size is smaller than font size
  fbmem: Check virtual screen sizes in fb_set_var()

 drivers/video/fbdev/core/fbcon.c | 28 ++++++++++++++++++++++++++++
 drivers/video/fbdev/core/fbmem.c | 20 +++++++++++++++++---
 include/linux/fbcon.h            |  4 ++++
 kernel/printk/printk.c           |  1 +
 4 files changed, 50 insertions(+), 3 deletions(-)

-- 
2.17.1

