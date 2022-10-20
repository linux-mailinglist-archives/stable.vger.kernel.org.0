Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B896054BA
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 03:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJTBNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 21:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJTBNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 21:13:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DCE176B9E
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 18:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666228414; x=1697764414;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=qJUtB1/t9rkeb/ZbcU0lJ7xF7+ZRKW7BSkQcNkdB4lg=;
  b=Lyc/9b4MWh05DexdeJdqvzWpOcg0z2LeIOQyIUPigK6BtjNyEVe85eWv
   oU2qUbrHaMWuLimmJI63UPF2EUzgO3vIYnvg5XizgQTKxtRBmTEdyBPeD
   z7t0+PdpxGzKBRI78OXrbSb24LHmKubRdTs5FmwqNFBFAosuPWEZfhxCr
   k7kLQcMEt3axLegBEFpa6htwHRFfqejgqSvzHClppekHGT2h1N0y9d3Y8
   xgP6/IVyijTD2a2gf46EZaaDboYUDT/pgliDpblJKh3vu4Cm2xxfyURRH
   iEXGqjgEEqNettVioqKA8sNITGjgBVwr0L61+6sGor+qnbbw1FWgqh4No
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="304187487"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="304187487"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 18:13:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="718755157"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="718755157"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Oct 2022 18:13:32 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1olK7n-0000c7-23;
        Thu, 20 Oct 2022 01:13:31 +0000
Date:   Thu, 20 Oct 2022 09:13:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH stable 5.10 5/5] kbuild: Add skip_encoding_btf_enum64
 option to pahole
Message-ID: <Y1Cgp/TOmE8scCvJ@b995051e45c0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019085604.1017583-6-jolsa@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH stable 5.10 5/5] kbuild: Add skip_encoding_btf_enum64 option to pahole
Link: https://lore.kernel.org/stable/20221019085604.1017583-6-jolsa%40kernel.org

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



