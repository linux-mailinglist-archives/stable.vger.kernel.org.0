Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A2438A645
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhETKZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235567AbhETKXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:23:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6646461A24;
        Thu, 20 May 2021 09:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504133;
        bh=uLYGGWE3AEh54ainvfUuzoOS8Gua1Ldb6foKwiA1TA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoXtY5GrLCh1JFMdur5fc2ZcCixSVQgiaV8vLVNMpE846/kouS3Pl7sm/21uPEeSl
         gReOk81F2SFHQJl1vil7zx9+yAnRIT1UCcDUqxwXxSgNZWubZQpIUCfPUIrSXDx+i8
         BHUWGqmmC4JEqpvDKwpD8GK4G+bIo+p1HQJLAsuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jessica Yu <jeyu@kernel.org>
Subject: [PATCH 4.14 108/323] modules: rename the licence field in struct symsearch to license
Date:   Thu, 20 May 2021 11:20:00 +0200
Message-Id: <20210520092123.802884867@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
@@ -526,7 +526,7 @@ struct symsearch {
 		NOT_GPL_ONLY,
 		GPL_ONLY,
 		WILL_BE_GPL_ONLY,
-	} licence;
+	} license;
 	bool unused;
 };
 
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -511,9 +511,9 @@ static bool check_symbol(const struct sy
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


