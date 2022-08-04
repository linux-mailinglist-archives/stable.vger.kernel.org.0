Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D14C589BB5
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 14:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiHDM37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 08:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbiHDM36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 08:29:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8502248E94
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 05:29:57 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Lz7HQ0MxGzWf0L;
        Thu,  4 Aug 2022 20:25:54 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
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
Subject: [PATCH stable 4.14 v3 1/3] printk: Export is_console_locked
Date:   Thu, 4 Aug 2022 12:27:32 +0000
Message-ID: <20220804122734.121201-2-chenjun102@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220804122734.121201-1-chenjun102@huawei.com>
References: <20220804122734.121201-1-chenjun102@huawei.com>
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

From: Hans de Goede <hdegoede@redhat.com>

commit d48de54a9dab5370edd2e991f78cc7996cf5483e upstream

This is a preparation patch for adding a number of WARN_CONSOLE_UNLOCKED()
calls to the fbcon code, which may be built as a module (event though
usually it is not).

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Chen Jun <chenjun102@huawei.com>
---
 kernel/printk/printk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 11173d0b51bc..ad4772869d48 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2259,6 +2259,7 @@ int is_console_locked(void)
 {
 	return console_locked;
 }
+EXPORT_SYMBOL(is_console_locked);
 
 /*
  * Check if we have any console that is capable of printing while cpu is
-- 
2.17.1

