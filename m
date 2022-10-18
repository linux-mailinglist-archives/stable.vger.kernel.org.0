Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2A16029C8
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 13:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJRLC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 07:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiJRLCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 07:02:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C86BB5FEC;
        Tue, 18 Oct 2022 04:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666090934; x=1697626934;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=QedL/Fm3JdGkHbWDHcQs6YYpeRDxbzlUvsranEIlDVM=;
  b=EPiNbR9PLHKV8NOr+Z4zN2MxOKQKa3dpRHINRlYTySe6fcmQUl7Syc5w
   sQSxMp2E0lvveSMtXvhnQaOX9kmJWcGWkKPNg8WW1U07y3y93B0gGCeat
   QaDjfjUFo0FMbBNN5xGVRuQiMSeD9YGzdUl0ReHidyC1af3EY2eP8G8vJ
   CO9RUKNWMFlQuxioJ3dpW8DNAtHvrBZxZFN6BQyti0KSU6SyGadS8F384
   dtcmTHzR2bu69KKuQiyhM/eGMdoXUugkHlxsnwiWnW+n3CaD4yllqPC+X
   Rvu7EmqF+9LsVa3KZ8fTBj2DhhKUClHbeOQQTwE5tsbg6yGtIr+NmoBVk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="286462306"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="286462306"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 04:02:13 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="771150865"
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="771150865"
Received: from ineznano-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.44.87])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2022 04:02:11 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     stable@vger.kernel.org
Cc:     intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ville.syrjala@linux.intel.com
Subject: v5.19 & v6.0 stable backport request
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Date:   Tue, 18 Oct 2022 14:02:08 +0300
Message-ID: <87k04xiedr.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hello stable team, please backport these two commits to stable kernels
v5.19 and v6.0:

4e78d6023c15 ("drm/i915/bios: Validate fp_timing terminator presence")
d3a7051841f0 ("drm/i915/bios: Use hardcoded fp_timing size for generating LFP data pointers")

References: https://lore.kernel.org/r/fac9a564-edff-db25-20d4-7146ae2a7dc8@redhat.com

Thanks,
Jani.

-- 
Jani Nikula, Intel Open Source Graphics Center
