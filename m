Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8163AA0D
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731668AbfFIQxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732369AbfFIQxR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:53:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E212081C;
        Sun,  9 Jun 2019 16:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099197;
        bh=MpYDlxEzM89J10j2FWR/9KD66j1za1YxxQWzRSi1PHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w98sDvUm8sPPYHBt+O8XVEXsOZ8u0ovh/VgyaIEkdRcqVW5EcPhI4LvuRiNIiGjEp
         R/qG6lz/zfqrKkKhh0BVtcKvhyaXyXU61PGePCz/Ah16KLDGcFMmirgH44PhPlyxD+
         H7po4SQfvCQRAYQO6guL6v6sX/TLuT78TnxUUWfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4.9 44/83] docs: Fix conf.py for Sphinx 2.0
Date:   Sun,  9 Jun 2019 18:42:14 +0200
Message-Id: <20190609164131.661407633@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Corbet <corbet@lwn.net>

commit 3bc8088464712fdcb078eefb68837ccfcc413c88 upstream.

Our version check in Documentation/conf.py never envisioned a world where
Sphinx moved beyond 1.x.  Now that the unthinkable has happened, fix our
version check to handle higher version numbers correctly.

Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/conf.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -37,7 +37,7 @@ from load_config import loadConfig
 extensions = ['kernel-doc', 'rstFlatTable', 'kernel_include', 'cdomain']
 
 # The name of the math extension changed on Sphinx 1.4
-if major == 1 and minor > 3:
+if (major == 1 and minor > 3) or (major > 1):
     extensions.append("sphinx.ext.imgmath")
 else:
     extensions.append("sphinx.ext.pngmath")


