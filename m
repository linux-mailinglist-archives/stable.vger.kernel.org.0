Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFEC5112DB
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 09:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359148AbiD0HyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 03:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359104AbiD0Hxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 03:53:44 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603FBDEA4
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 00:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651045834; x=1682581834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=027ChD7/Ah8j2KpdxfIqvBNWErEu69UY0jd8gI1R0fo=;
  b=MhgoE1HzS4osPvoQw5c1/DJ7a9O1i0MtsJ0e7twWz90TvBMUBEvJ7ed1
   /7tkT1mHu0QZyQFNAAZPJa4pFMswqG2zDk7KYu9c62AjlxdzsVqABh/ir
   WLAAb2POv2fLxQFJGrJ0/fSc6mW+uiCdTOmObXPSAprWiYm0Dbo/SLMbo
   UI6L9gHRXMVFdW6pHr7ETfrhV1kC8OyE3RYLr7fBoSWPIwunvGNF7afUm
   2GlKZSqVHf0W53WTu2Dxs/fpdRVjPHQxWlj2dEXg3eJ3/R8jbkhg+r/7r
   S+Qhe06YYvDbrpmt0tw0xru1+0QLwswJXRVFVfWmoKE7vxPTDp3iH6Knp
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="247781327"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="247781327"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 00:50:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="680163331"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 27 Apr 2022 00:50:32 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njcRT-0004TW-HG;
        Wed, 27 Apr 2022 07:50:31 +0000
Date:   Wed, 27 Apr 2022 15:49:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Anusha Srivatsa <anusha.srivatsa@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     kbuild-all@lists.01.org,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/dmc: Add MMIO range restrictions
Message-ID: <202204271502.BuTprbqW-lkp@intel.com>
References: <20220427003509.267683-1-anusha.srivatsa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427003509.267683-1-anusha.srivatsa@intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Anusha,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on drm-intel/for-linux-next]
[also build test ERROR on drm-tip/drm-tip next-20220426]
[cannot apply to v5.18-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Anusha-Srivatsa/drm-i915-dmc-Add-MMIO-range-restrictions/20220427-084021
base:   git://anongit.freedesktop.org/drm-intel for-linux-next
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20220427/202204271502.BuTprbqW-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/f79241ea04e8815b3c1b0ab6b9d6136efc8646d3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Anusha-Srivatsa/drm-i915-dmc-Add-MMIO-range-restrictions/20220427-084021
        git checkout f79241ea04e8815b3c1b0ab6b9d6136efc8646d3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/gpu/drm/i915/display/intel_dmc.c: In function 'parse_dmc_fw_header':
>> drivers/gpu/drm/i915/display/intel_dmc.c:476:9: error: this 'if' clause does not guard... [-Werror=misleading-indentation]
     476 |         if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count, dmc_header->header_ver, dmc_id))
         |         ^~
   drivers/gpu/drm/i915/display/intel_dmc.c:478:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
     478 |                 return 0;
         |                 ^~~~~~
   cc1: all warnings being treated as errors


