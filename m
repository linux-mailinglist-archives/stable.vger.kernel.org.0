Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49866AF5B4
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjCGTcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbjCGTbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:31:49 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D1A17CD1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678216650; x=1709752650;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=c1QNheMEc+8ictDdrPPyd0g3rP2K3ib+CJ+USnee4pE=;
  b=gagqnXgVLQ2k9DD2ze+WJ/NXMGf5OpKbgvkw/vGkvs0KiRBEaP1MTBRt
   vgyRJGjrrsc5quMLLlEou4oEzwJmRFbIwJ20VgqONxm9HWs06vwPEN/qD
   3OyKzY4y75nyZUDeARysi3roTexShdcXN07SRc0+UZEWOP9tXcXWXC06m
   ZZw/rqZg/94nVfJLGVxHdxNQFtRPr4VDRD5ffduhydvaMnfm1UTEBvJgu
   pU8uf00EUKkm91+pi/rgzvnXGHpcEPVHJaXrI0RCTOiR2OWvSZFV5Y9BF
   8Zxcwyw8Mo0vJgfVvUUn/sJROpXogge+AK31PZg3W6mxBvfftuJaMjPeV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="337469145"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="337469145"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 11:17:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="1006005190"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="1006005190"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 07 Mar 2023 11:17:16 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pZcoG-0001Xf-0E;
        Tue, 07 Mar 2023 19:17:16 +0000
Date:   Wed, 8 Mar 2023 03:17:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.15 01/11] xfs: use setattr_copy to set vfs inode
 attributes
Message-ID: <ZAeNryzk82WHn1C2@0f0c699f4fc0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307185922.125907-2-leah.rumancik@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Subject: [PATCH 5.15 01/11] xfs: use setattr_copy to set vfs inode attributes
Link: https://lore.kernel.org/stable/20230307185922.125907-2-leah.rumancik%40gmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



