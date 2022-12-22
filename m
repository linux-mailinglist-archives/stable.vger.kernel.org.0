Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12AE653A9F
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 03:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiLVC2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 21:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiLVC2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 21:28:53 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B99B65FB
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 18:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671676132; x=1703212132;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=xrlavxxJX9nRKs80rKe8/VFF61BnAsPPj8kXPRcNo+E=;
  b=QR+vEPEzk5uJAGUXxjcVZS6LsjdMdjCwd4QOygOpb0si2j0TkQBaDcWP
   XGrjbZZEI6FXsiuP4yueRKluy6vtskvqGqcU+4cNpyLmhaHMnQwRpOakJ
   IIKiVatjrqiC//SBsbUSVUIYFuk13fQjMnK9st8qt7aHlyhZHNAprSWzg
   CpzupCIbhfk/05OJf1ioXvUK1/FEQipdt40Ro8aOjLx1MolwbcPLdf05g
   qpIvNbL2cVNZJa8uZFCe8J3CJyb4pXZPmKnH4XCp4rlcmogIxwmJqpWEf
   35wjKB9wUx4VWQRDXBOJ5w6mUSmgW75ibMz7w2evQFOqHPhroEbWLjniK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="347161848"
X-IronPort-AV: E=Sophos;i="5.96,264,1665471600"; 
   d="scan'208";a="347161848"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 18:28:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="740380096"
X-IronPort-AV: E=Sophos;i="5.96,264,1665471600"; 
   d="scan'208";a="740380096"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2022 18:28:51 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p8BKE-000B8M-28;
        Thu, 22 Dec 2022 02:28:50 +0000
Date:   Thu, 22 Dec 2022 10:28:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
Message-ID: <Y6PAuCsjbX7y3Wrf@416bcb91c936>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Subject: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform devices for DT nodes without 'vdd-supply'
Link: https://lore.kernel.org/stable/20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d%40changeid

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



