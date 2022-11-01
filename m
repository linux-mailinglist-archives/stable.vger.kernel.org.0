Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5706142AB
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 02:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKABJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 21:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiKABJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 21:09:44 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AE41105;
        Mon, 31 Oct 2022 18:09:42 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4N1X1Y5rN1zl2ND;
        Tue,  1 Nov 2022 09:07:29 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
        by APP1 (Coremail) with SMTP id cCh0CgC3kXrScWBjlgRzBA--.16122S4;
        Tue, 01 Nov 2022 09:09:40 +0800 (CST)
From:   Yu Kuai <yukuai1@huaweicloud.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.com,
        bvanassche@acm.org
Cc:     linux-scsi@vger.kernel.org, yukuai3@huawei.com,
        yukuai1@huaweicloud.com, yi.zhang@huawei.com
Subject: [PATCH 5.10/5.15 v2] scsi: sd: Revert "scsi: sd: Remove a local variable"
Date:   Tue,  1 Nov 2022 09:31:24 +0800
Message-Id: <20221101013124.2615274-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgC3kXrScWBjlgRzBA--.16122S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1fZFyxZFykuw1UtryDGFg_yoW8CFy3pa
        y8XayYyrW5JF18C3srtFyxX3s3Ka92gry2gFW5u3y5ZrW8Kry5Wr1xKFZIva4UWFZxJr4f
        J3WqqrZ5XF4UArUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
        0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_
        Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoO
        J5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

This reverts commit 84f7a9de0602704bbec774a6c7f7c8c4994bee9c.

Because it introduces a problem that rq->__data_len is set to the wrong
value.

before the patch:
1) nr_bytes = rq->__data_len
2) rq->__data_len = sdp->sector_size
3) scsi_init_io()
4) rq->__data_len = nr_bytes

after the patch:
1) rq->__data_len = sdp->sector_size
2) scsi_init_io()
3) rq->__data_len = rq->__data_len -> __data_len is wrong

It will cause that io can only complete one segment each time, and the io
will requeue in scsi_io_completion_action(), which will cause severe
performance degradation.

Scsi write same is removed in commit e383e16e84e9 ("scsi: sd: Remove
WRITE_SAME support") from mainline, hence this patch is only needed for
stable kernels.

Fixes: 84f7a9de0602 ("scsi: sd: Remove a local variable")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---

Changes in v2:
 - add description that this patch is only needed for stable kernels.

 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index de6640ad1943..1e887c11e83d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1072,6 +1072,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	struct bio *bio = rq->bio;
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
+	unsigned int nr_bytes = blk_rq_bytes(rq);
 	blk_status_t ret;
 
 	if (sdkp->device->no_write_same)
@@ -1108,7 +1109,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	 */
 	rq->__data_len = sdp->sector_size;
 	ret = scsi_alloc_sgtables(cmd);
-	rq->__data_len = blk_rq_bytes(rq);
+	rq->__data_len = nr_bytes;
 
 	return ret;
 }
-- 
2.31.1

