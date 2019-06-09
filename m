Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB133A777
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731032AbfFIQt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731593AbfFIQty (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ED45205ED;
        Sun,  9 Jun 2019 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098993;
        bh=F+TYIcTfTft0dTVhJH50C6ngOyIF8PgxqwBW+hKQiak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNU9eY49CzvXFfdGRe06O7oRTR40igNjPolTlv4c2u6RxEz9Lfxh9pLhkltkvbX0C
         Dhurm77nhSjuoJNxR1aiqZPeV4onklsBkXWH5Bso/KcV3Fbcd4IrmAHOAz32reY7Jb
         yXSrGUmG+HFWVKxRhldumBB9fhxFatZrBwWWCd9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.14 11/35] Revert "fib_rules: fix error in backport of e9919a24d302 ("fib_rules: return 0...")"
Date:   Sun,  9 Jun 2019 18:42:17 +0200
Message-Id: <20190609164126.153138797@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
References: <20190609164125.377368385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 691306ebd18f945e44b4552a4bfcca3475e5d957 as the
patch that this "fixes" is about to be reverted...

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/fib_rules.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -564,7 +564,6 @@ int fib_nl_newrule(struct sk_buff *skb,
 	}
 
 	if (rule_exists(ops, frh, tb, rule)) {
-		err = 0;
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			err = -EEXIST;
 		goto errout_free;


