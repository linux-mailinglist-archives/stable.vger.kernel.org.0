Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EED64EAB8
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 12:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiLPLiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 06:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiLPLix (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 06:38:53 -0500
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC8E22B0D;
        Fri, 16 Dec 2022 03:38:52 -0800 (PST)
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4NYRvG3wZ9z9sqg;
        Fri, 16 Dec 2022 12:38:50 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UsdrRS_F0m-m; Fri, 16 Dec 2022 12:38:50 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4NYRvG37fyz9sTF;
        Fri, 16 Dec 2022 12:38:50 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5B0128B780;
        Fri, 16 Dec 2022 12:38:50 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id YSjPfFpHUnZN; Fri, 16 Dec 2022 12:38:50 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (unknown [192.168.7.183])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 245128B764;
        Fri, 16 Dec 2022 12:38:50 +0100 (CET)
Received: from PO20335.IDSI0.si.c-s.fr (localhost [127.0.0.1])
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.16.1) with ESMTPS id 2BGBcasZ1205738
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 12:38:36 +0100
Received: (from chleroy@localhost)
        by PO20335.IDSI0.si.c-s.fr (8.17.1/8.17.1/Submit) id 2BGBcY7t1205731;
        Fri, 16 Dec 2022 12:38:34 +0100
X-Authentication-Warning: PO20335.IDSI0.si.c-s.fr: chleroy set sender to christophe.leroy@csgroup.eu using -f
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     FRANJOU Stephane <stephane.franjou@csgroup.eu>,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Tony Jones <tonyj@suse.de>, Jiri Olsa <jolsa@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] [Backport for 4.14] perf script python: Remove explicit shebang from tests/attr.c
Date:   Fri, 16 Dec 2022 12:38:12 +0100
Message-Id: <3ca0515edb717e0f394f973f3cbbe2c80abb35e4.1671190496.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671190687; l=1110; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=WfhwuICpkYsCAPjFTSL2xadbipjhMYjzCdLwRf2aTus=; b=ImqOKirkns5rivDho31j4TrXihIe12Fn9rgoJHLogExFhaMaMowiRdPZEfE40tBwsxd1cSlwvDXQ TFdUBq/4A7r0QJZaTUbchNKuwib1ha6OjCRSpnt7QMqYdiNQcWmv
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

[Upstream commit d72eadbc1d2866fc047edd4535ffb0298fe240be]

tests/attr.c invokes attr.py via an explicit invocation of Python
($PYTHON) so there is therefore no need for an explicit shebang.

Also most distros follow pep-0394 which recommends that /usr/bin/python
refer only to v2 and so may not exist on the system (if PYTHON=python3).

Signed-off-by: Tony Jones <tonyj@suse.de>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20190124005229.16146-5-tonyj@suse.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 tools/perf/tests/attr.py | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index 6c68435585c7..3e07eee33b10 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -1,4 +1,3 @@
-#! /usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 
 import os
-- 
2.38.1

