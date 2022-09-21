Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB455BF3DC
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 04:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiIUCuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 22:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiIUCui (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 22:50:38 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0C16F55B
        for <stable@vger.kernel.org>; Tue, 20 Sep 2022 19:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663728630; x=1695264630;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UJKeT+rGrn3fh6xI+4XGfUnq9lL3lT3rg8jN+yT5b70=;
  b=FAbheh+fdix5wemtODVPE5mcr8swgALoXOAU9CypArcBYQo6azJCCmIc
   LvH27fhtczZ/P0GgfO1IDTGiDob0ZgyrYYtDD+G4EE6dlQMBPJMnFK9Zm
   oLO2+fKriNn7y4bNeB20+Xwkl2U2QaDTh+ysZCz6FD1Md7YTBW9YjCChE
   7n5Rwj1iQyxnHUP4p5ZoQjvMOJnPuUfTKoL4pJrzdeMVGfj63S2GCi68w
   y8g0VHbvYDGH/pvkJdV6h2T7NnD2+zI12nqyVSS7QLKxlpocZlA6GD1ah
   Kp6sUG4arBbOJXglhwxJ8PXcI7NOosq3KyguYAqDUWIqAlJJF4j3KwZ+E
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="361637125"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="361637125"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 19:50:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="794501084"
Received: from allen-box.sh.intel.com (HELO [10.239.159.48]) ([10.239.159.48])
  by orsmga005.jf.intel.com with ESMTP; 20 Sep 2022 19:50:26 -0700
Message-ID: <a5f2141a-d819-20de-1e6c-b9e93323998a@linux.intel.com>
Date:   Wed, 21 Sep 2022 10:44:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Cc:     baolu.lu@linux.intel.com, kevin.tian@intel.com, baolu.lu@intel.com,
        raghunathan.srinivasan@intel.com, iommu@lists.linux.dev,
        joro@8bytes.org, will@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu/vt-d: Check correct capability for sagaw
 determination
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>
References: <20220916071212.2223869-1-yi.l.liu@intel.com>
 <20220916071212.2223869-2-yi.l.liu@intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220916071212.2223869-2-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/22 3:12 PM, Yi Liu wrote:
> Check 5-level paging capability for 57 bits address width instead of
> checking 1GB large page capability.
> 
> Fixes: 53fc7ad6edf2 ("iommu/vt-d: Correctly calculate sagaw value of IOMMU")
> Cc:stable@vger.kernel.org
> Reported-by: Raghunathan Srinivasan<raghunathan.srinivasan@intel.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>

Queued for v6.0. Thank you very much!

https://lore.kernel.org/linux-iommu/20220921024054.3570256-1-baolu.lu@linux.intel.com

Best regards,
baolu
