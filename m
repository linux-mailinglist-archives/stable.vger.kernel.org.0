Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD14595165
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiHPE5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbiHPE40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:56:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879A6BB6A8;
        Mon, 15 Aug 2022 13:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8225861089;
        Mon, 15 Aug 2022 20:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D06C433D6;
        Mon, 15 Aug 2022 20:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596681;
        bh=eSju7C3yRhZNi5hkK0/J5yLVf4TRaMXFKrFi3jlI5tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nbhw+fo/PrWwYh3m9ohE5rU3dmDz5HEbDYYrIL7o6dbUORHDFnkOQHr6aBhSnlsuL
         fAnL6MFjNaHjgK6fJm9aAN8bBBqnnCJyBB2lShPBfDQj9xmQD+FTIKiK0QMiqZ1djV
         joah2hZaO3kR/XjPJuszHuFc/6tN/wAtJ2FbrLXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Wang Jianjian <wangjianjian3@huawei.com>,
        linux-ext4@vger.kernel.org, Bagas Sanjaya <bagasdotme@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1124/1157] Documentation: ext4: fix cell spacing of table heading on blockmap table
Date:   Mon, 15 Aug 2022 20:08:00 +0200
Message-Id: <20220815180525.307454244@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit 442ec1e5bb7c46c72c41898e13a5744c84cadf51 ]

Commit 3103084afcf234 ("ext4, doc: remove unnecessary escaping") removes
redundant underscore escaping, however the cell spacing in heading row of
blockmap table became not aligned anymore, hence triggers malformed table
warning:

Documentation/filesystems/ext4/blockmap.rst:3: WARNING: Malformed table.

+---------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| i.i_block Offset   | Where It Points                                                                                                                                                                                                              |
<snipped>...

The warning caused the table not being loaded.

Realign the heading row cell by adding missing space at the first cell
to fix the warning.

Fixes: 3103084afcf234 ("ext4, doc: remove unnecessary escaping")
Cc: stable@kernel.org
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Wang Jianjian <wangjianjian3@huawei.com>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Link: https://lore.kernel.org/r/20220619072938.7334-1-bagasdotme@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/ext4/blockmap.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/ext4/blockmap.rst b/Documentation/filesystems/ext4/blockmap.rst
index 2bd990402a5c..cc596541ce79 100644
--- a/Documentation/filesystems/ext4/blockmap.rst
+++ b/Documentation/filesystems/ext4/blockmap.rst
@@ -1,7 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
 +---------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-| i.i_block Offset   | Where It Points                                                                                                                                                                                                              |
+| i.i_block Offset    | Where It Points                                                                                                                                                                                                              |
 +=====================+==============================================================================================================================================================================================================================+
 | 0 to 11             | Direct map to file blocks 0 to 11.                                                                                                                                                                                           |
 +---------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
-- 
2.35.1



