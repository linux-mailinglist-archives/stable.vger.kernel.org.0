Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381DB6D1F4D
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 13:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjCaLkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 07:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCaLkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 07:40:21 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587921FD37
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 04:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680262796; x=1711798796;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=A2WCIv0h0Li4tUFo4QJWBvEpuFk/Geg5LR36AGQ94lo=;
  b=Nc6SGbesZchiObaE+D1+3DinrkqS4mBKn+vkzXY6jEkI/qJs7y6qp7hC
   sQ8xjo4fk+4bs36atWJlVCRQNepWLN3cQJsb8ul4dKOJHxoPyD6/8rgGM
   a8CL9028Ly/h0dHEYOR4C7UDa0yEjQYdea7hAJbbX3x7/DnoiogaGqYVE
   B3JgGhvh2IZNF/cKT+t/YdhlWcI/+OOi2b10Ri6fn0HRMoqJ6492Bw7gH
   w8IuMhILDkHLAMzuCUjvw12HISMyhErCooGfPlwphVaZhPGI4/C7OhBjV
   K2Fj6Qx8uBpxE+c7HXEz7P59ZBG1DfE2iwNJ2EUP54vmnqTuWfPFGb6eN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="427710263"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="427710263"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2023 04:39:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10665"; a="662389713"
X-IronPort-AV: E=Sophos;i="5.98,307,1673942400"; 
   d="scan'208";a="662389713"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 31 Mar 2023 04:39:34 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1piD6T-000Lja-31;
        Fri, 31 Mar 2023 11:39:33 +0000
Date:   Fri, 31 Mar 2023 19:39:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jianmin Lv <lvjianmin@loongson.cn>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH V2 3/5] irqchip/loongson-eiointc: Fix registration of
 syscore_ops
Message-ID: <ZCbGdDxFyQo2jweI@ec83ac1404bb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331113900.9105-4-lvjianmin@loongson.cn>
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
Subject: [PATCH V2 3/5] irqchip/loongson-eiointc: Fix registration of syscore_ops
Link: https://lore.kernel.org/stable/20230331113900.9105-4-lvjianmin%40loongson.cn

The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests



