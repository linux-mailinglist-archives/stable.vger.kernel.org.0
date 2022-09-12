Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C4B5B62C3
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 23:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiILVah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 17:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiILVag (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 17:30:36 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA38C28E14
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663018234; x=1694554234;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=Zm3mTJ5Li1XF+sgZN744AJcrY0AQjEYf8bsVf4uIgIo=;
  b=ZbDlRZ/Ba4oCxNKSrjErgjFeq3t+0S8EqkZdn9OeoR8wasYPP2kVimVn
   Wl/AXFqmSBuMT02YomBsE9Oc0oYxWy+WY1L0a2ks3TszsfFTHZtV12UKj
   uPVVzn4VCUa5WwmA0L7V5yxq9CWtkrR4sqx3g88yBGWcmjdj60fsGFc/d
   4sVYbVMuHZSy3blPLipRhO97j7cw1b+mLqD2fX/UATatw1iANmme66o4I
   4vGEVBmZGVqv2hiRLNdQkHNPlBe+ynD9gqv4TfpCTzWN7me6Af2gt+SYC
   GkhwF5ThFcIs/CW5ekDQY7Rmgs2niaBA4v0e+ivJxbzc0ERc8vJOfZOQ0
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="296709688"
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="296709688"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 14:30:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="741929834"
Received: from lkp-server02.sh.intel.com (HELO 4011df4f4fd3) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 12 Sep 2022 14:30:31 -0700
Received: from kbuild by 4011df4f4fd3 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oXr0g-0002tH-37;
        Mon, 12 Sep 2022 21:30:30 +0000
Date:   Tue, 13 Sep 2022 05:29:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eddie James <eajames@linux.ibm.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH v7 1/2] iio: pressure: dps310: Refactor startup procedure
Message-ID: <Yx+kyvJyhBwRsjfv@facefcfb2e4a>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912212743.37365-2-eajames@linux.ibm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH v7 1/2] iio: pressure: dps310: Refactor startup procedure
Link: https://lore.kernel.org/stable/20220912212743.37365-2-eajames%40linux.ibm.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



