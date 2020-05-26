Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1EC1E1866
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 02:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgEZARU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 20:17:20 -0400
Received: from mga04.intel.com ([192.55.52.120]:61430 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725969AbgEZARU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 20:17:20 -0400
IronPort-SDR: GalxOJCdaE2DWrXilvJyY/N++fjHLHDCjq0fc9xVN0324uLRJuzQ4T1Pw61pQRDdEWHOOL2ijn
 gzxZjXt+yLdA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 17:17:20 -0700
IronPort-SDR: ME2WbtH9ZDsUff+VQqn4Ba4oRZJesRkYnmb9m7xVmoLzaVzdgtvA+U6Mg0uCT+N+geDo6AxS+B
 xnRHu4AsEsVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,435,1583222400"; 
   d="scan'208";a="468102854"
Received: from xwang29-mobl.ccr.corp.intel.com (HELO [10.255.31.23]) ([10.255.31.23])
  by fmsmga005.fm.intel.com with ESMTP; 25 May 2020 17:17:19 -0700
Subject: Re: 2 kvm tests failed on v4.19 stable
From:   kernel test robot <yidingx.liu@intel.com>
To:     stable@vger.kernel.org
Cc:     "Li, Philip" <philip.li@intel.com>
References: <2de6a643-a6f5-8433-76c9-88e8fb0ab069@intel.com>
Message-ID: <04f35d3c-495d-aec4-7de6-ba4f2df6e1b4@intel.com>
Date:   Tue, 26 May 2020 08:16:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <2de6a643-a6f5-8433-76c9-88e8fb0ab069@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 5/25/20 10:14 AM, kernel test robot wrote:
> Hi, all.
>
> We noticed that below 2 tests passed on linux/master v5.7-rc6 but 
> failed on v4.19 stable.
>
> Maybe we should do a backport. ;-)
>
> Test on v4.19.124
>
> ```
>
> selftests: kvm: platform_info_test
> ========================================
> ==== Test Assertion Failure ====
>   platform_info_test.c:58: run->exit_reason == KVM_EXIT_IO
>   pid=6803 tid=6803 - Success
>      1  0x000055698f76829a: ?? ??:0
>      2  0x00007fc894fb0e0a: ?? ??:0
>      3  0x000055698f768409: ?? ??:0
>   Exit_reason other than KVM_EXIT_IO: 8 (SHUTDOWN),
>
> not ok 1..1 selftests: kvm: platform_info_test [FAIL]
>
> selftests: kvm: sync_regs_test
> ========================================
> ==== Test Assertion Failure ====
>   sync_regs_test.c:138: run->exit_reason == KVM_EXIT_IO
>   pid=6828 tid=6828 - Invalid argument
>      1  0x000055f54209140d: ?? ??:0
>      2  0x00007fc4675fae0a: ?? ??:0
>      3  0x000055f5420918e9: ?? ??:0
>   Unexpected exit reason: 8 (SHUTDOWN),
>
> not ok 1..3 selftests: kvm: sync_regs_test [FAIL]
>
> ```
>
> If you fix the issue, kindly add following tag
>
> Reported-by: kernel test robot <lkp@intel.com>
>
-- 
Best regards.
Liu Yiding

