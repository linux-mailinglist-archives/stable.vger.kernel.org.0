Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EDD47289F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbhLMKOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46660 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhLMJ56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:57:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E7669CE0E6B;
        Mon, 13 Dec 2021 09:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8B1C34600;
        Mon, 13 Dec 2021 09:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389475;
        bh=qvUw/qOeM9w/+FkQuJ64USMcdCTF48/SgX73se+Uhr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fckE3/70b18mUdb3/vU3hiKw7cGssI++v3c1wkCarmJQWK/nYQJZUvUlxmI26vErX
         sgANPlWJ5uE9zxzdKXHRKEiJe4FCL4sVNwGyVLlpOQSJ3tijApB1ok0uqHtnOZl36R
         lutHG3wInVPE0yfO/BnXc17jhOP/vkOIIBngXxw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 107/171] PM: runtime: Fix pm_runtime_active() kerneldoc comment
Date:   Mon, 13 Dec 2021 10:30:22 +0100
Message-Id: <20211213092948.648415539@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 444dd878e85fb33fcfb2682cfdab4c236f33ea3e upstream.

The kerneldoc comment of pm_runtime_active() does not reflect the
behavior of the function, so update it accordingly.

Fixes: 403d2d116ec0 ("PM: runtime: Add kerneldoc comments to multiple helpers")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pm_runtime.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -129,7 +129,7 @@ static inline bool pm_runtime_suspended(
  * pm_runtime_active - Check whether or not a device is runtime-active.
  * @dev: Target device.
  *
- * Return %true if runtime PM is enabled for @dev and its runtime PM status is
+ * Return %true if runtime PM is disabled for @dev or its runtime PM status is
  * %RPM_ACTIVE, or %false otherwise.
  *
  * Note that the return value of this function can only be trusted if it is


