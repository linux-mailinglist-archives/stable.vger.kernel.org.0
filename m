Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A41529BC46
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801946AbgJ0PpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801048AbgJ0Phl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4CE8204EF;
        Tue, 27 Oct 2020 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813061;
        bh=vtHwlY2xSLgUvff/al/JiYErjwP+mXqmcWZ2v2CieXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnTD5pCOTu0xdbH9MqfkPhShE83OS8oNR7w1dXFuzETAMYTAlJiQtYWf3sGev5i8+
         XiNdtn+uXTqbGiquNXhopOIuGXzldFvkiRA6NdvipFdIIquAsyl6QdW1XUrLZ3850K
         pILSdLdMaCyFhEALgnglplx0ZemmyZ/b1f0th2Hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 425/757] nfs: add missing "posix" local_lock constant table definition
Date:   Tue, 27 Oct 2020 14:51:15 +0100
Message-Id: <20201027135510.499477270@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit a2d24bcb97dc7b0be1cb891e60ae133bdf36c786 ]

"mount -o local_lock=posix..." was broken by the mount API conversion
due to the missing constant.

Fixes: e38bb238ed8c ("NFS: Convert mount option parsing to use functionality from fs_parser.h")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/fs_context.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index 524812984e2d4..009987e690207 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -94,6 +94,7 @@ enum {
 static const struct constant_table nfs_param_enums_local_lock[] = {
 	{ "all",		Opt_local_lock_all },
 	{ "flock",	Opt_local_lock_flock },
+	{ "posix",	Opt_local_lock_posix },
 	{ "none",		Opt_local_lock_none },
 	{}
 };
-- 
2.25.1



