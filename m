Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9F66924E8
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 18:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjBJR4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 12:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjBJR4o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 12:56:44 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F4274041
        for <stable@vger.kernel.org>; Fri, 10 Feb 2023 09:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676051803; x=1707587803;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=oDIoxmB1lXhyFQ8ndOeiDuORyfzib2k06uLgAX8FadQ=;
  b=ERPlXydadVj5xTRiftOJ8LWHlKH1jRnkJKlJiGIGuM0gJkA2DANHaoU6
   XgnV8K+iq6MneMc6vsO1+vPMPmtcaqUcKjNiqgR9QiwuhpI7kyrco6gqg
   LsjpaYjp0GhVyGDnULUPZrQCV62c6eP3J3BTwJqlM/K/B7IepF8tr+R+w
   9ZRkXJYki4nEA5gu5EW5gY9AEh5c1qtlrp5+QcwFVFDuofsZZn3PXEdX4
   zq6rTSJ2hjG4Zf2s+cb87mavCNHdeAxuUtEqVtr6SEMgg8E49msr2IJCH
   EijHAnNlSQ12Ki+PrK+ZmIlKDD+ZCmXUTNEeJdhSOLwAolqNJGgShnEh8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="328175083"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="328175083"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 09:56:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="777016033"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="777016033"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 10 Feb 2023 09:56:42 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pQXdZ-0005xF-2S;
        Fri, 10 Feb 2023 17:56:41 +0000
Date:   Sat, 11 Feb 2023 01:56:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alok Tiwari <alok.a.tiwari@oracle.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] scsi: target: core: Added a blank line after
 target_remove_from_tmr_list()
Message-ID: <Y+aFVRXuSX+/3HHX@a5b9dd7d9a79>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210175521.1469826-1-alok.a.tiwari@oracle.com>
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
Subject: [PATCH] scsi: target: core: Added a blank line after target_remove_from_tmr_list()
Link: https://lore.kernel.org/stable/20230210175521.1469826-1-alok.a.tiwari%40oracle.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



