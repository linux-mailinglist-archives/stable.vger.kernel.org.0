Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FA1499DC6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586222AbiAXWZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583233AbiAXWR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001BDC06138D;
        Mon, 24 Jan 2022 12:48:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D760260B03;
        Mon, 24 Jan 2022 20:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAC6C340E5;
        Mon, 24 Jan 2022 20:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057288;
        bh=Bf7idONjgD/oBEZ0+ZWnrASVJYEbrOEFixMhi+GyhwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNm7b/gdKAn65MyckyRFR38F41/HOSr9DbXKRpWxcSV/kgU5BpuWYaQcnQhbdJrfw
         716HS/B1G4uxQXjFbcR/sO/sMHeBwekzauXF451iFH9sayTjQpZqyMnp9qz/obg0Ja
         vXrNy/VmNtsC6p9obx69w9PyElSjJ6SQ/z/H/0n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.15 764/846] bpftool: Fix indent in option lists in the documentation
Date:   Mon, 24 Jan 2022 19:44:41 +0100
Message-Id: <20220124184127.311934994@linuxfoundation.org>
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

commit 986dec18bbf41f50edc2e0aa4ac5ef8e0f64f328 upstream.

Mixed indentation levels in the lists of options in bpftool's
documentation produces some unexpected results. For the "bpftool" man
page, it prints a warning:

    $ make -C bpftool.8
      GEN     bpftool.8
    <stdin>:26: (ERROR/3) Unexpected indentation.

For other pages, there is no warning, but it results in a line break
appearing in the option lists in the generated man pages.

RST paragraphs should have a uniform indentation level. Let's fix it.

Fixes: c07ba629df97 ("tools: bpftool: Update and synchronise option list in doc and help msg")
Fixes: 8cc8c6357c8f ("tools: bpftool: Document and add bash completion for -L, -B options")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211110114632.24537-5-quentin@isovalent.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |    6 +++---
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |    8 ++++----
 tools/bpf/bpftool/Documentation/bpftool.rst        |    6 +++---
 7 files changed, 14 insertions(+), 14 deletions(-)

--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -13,7 +13,7 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **btf** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | {**-d** | **--debug** } |
-		{ **-B** | **--base-btf** } }
+	{ **-B** | **--base-btf** } }
 
 	*COMMANDS* := { **dump** | **help** }
 
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -13,7 +13,7 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **cgroup** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-f** | **--bpffs** } }
+	{ **-f** | **--bpffs** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **tree** | **attach** | **detach** | **help** }
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -13,7 +13,7 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **gen** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-L** | **--use-loader** } }
+	{ **-L** | **--use-loader** } }
 
 	*COMMAND* := { **object** | **skeleton** | **help** }
 
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -13,7 +13,7 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **link** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
+	{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
 
 	*COMMANDS* := { **show** | **list** | **pin** | **help** }
 
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -13,11 +13,11 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **map** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
+	{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
 
 	*COMMANDS* :=
-	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext**
-	| **delete** | **pin** | **help** }
+	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext** |
+	**delete** | **pin** | **help** }
 
 MAP COMMANDS
 =============
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -13,12 +13,12 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **prog** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-f** | **--bpffs** } | { **-m** | **--mapcompat** } | { **-n** | **--nomount** } |
-		{ **-L** | **--use-loader** } }
+	{ **-f** | **--bpffs** } | { **-m** | **--mapcompat** } | { **-n** | **--nomount** } |
+	{ **-L** | **--use-loader** } }
 
 	*COMMANDS* :=
-	{ **show** | **list** | **dump xlated** | **dump jited** | **pin** | **load**
-	| **loadall** | **help** }
+	{ **show** | **list** | **dump xlated** | **dump jited** | **pin** | **load** |
+	**loadall** | **help** }
 
 PROG COMMANDS
 =============
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -19,14 +19,14 @@ SYNOPSIS
 	*OBJECT* := { **map** | **program** | **cgroup** | **perf** | **net** | **feature** }
 
 	*OPTIONS* := { { **-V** | **--version** } |
-		{ **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
+	{ **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
 
 	*MAP-COMMANDS* :=
 	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext** |
-		**delete** | **pin** | **event_pipe** | **help** }
+	**delete** | **pin** | **event_pipe** | **help** }
 
 	*PROG-COMMANDS* := { **show** | **list** | **dump jited** | **dump xlated** | **pin** |
-		**load** | **attach** | **detach** | **help** }
+	**load** | **attach** | **detach** | **help** }
 
 	*CGROUP-COMMANDS* := { **show** | **list** | **attach** | **detach** | **help** }
 


