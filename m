Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C157C4BF4F4
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 10:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiBVJsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 04:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiBVJsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 04:48:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9796790CDC
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 01:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645523270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1vLjaLOpjM/maPs9UeQipZMtimlrY+ZZDRN/XdiV3h8=;
        b=Knbw3/bKaoIBuKz66UMr7+P+g17yBXbfPJHB0VLaO0Jb/EXnjnlm4BaJfID92FWX36++4m
        v2GTrXoKUBG8kLBA/AxT4oV1ifGXRUNR4YIh/eAZCUMgwu/zoB0yslKFuutmZqBVpcMBBU
        z+d84i3FAX/9s1zWOPglfN4aUmqGaGE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-X9OWqKghNVSj1IoItq4FLQ-1; Tue, 22 Feb 2022 04:47:49 -0500
X-MC-Unique: X9OWqKghNVSj1IoItq4FLQ-1
Received: by mail-qv1-f71.google.com with SMTP id cg14-20020a05621413ce00b0042c2706a4beso20287318qvb.23
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 01:47:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1vLjaLOpjM/maPs9UeQipZMtimlrY+ZZDRN/XdiV3h8=;
        b=zxnxi9jClLPxY9vHTcSubU1SpZ30M2Vg8j6PmhALfo/w5DnP21VgsUp4bz8AdpkSeC
         omao7ZN37t4JTyXxi63ehC75jAKg/nNkJzMkCKuM5A3nWGqLOALgDJVEXKlQ2CJayDI8
         4QB0bCzi5AmS2FWmI6e7JBVJGahGbmAVoo2qMUqCyNyW0ks9JcDK00meNnpoxBXJ32Si
         OZHCAq731OsfDq4Ghx76bun9VVxkHYhJ+9h4DzE4NyunehZL0dTPZsZ+dU90CqAHvQQd
         k/WkR5ihMpmoRT/TerNVxWiWolSMuq+tc+fmc0sHV0l+ks6Syf2uIRm8sCtCvjBBTL6L
         oIRw==
X-Gm-Message-State: AOAM532c4oIx8StTSucuQWVCQYhJh9pgr9cIrnqlG8z9EDAz59OnRdex
        JmYz5ow4uiBcjq+KHz5LSIVBi87e4+p7b3KPJ6vtaMmKSz//Mvy7V0pc9iYXjYJnyuApEGUYXyN
        1upu9n7d631VKrnXu
X-Received: by 2002:ac8:5f4c:0:b0:2d9:9327:1355 with SMTP id y12-20020ac85f4c000000b002d993271355mr21214805qta.518.1645523268798;
        Tue, 22 Feb 2022 01:47:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLRApCkpCfkLM6BoxEEMUdWN7hRcfpssUWglONmZj/+bkfEiUyPxNFxljOVxDFiUxHMmgtfQ==
X-Received: by 2002:ac8:5f4c:0:b0:2d9:9327:1355 with SMTP id y12-20020ac85f4c000000b002d993271355mr21214790qta.518.1645523268571;
        Tue, 22 Feb 2022 01:47:48 -0800 (PST)
Received: from step1.redhat.com (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id br35sm27922533qkb.118.2022.02.22.01.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 01:47:47 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] vhost/vsock: don't check owner in vhost_vsock_stop() while releasing
Date:   Tue, 22 Feb 2022 10:47:42 +0100
Message-Id: <20220222094742.16359-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
ownership. It expects current->mm to be valid.

vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
the user has not done close(), so when we are in do_exit(). In this
case current->mm is invalid and we're releasing the device, so we
should clean it anyway.

Let's check the owner only when vhost_vsock_stop() is called
by an ioctl.

When invoked from release we can not fail so we don't check return
code of vhost_vsock_stop(). We need to stop vsock even if it's not
the owner.

Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Cc: stable@vger.kernel.org
Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v2:
- initialized `ret` in vhost_vsock_stop [Dan]
- added comment about vhost_vsock_stop() calling in the code and an explanation
  in the commit message [MST]

v1: https://lore.kernel.org/virtualization/20220221114916.107045-1-sgarzare@redhat.com
---
 drivers/vhost/vsock.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index d6ca1c7ad513..37f0b4274113 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -629,16 +629,18 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
 	return ret;
 }
 
-static int vhost_vsock_stop(struct vhost_vsock *vsock)
+static int vhost_vsock_stop(struct vhost_vsock *vsock, bool check_owner)
 {
 	size_t i;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&vsock->dev.mutex);
 
-	ret = vhost_dev_check_owner(&vsock->dev);
-	if (ret)
-		goto err;
+	if (check_owner) {
+		ret = vhost_dev_check_owner(&vsock->dev);
+		if (ret)
+			goto err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		struct vhost_virtqueue *vq = &vsock->vqs[i];
@@ -753,7 +755,12 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 	 * inefficient.  Room for improvement here. */
 	vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
 
-	vhost_vsock_stop(vsock);
+	/* Don't check the owner, because we are in the release path, so we
+	 * need to stop the vsock device in any case.
+	 * vhost_vsock_stop() can not fail in this case, so we don't need to
+	 * check the return code.
+	 */
+	vhost_vsock_stop(vsock, false);
 	vhost_vsock_flush(vsock);
 	vhost_dev_stop(&vsock->dev);
 
@@ -868,7 +875,7 @@ static long vhost_vsock_dev_ioctl(struct file *f, unsigned int ioctl,
 		if (start)
 			return vhost_vsock_start(vsock);
 		else
-			return vhost_vsock_stop(vsock);
+			return vhost_vsock_stop(vsock, true);
 	case VHOST_GET_FEATURES:
 		features = VHOST_VSOCK_FEATURES;
 		if (copy_to_user(argp, &features, sizeof(features)))
-- 
2.35.1

