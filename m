Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF0C65E957
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 11:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjAEKxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 05:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbjAEKwg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 05:52:36 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718ECDA9
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 02:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672915955; x=1704451955;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HPy4YNWSCTmFQ+lGiaR3TuDk7rvCR208Y/ytJrJs5f0=;
  b=T9c2TaXVO8BAPqbC8s+U9xkxutwS0sInIj+RCXC8HQVN+E63NwKiYG+C
   cHG5tGEBungO+HT9mEKu1MyUAx6+rtLb1izhfMGeSCq1N5HGBG3eczqGG
   xo95xZoQWGtTWXJ9pr8DsYfsy9xKpnV6ybm+y1Lwmwm1VxsA1SZuvmK8J
   1iUxRznANPcMqaGT/VGRTZxdFwgGe7DpWxnobN4jGfug4GKyTzg7c5oWE
   K6FZFGeG4/9dSgb3sg+WbTrMvy8UpnGoVlHt9x0GhhHIgQlOXAPT6XI24
   AGRTAHSxTjKwfFc/2MlfarH5pgPCxtvGPeLt0bHEXAVnU9mbUR5B8h2/E
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="349394705"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="349394705"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 02:52:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="605506801"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="605506801"
Received: from swathish-mobl.ger.corp.intel.com (HELO localhost) ([10.252.10.152])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 02:52:33 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     stable@vger.kernel.org
Cc:     jani.nikula@intel.com
Subject: [6.1 BACKPORT 0/2] drm/i915/dsi: two stable backports for 6.1
Date:   Thu,  5 Jan 2023 12:52:25 +0200
Message-Id: <20230105105227.689222-1-jani.nikula@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stable team, please pick up these two manual backports for 6.1 that
failed to apply [1][2].

Thanks,
Jani.


[1] https://lore.kernel.org/r/167284704812263@kroah.com
[2] https://lore.kernel.org/r/1672847059102181@kroah.com


Jani Nikula (2):
  drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence
  drm/i915/dsi: fix MIPI_BKLT_EN_1 native GPIO index

 drivers/gpu/drm/i915/display/intel_dsi_vbt.c | 94 +++++++++++++++++++-
 drivers/gpu/drm/i915/i915_irq.c              |  3 +
 drivers/gpu/drm/i915/i915_reg.h              |  1 +
 3 files changed, 95 insertions(+), 3 deletions(-)

-- 
2.34.1

