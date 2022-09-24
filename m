Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78985E894D
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 09:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbiIXHv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 03:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbiIXHv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 03:51:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42F2115A4F
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 00:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664005885; x=1695541885;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=5323Rt7T0/a6FsucFEL5Muya6AO19Jm5jaZf0r+6E2g=;
  b=UrWHSpvY2hWOR+T4ENc/kbl+FEB4AEwLoxqxC+KnUAXtUpGCRNPF/1DU
   jNhQVcOCPWaJIuQa6GMUDiuxThGCa5eKZ7boYZ/htRhePRGpFbIUfIrky
   QCnsLjtXBhAwDp6+aFAPmsHTzDJGmaVGacTfRzVD2+LfTitvGxyDHwLS2
   6rAfpbzRaszY9RHWk3kYBDyqnR75FVde2Q90gcfcXLR3Blle/nve67e0q
   o5AbtpKvl/smP56EBZ7e+yDWvIB8kFUHkvcpIluc8aZs/4/VwMk+vhJMu
   aaG0c9NrL4h6HWGuDjTWpCHOLdHX4V+qceimZCVGXbOu6ONc8I1v6dhHk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10479"; a="300737398"
X-IronPort-AV: E=Sophos;i="5.93,341,1654585200"; 
   d="scan'208";a="300737398"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2022 00:51:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,341,1654585200"; 
   d="scan'208";a="598142226"
Received: from lkp-server01.sh.intel.com (HELO c0a60f19fe7e) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 24 Sep 2022 00:51:24 -0700
Received: from kbuild by c0a60f19fe7e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1obzwZ-0006K4-1s;
        Sat, 24 Sep 2022 07:51:23 +0000
Date:   Sat, 24 Sep 2022 15:50:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shuai Xue <xueshuai@linux.alibaba.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to
 avoid memory leak
Message-ID: <Yy624noLRK752NW6@320659cf58f4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220924074953.83064-1-xueshuai@linux.alibaba.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Subject: [PATCH v2] ACPI: APEI: do not add task_work to kernel thread to avoid memory leak
Link: https://lore.kernel.org/stable/20220924074953.83064-1-xueshuai%40linux.alibaba.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



