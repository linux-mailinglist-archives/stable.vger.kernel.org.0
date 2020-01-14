Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88D313A399
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 10:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgANJR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 04:17:29 -0500
Received: from mga12.intel.com ([192.55.52.136]:59465 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgANJR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 04:17:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 01:17:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,432,1571727600"; 
   d="scan'208";a="225168169"
Received: from unknown (HELO [10.238.129.140]) ([10.238.129.140])
  by orsmga003.jf.intel.com with ESMTP; 14 Jan 2020 01:17:26 -0800
Subject: Re: [PATCH 3/4] x86/resctrl: Fix a deadlock due to inaccurate active
 reference of kernfs node
To:     Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, pei.p.jia@intel.com,
        stable@vger.kernel.org, Xiaochen Shen <xiaochen.shen@intel.com>
References: <1578500886-21771-4-git-send-email-xiaochen.shen@intel.com>
 <20200109143630.DD673206ED@mail.kernel.org>
From:   Xiaochen Shen <xiaochen.shen@intel.com>
Message-ID: <9a9ab238-604c-0c1f-f168-dd27ba89e989@intel.com>
Date:   Tue, 14 Jan 2020 17:17:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <20200109143630.DD673206ED@mail.kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

The backporting for v4.14.x stable tree needs some manual tweaking due to
difference code bases:
1. x86/resctrl rename/re-arrange in v5.0 upstream kernel.
2. Code change in upstream commit cfd0f34e4cd5 ("x86/intel_rdt: Add
diagnostics when making directories").

The backporting for v4.19.x stable tree needs some manual tweaking due to
difference code bases: x86/resctrl rename/re-arrange in v5.0 upstream
kernel.

I will work on the backporting once this patch is merged into upstream.

Thank you.

On 1/9/2020 22:36, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: c7d9aac61311 ("x86/intel_rdt/cqm: Add mkdir support for RDT monitoring").
> 
> The bot has tested the following trees: v5.4.8, v4.19.93, v4.14.162.
> 
> v5.4.8: Build OK!
> v4.19.93: Failed to apply! Possible dependencies:
>      Unable to calculate
> 
> v4.14.162: Failed to apply! Possible dependencies:
>      cfd0f34e4cd5 ("x86/intel_rdt: Add diagnostics when making directories")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 

-- 
Best regards,
Xiaochen
