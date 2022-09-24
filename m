Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686CE5E8CD9
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiIXM6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiIXM6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:58:34 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9656C10E5F7
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 05:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664024313; x=1695560313;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=OY6Fpe7McsK/FvADaO31oByGd45Ye898zXRgljnlet0=;
  b=kgCuP70/BUj1Uj3shNC45Gugt3PerHzGqFiEN5gq4QRh4jHPHJtIsMb7
   k9OC9mqtEEbwTDwtTFlEoELkt9nCB2SDqbPAlDry6ZbyAka51KgZW31E1
   yM0khrtAbir8kZFIA9ZE93z1KiC6WHkcp1UxjAw/g2/Xjj5CcaB7z8yRQ
   EMHDKzEpQneqsNl1raiBGxHqH51z479Plj+dzbbMCKCcyTSDKmEpRxRVP
   t3KIjET4iAx8sqojXQWWZfMXZ6gimGJ/Y3C84yfpgfgX5Xac133PwbzLG
   NIC7fVIzVOt9viHvL3Hya2YWF7341aubETuMMzezSap7JqyHsOh8sJ2Ki
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10480"; a="287903101"
X-IronPort-AV: E=Sophos;i="5.93,342,1654585200"; 
   d="scan'208";a="287903101"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2022 05:58:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,342,1654585200"; 
   d="scan'208";a="571689288"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 24 Sep 2022 05:58:32 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oc4jn-0006Vq-1A;
        Sat, 24 Sep 2022 12:58:31 +0000
Date:   Sat, 24 Sep 2022 20:58:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH 5.4 V2 01/19] MAINTAINERS: add Chandan as xfs maintainer
 for 5.4.y
Message-ID: <Yy7+3qt0eIo2IdtC@320659cf58f4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220924125656.101069-2-chandan.babu@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 5.4 V2 01/19] MAINTAINERS: add Chandan as xfs maintainer for 5.4.y
Link: https://lore.kernel.org/stable/20220924125656.101069-2-chandan.babu%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



