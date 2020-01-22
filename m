Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94205144AC1
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 05:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAVEYr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 21 Jan 2020 23:24:47 -0500
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:9708 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgAVEYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 23:24:46 -0500
IronPort-SDR: zdBBn8Mc8BbmdeOMRbvKnvezZaN7hmvtLgjj0g0WTVhDnGp/42T8LIgF68nNznKyX/S0UJnwV5
 nM0QwXHm6jyxUu3ME7SHvxPrOoyuNQjXA+JBGCBxIi1NRH7X7cZlSrvMiVKpHJkRzHFwgIJhKU
 OTepdsnRzQ/Fr+TDlAHW7O1+dH8pJs0wovw9mm7Ayf3Nq5nJx0l+OWdata7fHCF3rVc17J8t3k
 tD7+18UEJzz2lR9tqN7eGHRRRtoWfwWRi1i3ck1F9ol/Ncekpg5weFG5bEVCHfMbQnYoI9VPm2
 Ic8=
X-IronPort-AV: E=Sophos;i="5.70,348,1574150400"; 
   d="scan'208";a="45086045"
Received: from orw-gwy-01-in.mentorg.com ([192.94.38.165])
  by esa3.mentor.iphmx.com with ESMTP; 21 Jan 2020 20:24:45 -0800
IronPort-SDR: 1PEYK0Zhd73ljmnQXNlsUnwuMU8WaqBa6fggtZyqC72aoeTP0V474YLaDlRblaRzDFKAY3rpIV
 GaY6B4Rr9C1A==
From:   "Kumar, Vipul" <Vipul_Kumar@mentor.com>
To:     Sasha Levin <sashal@kernel.org>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
Thread-Topic: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
Thread-Index: AQHV0GkRCJ8wkYwpdkWzqz5/BlatGKf2e/EA//+aBCA=
Date:   Wed, 22 Jan 2020 04:24:42 +0000
Message-ID: <a764bca368794eccbda39238d85da9ba@svr-orw-mbx-01.mgc.mentorg.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
 <20200122022619.B95C024655@mail.kernel.org>
In-Reply-To: <20200122022619.B95C024655@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [147.34.91.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

As this patch is based on commit f3a02ecebed7 ("x86/tsc: Set TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Atom SoCs") which was introduced in 4.14.

So, this patch is not applicable for kernel versions prior to 4.14.

As this patch is under review, can we put it on hold ?

Regards,
Vipul 

-----Original Message-----
From: Sasha Levin [mailto:sashal@kernel.org] 
Sent: 22 January 2020 07:56
To: Sasha Levin <sashal@kernel.org>; Vipul Kumar <vipulk0511@gmail.com>; Kumar, Vipul <Vipul_Kumar@mentor.com>; Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-kernel@vger.kernel.org; Stable <stable@vger.kernel.org>; stable@vger.kernel.org; stable@vger.kernel.org
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Bay Trail SoC

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.4.13, v4.19.97, v4.14.166, v4.9.210, v4.4.210.

v5.4.13: Build OK!
v4.19.97: Build OK!
v4.14.166: Build failed! Errors:

v4.9.210: Failed to apply! Possible dependencies:
    f3a02ecebed7 ("x86/tsc: Set TSC_KNOWN_FREQ and TSC_RELIABLE flags on Intel Atom SoCs")

v4.4.210: Failed to apply! Possible dependencies:
    0007bccc3cfd ("x86: Replace RDRAND forced-reseed with simple sanity check")
    07dc900e17a9 ("perf/x86: Move Kconfig.perf and other perf configuration bits to events/Kconfig")
    1b74dde7c47c ("x86/cpu: Convert printk(KERN_<LEVEL> ...) to pr_<level>(...)")
    218cfe4ed888 ("perf/x86: Move perf_event_amd_ibs.c ....... => x86/events/amd/ibs.c")
    39b0332a2158 ("perf/x86: Move perf_event_amd.c ........... => x86/events/amd/core.c")
    442f5c74cbea ("perf/x86: Use INST_RETIRED.TOTAL_CYCLES_PS for cycles:pp for Skylake")
    5b26547dd7fa ("perf/x86: Move perf_event_amd_iommu.[ch] .. => x86/events/amd/iommu.[ch]")
    724697648eec ("perf/x86: Use INST_RETIRED.PREC_DIST for cycles: ppp")
    e633c65a1d58 ("x86/perf/intel/uncore: Make the Intel uncore PMU driver modular")
    fa9cbf320e99 ("perf/x86: Move perf_event.c ............... => x86/events/core.c")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
