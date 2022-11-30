Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA0563D9E0
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 16:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiK3Pu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 10:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiK3PuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 10:50:24 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F72E84DD4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669823423; x=1701359423;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=tYCqXHoxTqAW3+ErSFVgjAvQtVZdMlNSTEVMTPqasN4=;
  b=MTI7uAtKNN0c5treA6XszIOqa9yQQzIYQEwOMKnkEIOx1Nvq234xI7i4
   9D08ygCh2wtiFgQnHHhY54xd85fmAB6BRenq1aQsD+9aNyw+DYfcWtNrk
   b6+VvVrCqKV8lYtauBYwhoHz2DzIK32+i9ale1DHUhNsO1aVFjuOwaVBf
   qNLGlo+PiwrfvearGXdPVWel5B+SbUia2xNiko0ayf98mse6TNuO7ASCJ
   hjUQKe4fapuPqRD4+1wxHegLAB7FsRTdd/pCym5TQW0HA80G71iBiDJf3
   CJgn9sqYvFrnHOdO6ffwNJLyN91LfZV5kfr8t8fuVERNhpZtihCtPYMsR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="298798612"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="298798612"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 07:50:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="889334340"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="889334340"
Received: from lkp-server01.sh.intel.com (HELO 64a2d449c951) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2022 07:50:21 -0800
Received: from kbuild by 64a2d449c951 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p0PLp-000BMd-0V;
        Wed, 30 Nov 2022 15:50:21 +0000
Date:   Wed, 30 Nov 2022 23:49:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v6 1/2] kexec: Introduce kexec_with_frozen_processes
Message-ID: <Y4d7jhvvJKFCMO/P@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221127-snd-freeze-v6-1-3e90553f64a5@chromium.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH v6 1/2] kexec: Introduce kexec_with_frozen_processes
Link: https://lore.kernel.org/stable/20221127-snd-freeze-v6-1-3e90553f64a5%40chromium.org

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



