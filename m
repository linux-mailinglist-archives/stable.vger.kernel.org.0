Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7019B6192AB
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 09:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiKDIVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 04:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKDIVF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 04:21:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9739D26575
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 01:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667550063; x=1699086063;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=/XPa5CcEHOAK9N7CRv5LcnMadDvNIIIqqGGfzmCRPBA=;
  b=X9n+zhRiquKzMbchHoQ0oCP0GBUWcWUnFMEZKyRFExJIDnnAYFW20U7B
   hNa+Q2TX3xo4APVwoYF5+plbraR/wPlAZiPjyKvKgoh0ohFjeJavc261V
   tGj20Y7ZCrjCrJO2MzEPe7vrqrA+vlBnUnieCai+V2rFD6RQTD7GaTUz/
   bTT0ZbBOY8cHG/yIUe8xvkELRGcR3gXtCWc17eVfmBUn6paOQDJtUC1JV
   sWyyFV8S/4BZ8ppxPdy7pA/G8JBi+fCPlVHmTp0Qz3Sr80t+8XgrXuXH2
   jjgbn9H7HLd7rg19gfLKOyE05ZtT88MvDG9CkLEvH+dPyaSGBOBCv+X23
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="308624975"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="308624975"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 01:21:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="964262645"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="964262645"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 04 Nov 2022 01:21:02 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oqrwj-000GlB-1u;
        Fri, 04 Nov 2022 08:21:01 +0000
Date:   Fri, 4 Nov 2022 16:20:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jason Montleon <jmontleo@redhat.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH v4 1/2] ASoC: rt5514: fix legacy dai naming
Message-ID: <Y2TLO8cjDi3p5O8m@1ef3cb914f27>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103144612.4431-1-jmontleo@redhat.com>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Subject: [PATCH v4 1/2] ASoC: rt5514: fix legacy dai naming
Link: https://lore.kernel.org/stable/20221103144612.4431-1-jmontleo%40redhat.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



