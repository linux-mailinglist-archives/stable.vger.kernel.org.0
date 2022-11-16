Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FA562CEFC
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 00:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbiKPXo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 18:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKPXoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 18:44:10 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129664AF2A
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 15:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668642207; x=1700178207;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=4Kh6cLtmynoO8BaixKVKNVbQ9E+XiqqFGfNCWz531q8=;
  b=QhUVr/1g7t/sS6o6Fe1LUEIq3RTLag/cML+wxaxrf2H/6MH2EQUNWT6G
   Hu69hiZL06PV/RE+jOyJ2DqGWZ6lncLAlYXKlOdj5f9KC9+ASpMaeaClC
   xqTkR64zn28i0Z35cM73df9rxnaYOhdQxwC3eSL5Kq0Vx2XzawDHM58C4
   LiVY87OFbdPafWeIOMYfh12d9PN9Ju8fToqeK76EviYINGuEK5DyDyTzf
   SstDDtHHNZkwnoRgt0ZEBb7fH7wNx7PyQBbr9BObXrFJ/B2oV2D2j6lm9
   qDwTw5TI5KWDMmFU/kfcTdtihCwW+XiNDyyuIRas6+p+JzFhpe2VJBJPE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="376967380"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="376967380"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:43:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="884611284"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="884611284"
Received: from lkp-server01.sh.intel.com (HELO ebd99836cbe0) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 16 Nov 2022 15:43:24 -0800
Received: from kbuild by ebd99836cbe0 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ovS3v-0002qv-2d;
        Wed, 16 Nov 2022 23:43:23 +0000
Date:   Thu, 17 Nov 2022 07:42:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vishal Verma <vishal.l.verma@intel.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2 1/2] ACPI: HMAT: remove unnecessary variable
 initialization
Message-ID: <Y3V1bPPwd2EAiumA@34289d8193f4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116-acpi_hmat_fix-v2-1-3712569be691@intel.com>
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
Subject: [PATCH v2 1/2] ACPI: HMAT: remove unnecessary variable initialization
Link: https://lore.kernel.org/stable/20221116-acpi_hmat_fix-v2-1-3712569be691%40intel.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



