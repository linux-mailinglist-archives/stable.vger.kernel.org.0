Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074DB645282
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 04:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLGDVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 22:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLGDVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 22:21:34 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7C4554D7
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 19:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670383293; x=1701919293;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=6wXMoUik0xANWqJKN5ur/QpJCBdtKN1irtu29GNK3WA=;
  b=BL/v5Jzrl0fgqFBj7ySw14QdS2CooEk0nf1CfkQrQUKEPpmFPCLytCBQ
   KidUkjcqh4e6Gmrwvudcaics40dcBadXXss9nwF2TPT5wBhbN/3qczF3M
   Cc2vP3/slMJ/i49x05W5+A0XgEl36q9M2X1ZyI629MlJrbJAaNj79EPTs
   jFDKnTtG1JhYOYLRsOmjWbzc6+a7zmG12dpflAgUSCv9dA0gBQ1LvE9xZ
   eQczNZ+gooHFTYdQc0ikuA/nwkEvjk0yPnj+ZrliGZFzMS0TqPSO1wQ6Y
   XPqFWhct4ezfr8v/yBTCv5GlTGSFIyRdc0hCX91KjnX0wqZo47I51px6W
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="315506413"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="315506413"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 19:21:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="646449767"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="646449767"
Received: from lkp-server01.sh.intel.com (HELO b3c45e08cbc1) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 06 Dec 2022 19:21:31 -0800
Received: from kbuild by b3c45e08cbc1 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p2kzz-0001VB-0Z;
        Wed, 07 Dec 2022 03:21:31 +0000
Date:   Wed, 7 Dec 2022 11:21:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dicheng Wang <wangdicheng123@hotmail.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v3 -next] ALSA:usb-audio:add the information of KT0206
 device driven by USB audio
Message-ID: <Y5AGnMHJCzS1sx9l@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SG2PR02MB58789FBF9A2EA801AF49D5E88A1A9@SG2PR02MB5878.apcprd02.prod.outlook.com>
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
Subject: [PATCH v3 -next] ALSA:usb-audio:add the information of KT0206 device driven by USB audio
Link: https://lore.kernel.org/stable/SG2PR02MB58789FBF9A2EA801AF49D5E88A1A9%40SG2PR02MB5878.apcprd02.prod.outlook.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



