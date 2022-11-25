Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F05563825F
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 03:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKYC0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 21:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiKYC0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 21:26:51 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9E8252B6
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 18:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669343211; x=1700879211;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=GcJjgw1sCXT5mX+d29usBjZgjyHpFQCXfuealDLwBKk=;
  b=YMQSCPyltzLib/UA/SsOS988bmcXz1SfDTJb6K0h9m4DMfktcvvqIjNf
   pPV26036eqvEY2XcBB3WcBmg+UyMvkBKk2Qew9iOBLDkxKLhSrWH6pBVV
   OlVJ9+mrFJFnyswm6ZPbNvAZM0TVAOLfo9fApRj7NU4xvJ1LtkHpknPg8
   RYP9ixFVTKmQqiVSsOhEJBqBTi07pA2emVNPxmabg62IsUrw+F29zsJ80
   aaO+mkA4U2bzs8EJswZgleKtmJcP1m9HJvzx5TKHIhrf6ZOdAnLZUpXkg
   9yvTjCFfUDPqZPQh57RZ46oM6P1ac7kJiRFuQBU8829sMwoenpyGYwBqH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="294099881"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="294099881"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 18:26:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="748425139"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="748425139"
Received: from lkp-server01.sh.intel.com (HELO 64a2d449c951) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 24 Nov 2022 18:26:50 -0800
Received: from kbuild by 64a2d449c951 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oyOQT-0004Yj-1S;
        Fri, 25 Nov 2022 02:26:49 +0000
Date:   Fri, 25 Nov 2022 10:26:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Cindy Lu <lulu@redhat.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2] vhost_vdpa: fix the crash in unmap a large memory
Message-ID: <Y4Anyy7ZWcxDYmNk@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125022317.2157263-1-lulu@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH v2] vhost_vdpa: fix the crash in unmap a large memory
Link: https://lore.kernel.org/stable/20221125022317.2157263-1-lulu%40redhat.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



