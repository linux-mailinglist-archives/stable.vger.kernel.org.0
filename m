Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BF864DD7F
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 16:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiLOPNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 10:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiLOPNJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 10:13:09 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C73C3134F
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 07:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671117154; x=1702653154;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=8fGzHXQ3ieml722S6qgKR16cdo8fHidbjyCiG3c+O3g=;
  b=BpYun0R2AzvvfD30VNiSQtGOhtVbqCH8nHwzqQ8pC3ewI950WTHiloh+
   LgMvxW3PXAX8DuMsyW0aV1lORp+URUhQ7u0XD/KQrdb/ZMzzgxtZGRXbH
   0oGGq3DRssoP8RYqO398omH9TgYFf91ZwMPjvs7haG6yK0RAMFiu1d4U9
   ORCghfeDTu7IHKmVCqAbQBcZ6VzghKzit/S4TikXNm9imLc+bDfvjA9zA
   ZG9txuV9UOhOLvwmEV9x8MKA55IwWMfNHaL1bK+dbVh2FuX6oVDSp9fEr
   roHfLPWZBXJH9zZDqVD7OiuhyrrarrO6plD643WLheJckuX1bEV9oS8cz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="383021037"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="383021037"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 06:50:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="680112879"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="680112879"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 15 Dec 2022 06:50:53 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p5pZU-0006LO-22;
        Thu, 15 Dec 2022 14:50:52 +0000
Date:   Thu, 15 Dec 2022 22:50:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH net v3] openvswitch: Fix flow lookup to use unmasked key
Message-ID: <Y5s0GEK+ylnDnpXP@416bcb91c936>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167111551443.359845.7122827280135116424.stgit@ebuild>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH net v3] openvswitch: Fix flow lookup to use unmasked key
Link: https://lore.kernel.org/stable/167111551443.359845.7122827280135116424.stgit%40ebuild

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



