Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A1E37CA60
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbhELQ3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236061AbhELQU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 284F061D91;
        Wed, 12 May 2021 15:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834388;
        bh=EmenkmgXzbETJXxyEhg+6X91o8oRfZ2udC3IK2DMjdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kd/1f1j7tDAiIfrFVl1n+uQdpzrJVpN/EzVw4yesP363jUbRBCDxkWaPK7y0bhdg6
         zdYPuCG3MML+qNnNU244BVYANUrZ3xt7gy/0kasp2TOCfMtqpAGsafUW/4uUD8T2Kl
         6e7rUI9TGuH1x0i90iWidlN/NPYMTcXoVTXu/1Ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 479/601] ovl: show "userxattr" in the mount data
Date:   Wed, 12 May 2021 16:49:16 +0200
Message-Id: <20210512144843.616176661@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giuseppe Scrivano <gscrivan@redhat.com>

[ Upstream commit 321b46b904816241044e177c1d6282ad20f17416 ]

This was missed when adding the option.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
Fixes: 2d2f2d7322ff ("ovl: user xattr")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 3ff33e1ad6f3..ce274d4e6700 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -380,6 +380,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 			   ofs->config.metacopy ? "on" : "off");
 	if (ofs->config.ovl_volatile)
 		seq_puts(m, ",volatile");
+	if (ofs->config.userxattr)
+		seq_puts(m, ",userxattr");
 	return 0;
 }
 
-- 
2.30.2



