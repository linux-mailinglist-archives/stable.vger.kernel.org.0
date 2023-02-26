Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6281E6A2D4D
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBZDl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBZDl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:41:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBEEE3A4;
        Sat, 25 Feb 2023 19:41:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6614860BC9;
        Sun, 26 Feb 2023 03:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8BBC433A1;
        Sun, 26 Feb 2023 03:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677382915;
        bh=rF3oV65mpAAKnHzoMIgV3vmJ1rJ/b8RXBziW6URAM+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfmVk64CAvDeqPhvb1k+itEnJNFpsN+Y5Hfji1vSe0FsJjVfjxMCoT9BTlKbiUkqi
         7G3W6cIbrpoW7Cejg7wclRbfr8C5xvVOrkTZWt02Wn5HqPbAZYxoGiJNtTQfXaMV6P
         pD6ZH51VeN4Q56JhaPkeliQ6e7ceA4sXnpCW2C8h8wHtxKuv6PfFUFfHdj2BMF1kG6
         bE/moH4f3Pe5wYQX9M3lAJMD9VcmkHN2YTv4rr2MM7ZtNTvS/JDqwnVoK6SRmijNDY
         AnO6EECrxEeFHk29DEmzDXhl7eCk+E4HZr3Aj4oH2phRGxjoHiuV634F09VbONMjY0
         7yvrIsaHxN3rQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jack@suse.com
Subject: [PATCH AUTOSEL 6.2 03/21] udf: Define EFSCORRUPTED error code
Date:   Sat, 25 Feb 2023 22:41:32 -0500
Message-Id: <20230226034150.771411-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034150.771411-1-sashal@kernel.org>
References: <20230226034150.771411-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 291b56dd011ee..6bccff3c70f54 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -55,6 +55,8 @@
 #define MF_DUPLICATE_MD		0x01
 #define MF_MIRROR_FE_LOADED	0x02
 
+#define EFSCORRUPTED EUCLEAN
+
 struct udf_meta_data {
 	__u32	s_meta_file_loc;
 	__u32	s_mirror_file_loc;
-- 
2.39.0

