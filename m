Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41CE69D285
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbjBTSFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjBTSFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:05:24 -0500
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D2A1F929
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1676916319;
        bh=w+QxJPpHfrBUYvIIgJmYXox1/yYsewWoqALi2AevEag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=zBu7TgzstJUeQuaNXULl/HGzAkloU9dXdHxfa9+SZ17FmE9zR4ABFu1JLl3Kq7/G1
         hFlpzIhu65IajBVbb/RyP+OypMsrnjagHBnDMtTWHMgpd8Sm3q67e1ej9ZKv7nFcqk
         b1LdvAX9sw2tqj6lRfidRpUp9o3s5uGp8B0p0u1k=
Received: from localhost.localdomain ([106.92.97.84])
        by newxmesmtplogicsvrszc1-0.qq.com (NewEsmtp) with SMTP
        id 141274B8; Tue, 21 Feb 2023 02:05:01 +0800
X-QQ-mid: xmsmtpt1676916314top2dxfqh
Message-ID: <tencent_78F37DD503B56650D624427A3CB3879FDB06@qq.com>
X-QQ-XMAILINFO: OLsBWtCIHsg6MkIh0oP27Z0MiRETPqCMi2NhfCBfg0b6i1eQRn04PEhoGGeaFC
         PcWJ2CQkPT8A8GHp8Jdrww9UbgjUsFnnerEn4QnJsd7cAfQ4yNKbKYogRmTQZC2+udUa3GYujYox
         WmldWMzD9eDN4JAh85m1nyzTn00TEkrazwtlBpXeY85c7m1yp39zVESAUm07ns0XSVRdx7UdCM3o
         8hUmPSAtMdfLsN6bA51JipZp76S41tHmHZh/lmoJ52IIRv3c+2corIfesfDPkJ/WbqvOF0O2h2Yr
         Jzu2yxD+2PCT0Pbj8wRiNZt8z68F7cQyVz7B7DAYPvFgOfZaWK/QSVaYERbi/CROLye3pGkW4DIU
         buSp+0Bu5WSdLV6KTf17y/QjFm+WyiQbw1NTXdLJGn8h020LyALgnCSpyHDqnK5gVfUHVIsPHMLQ
         1/ENou/GBU4HxHnl50lb4R5Yupeia9ZLWEXUonFIYsZz422cFYA18l9sXEk5FwhTshWSTnf70FVD
         NQqP2Mw/PQb0Y+GsA/ps7mqvWCQ1TxqlB6Eosst0IqcZ8oE9vrdZ8dp/5buiI9vg58SP5kRXHZXl
         MVwODZ6tGmag/Q9AHqSa1RMjkomuBYN6xiHKpK1qlElQdwgt93uhfDEHcJCpfLJ3ZMng89ij0c49
         TZBTG8Bs5uUsnd1f8r+Wm5OqA6VpvGR8nf4eRPaW2lS1rIubHc6+lAV5GVjT0x7pCR0oFOPbmqsl
         VSJtR/NonyDaoW/t2lG5RNJjPbuy++R/uT4EPXpbehqGm2729uPNT+4F7SBhBLjqOtg8R23+8mbf
         ixJbBlJsdJ44SHSsg/S0edBx1+neh8zupHkAEyPt16gzYD2Jv9pJUPJJ+EjiAxyk8vfOI8qOH4GR
         iAtUVeVd7RFyi2iEk+zMObchqGO8ghidaBbLNYs47YXgBmTJ6vI71MYDC9QyFbCX5ZQDF8DoA6fl
         PS8kOQFVe8IkSA+cM9Cuzf7dIW6KMv4RkaAv5MFCm0BTBRj9NFB3ckEFNLgCi7cvTsuYH7ZTjkJo
         8X0WDojFqiHqr98VTKDbdQzfzlzhjJfR64Jnml9s4Xrv6vD7rvTg5foYh+9bLl7yVTOdpBmw==
From:   wenyang.linux@foxmail.com
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Zhang Wensheng <zhangwensheng5@huawei.com>,
        Yu Kuai <yukuai3@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 5.10 4/4] nbd: fix possible overflow on 'first_minor' in nbd_dev_add()
Date:   Tue, 21 Feb 2023 02:04:49 +0800
X-OQ-MSGID: <20230220180449.36425-4-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230220180449.36425-1-wenyang.linux@foxmail.com>
References: <20230220180449.36425-1-wenyang.linux@foxmail.com>
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

From: Zhang Wensheng <zhangwensheng5@huawei.com>

commit 858f1bf65d3d9c00b5e2d8ca87dc79ed88267c98 upstream.

When 'index' is a big numbers, it may become negative which forced
to 'int'. then 'index << part_shift' might overflow to a positive
value that is not greater than '0xfffff', then sysfs might complains
about duplicate creation. Because of this, move the 'index' judgment
to the front will fix it and be better.

Fixes: b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")
Fixes: 940c264984fd ("nbd: fix possible overflow for 'first_minor' in nbd_dev_add()")
Signed-off-by: Zhang Wensheng <zhangwensheng5@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20220521073749.3146892-6-yukuai3@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
---
 drivers/block/nbd.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 1ddae8f768d5..dbcd903ba128 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1771,17 +1771,7 @@ static int nbd_dev_add(int index)
 	refcount_set(&nbd->refs, 1);
 	INIT_LIST_HEAD(&nbd->list);
 	disk->major = NBD_MAJOR;
-
-	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since index << part_shift might overflow, or
-	 * MKDEV() expect that the max bits of first_minor is 20.
-	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
-		err = -EINVAL;
-		goto out_free_idr;
-	}
-
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
 	sprintf(disk->disk_name, "nbd%d", index);
@@ -1875,8 +1865,19 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 	if (!netlink_capable(skb, CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (info->attrs[NBD_ATTR_INDEX])
+	if (info->attrs[NBD_ATTR_INDEX]) {
 		index = nla_get_u32(info->attrs[NBD_ATTR_INDEX]);
+
+		/*
+		 * Too big first_minor can cause duplicate creation of
+		 * sysfs files/links, since index << part_shift might overflow, or
+		 * MKDEV() expect that the max bits of first_minor is 20.
+		 */
+		if (index < 0 || index > MINORMASK >> part_shift) {
+			printk(KERN_ERR "nbd: illegal input index %d\n", index);
+			return -EINVAL;
+		}
+	}
 	if (!info->attrs[NBD_ATTR_SOCKETS]) {
 		printk(KERN_ERR "nbd: must specify at least one socket\n");
 		return -EINVAL;
-- 
2.37.2

