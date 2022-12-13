Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A699A64B780
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 15:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235639AbiLMOhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 09:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiLMOhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 09:37:07 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC8B13D56
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 06:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670942226; x=1702478226;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=xgNrKtjkuBXAdoSYd0SQ7z78QUyYjWn3p6n80iFjMUc=;
  b=JypLC2qhG2gfkNNwjcacu0U/zU1JVeprMJAhV/g/sPWHTqqkNUNd1T4J
   2SbL1uq1C26yfpDBUmsL2yHFoYhTGUUnoTq1EtBcPB3PDW5qa6nxyCTeT
   B8MqUj3Oo7roYiddPbObJwHXIlHcpRXiiKWRFVy6lNZTiiM0GrfxyI/ur
   G9GDNn47Q9nIJcQpsf1ZQTHxvr1UuteRXRRWun9ALl+2I0VmK2YdPYrir
   SfXtRu3D3SgzWwbRdJcb/rOrYIn+idSVPR4U7w/Xsf8UCn8EkfZDSZLsr
   A7UVCFFZQ+8Bp25GeNE9vx5+9YG/WAR/SKw8Lrq3h7AudxEop60XfgUjH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="301559934"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="301559934"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 06:37:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="650726061"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="650726061"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 13 Dec 2022 06:37:02 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p56Oz-0004Qn-1H;
        Tue, 13 Dec 2022 14:37:01 +0000
Date:   Tue, 13 Dec 2022 22:36:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v2 2/2] media: uvcvideo: Do not alloc dev->status
Message-ID: <Y5iOCG8fSyuaFdfz@0d7994225921>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212-uvc-race-v2-2-54496cc3b8ab@chromium.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH v2 2/2] media: uvcvideo: Do not alloc dev->status
Link: https://lore.kernel.org/stable/20221212-uvc-race-v2-2-54496cc3b8ab%40chromium.org

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



