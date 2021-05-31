Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC1D395BAB
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhEaNXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232077AbhEaNVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:21:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85AC3613D5;
        Mon, 31 May 2021 13:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467144;
        bh=TKq5CCJ0eDoPwAoBeEAeQs1hYcnkJdOuA34DxS8ZYHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unX5r1zmH/0eqfZfHe1jqrIcaNdIH5qzs/vMtlZ38cpL0vyHb3ABMETV9xrRlCzxM
         UuC+iC4rkhmVN5QH+/W4vY7W0hnJqhefvwTqv0I3BWU+lXkHaPevP++HuT9+nQL8KX
         NA/XQ2r3FihSMMDDA32xJjDCOP/k3bHPmOTxuSYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH 4.9 03/66] scripts: switch explicitly to Python 3
Date:   Mon, 31 May 2021 15:13:36 +0200
Message-Id: <20210531130636.378813099@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.254683895@linuxfoundation.org>
References: <20210531130636.254683895@linuxfoundation.org>
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
[nicolas@fjasle.eu: update context for v4.9]
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
 #
 # diffconfig - a tool to compare .config files.
 #


