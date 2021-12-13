Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB237472A5F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244237AbhLMKkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244231AbhLMKjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:39:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37806C08EC6F;
        Mon, 13 Dec 2021 01:52:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01C4EB80E15;
        Mon, 13 Dec 2021 09:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31426C00446;
        Mon, 13 Dec 2021 09:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389141;
        bh=ZcebZ99Y1Z/56l7Zw0iTCScFIT12/2EDsZeR3UFRPUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4RRNAC7tCYm2PFkr4kcUROmG1aptqooljeW9ZdFpip38vueZF6EnmT6OjWWvAAjG
         pfkO99Z34G5JervjK0qZzlBB+AUkRqzj8zNEejRnXMfQfwF95zBBY9079pAjHE6Eg/
         iFsAZeG8s+jCFdwr1PFsLLiU5Ve97olmFqW52Zpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Robert Karszniewicz <r.karszniewicz@phytec.de>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 132/132] Documentation/Kbuild: Remove references to gcc-plugin.sh
Date:   Mon, 13 Dec 2021 10:31:13 +0100
Message-Id: <20211213092943.611616280@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Karszniewicz <r.karszniewicz@phytec.de>

commit 1cabe74f148f7b99d9f08274a62467f96c870f07 upstream.

gcc-plugin.sh has been removed in commit
1e860048c53e ("gcc-plugins: simplify GCC plugin-dev capability test").

Signed-off-by: Robert Karszniewicz <r.karszniewicz@phytec.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kbuild/gcc-plugins.rst |    6 ------
 1 file changed, 6 deletions(-)

--- a/Documentation/kbuild/gcc-plugins.rst
+++ b/Documentation/kbuild/gcc-plugins.rst
@@ -44,12 +44,6 @@ Files
 	This is a compatibility header for GCC plugins.
 	It should be always included instead of individual gcc headers.
 
-**$(src)/scripts/gcc-plugin.sh**
-
-	This script checks the availability of the included headers in
-	gcc-common.h and chooses the proper host compiler to build the plugins
-	(gcc-4.7 can be built by either gcc or g++).
-
 **$(src)/scripts/gcc-plugins/gcc-generate-gimple-pass.h,
 $(src)/scripts/gcc-plugins/gcc-generate-ipa-pass.h,
 $(src)/scripts/gcc-plugins/gcc-generate-simple_ipa-pass.h,


