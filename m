Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763B6379D4A
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 05:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhEKDEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 23:04:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:40904 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhEKDEL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 23:04:11 -0400
IronPort-SDR: lDG7UjpuSK5GXZ0envi8wTlDzHx/dwP5ZLk39YgeZAzEcJE/9DSAwAGOVUJBybd3uMKmd6NhxV
 HQKDNlowbuRQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="199017996"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="199017996"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 20:03:03 -0700
IronPort-SDR: l/9b2DC4Sq2LQe+RD/oFnIyuvYUQWUJrkJyuplK+su+ekyBFMxk34RH6hC0a35vQUjGKWjGRoV
 KKopgJYLU+6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="609328955"
Received: from unknown (HELO coxu-arch-shz.sh.intel.com) ([10.239.160.26])
  by orsmga005.jf.intel.com with ESMTP; 10 May 2021 20:03:01 -0700
From:   Colin Xu <colin.xu@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gvt-dev@lists.freedesktop.org, zhenyuw@linux.intel.com,
        colin.xu@intel.com
Subject: [PATCH 0/2] drm/i915/gvt: Backport GVT BXT/APL fix to 5.10.y
Date:   Tue, 11 May 2021 11:02:53 +0800
Message-Id: <cover.1620702000.git.colin.xu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a5a8ef937cfa79167f4b2a5602092b8d14fd6b9a upstream
commit 4ceb06e7c336f4a8d3f3b6ac9a4fea2e9c97dc07 upstream

Upstream intel-gvt fixed some breaking and GPU hang issues on BXT/APL platform
but 5.10.y doesn't have so backport them. These patch have been rebased to
linux-5.10.y.

Colin Xu (2):
  drm/i915/gvt: Fix virtual display setup for BXT/APL
  drm/i915/gvt: Fix vfio_edid issue for BXT/APL

 drivers/gpu/drm/i915/gvt/display.c | 212 +++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/gvt/mmio.c    |   5 +
 drivers/gpu/drm/i915/gvt/vgpu.c    |   5 +-
 3 files changed, 219 insertions(+), 3 deletions(-)

-- 
2.31.1

