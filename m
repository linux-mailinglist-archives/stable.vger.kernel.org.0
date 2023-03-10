Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB986B4591
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjCJOe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbjCJOer (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:34:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB692E8ABF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:34:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65075616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A25C4339B;
        Fri, 10 Mar 2023 14:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458885;
        bh=fqneD1KqA68oxYJPXhQc6BCeLx3MvDpiUkJKQp+1Rxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4WUXz/eUBIN9Kzco+BadnbXbyLl6AAh46bmkhpa0A/5tl0AJfPQ7H8SLzmsX/6+N
         visNGbs3rYHrnQmg4UVEEgCxuNgIVQdYRUN07MXsMOUCjG+t7ZTWSfGn+3iqxpZTVG
         U4CjyTxDuIXRU0VkjrvAeo0acJrKXA7fKtgrACwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/357] udf: Define EFSCORRUPTED error code
Date:   Fri, 10 Mar 2023 14:37:45 +0100
Message-Id: <20230310133742.500290348@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.39.2



