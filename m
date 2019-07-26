Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7372E75FE8
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 09:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfGZHgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 03:36:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:41199 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfGZHgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 03:36:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 00:36:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,310,1559545200"; 
   d="scan'208";a="369967736"
Received: from jlahtine-desk.ger.corp.intel.com ([10.252.2.51])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jul 2019 00:36:03 -0700
From:   Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 0/8] i915 fixes that missed v5.2
Date:   Fri, 26 Jul 2019 10:35:48 +0300
Message-Id: <20190726073556.9011-1-joonas.lahtinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backports of fixes for v5.2.

Chris Wilson (3):
  drm/i915: Make the semaphore saturation mask global
  drm/i915/userptr: Acquire the page lock around set_page_dirty()
  drm/i915: Don't dereference request if it may have been retired when
    printing

John Harrison (1):
  drm/i915: Support flags in whitlist WAs

Kenneth Graunke (1):
  drm/i915: Disable SAMPLER_STATE prefetching on all Gen11 steppings.

Lionel Landwerlin (3):
  drm/i915/perf: fix ICL perf register offsets
  drm/i915: whitelist PS_(DEPTH|INVOCATION)_COUNT
  drm/i915/icl: whitelist PS_(DEPTH|INVOCATION)_COUNT

 drivers/gpu/drm/i915/i915_gem_userptr.c    | 10 ++++-
 drivers/gpu/drm/i915/i915_perf.c           | 10 +++--
 drivers/gpu/drm/i915/i915_reg.h            |  7 ++++
 drivers/gpu/drm/i915/i915_request.c        |  4 +-
 drivers/gpu/drm/i915/intel_context.c       |  1 -
 drivers/gpu/drm/i915/intel_context_types.h |  2 -
 drivers/gpu/drm/i915/intel_engine_cs.c     | 17 +++++----
 drivers/gpu/drm/i915/intel_engine_types.h  |  2 +
 drivers/gpu/drm/i915/intel_workarounds.c   | 43 ++++++++++++++++++++--
 9 files changed, 77 insertions(+), 19 deletions(-)

-- 
2.20.1

