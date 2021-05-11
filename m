Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B3F37AEF7
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 20:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhEKTA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 15:00:29 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:57657 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbhEKTA2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 15:00:28 -0400
Received: from leknes.fjasle.eu ([92.116.95.191]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MaIKJ-1m3rjK015x-00WG70; Tue, 11 May 2021 20:58:43 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id 99F503C083; Tue, 11 May 2021 20:58:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
        t=1620759519; bh=FaD466R31miMxVlYtxK4z0Q063fRTTllwY+w8rtPSPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKoZ/RiVJv3+DROmxyfgDhlKwFS5+uD88dRH+kg0CZazRanpcBRbZk+u8exJZaVMd
         dadkGUiw1kagrj/sU15dnZC4rkXss0YsdhZM0e/Zp00MBsNTsIt5CWvkg7kZVuKlO5
         QO3tBHbyOm3eF93Wx3x7pqOq+hh1ABfkMtYLYbwA=
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH v2 2/2] scripts: switch explicitly to Python 3
Date:   Tue, 11 May 2021 20:58:17 +0200
Message-Id: <20210511185817.2695437-3-nicolas@fjasle.eu>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210511185817.2695437-1-nicolas@fjasle.eu>
References: <20210511185817.2695437-1-nicolas@fjasle.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:0bgFNKm7La74oYl9Eh2AgVsJMhSXCVJgaM9ahZUGyZrJsvnfZ7u
 Q6X3FvRK3wpWuDh58Mx6kUNdWPx5iOhlZKzNBOWZTjfL8xKxb1zT/czACQgjEA8WTwKgDSh
 45y4Cuqug9mt/IY55kK5Cn99QjQEG27dFTesPSpeWuMgOXo2xq1WcfIzU6EhryONEbu2R11
 O1lVE+hfDfTiRSs5OvJ0w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NlVXrntQAXc=:jromK0BxWHIv4tddOSMwx+
 AATSDNPUsADv0By0Qdy/mZlbSFSeM96Cl4cIry9n4aDgqjs1WhrULgCHhzig5LGrhsGZj4c7B
 FzfcaTg1eeeoPFsCS/Zw/8aFgvqKPkOxSp8sj3KZjFJAmGRFx7AUzXaBgLiAC48mypkxxpOQm
 WSRu+1vcpehKBYca5+uRX3VC7fY/n8/JoMDKfDPR4lgrH6EvFJdV/SE6elSo97sE9VNghxtv7
 P1xb2NHxHVhlsn5REjAjUC8qiQzfg5+ap2/e//gtRyrlVg7AvU2GwfqbvcCruIod5vIY5pez/
 cshhNpNOAnehPY+Clx3t7e04Yp0Jc2THKfARwNF/yqzCsTxTiq0tE/1FVwRiSofzy7uuhGWKD
 dqt1MO73+fYfxffhVAEcGMqOrk9hzxB1IASudYbobmiTlLmMnygQzKVccIONoJNKBAhVsduCj
 VTdefKSZyeEA9ISHR5VbEZ0ej8/fqH9bvXJNt315fb/J12sWL2S8n7inz3EYdJK2yZNFFBjlR
 87cgoOzjlUGcG0ClOU/uG0=
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

