Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6592390F44
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 06:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhEZETo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 00:19:44 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:43381 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhEZETn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 00:19:43 -0400
Received: from leknes.fjasle.eu ([92.116.119.165]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MsqIi-1lRk693YM4-00t950; Wed, 26 May 2021 06:17:41 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id EF7083C57F; Wed, 26 May 2021 06:17:39 +0200 (CEST)
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     nicolas@fjasle.eu
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.14 2/2] scripts: switch explicitly to Python 3
Date:   Wed, 26 May 2021 06:17:28 +0200
Message-Id: <20210526041728.4114392-3-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210526041728.4114392-1-nicolas@fjasle.eu>
References: <20210526041728.4114392-1-nicolas@fjasle.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lUM2miUEeN3yLdzGNYm0RjX963zbZa0OsKJXj5O1sBAMHB7HrNg
 aSgZXLubEe7VJRcI0D3vnyb5wgZyM5TSk5FjoheIcDT6msG6UOUSFkZc60PwiLsP1VW5oey
 2I9cHQpCHRRUrnLx/WdH3iQt/nLNbycMKjr5QSYMUS+cVs9fcZPX5ddbOpxPXJc73kQbDnR
 gm+vtyFUQFz1xFv4DS89Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:S8nxAiQbk/A=:Rxy79hzUh2QuZn0zhEh38o
 ev01P/GSruwjaXCPE/4GhjMD5nG/D2ksjwkcvQ0dYQOwnrusU5VY1w0psvzHPHfomv0BsIKjD
 CVTfZB5P/5y6gi14+3JuZTiXm53dFkrRUoqTXVKLHyzizXKluK0k4G1gHiOhi+IigDOl7Co19
 j9SC67X8iR6BXgbtiKTDpsvTgvvO5Fs6XE1ppsWrwkR5UQ3TnknXb5THpfuIUwi4qM3kWeoCG
 iF5lmtpfy4cPsNGxnumff0oWtl/Yw0/PLNJdwqNeg3qS5t3D6Eh9Ap55gfBxpEHGj6QnSz/dJ
 DsgGscswIZK4YXq5YL3r3RZ8sie2BVsZf1U/d2UcY7InggspQ7JVqMnmfnewPcbftOr+PbCSO
 py7RVo+wlop26JLT94xIRFDYuaT1hPpNlff/E6b1bVHfBHDxQX03Oqomy6aLeykeNoP9HaB3y
 WF+7OatCqQKzpLLKh0wf98/IraArzYi7iHIpP4Vpwg8lXGxf2XT0OePCs/RmmWVODmfuF8IWi
 MQRfVZEURrJkIsRisdGfEw=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 51839e29cb5954470ea4db7236ef8c3d77a6e0bb upstream.

Some distributions are about to switch to Python 3 support only.
This means that /usr/bin/python, which is Python 2, is not available
anymore. Hence, switch scripts to use Python 3 explicitly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nicolas Schier <nicolas@fjasle.eu>
---
 scripts/bloat-o-meter | 2 +-
 scripts/diffconfig    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
index 654cce5614d8..0c9a3a715f2c 100755
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Copyright 2004 Matt Mackall <mpm@selenic.com>
 #
diff --git a/scripts/diffconfig b/scripts/diffconfig
index 627eba5849b5..d5da5fa05d1d 100755
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 #
 # diffconfig - a tool to compare .config files.
-- 
2.30.2

