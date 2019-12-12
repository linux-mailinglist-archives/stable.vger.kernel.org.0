Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8638E11D11C
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 16:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfLLPfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 10:35:13 -0500
Received: from foss.arm.com ([217.140.110.172]:50940 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729262AbfLLPfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Dec 2019 10:35:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EA8E30E;
        Thu, 12 Dec 2019 07:35:13 -0800 (PST)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E79DB3F6CF;
        Thu, 12 Dec 2019 07:35:11 -0800 (PST)
Subject: Re: [PATCH 1/3] KVM: arm/arm64: Properly handle faulting of device
 mappings
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        stable@vger.kernel.org
References: <20191211165651.7889-1-maz@kernel.org>
 <20191211165651.7889-2-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <98c0018d-1a32-c775-04c2-36440221709e@arm.com>
Date:   Thu, 12 Dec 2019 15:35:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191211165651.7889-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 11/12/2019 16:56, Marc Zyngier wrote:
> A device mapping is normally always mapped at Stage-2, since there
> is very little gain in having it faulted in.
> 
> Nonetheless, it is possible to end-up in a situation where the device
> mapping has been removed from Stage-2 (userspace munmaped the VFIO
> region, and the MMU notifier did its job), but present in a userspace
> mapping (userpace has mapped it back at the same address). In such
> a situation, the device mapping will be demand-paged as the guest
> performs memory accesses.
> 
> This requires to be careful when dealing with mapping size, cache
> management, and to handle potential execution of a device mapping.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
