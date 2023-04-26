Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577136EF97F
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 19:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbjDZRgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 13:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbjDZRgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 13:36:37 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBCDBE
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 10:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682530597; x=1714066597;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=tezNWOvQJSSxdI7I83KAUWXgOP6teNa3hTONMUyH7aI=;
  b=H1Ry13YyHR7gnnzdGmZbuhW6TbzOTATDOEnxgZGzA3sNPij+yljPDuNs
   eOaMpzDcip9j9y2M74gt02BAJIJbZtt31vObBnxtlZXp5Cbq7WyrsQJiI
   bj7I9DhmL7tMTWErxaaxdiEEuQPSq+J1uf6tEEFsWG8qIlByooCV2Vh7j
   yKJEgEcFfYoDQRnS5y8i6HS7d5fS3Xu5XF7/4lCeidFq257EshmRRLfhr
   8pX0lC3orWOmt9Yijy/jEb+A5Cv2clEfF0vz6Nh03C+MhRgeuja/b+XQO
   1cAiiZs7nwiEz0R0Mi723eFOnfKffKZKjs8a5wbrvAe+2iQ/oTKzkrViP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="326789113"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="326789113"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 10:34:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="1023717610"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="1023717610"
Received: from lkp-server01.sh.intel.com (HELO 041f065c1b1b) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 26 Apr 2023 10:34:47 -0700
Received: from kbuild by 041f065c1b1b with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1prj2U-0000PG-1P;
        Wed, 26 Apr 2023 17:34:46 +0000
Date:   Thu, 27 Apr 2023 01:34:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [net v2] net: ethernet: mtk_eth_soc: drop generic vlan rx
 offload, only use DSA untagging
Message-ID: <ZElgif1TKL9cMVOk@afc780e125e2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426172153.8352-1-linux@fw-web.de>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
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
Subject: [net v2] net: ethernet: mtk_eth_soc: drop generic vlan rx offload, only use DSA untagging
Link: https://lore.kernel.org/stable/20230426172153.8352-1-linux%40fw-web.de

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



