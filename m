Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1236A2DD9
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjBZDqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjBZDqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:46:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE3F199E8;
        Sat, 25 Feb 2023 19:45:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2DE8B80B89;
        Sun, 26 Feb 2023 03:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA2BC433EF;
        Sun, 26 Feb 2023 03:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677383059;
        bh=Yq1AOdpFI9Kd7tNQMKTe0eChcsICUgS4tykeAJ/QfPs=;
        h=From:To:Cc:Subject:Date:From;
        b=hqcLyCt7IRJGuFY5TfAWgXGSH1qicthxZGQb990R56zOorYn/x+aA7Du23I5ywCuz
         vCZi08L38qbYweYA1e61nRejP+0lRoH9Y1XkwRE0qTy4LAEhyRCItd8QsmRZJFuPz4
         jPWuReOFnimLPyLM9/gwEEYGvPzJIe8CVukR9PHIFwnrxez8B4xfWbx6jC7ns+tq93
         Y9k4Rk03IwLJF2OqSgbtXy0tR7ZlWe/vPsxakRPjIhGtoHTakNWOuWl+tvMWK9S7I9
         DjpA944SCYn+F+WTT4ZQO5WXEHxjG8o3ba0UbaFu77oP/gNI+io62JkIGt67L8qlag
         64laeI7dYHzHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jack@suse.com
Subject: [PATCH AUTOSEL 5.4 1/4] udf: Define EFSCORRUPTED error code
Date:   Sat, 25 Feb 2023 22:44:13 -0500
Message-Id: <20230226034417.775491-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 3d2d7e61553dbcc8ba45201d8ae4f383742c8202 ]

Similarly to other filesystems define EFSCORRUPTED error code for
reporting internal filesystem corruption.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/udf_sb.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 8eace7a633d38..d91cbfb08983e 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -51,6 +51,8 @@
 #define MF_DUPLICATE_MD		0x01
 #define MF_MIRROR_FE_LOADED	0x02
 
+#define EFSCORRUPTED EUCLEAN
+
 struct udf_meta_data {
 	__u32	s_meta_file_loc;
 	__u32	s_mirror_file_loc;
-- 
2.39.0

