Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A69C472A5D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbhLMKj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238915AbhLMKjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:39:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64842C08EC6E;
        Mon, 13 Dec 2021 01:52:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0C78CE0E83;
        Mon, 13 Dec 2021 09:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ED6C00446;
        Mon, 13 Dec 2021 09:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389138;
        bh=q+FF74ybS3nJNAc0EcScXMJntWYGH0PDpJ4/ImbvQsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hFgEXI4vFQnLG2Y7S+wY9/HlfW0CztOSQdUO9JrKciFj8WlgDFI5noDeEI3mUJxc
         9O79zPvTofPsgL+dIAcSgwpoJAHIwjBJ82aBwjHVlHfQG2AhbMkWqz5mI9J18No7wx
         gta4g9TIQlbrKiIQDnsFTyHzcJv9aY0DhNdGLHTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 131/132] MAINTAINERS: adjust GCC PLUGINS after gcc-plugin.sh removal
Date:   Mon, 13 Dec 2021 10:31:12 +0100
Message-Id: <20211213092943.581898119@linuxfoundation.org>
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

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

commit 5136bb8c8b5872676f397b27f93a30568baf3a25 upstream.

Commit 1e860048c53e ("gcc-plugins: simplify GCC plugin-dev capability test")
removed ./scripts/gcc-plugin.sh, but missed to adjust MAINTAINERS.

Hence, ./scripts/get_maintainers.pl --self-test=patterns warns:

  warning: no file matches    F:    scripts/gcc-plugin.sh

Adjust entries in GGC PLUGINS section after this file removal.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7310,7 +7310,6 @@ L:	linux-hardening@vger.kernel.org
 S:	Maintained
 F:	Documentation/kbuild/gcc-plugins.rst
 F:	scripts/Makefile.gcc-plugins
-F:	scripts/gcc-plugin.sh
 F:	scripts/gcc-plugins/
 
 GCOV BASED KERNEL PROFILING


