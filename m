Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9E47FA80
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732264AbfHBNXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393915AbfHBNXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:23:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9050D20644;
        Fri,  2 Aug 2019 13:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752192;
        bh=FI1AbKWqa1YCKS4h18fkWOJkMmVId5M0OrgX9gzHDWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnCEAWzB5V6dku66gbJ/YhGrnqRKTjx4POEzcvf2mPkY1vEFD8OJb/CC0tZypKU9h
         br3oNshM79Rr5jSU1uZyD2NMWVfVtlQhi8Jqg4sp2+QlJTJFV4rWxTpw6mYHVGaNba
         VksdMJhnwl0CpKzaQmHEJZsEgETsba9Ywem3JZ6Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 06/42] scripts/sphinx-pre-install: fix script for RHEL/CentOS
Date:   Fri,  2 Aug 2019 09:22:26 -0400
Message-Id: <20190802132302.13537-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802132302.13537-1-sashal@kernel.org>
References: <20190802132302.13537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

[ Upstream commit b308467c916aa7acc5069802ab76a9f657434701 ]

There's a missing parenthesis at the script, with causes it to
fail to detect non-Fedora releases (e. g. RHEL/CentOS).

Tested with Centos 7.6.1810.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/sphinx-pre-install | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
index 067459760a7b0..3524dbc313163 100755
--- a/scripts/sphinx-pre-install
+++ b/scripts/sphinx-pre-install
@@ -301,7 +301,7 @@ sub give_redhat_hints()
 	#
 	# Checks valid for RHEL/CentOS version 7.x.
 	#
-	if (! $system_release =~ /Fedora/) {
+	if (!($system_release =~ /Fedora/)) {
 		$map{"virtualenv"} = "python-virtualenv";
 	}
 
-- 
2.20.1

