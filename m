Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E808858C1DF
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 04:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbiHHCvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 22:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiHHCvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 22:51:15 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6977C2BDC
        for <stable@vger.kernel.org>; Sun,  7 Aug 2022 19:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659927074; x=1691463074;
  h=subject:references:to:cc:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=eUzjeCcnxwqqbmx8ak3RyhYp10Cgjfyg7zy2LsmFviE=;
  b=Bz3FMdcNXfVdQIeh9LTxO+t/hXQcPKmTbWf1ZD5UYvgZH+eH/la3lse3
   HvhZVE6KOJfjAH0QTmURJgJK0TMEP6BNg4jVer+tLNZrMHkEyLlyQFfHw
   zldIm6bh8JQr//yCb3SZG4fUWmPRtEUJk/f2KJxWKw+kCZxS72QJjpT6Y
   b3x03rtS+eadWqnKikVktre6lyv0OQ9r87N4DHfMG+i1S43B257KZJGEq
   RViJCH4ZGq4Wr6EjPUbjNdenjRPMg0GT4VJesqrgTRAmvNIjyQX+QppIe
   39yDwX/WhWRJIlkzWJbMQ9gDJGbB25Cs6nJkr636bk/+DbRyLFEnxMjAT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="273536965"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="273536965"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 19:51:13 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="663739756"
Received: from rongch2-mobl.ccr.corp.intel.com (HELO [10.254.215.109]) ([10.254.215.109])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 19:51:11 -0700
Subject: Fwd: warning: stable kernel rule is not satisfied
References: <2364552d-9b18-875a-484a-d54ee8b9b9ee@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, lkp <lkp@intel.com>
From:   kernel test robot <rong.a.chen@intel.com>
X-Forwarded-Message-Id: <2364552d-9b18-875a-484a-d54ee8b9b9ee@intel.com>
Message-ID: <baf4e189-2302-ea9c-e905-4ebc33c1e937@intel.com>
Date:   Mon, 8 Aug 2022 10:51:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2364552d-9b18-875a-484a-d54ee8b9b9ee@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

Sorry to bother you, this is kernel test robot, we have sent some
reports related to the stable kernel rule, do you want to receive such
report? or any suggestion for us to improve it, or disable it?

Best Regards,
Rong Chen

-------- Forwarded Message --------
Subject: warning: stable kernel rule is not satisfied
<snip>

Hi,

Thanks for your patch.

FYI: kernel test robot notices the stable kernel rule is not satisfied.

Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'
Subject: [PATCH 5.10] block: fix null-deref in percpu_ref_put
Link: 
https://lore.kernel.org/stable/20220729065243.1786222-1-zhangwensheng%40huaweicloud.com

The check is based on 
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



