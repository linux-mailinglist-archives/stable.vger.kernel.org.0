Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCC9DD4AE
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfJRW0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:26:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbfJRWES (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7208222C5;
        Fri, 18 Oct 2019 22:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436258;
        bh=pvimibEjAyXqsfHKR7k5YuuvTWdfplcgN9pW/WPSVwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veNGxJ3ON8zF6PobeBkqV38GQXhYTZ+JyMeZzFJCbqQBz5h/HifjIOwu791f3B8TU
         rT9Y/ln+uZ9EWdV2XuIzU3dMJ8DMQBaOmQRh6sLm5qGAxkDa3D4oJIIIYBcC3dAVx8
         KmX8ywpqOkVJ6WQ4un5dEDdmbVmQdBok2msca1pU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 41/89] fs: cifs: mute -Wunused-const-variable message
Date:   Fri, 18 Oct 2019 18:02:36 -0400
Message-Id: <20191018220324.8165-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit dd19c106a36690b47bb1acc68372f2b472b495b8 ]

After 'Initial git repository build' commit,
'mapping_table_ERRHRD' variable has not been used.

So 'mapping_table_ERRHRD' const variable could be removed
to mute below warning message:

   fs/cifs/netmisc.c:120:40: warning: unused variable 'mapping_table_ERRHRD' [-Wunused-const-variable]
   static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
                                           ^
Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/netmisc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index ed92958e842d3..657f409d4de06 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -117,10 +117,6 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{0, 0}
 };
 
-static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
-	{0, 0}
-};
-
 /*
  * Convert a string containing text IPv4 or IPv6 address to binary form.
  *
-- 
2.20.1

