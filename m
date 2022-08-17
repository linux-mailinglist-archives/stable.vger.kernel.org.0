Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EC659670C
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 03:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbiHQByl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 21:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbiHQByk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 21:54:40 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF9E96757
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 18:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660701279; x=1692237279;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=npyYrEWOSQ15ackLhvx/bMTRokAkLLuv0Xy5zBOoDU0=;
  b=LbLqMLfjzKkRnrIOU/lVHD4GSxkf0ZN6M+ZmcjEmv29gVm27r4eklFs+
   1ASWRfmeDRV4g+Te9AcwO3rpeF+rsgQeSIFxbJ4vpGWLcpF/xzENkJTGL
   8pddYbfKMLgDJm/aZHpRLJSUy3TnBl01JLbG6s5rBIN2uRwhpywHzGQ8x
   24dfhz2l3awge7oz2BU1/GhFrS1jbvV7V9f5dOvqu9j4XgKts0PnYtw1x
   dv3hSK+gqzXyy4mwbbwhFA83FpYZvULc5sFhtdKI9MSiFO5kM4Q0Ll0qP
   XNt2mfWKzDZdx2nxR6H1M1V9lWOmm8PT1EVdgDlhOlZPYFSrEud2P1nAp
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="378669060"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="378669060"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 18:54:39 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="667389690"
Received: from rongch2-desk.sh.intel.com (HELO localhost) ([10.239.159.175])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 18:54:38 -0700
Date:   Wed, 17 Aug 2022 09:54:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Badhri Jagan Sridharan <badhri@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: typec: tcpm: Return ENOTSUPP for power supply
 prop writes
Message-ID: <YvxKXBTZ8xNhNsPN@rongch2-desk2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220816191150.1432166-1-badhri@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
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
Subject: [PATCH v2] usb: typec: tcpm: Return ENOTSUPP for power supply prop writes
Link: https://lore.kernel.org/stable/20220816191150.1432166-1-badhri%40google.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
