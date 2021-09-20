Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21DD7411D72
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348846AbhITRU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348257AbhITRSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3385A61A2C;
        Mon, 20 Sep 2021 16:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157189;
        bh=SZp5RZ6WDfI9/ZaQlkOS8N288enWjTaaoiP8isF7NuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFyrUAmPe4O72TujCMk4Z1tN7HBcm4p85YYdk+5MvOLQCVYK9dN7zte3ta6rvxgxc
         KkBv/mNGHfze2ft65ybojRqfYz0v9WuWDq5IfmhG8u2ZhpN+l2UZFKDCmjCpGdQ2tQ
         GwtZBYKoso8vBNICvtI7mBcLkbqJ2B/FDMF103dY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Austin Kim <austin.kim@lge.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.14 094/217] IMA: remove -Wmissing-prototypes warning
Date:   Mon, 20 Sep 2021 18:41:55 +0200
Message-Id: <20210920163927.826192474@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Austin Kim <austin.kim@lge.com>

commit a32ad90426a9c8eb3915eed26e08ce133bd9e0da upstream.

With W=1 build, the compiler throws warning message as below:

   security/integrity/ima/ima_mok.c:24:12: warning:
   no previous prototype for ‘ima_mok_init’ [-Wmissing-prototypes]
       __init int ima_mok_init(void)

Silence the warning by adding static keyword to ima_mok_init().

Signed-off-by: Austin Kim <austin.kim@lge.com>
Fixes: 41c89b64d718 ("IMA: create machine owner and blacklist keyrings")
Cc: stable@vger.kernel.org
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_mok.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/integrity/ima/ima_mok.c
+++ b/security/integrity/ima/ima_mok.c
@@ -26,7 +26,7 @@ struct key *ima_blacklist_keyring;
 /*
  * Allocate the IMA blacklist keyring
  */
-__init int ima_mok_init(void)
+static __init int ima_mok_init(void)
 {
 	struct key_restriction *restriction;
 


