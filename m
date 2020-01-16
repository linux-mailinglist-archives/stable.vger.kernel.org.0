Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA6113F923
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbgAPQxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730710AbgAPQxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1316F22464;
        Thu, 16 Jan 2020 16:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193594;
        bh=ZSxEVRSmMAAdMVZzDNhQUmTVVIl+v3iiq49YEo1QT9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kc7sez+dYG8soqToEjxoUc8ZCi4Sc6ycX8ij+bnlP3ikWKa10EgfhyycQMUaOFh0o
         6Yeot9UcdOjM3mV4gOZU0yPgFEiBQmhGNsaBjGIpmhajSEYirhrbDahE3JRGjGRLNu
         v119QNdxWXGoeqD7rB+xyEDXvtktXSZdsDyzsZw4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott Mayhew <smayhew@redhat.com>,
        Jamie Heilman <jamie@audible.transient.net>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 134/205] nfsd: v4 support requires CRYPTO_SHA256
Date:   Thu, 16 Jan 2020 11:41:49 -0500
Message-Id: <20200116164300.6705-134-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit a2e2f2dc77a18d2b0f450fb7fcb4871c9f697822 ]

The new nfsdcld client tracking operations use sha256 to compute hashes
of the kerberos principals, so make sure CRYPTO_SHA256 is enabled.

Fixes: 6ee95d1c8991 ("nfsd: add support for upcall version 2")
Reported-by: Jamie Heilman <jamie@audible.transient.net>
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 10cefb0c07c7..c4b1a89b8845 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -73,7 +73,7 @@ config NFSD_V4
 	select NFSD_V3
 	select FS_POSIX_ACL
 	select SUNRPC_GSS
-	select CRYPTO
+	select CRYPTO_SHA256
 	select GRACE_PERIOD
 	help
 	  This option enables support in your system's NFS server for
-- 
2.20.1

