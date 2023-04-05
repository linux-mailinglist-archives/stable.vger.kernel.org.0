Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8AF6D7A9C
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 13:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbjDELD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 07:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237226AbjDELD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 07:03:27 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F7B2720
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 04:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680692604; x=1712228604;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=+hLliYYIonZIdon8qWdGM0W8gjGNtAs0W2oC7Td2RNQ=;
  b=C/2/4H5wUqRChJdENZwJbqzzEYhgc0yAuJx22nrf/pX2can+sqEbyAfg
   8DimrJzcFlFXA+HC9Bn2jtmbVq3qOcTK4OEHOyp8hIPG9utJcHOJtfJR4
   PK3AQ/uZQ1VuNMqJ19FuGkYGycBEQ/bz+jfifAnj6VHcvCsf2NUsr38QT
   HFCSAZUx9yrQ57Uj8avR5Assa6SOOej4hJxST+/jx/ZN4JR3OxVDSQ9HA
   W/NhH65MAxmTWPupIn8NJow1QW0Q430cpFNs0diZEJcaBen+SWFhwPNfk
   MRX+6NGY/KndYrltCo0TWfH9Q4nS52IeTiQq/Z5c4ThfTZxuYlvJ57JYn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="322802993"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="322802993"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 04:03:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="797874121"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="797874121"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 05 Apr 2023 04:03:09 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pk0uz-000QU8-0z;
        Wed, 05 Apr 2023 11:03:09 +0000
Date:   Wed, 5 Apr 2023 19:02:26 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shaun Tancheff <shaun.tancheff@gmail.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] memcg-v1: Enable setting memory min, low, high
Message-ID: <ZC1VQvSSAeF7AXlE@ec83ac1404bb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405110107.127156-1-shaun.tancheff@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH] memcg-v1: Enable setting memory min, low, high
Link: https://lore.kernel.org/stable/20230405110107.127156-1-shaun.tancheff%40gmail.com

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



