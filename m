Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6AE38A1E9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhETJgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:36:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232834AbhETJeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:34:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EFF961358;
        Thu, 20 May 2021 09:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502946;
        bh=7yn0w1cqVxet9VqZQY8uopsy2K0zrYzUXRQ8gutjg9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMJKOmyvKxwGtlsER+pgtQKagGXgd15pxhavSiiAcL309mHSqDUU5y3GqALCpHgf4
         CENNRfL9m1Pgx2eAgntIwt6TkM+jrqyyary4u2rUCoqQdsHL8HGmVHMptJYVNGWvN6
         TzNHD+cp3Bv64l1PEc2VFg/hRhmI9zKwLk6p51bU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.4 37/37] scripts: switch explicitly to Python 3
Date:   Thu, 20 May 2021 11:22:58 +0200
Message-Id: <20210520092053.492044045@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
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


