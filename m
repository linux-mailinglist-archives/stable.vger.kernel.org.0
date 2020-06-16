Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1C81FB90E
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731728AbgFPQAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732748AbgFPPwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:52:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7592207C4;
        Tue, 16 Jun 2020 15:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322761;
        bh=9/f0wi49iItWo3HVGU0BxHoshxsiC38fZ6j+hzA7fI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ya/qYjlM9JDhxqYETjWj8+2Q/h5NMLbaL3szAEYaWnyKOaVtMxLxa6zlyaQBZ3bbC
         H+AXcTXTFpZXChi3gIc/PC5SY/NiU+o5QLXQIaGeEI/4oxsxsFine4IZPf3uxj4R60
         FqmhwWWtXbduNY4DK9u3Q9S0WCRvmWCnIt1VLBNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Subject: [PATCH 5.6 066/161] smb3: fix typo in mount options displayed in /proc/mounts
Date:   Tue, 16 Jun 2020 17:34:16 +0200
Message-Id: <20200616153109.524240065@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 7866c177a03b18be3d83175014c643546e5b53c6 upstream.

Missing the final 's' in "max_channels" mount option when displayed in
/proc/mounts (or by mount command)

CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Shyam Prasad N <nspmangalore@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -621,7 +621,7 @@ cifs_show_options(struct seq_file *s, st
 	seq_printf(s, ",actimeo=%lu", cifs_sb->actimeo / HZ);
 
 	if (tcon->ses->chan_max > 1)
-		seq_printf(s, ",multichannel,max_channel=%zu",
+		seq_printf(s, ",multichannel,max_channels=%zu",
 			   tcon->ses->chan_max);
 
 	return 0;


