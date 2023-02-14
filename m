Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6B6696F7C
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjBNV1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbjBNV1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:27:05 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0C5303DD;
        Tue, 14 Feb 2023 13:26:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id bg2so7043535pjb.4;
        Tue, 14 Feb 2023 13:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AvsSfQdiGaa1AyDvXxOboWMtTwpMwQiRc7D7tG1w9Ro=;
        b=iVcmPbW1yesxM8IwO+CU1yc4byy9FpRevMUSsDRzrYNQzGRJ/GLQTTQsYq1pStzEWQ
         EJLn10vdbCD5IVkbAMYskORrDtDrVKvgUHQJSO+LfrnFQHaw+jQqFzZT8X4L+0DWcmrO
         Z7DcQH+8RJA9c3GBNKST/vXwesqB/mjSHOZ/80ub79roq906ysnXxCPM64kWgbH2oq8O
         DrNr4Hwe2wRZyKuOEaUlTUz42oXUH0nc/2eMb3aFOxlA6YuptVS9O2cheDneds5B7mMa
         h2X21ckBiofoXXhNnOkYcjZCsmLzGEzegfPcs3phSu/EFYh+uhlzRR2GPkzEHBfwnrJw
         ngoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AvsSfQdiGaa1AyDvXxOboWMtTwpMwQiRc7D7tG1w9Ro=;
        b=3zzPdlDgDtuY+zVOPxPrgWN6UP10kxAJMhm/j3hbL0rJsZR/Yojpf8KZkfu7Qapl7G
         7oACFo+1j+BHt227jeHWlVo6fwBDE++xR8t0hujWsAbGnKd894eanGZE3GtVWlapDrhr
         pVMZJXZzDGmLOA3bvI4akwL3ho4POq7n4K8rXYwkxZf4DkW3Ib5IqB0r5RhsKxjaeecR
         6WD77z6Cyg4W9vC6MHryYULSYYaZUtXNQObfFfeYPpnU0wjLqD2tGxXeDIVIR5Wq+MTp
         QSD+q6kLqXP0l3hMC9oIOFyKf/I8GRpvWJoWAPAnDo630awLQkk8lqN2iiYtFaVUWQ0h
         uLpQ==
X-Gm-Message-State: AO0yUKWwvOLa9fA6zAIBfH9s9q0JlAG807HG9Nh/VlWadMWAjY3pwah9
        cZ7I+BGvRt+KJUsH/VqlIyDucwxVZun7vQ==
X-Google-Smtp-Source: AK7set+Fy1QlswK6VigLtt7GdUUadz2KELuXnhPdbVYsZc2dHkGMc5a4orWFPUlJRiMH0TCXgpOdng==
X-Received: by 2002:a17:902:da90:b0:192:5ec4:6656 with SMTP id j16-20020a170902da9000b001925ec46656mr165064plx.3.1676409965810;
        Tue, 14 Feb 2023 13:26:05 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cf14:3756:2b5e:fb87])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00195f0fb0c18sm6692569pln.31.2023.02.14.13.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:26:05 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 01/10] xfs: zero inode fork buffer at allocation
Date:   Tue, 14 Feb 2023 13:25:25 -0800
Message-Id: <20230214212534.1420323-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230214212534.1420323-1-leah.rumancik@gmail.com>
References: <20230214212534.1420323-1-leah.rumancik@gmail.com>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit cb512c921639613ce03f87e62c5e93ed9fe8c84d ]

When we first allocate or resize an inline inode fork, we round up
the allocation to 4 byte alingment to make journal alignment
constraints. We don't clear the unused bytes, so we can copy up to
three uninitialised bytes into the journal. Zero those bytes so we
only ever copy zeros into the journal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1d174909f9bd..20095233d7bc 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -50,8 +50,13 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
+		/*
+		 * As we round up the allocation here, we need to ensure the
+		 * bytes we don't copy data into are zeroed because the log
+		 * vectors still copy them into the journal.
+		 */
 		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_alloc(real_size, KM_NOFS);
+		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -500,10 +505,11 @@ xfs_idata_realloc(
 	/*
 	 * For inline data, the underlying buffer must be a multiple of 4 bytes
 	 * in size so that it can be logged and stay on word boundaries.
-	 * We enforce that here.
+	 * We enforce that here, and use __GFP_ZERO to ensure that size
+	 * extensions always zero the unused roundup area.
 	 */
 	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
-				      GFP_NOFS | __GFP_NOFAIL);
+				      GFP_NOFS | __GFP_NOFAIL | __GFP_ZERO);
 	ifp->if_bytes = new_size;
 }
 
-- 
2.39.1.581.gbfd45094c4-goog

