Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4CE3CE562
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348694AbhGSPti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350061AbhGSPpe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E71060E0C;
        Mon, 19 Jul 2021 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711972;
        bh=E8/8zs48AkQl1xfhu1EZllqIsuu3oDO3yPGO4UMQ4R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsWJNzAMfUl4OZDVNVotinIV33XjUGb2JLB4Yv16ROQhk9KwQvecl91xEQDlalsOG
         IpOAVlvguHMG2ncYffaDaNXi7SU6Q9PSeOvPZCr9vaZd7bmr3DoOaC6moC2VzUfd/2
         QADxHxjlE/WB+/xu9z042UkgEGckITqM7sOVAZoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 202/292] f2fs: fix to avoid adding tab before doc section
Date:   Mon, 19 Jul 2021 16:54:24 +0200
Message-Id: <20210719144949.136527336@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 3c16dc40aab84bab9cf54c2b61a458bb86b180c3 ]

Otherwise whole section after tab will be invisible in compiled
html format document.

Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Fixes: 89272ca1102e ("docs: filesystems: convert f2fs.txt to ReST")
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/f2fs.rst | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index 35ed01a5fbc9..bb2261431fbb 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -711,10 +711,10 @@ users.
 ===================== ======================== ===================
 User                  F2FS                     Block
 ===================== ======================== ===================
-                      META                     WRITE_LIFE_NOT_SET
-                      HOT_NODE                 "
-                      WARM_NODE                "
-                      COLD_NODE                "
+N/A                   META                     WRITE_LIFE_NOT_SET
+N/A                   HOT_NODE                 "
+N/A                   WARM_NODE                "
+N/A                   COLD_NODE                "
 ioctl(COLD)           COLD_DATA                WRITE_LIFE_EXTREME
 extension list        "                        "
 
@@ -740,10 +740,10 @@ WRITE_LIFE_LONG       "                        WRITE_LIFE_LONG
 ===================== ======================== ===================
 User                  F2FS                     Block
 ===================== ======================== ===================
-                      META                     WRITE_LIFE_MEDIUM;
-                      HOT_NODE                 WRITE_LIFE_NOT_SET
-                      WARM_NODE                "
-                      COLD_NODE                WRITE_LIFE_NONE
+N/A                   META                     WRITE_LIFE_MEDIUM;
+N/A                   HOT_NODE                 WRITE_LIFE_NOT_SET
+N/A                   WARM_NODE                "
+N/A                   COLD_NODE                WRITE_LIFE_NONE
 ioctl(COLD)           COLD_DATA                WRITE_LIFE_EXTREME
 extension list        "                        "
 
-- 
2.30.2



