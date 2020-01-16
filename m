Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 646D613FD43
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732465AbgAPXX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:23:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:52714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732710AbgAPXX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CC362072E;
        Thu, 16 Jan 2020 23:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217037;
        bh=6ONN6THwSMVFtzfoVkjJLw7s//kr73b1b6PtaCSjUDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yBHEoOaQDT4WWajZVzVlrZNQXGAWiGt+Rlsg6fkskeZH1ZxwFW9S1zq5654KTwFva
         oSFsvFOt2KaEdxOfgqR/7lrqcnvt5cbNQU+kcYPrbhsDsRYglfKb4ZCd3mRm8QQAc+
         nHwYK3GOSrW7GoZsyr1Y5tPr7KkLZT80tFYB36To=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jamie Heilman <jamie@audible.transient.net>,
        Scott Mayhew <smayhew@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.4 106/203] nfsd: v4 support requires CRYPTO_SHA256
Date:   Fri, 17 Jan 2020 00:17:03 +0100
Message-Id: <20200116231754.812048179@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

commit a2e2f2dc77a18d2b0f450fb7fcb4871c9f697822 upstream.

The new nfsdcld client tracking operations use sha256 to compute hashes
of the kerberos principals, so make sure CRYPTO_SHA256 is enabled.

Fixes: 6ee95d1c8991 ("nfsd: add support for upcall version 2")
Reported-by: Jamie Heilman <jamie@audible.transient.net>
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


