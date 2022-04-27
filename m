Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337C551101E
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 06:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357645AbiD0E3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 00:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357635AbiD0E3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 00:29:35 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B3013DE0
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 21:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651033586; x=1682569586;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2yl9WoU/zaTTRYdh9seA58rrOYpJ2DHp095I5XnTEDw=;
  b=E8LHTKmR2pZfvtniHkSmzUPJeWWZobsTWqPCiFO66aollj4KVKjk2eDB
   rAORtU4MyyBwQvJuFae/SNgXAC5D847jLKmPu4UgPdLuug9ff57v4aEvX
   Z8WLXZqc1iN2osadmbULJyL3mvzlMljelnhOZUQ8WUQXIMMbwXGM8NYXX
   JrYXbz4Cvub+6TeEg7/XVzY+NGRJhWzJLQLVY/ypl49q9JBcKEiH7MRNn
   eGbhRaz11gVBUuRl6VMjRHTX7/YEQ+Fue/cv2AVpYqKAfx8plnJqtCfkD
   8KPEcfFlmpgOv72x7o4ZKHZ3tPk34UtrjSmpS72/2kJHfAkqih89vmcFc
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="265970555"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="265970555"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 21:26:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="730601616"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 26 Apr 2022 21:26:23 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njZFv-0004Ju-62;
        Wed, 27 Apr 2022 04:26:23 +0000
Date:   Wed, 27 Apr 2022 12:26:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Anusha Srivatsa <anusha.srivatsa@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     kbuild-all@lists.01.org,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/dmc: Add MMIO range restrictions
Message-ID: <202204271216.6t3eWj4f-lkp@intel.com>
References: <20220427003509.267683-1-anusha.srivatsa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427003509.267683-1-anusha.srivatsa@intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Anusha,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on drm-intel/for-linux-next]
[also build test WARNING on drm-tip/drm-tip next-20220426]
[cannot apply to v5.18-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Anusha-Srivatsa/drm-i915-dmc-Add-MMIO-range-restrictions/20220427-084021
base:   git://anongit.freedesktop.org/drm-intel for-linux-next
config: i386-randconfig-a012-20220425 (https://download.01.org/0day-ci/archive/20220427/202204271216.6t3eWj4f-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/f79241ea04e8815b3c1b0ab6b9d6136efc8646d3
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Anusha-Srivatsa/drm-i915-dmc-Add-MMIO-range-restrictions/20220427-084021
        git checkout f79241ea04e8815b3c1b0ab6b9d6136efc8646d3
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/gpu/drm/i915/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/gpu/drm/i915/display/intel_dmc.c: In function 'parse_dmc_fw_header':
>> drivers/gpu/drm/i915/display/intel_dmc.c:476:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
     476 |         if (!dmc_mmio_addr_sanity_check(dmc, mmioaddr, mmio_count, dmc_header->header_ver, dmc_id))
         |         ^~
   drivers/gpu/drm/i915/display/intel_dmc.c:478:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
     478 |                 return 0;
         |                 ^~~~~~


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
