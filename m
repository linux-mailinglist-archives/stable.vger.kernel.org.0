Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102D8498F2C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346661AbiAXTvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59766 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347706AbiAXTi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:38:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 782B7B8121A;
        Mon, 24 Jan 2022 19:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92881C340E5;
        Mon, 24 Jan 2022 19:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053134;
        bh=qlfGHbOjwuWJJj7g3mrICRmEQ360zRztaKRh34ZW7F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ow6VYiQ8EDREy0KHRvyPtEqNGPWts/OeWO/SVQBf8Eh54ycaUpIn93CBHf8qDkYy3
         ptwI5zbUgPWRW8+/8DiWaKXS67JPZKmtuCuSpOLOoFoKYVjYu8bq/JC7/ZaIv5oipp
         WxFLerWVzlNZkUn6lL5HmNHSXlXMaZYkhZABTzOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.4 288/320] bpftool: Remove inclusion of utilities.mak from Makefiles
Date:   Mon, 24 Jan 2022 19:44:32 +0100
Message-Id: <20220124184003.755661206@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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


