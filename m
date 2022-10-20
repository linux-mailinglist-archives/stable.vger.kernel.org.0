Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6887B60553D
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 03:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiJTByo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 21:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJTByk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 21:54:40 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343E4360A6
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 18:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666230878; x=1697766878;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=ECte5vSBm95Ayj244ri5RIg6y5XDFstkncWpJe6AU5o=;
  b=Lt4FSH27OGBeWRIqq1FcbX2eSVyR0NrlNWF6zmVVxYFoXTWU6M7abieH
   vzy4HAh2DZQLyfI7zcPJzQwEepolHckwpG8GksEztCLLh7IWga+awGypc
   0asMbR/iY8S7NRaQx55GXCybgFwuNSiLnOkeIjFOMC47rmxKHu+jskmxh
   NtQPr6QhMEFtoYq7sYPpWFJrt3exMdafKQOzQDPxQURzyWfdrJLv4VX+G
   77Im8YjcWM1tC3Fp7qqusJ3I/jV1FL9mEu0Uug13I69sSTZzyIMZ0/oIf
   XvDcBMFuGHYSzHTqeDF6jqEdJ9N5ojBau40nq6dc/YK6OaswWVQhKbFQS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="307679502"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="307679502"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 18:54:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="958631386"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="958631386"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 19 Oct 2022 18:54:36 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1olKlX-0000hX-2G;
        Thu, 20 Oct 2022 01:54:35 +0000
Date:   Thu, 20 Oct 2022 09:54:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Bard Liao <yung-chuan.liao@linux.intel.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] soundwire: intel: Initialize clock stop timeout
Message-ID: <Y1CqP/cHlITzWCRi@b995051e45c0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020015624.1703950-1-yung-chuan.liao@linux.intel.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH] soundwire: intel: Initialize clock stop timeout
Link: https://lore.kernel.org/stable/20221020015624.1703950-1-yung-chuan.liao%40linux.intel.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



