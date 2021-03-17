Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635F233E739
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 03:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhCQCzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 22:55:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:51655 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhCQCzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 22:55:12 -0400
IronPort-SDR: bpi+En2K7cqx/KjMHAs4Hh66o1M2B4dpqHG1fsYIqBRKd6aqakewSGYha2eK1nm4mKlghj3/+S
 tQrYKS1SIqnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="250737133"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="250737133"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 19:55:11 -0700
IronPort-SDR: 6F8Xetb+REVHd55/H7P6Mkix8meq0bXw6YbDtR/hMH6piONcm5A5e8ShDdmcF16zYaK77wukEH
 txuG+nkyW1lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="590888164"
Received: from unknown (HELO coxu-arch-shz.sh.intel.com) ([10.239.160.25])
  by orsmga005.jf.intel.com with ESMTP; 16 Mar 2021 19:55:10 -0700
From:   Colin Xu <colin.xu@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com,
        colin.xu@intel.com
Subject: [PATCH 0/5] drm/i915/gvt: Backport GVT BXT/APL fix to 5.4.y
Date:   Wed, 17 Mar 2021 10:54:59 +0800
Message-Id: <cover.1615946755.git.colin.xu@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8fe105679765700378eb328495fcfe1566cdbbd0 upstream
commit 92010a97098c4c9fd777408cc98064d26b32695b upstream
commit a5a8ef937cfa79167f4b2a5602092b8d14fd6b9a upstream
commit 28284943ac94014767ecc2f7b3c5747c4a5617a0 upstream
commit 4ceb06e7c336f4a8d3f3b6ac9a4fea2e9c97dc07 upstream

Upstream intel-gvt fixed some breaking and GPU hang issues on BXT/APL platform
but 5.4.y doesn't have so backport them. These patch have been rebased to
linux-5.4.y.

Colin Xu (4):
  drm/i915/gvt: Set SNOOP for PAT3 on BXT/APL to workaround GPU BB hang
  drm/i915/gvt: Fix mmio handler break on BXT/APL.
  drm/i915/gvt: Fix virtual display setup for BXT/APL
  drm/i915/gvt: Fix vfio_edid issue for BXT/APL

Zhenyu Wang (1):
  drm/i915/gvt: Fix port number for BDW on EDID region setup

 drivers/gpu/drm/i915/gvt/display.c  | 212 ++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/gvt/handlers.c |  40 +++++-
 drivers/gpu/drm/i915/gvt/mmio.c     |   5 +
 drivers/gpu/drm/i915/gvt/vgpu.c     |   5 +-
 4 files changed, 258 insertions(+), 4 deletions(-)

-- 
2.30.2

