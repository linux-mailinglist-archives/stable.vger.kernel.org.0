Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A485FE1B0
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJMSoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiJMSnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:43:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A7E2734
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 11:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665686476; x=1697222476;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=fhSv9E4eQptTHg9jvWExwmtIWbcZtU/l990iC19WMxQ=;
  b=G0kHVuF3yBclVdBPPU6kFCkLN35N4S/53fKF2hCXo+oH4PAUp7sAjmDJ
   KmePweC/WQ2QcT/hCx2IMKtX1UpczhOCPSit/GfXF6+Tb0ImamA6EQDgS
   alQft4AU0RXH+pB1GSDCRnXMZyW4sMTNyoSkUty+onXl+fpo+dWp6ELhJ
   TLDyo8au/7/G8QZ/ErvdlOzWS/8wQqjFb8pJo0FtLliBxjZghwu9GsFT2
   DnbmMkd/drxd7Q9/kar23+ifXUzaWqh6Qm77wXy1t5raR+3N7EvhXROOh
   bdpEPVdyEteXXpBlj5SDEW5TpyxU/yPj3U8gG24k54dXBpvNVfuexZRWP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="305164322"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="305164322"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 11:40:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10499"; a="605090633"
X-IronPort-AV: E=Sophos;i="5.95,182,1661842800"; 
   d="scan'208";a="605090633"
Received: from lkp-server01.sh.intel.com (HELO 2af0a69ca4e0) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 13 Oct 2022 11:40:15 -0700
Received: from kbuild by 2af0a69ca4e0 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oj37v-0005Sp-0Y;
        Thu, 13 Oct 2022 18:40:15 +0000
Date:   Fri, 14 Oct 2022 02:39:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable@vger.kernel.org, kbuild-all@lists.01.org
Subject: Re: [PATCH] Documentation: process: update the list of current LTS
Message-ID: <Y0hbbdOZuAqIoUd9@6594fa6d681d>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013183414.667316-1-ndesaulniers@google.com>
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
Subject: [PATCH] Documentation: process: update the list of current LTS
Link: https://lore.kernel.org/stable/20221013183414.667316-1-ndesaulniers%40google.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



