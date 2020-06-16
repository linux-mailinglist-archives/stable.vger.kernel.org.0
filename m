Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4D41FBA22
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbgFPPpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732102AbgFPPpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:45:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99F632071A;
        Tue, 16 Jun 2020 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322332;
        bh=9/f0wi49iItWo3HVGU0BxHoshxsiC38fZ6j+hzA7fI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHQ03V4+5j6TZyrAajQdtt80vT735q8CGpMybTRQcDCjHUXps+S/SEwdYmGAGI4EC
         RKWZPbfZfHTJlFINx4Sd2wGeXmVic17KkWcPc3VEs+xlRTeR84FtoUVY3Tlckb8/M4
         TXXkNHcuxsAjzbLH7l5u0br3QOeT7dolNx9fnhSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Subject: [PATCH 5.7 060/163] smb3: fix typo in mount options displayed in /proc/mounts
Date:   Tue, 16 Jun 2020 17:33:54 +0200
Message-Id: <20200616153109.723325561@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
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


