Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB797F874
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393285AbfHBNUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393219AbfHBNUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A7C121850;
        Fri,  2 Aug 2019 13:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752005;
        bh=dHperu63nYS8UK5KTdZoHxwDBf0maf/PLEgDFchR0oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KIXk3N11YxW/5OorTHk/yAqZQTLnSFptneabjynS/Z/uUTxBr0TSGQdfgzcWaxUbD
         zCa4QPDtx3Hk0r5RrWFVqOWwaIj6yZRP6vFItaR/y2YF4BvmDoxDcgZD0yIRUc5UgN
         wMY22/rXNakv/5Ym5xl3iMUorn6IlHn8BNgAHk74=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 11/76] scripts/sphinx-pre-install: fix latexmk dependencies
Date:   Fri,  2 Aug 2019 09:18:45 -0400
Message-Id: <20190802131951.11600-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

[ Upstream commit 353290a9eb5362a80bc8e52fcd7eb77a30f48afc ]

The name of the package with carries latexmk is different
on two distros:

- On OpenSUSE, latexmk is packaged as "texlive-latexmk-bin"
- On Mageia, latexmk is packaged at "texlive-collection-basic"

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/sphinx-pre-install | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
index 4cc2b3ee5209f..1f9f0a334c24f 100755
--- a/scripts/sphinx-pre-install
+++ b/scripts/sphinx-pre-install
@@ -447,6 +447,8 @@ sub give_opensuse_hints()
 		"texlive-zapfding",
 	);
 
+	$map{"latexmk"} = "texlive-latexmk-bin";
+
 	check_rpm_missing(\@suse_tex_pkgs, 2) if ($pdf);
 	check_missing_tex(2) if ($pdf);
 	check_missing(\%map);
@@ -472,6 +474,8 @@ sub give_mageia_hints()
 		"texlive-fontsextra",
 	);
 
+	$map{"latexmk"} = "texlive-collection-basic";
+
 	check_rpm_missing(\@tex_pkgs, 2) if ($pdf);
 	check_missing(\%map);
 
-- 
2.20.1

