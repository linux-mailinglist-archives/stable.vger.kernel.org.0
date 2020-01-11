Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D96A1380EA
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbgAKKii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729445AbgAKKig (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:38:36 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D032B20848;
        Sat, 11 Jan 2020 10:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578739115;
        bh=4L+WNPHNKKg6Jw3SiwCYTFzyVmNImrxHEevu5JrADSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQXC2J+ljHBQWsA1HyahRDtpLjvKatjWipnCsmHeM4GAz1b9bhB5mJyInOLzQATWt
         DjraeIs2jyOr172wEwC2aPA3yMOGG7LlWpG8pIj1XZUQP25r/Cu0FY7fjya3j78l5H
         zP5TbXlB6pps1/pR1ScZwL+RzlGqHnx4LGfjnilM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Enrico Weigelt, metux IT consult" <info@metux.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/165] scripts: package: mkdebian: add missing rsync dependency
Date:   Sat, 11 Jan 2020 10:50:16 +0100
Message-Id: <20200111094929.770391490@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enrico Weigelt, metux IT consult <info@metux.net>

[ Upstream commit a11391b6f50689adb22c65df783e09143fafb794 ]

We've missed the dependency to rsync, so build fails on
minimal containers.

Fixes: 59b2bd05f5f4 ("kbuild: add 'headers' target to build up uapi headers in usr/include")
Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/mkdebian | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/mkdebian b/scripts/package/mkdebian
index e0750b70453f..7c230016b08d 100755
--- a/scripts/package/mkdebian
+++ b/scripts/package/mkdebian
@@ -174,7 +174,7 @@ Source: $sourcename
 Section: kernel
 Priority: optional
 Maintainer: $maintainer
-Build-Depends: bc, kmod, cpio, bison, flex | flex:native $extra_build_depends
+Build-Depends: bc, rsync, kmod, cpio, bison, flex | flex:native $extra_build_depends
 Homepage: http://www.kernel.org/
 
 Package: $packagename
-- 
2.20.1



