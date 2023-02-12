Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F30469369A
	for <lists+stable@lfdr.de>; Sun, 12 Feb 2023 10:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjBLJCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Feb 2023 04:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBLJCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Feb 2023 04:02:19 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A955E1285B;
        Sun, 12 Feb 2023 01:02:18 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m20-20020a05600c3b1400b003e1e754657aso783423wms.2;
        Sun, 12 Feb 2023 01:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehYxgfkuCBBLt/PfsjG12E/5syCw9Oem9p3lLyMkvi4=;
        b=aJ7BpW3I9+HzxU2esjIlFUY4Zw+4qE47Irz8W4c5vkh4+pxVLNe7Sql1DkELdO4sGQ
         IDFCUR/sjHI5D78ZrR3jReMyy6nw5yY8fYcNjynuqI8ype5ncV6d1jDgnrBwljxUXjvR
         gI5ps1C1bV1VkCztQJzAOorXqRlmIGzZKE7cMPuI3piyo8eySx1wYjaTZWWRsAnxwyLR
         KWUoCk+vMP9hXhTvrVMkD/mt+ieVEogND3pQMpGyRudGXu22HYJ2ljKpGbdi1haMAexc
         IdQ09ltkRht/5I7c/MtkH6vTAw6bg10F1r9cVeO99DCTwaLs3493s+0TD6WxUsPr2G1Z
         9B8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehYxgfkuCBBLt/PfsjG12E/5syCw9Oem9p3lLyMkvi4=;
        b=kDOjb/jj3FKsbp/CwozGsjQo1L1Rz+RO1euoA8t0ChWUPhN7taEk0OwrSxY/XYwGWA
         QYeWgIrPcO1tVC7XmD39m+1HHyuZlcrPF2BkV8tZWVtaZFJjBG6nvWPOTv2WYWhz8O/h
         6yWcq5lqT8TMWAX5Zy4gUonAH6toZ5HTYMN0VSSPjPU2Wp2ooNPDpLxd3WGxJC7jBmzF
         d3Ba8HBSHO90dukl8S5ABkIXCfbxoa07eVWrf0nE910cUwvCbulm9mCuIJAQs/UfzXwc
         1OLWe1k9M87T1KLb/5lgrHilGNIHByA3VMsSI4XWMelyd4fwahihjFE2cvwSu3WzQtrA
         hTfg==
X-Gm-Message-State: AO0yUKV2Ar90AFN223Zy/HHb7AwLt3MY16gD5KTVQAQiP/tEBFeop2vo
        ++JIggockeVKO5ORoVgXY3o=
X-Google-Smtp-Source: AK7set9lZWpu0D3mkELmAV6cog3P+kvg8XfV6yFFIHFXR/REtId3QspotUFKUMB9y6+oqOpJZaTplQ==
X-Received: by 2002:a05:600c:1895:b0:3da:2ba4:b97 with SMTP id x21-20020a05600c189500b003da2ba40b97mr2201165wmp.19.1676192537078;
        Sun, 12 Feb 2023 01:02:17 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c450700b003dc42d48defsm12017183wmo.6.2023.02.12.01.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 01:02:16 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        stable@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 1/2] ovl: remove privs in ovl_copyfile()
Date:   Sun, 12 Feb 2023 11:02:03 +0200
Message-Id: <20230212090204.339226-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230212090204.339226-1-amir73il@gmail.com>
References: <20230212090204.339226-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b306e90ffabdaa7e3b3350dbcd19b7663e71ab17 upstream.

Underlying fs doesn't remove privs because copy_range/remap_range are
called with privileged mounter credentials.

This fixes some failures in fstest generic/673.

Fixes: 8ede205541ff ("ovl: add reflink/copyfile/dedup support")
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index b019f27c1360..259b2d41b707 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -687,14 +687,23 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	const struct cred *old_cred;
 	loff_t ret;
 
+	inode_lock(inode_out);
+	if (op != OVL_DEDUPE) {
+		/* Update mode */
+		ovl_copyattr(ovl_inode_real(inode_out), inode_out);
+		ret = file_remove_privs(file_out);
+		if (ret)
+			goto out_unlock;
+	}
+
 	ret = ovl_real_fdget(file_out, &real_out);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	ret = ovl_real_fdget(file_in, &real_in);
 	if (ret) {
 		fdput(real_out);
-		return ret;
+		goto out_unlock;
 	}
 
 	old_cred = ovl_override_creds(file_inode(file_out)->i_sb);
@@ -723,6 +732,9 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	fdput(real_in);
 	fdput(real_out);
 
+out_unlock:
+	inode_unlock(inode_out);
+
 	return ret;
 }
 
-- 
2.34.1

