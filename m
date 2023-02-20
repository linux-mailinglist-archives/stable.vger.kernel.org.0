Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B18F69D28D
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjBTSId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbjBTSIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:08:32 -0500
X-Greylist: delayed 192 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Feb 2023 10:08:22 PST
Received: from out203-205-221-155.mail.qq.com (out203-205-221-155.mail.qq.com [203.205.221.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11DDAD39
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1676916500;
        bh=oX3DCvxvllFVXeuXGVcSp5LTU91v7TLhOidx8keLBhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=aI1b8sGYJIoChVGmi9KW80C54aUlBwXV1ExX6/ZhLxsT4/7BkOSm3IfN5AukFKyZ9
         GV559ugcVXfgDTDKGg2HfLaKuGifj5WyKezr6GAtvMcReQexzoYg2qea3j2NqkI/NA
         ZLJgIZRMxbJjjBGOspGh2a9z/0PXQAOWhEBLkTvk=
Received: from localhost.localdomain ([106.92.97.84])
        by newxmesmtplogicsvrszc1-0.qq.com (NewEsmtp) with SMTP
        id 141274B8; Tue, 21 Feb 2023 02:05:01 +0800
X-QQ-mid: xmsmtpt1676916303tyixcg8qa
Message-ID: <tencent_B899BECA817A270876922C5D8B19C78FE805@qq.com>
X-QQ-XMAILINFO: NMGzQWUSIfvTebJKomk4jB7j+EayZcmfdZy4URM43hU8iyyiCp3cqIxyVY9c2R
         IEz2leCQL2/3Mfofic2G0x8br7W2I/W1vko3AEBdp3o5TOHH1Aq2G8YdRaUfwdjuOG1iGrJAypY5
         sAFcNLy7AB0Eb7Y5ytELSUn3TNUF3w0RKytyUyanLRH59+NS/HpsbtPep4rQCqc5AU/OQMZxoNT9
         Kq+TxeOonXoUbsyxuPfY/0W2rH7NPR98KO/kLTUuS3+ULQOA8BLDaixvXDy1+WNP84slESQpnmVP
         1LtQ4/CW/d2z7pk7K8DxJ6m/KusD7iSX0R9Nv5PG0+hxOLuvvrBOtIOcpGckNbchvsp27zkjpKsO
         Hbdxq8rHTlGyUHzU65mHQWKLUEPdN0DMeR7f470GwTxF2TKlSUWJg+PbCM3CCr3tMASdumUd7rhB
         2PxnVtj15NlIDJ8CQt9k8lDb7n6JxC9uqHJlBIbuiwTeEOEWNDhwVKu10lNFjcGxR0Cs8/a5y//T
         SJ4XbraQIFXoGBFmLNASNVhJp8yTmTT9ebHO7gJDCduluFtB/r+RUeBBgpBIVeVksE0a3/TcxZdZ
         T+zn33sT1ooXBAZ2TxVCgNzsMRysXDc0LskRgUunuQ28VVOaY3Tes5jQSl7xactz1OK/R3kHE42S
         EQsdjvemKZHnozX3Z0CjFcljmWKFOwWrJJjAVSrqePW21ud233swMOJqhT5eqy0wazWEwisCMPOq
         P4rP31oSicUCqmzTyjhbN9e0piEyzhJ+B13RUeKYH1f/mgU1oqBxYc+uQxomdpyzwM1eh1MCBRUb
         1L3YXzkhLeIa1e6M3OI3PMn+WCSBNFhsWpPSpQ6/BlnXdkZyoWP8qV6ImUpkJ3Scvwwp/U8b45MA
         tdhxd3u3skz3tqSCiYbi8dPJqqdaRmmOdUGzhSU5WGgPVTyGxboeB1W4orHDNt4fVe/aQ0LQQL/U
         nWwaZzSpVg/jh5Oa89/qM7Y9iF1MoUl7VS3CbdnxsVnBJnfOAvBdSr9Oo+xZeMZXydP0FFffdHzG
         NJ7gA7jiC7HKK+y+0PlPz6df7jDiw=
From:   wenyang.linux@foxmail.com
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Yu Kuai <yukuai3@huawei.com>, Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 5.10 2/4] nbd: fix max value for 'first_minor'
Date:   Tue, 21 Feb 2023 02:04:47 +0800
X-OQ-MSGID: <20230220180449.36425-2-wenyang.linux@foxmail.com>
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

From: Yu Kuai <yukuai3@huawei.com>

commit e4c4871a73944353ea23e319de27ef73ce546623 upstream.

commit b1a811633f73 ("block: nbd: add sanity check for first_minor")
checks that 'first_minor' should not be greater than 0xff, which is
wrong. Whitout the commit, the details that when user pass 0x100000,
it ends up create sysfs dir "/sys/block/43:0" are as follows:

nbd_dev_add
 disk->first_minor = index << part_shift
  -> default part_shift is 5, first_minor is 0x2000000
  device_add_disk
   ddev->devt = MKDEV(disk->major, disk->first_minor)
    -> (0x2b << 20) | (0x2000000) = 0x2b00000
   device_add
    device_create_sys_dev_entry
	 format_dev_t
	  sprintf(buffer, "%u:%u", MAJOR(dev), MINOR(dev));
	   -> got 43:0
	  sysfs_create_link -> /sys/block/43:0

By the way, with the wrong fix, when part_shift is the default value,
only 8 ndb devices can be created since 8 << 5 is greater than 0xff.

Since the max bits for 'first_minor' should be the same as what
MKDEV() does, which is 20. Change the upper bound of 'first_minor'
from 0xff to 0xfffff.

Fixes: b1a811633f73 ("block: nbd: add sanity check for first_minor")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20211102015237.2309763-2-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
---
 drivers/block/nbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index bf8148ebd858..bd05eaf04143 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1773,11 +1773,11 @@ static int nbd_dev_add(int index)
 	disk->major = NBD_MAJOR;
 
 	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since first_minor will be truncated to
-	 * byte in __device_add_disk().
+	 * sysfs files/links, since MKDEV() expect that the max bits of
+	 * first_minor is 20.
 	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor > 0xff) {
+	if (disk->first_minor > MINORMASK) {
 		err = -EINVAL;
 		goto out_free_idr;
 	}
-- 
2.37.2

