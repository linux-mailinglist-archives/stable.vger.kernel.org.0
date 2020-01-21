Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B244A1445DF
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 21:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgAUUYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 15:24:19 -0500
Received: from mga05.intel.com ([192.55.52.43]:39948 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgAUUYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jan 2020 15:24:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 12:24:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,347,1574150400"; 
   d="scan'208";a="215661899"
Received: from unknown (HELO skalakox.lm.intel.com) ([10.232.116.60])
  by orsmga007.jf.intel.com with ESMTP; 21 Jan 2020 12:24:18 -0800
From:   Sushma Kalakota <sushmax.kalakota@intel.com>
To:     stable@vger.kernel.org
Cc:     Jonathan Derrick <jonathan.derrick@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sushma Kalakota <sushmax.kalakota@intel.com>
Subject: [BACKPORT v4.19 0/3] Fixes for nv50/gf100 under VMD
Date:   Tue, 21 Jan 2020 13:28:25 -0700
Message-Id: <20200121202828.16590-1-sushmax.kalakota@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This fix is a case where a nv50 or gf100 graphics card is used on a VMD
Domain (or other memory restricted domain) that results in a
null-pointer dereference.

One of the original fixes was already backported:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-4.19.y&id=5744fd7fa1d164a8fcbb1a65def927cab84c9a68

Sushma Kalakota (3):
  drm/nouveau/bar/nv50: check bar1 vmm return value
  drm/nouveau/bar/gf100: ensure BAR is mapped
  drm/nouveau/mmu: qualify vmm during dtor

 drivers/gpu/drm/nouveau/nvkm/subdev/bar/gf100.c | 2 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/bar/nv50.c  | 2 ++
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c   | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.17.1
