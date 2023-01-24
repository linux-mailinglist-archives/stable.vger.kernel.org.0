Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01A5679DEB
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 16:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbjAXPsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 10:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbjAXPsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 10:48:14 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D508F1EFC9
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 07:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674575293; x=1706111293;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=NZX1XswjGTa5tW61Md/AGLEZAIMXQBL2r0SR7aa95EE=;
  b=n1fCmSO0aa6zw7+3UDuFazpbcTBLQIPn1BM17MYmwdcI0Zcq0jhQDPJE
   32tCHLH+BGZKkgvWrNnUa1fWwNtx0nx+ySOwAY8xPoQiedqDBuLfZGns/
   5qp1jUpzrWwMnLRAtxn6qG4emhO6VbLVO+Eejg7xf6cUKfW4b6/FBGzHl
   OfveaG4kd4po95UaqnO/XslZEtnbbE76iNdIMUt6w4pxp2Pq1aHIR0CvD
   BHyx64vTxIE/KYP+VfKT1JN8Wu2wluIlYDVpZ9c7QUDYecuCJoaZVO/FJ
   8rgxn8C3p06OiFb0PWqsoJA1dZMobzsK7N5RIr5w9qLUV4UuySwE2MMHG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="327580793"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="327580793"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 07:48:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="730723888"
X-IronPort-AV: E=Sophos;i="5.97,242,1669104000"; 
   d="scan'208";a="730723888"
Received: from pesir-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.197])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 07:47:57 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     intel-gfx@lists.freedesktop.org
Subject: v6.1 stable backport request
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Date:   Tue, 24 Jan 2023 17:47:54 +0200
Message-ID: <878rhs6ij9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Stable team, please backport these two commits to v6.1:

2bd0db4b3f0b ("drm/i915: Allow panel fixed modes to have differing sync polarities")
55cfeecc2197 ("drm/i915: Allow alternate fixed modes always for eDP")

Reference for posterity: https://gitlab.freedesktop.org/drm/intel/-/issues/7841


Thanks,
Jani.

-- 
Jani Nikula, Intel Open Source Graphics Center
