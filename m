Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAABE145BA1
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 19:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgAVSjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 13:39:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:25823 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgAVSjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 13:39:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2020 10:39:04 -0800
X-IronPort-AV: E=Sophos;i="5.70,350,1574150400"; 
   d="scan'208";a="229452297"
Received: from rchatre-mobl.amr.corp.intel.com (HELO [10.251.27.52]) ([10.251.27.52])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 22 Jan 2020 10:39:03 -0800
Subject: Re: [tip: x86/urgent] x86/resctrl: Fix a deadlock due to inaccurate
 reference
To:     Sasha Levin <sashal@kernel.org>,
        tip-bot2 for Xiaochen Shen <tip-bot2@linutronix.de>,
        linux-tip-commits@vger.kernel.org,
        Xiaochen Shen <xiaochen.shen@intel.com>
Cc:     stable@vger.kernel.org
References: <157953883190.396.13475989556891199147.tip-bot2@tip-bot2>
 <20200122022624.4118C2465B@mail.kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <f43803d4-0a66-386a-7ac4-cc9bee249c0a@intel.com>
Date:   Wed, 22 Jan 2020 10:39:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200122022624.4118C2465B@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Xiaochen (author of the patch)

On 1/21/2020 6:26 PM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: c7d9aac61311 ("x86/intel_rdt/cqm: Add mkdir support for RDT monitoring").
> 
> The bot has tested the following trees: v5.4.13, v4.19.97, v4.14.166.
> 
> v5.4.13: Build OK!
> v4.19.97: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> v4.14.166: Failed to apply! Possible dependencies:
>     cfd0f34e4cd5 ("x86/intel_rdt: Add diagnostics when making directories")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
