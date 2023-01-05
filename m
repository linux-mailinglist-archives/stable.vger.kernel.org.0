Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA3765E4A4
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 05:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjAEEXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 23:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjAEEXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 23:23:07 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DA417E1C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 20:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672892585; x=1704428585;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=4SV1mI7pC9agZVlhUPmntHCPScQyTWJP2O0ld7Eg0k4=;
  b=aHlN9L4fuOO9de9QiLtBHa2f+rk6wymUFegS5p781wWdQ5ueKbYZPeny
   IdlOp/5S2qoCS0Xn5/xObdBjXuKMFe8kzxObtia5RIvs1biwJ16F0MP+N
   OgRDJ6iD96ViWAqTRsFZ9EGfk5KAYGEg9lLSA/ieQIv2IquhRjtDL2aXu
   OsZYd7H7zhlMtvd+SoSduZO4iVHtOhlH4Xoa4OC/uncOHUu2AKkK+uOgW
   uQgTEYwt8nEX6YQhbGrOE041Q60kjyD1PLW7RDxY2lqOWMhrYZTeJMra1
   bwj9ukgp9BxF+XUIrdXVOGf5MC354hXcpt69oGSL/l4QpEgu7z8ZrEKwf
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="319817513"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="319817513"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 20:22:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="633026660"
X-IronPort-AV: E=Sophos;i="5.96,302,1665471600"; 
   d="scan'208";a="633026660"
Received: from lkp-server02.sh.intel.com (HELO f1920e93ebb5) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 04 Jan 2023 20:22:56 -0800
Received: from kbuild by f1920e93ebb5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pDHmJ-00016n-0w;
        Thu, 05 Jan 2023 04:22:55 +0000
Date:   Thu, 5 Jan 2023 12:22:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Linyu Yuan <quic_linyyuan@quicinc.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] usb: ucsi: fix connector partner ucsi work issue
Message-ID: <Y7ZQc313LcVTxEJ9@3aeda0d71eb3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1672892324-12335-1-git-send-email-quic_linyyuan@quicinc.com>
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
Subject: [PATCH] usb: ucsi: fix connector partner ucsi work issue
Link: https://lore.kernel.org/stable/1672892324-12335-1-git-send-email-quic_linyyuan%40quicinc.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



