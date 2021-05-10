Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5F2379846
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 22:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhEJUYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 16:24:42 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:41247 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbhEJUYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 16:24:42 -0400
Received: from leknes.fjasle.eu ([92.116.68.92]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MFsIZ-1ljnKI3K4F-00HQ6T; Mon, 10 May 2021 22:23:05 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id C0C323C074; Mon, 10 May 2021 22:23:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
        t=1620678181; bh=FaD466R31miMxVlYtxK4z0Q063fRTTllwY+w8rtPSPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRb7f/7AIYyXmDvkcu4gECA60oUDx3Fh5Wnst/NHXond6OG/+p5ZHrvds2iWSsiBA
         x3E3s3uMb/kuR26TgdaaIR5p0mIeSQr7iC6jXODMwym31FPpd/9cVwn5aTUrlB9bou
         aNnFtBSN80YUnEwcQOI8GPqtSoO5mBtA/7bhB4es=
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH 2/2] scripts: switch explicitly to Python 3
Date:   Mon, 10 May 2021 22:22:21 +0200
Message-Id: <20210510202221.2601299-3-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210510202221.2601299-1-nicolas@fjasle.eu>
References: <20210510202221.2601299-1-nicolas@fjasle.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:DymuSj6zWO+xWKbn9h4vu+2l57r3lA2HfUR62FVbVK5eCSD0KIz
 sEiZ1f+m811ZRp82czb3psmMlJSow/YsJ7kGMjFPJJC8Y6x15zgtO06q8leRe3h2QJb/ylf
 FFwtYs1hCmj14sVuMq46tp2hLYlWEbW0ShjgNWoTXvpVaRUwUoC1nT5Vfjr9/eRJw+JZ2ks
 Z7VdECXvxtI9mIJMa6MTQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DOiMKGNBBZg=:cdHOBAovEOj76RrDkZa2Me
 5s7qpjYnXJGuSjgluYq2z60xwoGdrbDWfs8OFBUy4DmblgYR5GEwnptU3/qTQXmpBnSPu4hBB
 HNFC5bktBWkEoTj4ge9tZLKFwtP9h3R6Nstwzk53Y7YyRVyBSx1ZX5If7b3sGsm1YM6oqxPas
 wceMQih/eGAhFlz/sbSaFRBow9SRaUjcCN8FA+d1VJBJmmhVrGSzH8uDzisHg9YLiObdVg2ug
 wRv+unktwqD1Pj9ONA3cB5X5qcbssdFLRT1G0+b+DNMDvCe2VDNZ6GwR3xGP9TpGMUGqCBT9A
 uRIBy09Izh+0VgrQUGz46k+np0SXMS+xTxONMjz2GLePJVRPYJcaC9/p/0KgqozrwYYPcCiOk
 QK6LWvOneCLjEs88RIC92IA+LZRIKCVs92z1v5Et7QLNlF5D50xD3Y4x3wNA6aA6C5JAqVZBs
 ROqs8rtGEBPJu6BZvJjNm0oohoYjqNrTKdWLQYTvvZ9o85IXHO7AccYNdW3LDeCFjKRW8Gpt6
 i0vMFZkXCyw43RpkBCLiXU=
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
[nicolas@fjasle.eu: ported to v4.9, updated context]
Signed-off-by: Nicolas Schier <nicolas@fjasle.eu>
---
 scripts/bloat-o-meter | 2 +-
 scripts/diffconfig    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
index 08e607e829c0..a650bea5ccdd 100755
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Copyright 2004 Matt Mackall <mpm@selenic.com>
 #
diff --git a/scripts/diffconfig b/scripts/diffconfig
index ad1b16ec0f5b..19189f3c4a03 100755
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # diffconfig - a tool to compare .config files.
 #
-- 
2.30.1

