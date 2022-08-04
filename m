Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205A8589807
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 09:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbiHDHCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Aug 2022 03:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237782AbiHDHCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Aug 2022 03:02:49 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C112127CF6
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 00:02:47 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Lz0526VhNzTgYV;
        Thu,  4 Aug 2022 15:01:26 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 15:02:45 +0800
Received: from mdc.huawei.com (10.175.112.208) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 4 Aug 2022 15:02:45 +0800
From:   Chen Jun <chenjun102@huawei.com>
To:     <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <xuqiang36@huawei.com>
Subject: [PATCH stable 4.14 0/1] Backport "printk: Export is_console_locked"
Date:   Thu, 4 Aug 2022 07:00:24 +0000
Message-ID: <20220804070025.122783-1-chenjun102@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

https://lore.kernel.org/stable/20220729031140.21806-1-chenjun102@huawei.com/
will make build failed if CONFIG_FB = M.
The error is:
	ERROR: "is_console_locked" [drivers/video/fbdev/core/fb.ko] undefined!

To fix it, backport d48de54a9dab ("printk: Export is_console_locked").

Hans de Goede (1):
  printk: Export is_console_locked

 kernel/printk/printk.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.17.1

