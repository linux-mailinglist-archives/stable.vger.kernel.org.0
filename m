Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E435499DC1
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586198AbiAXWZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358273AbiAXWRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E05EC061381;
        Mon, 24 Jan 2022 12:48:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0FFA60B03;
        Mon, 24 Jan 2022 20:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1437C340E5;
        Mon, 24 Jan 2022 20:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057285;
        bh=qlfGHbOjwuWJJj7g3mrICRmEQ360zRztaKRh34ZW7F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrNIGsdme0xN4KRF6p4YXdbT7VeZYIdpWi5CzMxRPC2IXkVmyyUJYxWcCzC/KBfht
         K4+trk6RBUHvZdLMFdJgKy9DlcSoHu7Leqw58x5VpY9FB15WQSw9D6eQVRAh/nlyXg
         W9sOSdOSdaRpNm9W1Vw4luJCWK+uljsyIYudbaMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.15 763/846] bpftool: Remove inclusion of utilities.mak from Makefiles
Date:   Mon, 24 Jan 2022 19:44:40 +0100
Message-Id: <20220124184127.279189287@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quentin Monnet <quentin@isovalent.com>

commit 48f5aef4c458c19ab337eed8c95a6486cc014aa3 upstream.

Bpftool's Makefile, and the Makefile for its documentation, both include
scripts/utilities.mak, but they use none of the items defined in this
file. Remove the includes.

Fixes: 71bb428fe2c1 ("tools: bpf: add bpftool")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211110114632.24537-3-quentin@isovalent.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/bpftool/Documentation/Makefile |    1 -
 tools/bpf/bpftool/Makefile               |    1 -
 2 files changed, 2 deletions(-)

--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 include ../../../scripts/Makefile.include
-include ../../../scripts/utilities.mak
 
 INSTALL ?= install
 RM ?= rm -f
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 include ../../scripts/Makefile.include
-include ../../scripts/utilities.mak
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))


