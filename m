Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D013437815F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhEJK0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbhEJKZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57A836147D;
        Mon, 10 May 2021 10:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642275;
        bh=/MdyqcPqNotFhhpxMB0ZD5owYz45BXTbb5A4opUzxUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gGYeeskqJ46QoBcVOIBci4KW4+9oE0xHPy6zZv4n8iNPaEtv+VkI33DFHWWgs3p8l
         RdvsEbWJOP4R/9K1WZ+1qi3nGQUNPNQbx1BA7EWzdHwObX9BU7mJHCrsVZM7BfwYJV
         KNorMoYXZypzUDGp3Hy9PKWjRympNZ1DEw5D/EZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 5.4 029/184] modules: rename the licence field in struct symsearch to license
Date:   Mon, 10 May 2021 12:18:43 +0200
Message-Id: <20210510101951.189492860@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
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
@@ -565,7 +565,7 @@ struct symsearch {
 		NOT_GPL_ONLY,
 		GPL_ONLY,
 		WILL_BE_GPL_ONLY,
-	} licence;
+	} license;
 	bool unused;
 };
 
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -502,9 +502,9 @@ static bool check_exported_symbol(const
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


