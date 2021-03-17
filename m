Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E0E33F86E
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 19:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhCQSt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 14:49:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:39004 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233100AbhCQStM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 14:49:12 -0400
IronPort-SDR: wJSagCQo9JI5sNAPVnOX6Rn/KD4RSeeLYRfBM8hqW+69pi+FSI0Y0Jyp7h+qg2eb6de04VcPXz
 QCYUQaJF+VTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9926"; a="209499349"
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="209499349"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 11:49:05 -0700
IronPort-SDR: El5N0F38OB5gA9/Zy+oj9TKOhuyGp1TOEfgTj+IDCJ1CE1Ta5u4pJ43iOUZXNCAj7NycvKzlxC
 pNaQ7DxAOqUw==
X-IronPort-AV: E=Sophos;i="5.81,257,1610438400"; 
   d="scan'208";a="511828503"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 11:49:04 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH v2 0/3] drm/i915: Fix DP LTTPR link training mode initialization
Date:   Wed, 17 Mar 2021 20:48:58 +0200
Message-Id: <20210317184901.4029798-1-imre.deak@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is v2 of
https://patchwork.freedesktop.org/series/88015/

also making sure that LTTPRs are detected and initialized only if the
DPCD and LTTPR revisions are > 1.4 as required by Display Port
specification.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.11

Imre Deak (3):
  drm/i915/ilk-glk: Fix link training on links with LTTPRs
  drm/i915: Disable LTTPR support when the DPCD rev < 1.4
  drm/i915: Disable LTTPR support when the LTTPR rev < 1.4

 drivers/gpu/drm/i915/display/intel_dp.c       |  4 +-
 drivers/gpu/drm/i915/display/intel_dp_aux.c   |  7 ++
 .../drm/i915/display/intel_dp_link_training.c | 66 ++++++++++++++-----
 .../drm/i915/display/intel_dp_link_training.h |  2 +-
 4 files changed, 58 insertions(+), 21 deletions(-)

-- 
2.25.1

