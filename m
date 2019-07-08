Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA23E624CD
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387787AbfGHPVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387757AbfGHPVn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:21:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F08214C6;
        Mon,  8 Jul 2019 15:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599302;
        bh=+erWMCoHTiSsklg2eI6FKFJT38mbys5O4ZaxKE9Ogkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q75EdKaXJnAWQlELDLaZEvoICU1KGCtXW2BgOQMbyYKBYCe60f5Sktg4F50NZkjqm
         3H6l/edJd3bhMXly34fMDavQ7ybFlbJE+GXMKRgGPypmnGt2HpUE0/CFeN0KDhbs3L
         LnwlLt1LlR58vFOiytuydZzp6AVAQxd5ToJNiF2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Adeodato=20Sim=C3=B3?= <dato@net.com.org.es>,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 044/102] net/9p: include trans_common.h to fix missing prototype warning.
Date:   Mon,  8 Jul 2019 17:12:37 +0200
Message-Id: <20190708150528.713266530@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 52ad259eaac0454c1ac7123e7148cf8d6e6f5301 ]

This silences -Wmissing-prototypes when defining p9_release_pages.

Link: http://lkml.kernel.org/r/b1c4df8f21689b10d451c28fe38e860722d20e71.1542089696.git.dato@net.com.org.es
Signed-off-by: Adeodato Simó <dato@net.com.org.es>
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
index 38aa6345bdfa..9c0c894b56f8 100644
--- a/net/9p/trans_common.c
+++ b/net/9p/trans_common.c
@@ -14,6 +14,7 @@
 
 #include <linux/mm.h>
 #include <linux/module.h>
+#include "trans_common.h"
 
 /**
  *  p9_release_req_pages - Release pages after the transaction.
-- 
2.20.1



