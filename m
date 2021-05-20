Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD2238A56A
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhETKQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236180AbhETKOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:14:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4716B613F1;
        Thu, 20 May 2021 09:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503889;
        bh=7yn0w1cqVxet9VqZQY8uopsy2K0zrYzUXRQ8gutjg9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sm1hQiMB16IarEVwFjXAyC+T1YzOJwDLyHFDrGhOQGeZ8Qdf+hVRPGae1+mWcp9ED
         Ngft+MuF+iyqC00tzTdp2MdI2vB7/hTZ3529jiRJBNq6AYfDvvVWPgAdWx84C+qud4
         651HYRvi0NMH8UP1s1Rss3AkQuMmjlMtrDgyXR3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 425/425] scripts: switch explicitly to Python 3
Date:   Thu, 20 May 2021 11:23:14 +0200
Message-Id: <20210520092145.369052506@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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


