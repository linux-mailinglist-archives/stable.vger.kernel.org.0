Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71315674790
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 00:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjASXyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 18:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjASXye (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 18:54:34 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960529F3B8
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 15:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674172471; x=1705708471;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=4wk0/37NDtv/IscsBLnjWY2KUlXzvAtJBt2rgH7grzw=;
  b=OLedLu+NWrYpqb0jLIIq9SobMf6dfCXx6gVKdZKYSlJs572H/CiCS4mX
   UGNXAmVGVFgwv/nHN2V99QdSdrv1rTF6a1MzJYLVgBhZUN5i3sxKcZPtn
   eNkkW+8NKEu8IHD8o1kH4AWwhzjxKu1Uvm+27xtSmiKX6GUFJvsVTAP95
   OGz3gXmsHT+1g/ClxbPz1zZ1Op+xjNGdmNhDNqFZbSbGsGlNGRIzldm1U
   78ARrN9a1jG/QA46Yu/pbugIQRbhyMC7GZU7HZGTZlkJNyfqZmYaDSJOK
   AN3BC6dK9R8VJjrAbPPh6W4Mdrg2/dP7MFNV4bVSJ081WkI26F5j+cMQ0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="389983212"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="389983212"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 15:54:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="768456428"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="768456428"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2023 15:54:29 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIejk-0001zU-2s;
        Thu, 19 Jan 2023 23:54:28 +0000
Date:   Fri, 20 Jan 2023 07:54:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Harry Wentland <harry.wentland@amd.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 4/7] drm/drm_print: correct format problem
Message-ID: <Y8nYJQLtcFM0x2nc@06a1915e439d>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119235200.441386-5-harry.wentland@amd.com>
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
Subject: [PATCH 4/7] drm/drm_print: correct format problem
Link: https://lore.kernel.org/stable/20230119235200.441386-5-harry.wentland%40amd.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



