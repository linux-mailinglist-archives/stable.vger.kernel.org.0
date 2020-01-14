Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C666613A33E
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 09:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbgANIv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 03:51:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:4333 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbgANIv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 03:51:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2020 00:51:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,432,1571727600"; 
   d="scan'208";a="225161401"
Received: from unknown (HELO [10.238.129.140]) ([10.238.129.140])
  by orsmga003.jf.intel.com with ESMTP; 14 Jan 2020 00:51:23 -0800
Subject: Re: [PATCH 1/4] x86/resctrl: Fix use-after-free when deleting
 resource groups
To:     Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, pei.p.jia@intel.com,
        stable@vger.kernel.org, Xiaochen Shen <xiaochen.shen@intel.com>
References: <1578500886-21771-2-git-send-email-xiaochen.shen@intel.com>
 <20200109143629.C6C822077B@mail.kernel.org>
From:   Xiaochen Shen <xiaochen.shen@intel.com>
Message-ID: <33a88a00-56d3-3cd2-a0dc-0d97e5a7329a@intel.com>
Date:   Tue, 14 Jan 2020 16:51:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <20200109143629.C6C822077B@mail.kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

The backporting for v4.14.x and v4.19.x stable trees needs some manual
tweaking due to difference code bases (since x86/resctrl rename/re-arrange
in v5.0 upstream kernel).

I will work on the backporting once this patch is merged into upstream.

Thank you.

On 1/9/2020 22:36, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support").
> 
> The bot has tested the following trees: v5.4.8, v4.19.93, v4.14.162.
> 
> v5.4.8: Build OK!
> v4.19.93: Failed to apply! Possible dependencies:
>      Unable to calculate
> 
> v4.14.162: Failed to apply! Possible dependencies:
>      Unable to calculate
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 

-- 
Best regards,
Xiaochen
