Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DEB47AE5C
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238910AbhLTPA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239189AbhLTO63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062B3C0617A2;
        Mon, 20 Dec 2021 06:50:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC099B80EE5;
        Mon, 20 Dec 2021 14:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13525C36AE7;
        Mon, 20 Dec 2021 14:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011797;
        bh=MtqeA1KG2b7BLslxpJrMx6wcjDQU6ou13B4I1m2GwY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvGnRaXYOU/9yFYY7VpK9K8pIlIL07LuZKLxhM5qrv6ap899B0BRdmDHcBL7n/9t0
         FdsA8mTvAveHYfpCUIN8MxqpZ946PbVWLKpqH/u60KszQUM4hg7r5rp8p10vzO7Qy9
         NX0LZjTjOnwpb5EygU9Ko+vjwQMUDN/DPqT2uQp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.10 77/99] zonefs: add MODULE_ALIAS_FS
Date:   Mon, 20 Dec 2021 15:34:50 +0100
Message-Id: <20211220143031.986062532@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 8ffea2599f63fdbee968b894eab78170abf3ec2c upstream.

Add MODULE_ALIAS_FS() to load the module automatically when you do "mount
-t zonefs".

Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Cc: stable <stable@vger.kernel.org> # 5.6+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: Johannes Thumshirn <jth@kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1799,5 +1799,6 @@ static void __exit zonefs_exit(void)
 MODULE_AUTHOR("Damien Le Moal");
 MODULE_DESCRIPTION("Zone file system for zoned block devices");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_FS("zonefs");
 module_init(zonefs_init);
 module_exit(zonefs_exit);


