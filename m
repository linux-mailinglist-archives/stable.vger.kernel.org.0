Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D263395D2F
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhEaNmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232398AbhEaNkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:40:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7B7661466;
        Mon, 31 May 2021 13:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467656;
        bh=aLK+Wgwo7nLp7z0y8czxP1P/GZz5hTsKxMM0gzmJJP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZUfPNOJmfD4yormfduAPvg2NKfDdCFJLaH++wHjfWVV0107V66ZIZ+geXPDJyOXo
         fv2ZY+h/M9NSS/OZNqPJb1krlcvl7S3i3hGGS0IadLXYbmRdD0v6L+I+TeE6G8Qbqw
         4P1ye0As+j26TcanAOW4wiQQ/cAf/lyZdJCYEqvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH 4.14 03/79] scripts: switch explicitly to Python 3
Date:   Mon, 31 May 2021 15:13:48 +0200
Message-Id: <20210531130636.111383070@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/bloat-o-meter |    2 +-
 scripts/diffconfig    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 #
 # Copyright 2004 Matt Mackall <mpm@selenic.com>
 #
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -1,4 +1,4 @@
-#!/usr/bin/env python
+#!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 #
 # diffconfig - a tool to compare .config files.


