Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E959314557B
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgAVNW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgAVNW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:22:26 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 038B6205F4;
        Wed, 22 Jan 2020 13:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699345;
        bh=q+uwZbHrhnEvPeUulaq1n7jqJ5rCMHn4Q3crXScWbqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6q3CLbdoJrZ3H959TRxDlCM59Yuct6pVqFA92JXrZQUFxeDSQjlIc5gfYpx0ibLO
         DNVcldxDbzjsrYClfemKW68IjB4N/P4hSwspPjVt/qH/vg1+65wkl7dLYnC9mhchLQ
         Vy3K/HTy9CXpH4aSlAgM3sBuxOz5DSH5RKTA8ylo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 5.4 070/222] drm/i915: Add missing include file <linux/math64.h>
Date:   Wed, 22 Jan 2020 10:27:36 +0100
Message-Id: <20200122092838.734177378@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit ea38aa2ea5b0969776f0a47f174ce928a22be803 upstream.

Fix build error:
./drivers/gpu/drm/i915/selftests/i915_random.h: In function i915_prandom_u32_max_state:
./drivers/gpu/drm/i915/selftests/i915_random.h:48:23: error:
 implicit declaration of function mul_u32_u32; did you mean mul_u64_u32_div? [-Werror=implicit-function-declaration]
  return upper_32_bits(mul_u32_u32(prandom_u32_state(state), ep_ro));

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 7ce5b6850b47 ("drm/i915/selftests: Use mul_u32_u32() for 32b x 32b -> 64b result")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20200107135014.36472-1-yuehaibing@huawei.com
(cherry picked from commit 62bf5465b26d1f502430b9c654be7d16bf2e242d)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/selftests/i915_random.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/selftests/i915_random.h
+++ b/drivers/gpu/drm/i915/selftests/i915_random.h
@@ -25,6 +25,7 @@
 #ifndef __I915_SELFTESTS_RANDOM_H__
 #define __I915_SELFTESTS_RANDOM_H__
 
+#include <linux/math64.h>
 #include <linux/random.h>
 
 #include "../i915_selftest.h"


