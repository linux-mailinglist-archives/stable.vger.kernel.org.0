Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C19F38A2FA
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhETJrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:47:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233285AbhETJpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:45:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05540613DA;
        Thu, 20 May 2021 09:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503221;
        bh=PsaSNH0VogRsdlZmb4ncf8ctC/iC9bO0p8QcII5+C/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HR0dGaE+vv34Ly+1rULRDTKAasoaB64HHmxAWmQLSB8xf/ww0nrFKVq4KHItjJxhW
         afdCj5WzluUJhMj2OG9f1akua0hrTxqpGUSMiEtDF7Rj5REjW0FN7a7A6jNeqimcd3
         hGAZ07LvuPhOYMk5gMBstYW8vyK29+wjw8PikUDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.19 124/425] modules: rename the licence field in struct symsearch to license
Date:   Thu, 20 May 2021 11:18:13 +0200
Message-Id: <20210520092135.507110747@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit cd8732cdcc37d7077c4fa2c966b748c0662b607e upstream.

Use the same spelling variant as the rest of the file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jessica Yu <jeyu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/module.h |    2 +-
 kernel/module.c        |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -533,7 +533,7 @@ struct symsearch {
 		NOT_GPL_ONLY,
 		GPL_ONLY,
 		WILL_BE_GPL_ONLY,
-	} licence;
+	} license;
 	bool unused;
 };
 
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -496,9 +496,9 @@ static bool check_symbol(const struct sy
 	struct find_symbol_arg *fsa = data;
 
 	if (!fsa->gplok) {
-		if (syms->licence == GPL_ONLY)
+		if (syms->license == GPL_ONLY)
 			return false;
-		if (syms->licence == WILL_BE_GPL_ONLY && fsa->warn) {
+		if (syms->license == WILL_BE_GPL_ONLY && fsa->warn) {
 			pr_warn("Symbol %s is being used by a non-GPL module, "
 				"which will not be allowed in the future\n",
 				fsa->name);


