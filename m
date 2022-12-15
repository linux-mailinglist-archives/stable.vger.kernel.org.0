Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561E964DDC3
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 16:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiLOPZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 10:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiLOPZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 10:25:44 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FC96243
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 07:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671117942; x=1702653942;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=Mm10yNQjw6ATCKOsPDc9QFmbTXGo7Chrw6B6Td78aOg=;
  b=BXqXkUM0c8k1QnGZorelD7OAUum1woAyZjUkyShIkh3IuM/efQH20dDd
   2YqoTM1B3hi/jW98r7bnmr+fSgDGbPJD2CmEH9JU2GJf25kR+hx7Joy66
   qrwPBUZUI7EzBpqDMnrhCXSJlZlcfFGGunXv2ZqLxqes9DmW2OCCP9lWv
   hGi8UYNCP752F8/II+SNrmyLiLSa8+Eg/tE9AOTpe4iwLWZg9K8uxSVID
   6bD37PGUrxChZ2ZEKtGLgrPDZLSpizq4ns0eAK4SeMTLk8QkuNimevC/q
   vrHC66wCt7tVzFSMne8oUuN3jOfdzA1DJdIL+PiGFJWR4kAReRhSjW6nQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="345789353"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="345789353"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 07:14:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="894824785"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="894824785"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 15 Dec 2022 07:14:53 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p5pwj-0006MY-0k;
        Thu, 15 Dec 2022 15:14:53 +0000
Date:   Thu, 15 Dec 2022 23:14:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Michal Hocko <mhocko@suse.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] mm/mempolicy: do not duplicate policy if it is not
 applicable for set_mempolicy_home_node
Message-ID: <Y5s5zroPehFNAmTt@416bcb91c936>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5sz3Ax+tONdWgbN@dhcp22.suse.cz>
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
Subject: [PATCH] mm/mempolicy: do not duplicate policy if it is not applicable for set_mempolicy_home_node
Link: https://lore.kernel.org/stable/Y5sz3Ax%2BtONdWgbN%40dhcp22.suse.cz

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



