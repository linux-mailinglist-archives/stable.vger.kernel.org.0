Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BFC47AFB2
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhLTPR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238991AbhLTPQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:16:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00972C110F32;
        Mon, 20 Dec 2021 06:57:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1E91B80EF3;
        Mon, 20 Dec 2021 14:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5130C36AE7;
        Mon, 20 Dec 2021 14:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012276;
        bh=JKMX6llezc1BIPYyVgwOFaZ71gMVk0aM/Bsl9kRJ6Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jvf3DNE1r1kS4pah2qll4iBwjKtOGnSghMajm7ddzZUzI9xtldeoYmHLfOACZPcPL
         t6YNpZPbOcde21bkgjTDV1BiBDNJ1HXjmVoGicyRnQExRqAUlLgb1HkWCwFhMNliwS
         IOtVkoVdwPPT0+s4P59nv+XoJmY9pFT5WZlVhw/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.15 136/177] zonefs: add MODULE_ALIAS_FS
Date:   Mon, 20 Dec 2021 15:34:46 +0100
Message-Id: <20211220143044.664331466@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
@@ -1787,5 +1787,6 @@ static void __exit zonefs_exit(void)
 MODULE_AUTHOR("Damien Le Moal");
 MODULE_DESCRIPTION("Zone file system for zoned block devices");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_FS("zonefs");
 module_init(zonefs_init);
 module_exit(zonefs_exit);


