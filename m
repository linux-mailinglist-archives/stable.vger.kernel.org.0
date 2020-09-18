Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1A82702EA
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 19:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgIRRIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 13:08:37 -0400
Received: from foss.arm.com ([217.140.110.172]:49908 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgIRRIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Sep 2020 13:08:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D0DE30E;
        Fri, 18 Sep 2020 10:08:36 -0700 (PDT)
Received: from [10.57.51.251] (unknown [10.57.51.251])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FA3D3F73B;
        Fri, 18 Sep 2020 10:08:34 -0700 (PDT)
Subject: Re: [PATCH 03/19] arm64: Run ARCH_WORKAROUND_2 enabling code on all
 CPUs
To:     will@kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     catalin.marinas@arm.com, dbrazdil@google.com, maz@kernel.org,
        stable@vger.kernel.org
References: <20200918164729.31994-1-will@kernel.org>
 <20200918164729.31994-4-will@kernel.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <8b7efd54-af13-f7ec-615b-991f76412358@arm.com>
Date:   Fri, 18 Sep 2020 18:13:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200918164729.31994-4-will@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/18/2020 05:47 PM, Will Deacon wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> Commit 606f8e7b27bf ("arm64: capabilities: Use linear array for
> detection and verification") changed the way we deal with per-CPU errata
> by only calling the .matches() callback until one CPU is found to be
> affected. At this point, .matches() stop being called, and .cpu_enable()
> will be called on all CPUs.
> 
> This breaks the ARCH_WORKAROUND_2 handling, as only a single CPU will be
> mitigated.
> 
> In order to address this, forcefully call the .matches() callback from a
> .cpu_enable() callback, which brings us back to the original behaviour.
> 
> Fixes: 606f8e7b27bf ("arm64: capabilities: Use linear array for detection and verification")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
