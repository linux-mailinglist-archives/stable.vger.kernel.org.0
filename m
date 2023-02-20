Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CF169D283
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjBTSFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjBTSFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:05:10 -0500
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07FE20552
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1676916303;
        bh=SWQSw1JH8cn5f0vcBOn1H8ibqC2WQo9JreZHhGXNQVU=;
        h=From:To:Cc:Subject:Date;
        b=i6ON0xJZtJR0lDH3z543kUwWFORwYBDKtWIcUqxnkoqyaX6y9mTk58dTQWNmjDuwb
         zPxA9kKeGxgxIdU54cp43kj0TRd8M58EClcoA7FP+1TkPVlgj9eJ4SRXJAowcBYLNt
         KwbyH11KNEHm4akm3Bfh7jN0XwgtKZOKYYuv1LuI=
Received: from localhost.localdomain ([106.92.97.84])
        by newxmesmtplogicsvrszc1-0.qq.com (NewEsmtp) with SMTP
        id 141274B8; Tue, 21 Feb 2023 02:05:01 +0800
X-QQ-mid: xmsmtpt1676916301t24lo456k
Message-ID: <tencent_B38279CA0FF1F9A0CA887A2B886A92209D05@qq.com>
X-QQ-XMAILINFO: NEq0i4SycP3b0Asou6utGokkCc2O0wvGRUXMkh5ELffcnrC5wdFiNe2WOgNl7t
         W1cgwDcxyEC7CM/9lSrWAVl9H625mb9O4YqsJypDAvnuvDFweiw2e569mL5MwiX8T16mjKiKOiJc
         SQlpOp5XtEMD2cZoXtJCH3+ojrlCQyw7UgFG11HhzXFwcmEABS7a14dO51xZtVnSVfJBbJMaFCDt
         X1/fkomtBb6gt7+PYM3+NJxnHHs6l+Imqad1IKeIaYpIdkqBqhkS5MpXfc/B0kjnyD9aVwEMKTlF
         qHglAO5PeNIqr9MoWAA+MR5JnXs0o7jBpSe9KGWCms8WJPgMSnRDV12mMhBPmYI25YLeUR6inbGS
         qUe54b50OxnBgSXfvfxm5VXgPl7S79qtmBRmcXzikH3jxVVftVGA7mS6FO7k2rcmVgqlGvj5AbOU
         lYlP8QwTJGgzshFTvMlKXwzrs4NuS78X/knGZ90bfLdqNsRblVszITpid9trTFuP/EWAdxdiXsx/
         ebTgF8BcK4F8XJcSpG4Tv9tumA3NvsAYBBkfBsqNDowSL16XKWSnwLlMKRA8ILorakEz3CBB29w9
         dcjURLBoxZZnikYhJ13c5T4Gxq/8KmhYsTm4T/T549Rpyo16mCJUldXhoHn/YQSU3FV/bP4qcdyT
         5fwn21iECxVpkkt+Bri6QEfRhav/xrSAYL6hxLDwDLejhM4Uub57SyWwsdYW+9/wvv0ZKEHUTcU8
         tBjDUz3N1BaslY84E1pyS/A8UO0UgMH1tKtX4eLOheyQSc84vNShbOWoXqabDmVVnVegDtwJSWoQ
         lCbWbsrbCcxy/oKv4HyVQg6qvR4DUvPj2kebMvpOhvm3IXNUCZJcqpys4q7utrrIQkrabA4+J+sB
         pn+clt+PuCrhuzxhav6YSd5BEZx+FZgMX4kzjEOffnd4bIBWnyj1zjvDe80kIYEd5gUiEhqa42Ra
         bMwwAjey8NQzMZr5cbuANezaet5haHuF369dHcR9vwyoR8eVZuMP1kQhYpgL5KUutyQXiDdL98s+
         9FlZGpx4FLWxGR9HrW
From:   wenyang.linux@foxmail.com
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Wen Yang <wenyang.linux@foxmail.com>,
        Joel Stanley <joel@jms.id.au>, Christoph Hellwig <hch@lst.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 5.10 1/4] Revert "Revert "block: nbd: add sanity check for first_minor""
Date:   Tue, 21 Feb 2023 02:04:46 +0800
X-OQ-MSGID: <20230220180449.36425-1-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang.linux@foxmail.com>

This reverts commit 0daa75bf750c400af0a0127fae37cd959d36dee7.

These problems such as:
https://lore.kernel.org/all/CACPK8XfUWoOHr-0RwRoYoskia4fbAbZ7DYf5wWBnv6qUnGq18w@mail.gmail.com/
It was introduced by introduced by commit b1a811633f73 ("block: nbd: add sanity check for first_minor")
and has been have been fixed by commit e4c4871a7394 ("nbd: fix max value for 'first_minor'").

Cc: Joel Stanley <joel@jms.id.au>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Pavel Skripkin <paskripkin@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
---
 drivers/block/nbd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b0d3dadeb964..bf8148ebd858 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1771,7 +1771,17 @@ static int nbd_dev_add(int index)
 	refcount_set(&nbd->refs, 1);
 	INIT_LIST_HEAD(&nbd->list);
 	disk->major = NBD_MAJOR;
+
+	/* Too big first_minor can cause duplicate creation of
+	 * sysfs files/links, since first_minor will be truncated to
+	 * byte in __device_add_disk().
+	 */
 	disk->first_minor = index << part_shift;
+	if (disk->first_minor > 0xff) {
+		err = -EINVAL;
+		goto out_free_idr;
+	}
+
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
 	sprintf(disk->disk_name, "nbd%d", index);
-- 
2.37.2

