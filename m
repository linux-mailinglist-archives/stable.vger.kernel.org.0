Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ED3589AF9
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 13:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbiHDLS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 07:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239644AbiHDLSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 07:18:13 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7779467C9E
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 04:18:02 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Lz5lY2N7fzTgXQ;
        Thu,  4 Aug 2022 19:16:41 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 19:18:00 +0800
Received: from mdc.huawei.com (10.175.112.208) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 19:17:59 +0800
From:   Chen Jun <chenjun102@huawei.com>
To:     <stable@vger.kernel.org>, <deller@gmx.de>, <geert@linux-m68k.org>,
        <b.zolnierkie@samsung.com>, <gregkh@linuxfoundation.org>
CC:     <xuqiang36@huawei.com>
Subject: [PATCH stable 4.14 v2 0/3] add fix patches for CVE-2021-33655
Date:   Thu, 4 Aug 2022 11:15:36 +0000
Message-ID: <20220804111539.96424-1-chenjun102@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

