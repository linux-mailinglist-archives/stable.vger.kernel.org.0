Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E2C408DB8
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241867AbhIMN2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241873AbhIMN0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:26:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDD886124A;
        Mon, 13 Sep 2021 13:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539358;
        bh=iunw2Io+LwlzTrWZu9n0ONV4qgrSwhf3yZfN3wpLAek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARiSKB7NqPiwmxVpE6rmrdAvpNiQ6kk1P321bjvNSP7UTaac3a31QwX8AccjAUx2/
         twsTISseFLFrE3mRDRcKcaXJ1z+67fIgYFG36pSOSO5PHKHgj/RhnSadG6L5u4lfqm
         lzRo7UrMvrJW2DfopPgPrrHrPLIhshunt/fSCs7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Austin Kim <austin.kim@lge.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.4 140/144] IMA: remove -Wmissing-prototypes warning
Date:   Mon, 13 Sep 2021 15:15:21 +0200
Message-Id: <20210913131052.613345488@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
@@ -21,7 +21,7 @@ struct key *ima_blacklist_keyring;
 /*
  * Allocate the IMA blacklist keyring
  */
-__init int ima_mok_init(void)
+static __init int ima_mok_init(void)
 {
 	struct key_restriction *restriction;
 


