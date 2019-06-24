Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9736351BA2
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 21:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfFXTs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 15:48:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:53989 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbfFXTs4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 15:48:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jun 2019 12:48:56 -0700
X-IronPort-AV: E=Sophos;i="5.63,413,1557212400"; 
   d="scan'208";a="172096113"
Received: from rchatre-mobl.amr.corp.intel.com (HELO [10.24.14.145]) ([10.24.14.145])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 24 Jun 2019 12:48:56 -0700
Subject: Re: [PATCH] x86/resctrl: Prevent possible overrun during bitmap
 operations
To:     Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        fenghua.yu@intel.com, bp@alien8.de
Cc:     mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        stable@vger.kernel.org
References: <58c9b6081fd9bf599af0dfc01a6fdd335768efef.1560975645.git.reinette.chatre@intel.com>
 <20190622181348.648872084E@mail.kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <978e4571-7e77-8318-7ff7-efcb90d8366f@intel.com>
Date:   Mon, 24 Jun 2019 12:48:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190622181348.648872084E@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 6/22/2019 11:13 AM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: e651901187ab x86/intel_rdt: Introduce "bit_usage" to display cache allocations details.
> 
> The bot has tested the following trees: v5.1.12, v4.19.53.
> 
> v5.1.12: Build OK!
> v4.19.53: Failed to apply! Possible dependencies:
>     Unable to calculate
> 
> 
> How should we proceed with this patch?

The files modified in this patch moved after v4.19. I can send an
updated patch for v4.19 stable but will wait until the original is
merged into Linus's tree to ensure the commit ids referenced are accurate.

Reinette
