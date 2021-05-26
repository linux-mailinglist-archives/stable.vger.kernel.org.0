Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5455390F43
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 06:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhEZETm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 00:19:42 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:45385 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhEZETl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 00:19:41 -0400
Received: from leknes.fjasle.eu ([92.116.119.165]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MIKs0-1lgJSi3QzU-00EOOV; Wed, 26 May 2021 06:17:56 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id D18A03C581; Wed, 26 May 2021 06:17:55 +0200 (CEST)
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     nicolas@fjasle.eu
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.9 2/2] scripts: switch explicitly to Python 3
Date:   Wed, 26 May 2021 06:17:52 +0200
Message-Id: <20210526041752.4114476-3-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210526041752.4114476-1-nicolas@fjasle.eu>
References: <20210526041752.4114476-1-nicolas@fjasle.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:97M1mIKqqoJyO+gbgTom+fqlydLF+9HtlTPYYTfYW2RsjtDcaD0
 gUGKiKFvbpZ1sDR8DoHZM2Ehf79m3oOSaalgl2wj+MDQ+ayupHQLIXIbLFiyCnLB8xqEUqe
 qICxr9rsfSUSmAmNJz94TpaHi7uC3+4ATvA90W3w7iApOpBbIOT3v8x980zL9//0moD6y0z
 LJl/1vxC1jAVClWJxj7HA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7U6O1mu08n0=:92WnNBliXtcSFyuDLh3Kra
 NNPYAqQRmUuxWx6O14JMI17HFephhQEKroh8lz3ud/G4UptLMhs/K0JeWhrhoOU0Req/pV3u/
 0jJ3Cti0Rw1hsqYwbOOq7w2vW3I2BWNTjJdQmbuZdGffh5iMZc3zQNB/aPohBhSjfrjuX+t6q
 MaP3OXlAAH1QGMlMfT5+lTt/0wVPfzPp9PvxXbbfPa/qUH2dlgugnmOPaUtnPHhRsbq2ZABcX
 RM7SPthbeR5iEQimlPYSflT1qhDplLc9xrltBW6OO13NPomdI4WZFBDfZqK0EI3spn7kGEdob
 YfqcaFtpyoNMFUvPJ3WEv88DR2KxQTCx4rgTKYGoeOzB4+yqDYTwvCHM6MBj0POyvnoKg2EvE
 aLUdrF1SwcGGWfOHyInV8GzLjmPt2rTCDqk+4qHDOpg4rT2tXYK+SJK6RHYqW7+cKoKFW11uA
 29fNPbb75tkTN4T1QO7XKHNdujzS0l3fxWJIsKWEJkHgfQhKpvbIsuE0kMace67u/HHLIwVcI
 75VrULCkOyf/2GJjp5qO4s=
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
[nicolas@fjasle.eu: update context for v4.9]
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
2.30.2