vim +/if +476 drivers/gpu/drm/i915/display/intel_dmc.c

   406	
   407	static u32 parse_dmc_fw_header(struct intel_dmc *dmc,
   408				       const struct intel_dmc_header_base *dmc_header,
   409				       size_t rem_size, u8 dmc_id)
   410	{
   411		struct drm_i915_private *i915 = container_of(dmc, typeof(*i915), dmc);
   412		struct dmc_fw_info *dmc_info = &dmc->dmc_info[dmc_id];
   413		unsigned int header_len_bytes, dmc_header_size, payload_size, i;
   414		const u32 *mmioaddr, *mmiodata;
   415		u32 mmio_count, mmio_count_max, start_mmioaddr;
   416		u8 *payload;
   417	
   418		BUILD_BUG_ON(ARRAY_SIZE(dmc_info->mmioaddr) < DMC_V3_MAX_MMIO_COUNT ||
   419			     ARRAY_SIZE(dmc_info->mmioaddr) < DMC_V1_MAX_MMIO_COUNT);
   420	
   421		/*
   422		 * Check if we can access common fields, we will checkc again below
   423		 * after we have read the version
   424		 */
   425		if (rem_size < sizeof(struct intel_dmc_header_base))
   426			goto error_truncated;
   427	
   428		/* Cope with small differences between v1 and v3 */
   429		if (dmc_header->header_ver == 3) {
   430			const struct intel_dmc_header_v3 *v3 =
   431				(const struct intel_dmc_header_v3 *)dmc_header;
   432	
   433			if (rem_size < sizeof(struct intel_dmc_header_v3))
   434				goto error_truncated;
   435	
   436			mmioaddr = v3->mmioaddr;
   437			mmiodata = v3->mmiodata;
   438			mmio_count = v3->mmio_count;
   439			mmio_count_max = DMC_V3_MAX_MMIO_COUNT;
   440			/* header_len is in dwords */
   441			header_len_bytes = dmc_header->header_len * 4;
   442			start_mmioaddr = v3->start_mmioaddr;
   443			dmc_header_size = sizeof(*v3);
   444		} else if (dmc_header->header_ver == 1) {
   445			const struct intel_dmc_header_v1 *v1 =
   446				(const struct intel_dmc_header_v1 *)dmc_header;
   447	
   448			if (rem_size < sizeof(struct intel_dmc_header_v1))
   449				goto error_truncated;
   450	
   451			mmioaddr = v1->mmioaddr;
   452			mmiodata = v1->mmiodata;
   453			mmio_count = v1->mmio_count;
   454			mmio_count_max = DMC_V1_MAX_MMIO_COUNT;
   455			header_len_bytes = dmc_header->header_len;
   456			start_mmioaddr = DMC_V1_MMIO_START_RANGE;
   457			dmc_header_size = sizeof(*v1);
   458		} else {
   459			drm_err(&i915->drm, "Unknown DMC fw header version: %u\n",
   460				dmc_header->header_ver);
   461			return 0;
   462		}
   463	
   464		if (header_len_bytes != dmc_header_size) {
   465			drm_err(&i915->drm, "DMC firmware has wrong dmc header length "
   466				"(%u bytes)\n", header_len_bytes);
   467			return 0;
   468		}
   469	
   470		/* Cache the dmc header info. */
   471		if (mmio_count > mmio_count_max) {
   472			drm_err(&i915->drm, "DMC firmware has wrong mmio count %u\n", mmio_count);
   473			return 0;
   474		}
   475	
 > 476		if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count, dmc_header->header_ver, dmc_id))
   477			drm_err(&i915->drm, "DMC firmware has Wrong MMIO Addresses\n");
   478			return 0;
   479	
   480		for (i = 0; i < mmio_count; i++) {
   481			dmc_info->mmioaddr[i] = _MMIO(mmioaddr[i]);
   482			dmc_info->mmiodata[i] = mmiodata[i];
   483		}
   484		dmc_info->mmio_count = mmio_count;
   485		dmc_info->start_mmioaddr = start_mmioaddr;
   486	
   487		rem_size -= header_len_bytes;
   488	
   489		/* fw_size is in dwords, so multiplied by 4 to convert into bytes. */
   490		payload_size = dmc_header->fw_size * 4;
   491		if (rem_size < payload_size)
   492			goto error_truncated;
   493	
   494		if (payload_size > dmc->max_fw_size) {
   495			drm_err(&i915->drm, "DMC FW too big (%u bytes)\n", payload_size);
   496			return 0;
   497		}
   498		dmc_info->dmc_fw_size = dmc_header->fw_size;
   499	
   500		dmc_info->payload = kmalloc(payload_size, GFP_KERNEL);
   501		if (!dmc_info->payload)
   502			return 0;
   503	
   504		payload = (u8 *)(dmc_header) + header_len_bytes;
   505		memcpy(dmc_info->payload, payload, payload_size);
   506	
   507		return header_len_bytes + payload_size;
   508	
   509	error_truncated:
   510		drm_err(&i915->drm, "Truncated DMC firmware, refusing.\n");
   511		return 0;
   512	}
   513	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
