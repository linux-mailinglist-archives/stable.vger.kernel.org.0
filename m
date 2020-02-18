Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACB4162E9B
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgBRSbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:31:55 -0500
Received: from foss.arm.com ([217.140.110.172]:58546 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgBRSbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 13:31:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 843CF31B;
        Tue, 18 Feb 2020 10:31:54 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98D963F68F;
        Tue, 18 Feb 2020 10:31:52 -0800 (PST)
Subject: Re: drivers/iommu/qcom_iommu.c:348 qcom_iommu_domain_free+0x5c/0x70
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Sasha Levin <sashal@kernel.org>, iommu@lists.linux-foundation.org,
        robdclark@gmail.com, bjorn.andersson@linaro.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>,
        Will Deacon <will@kernel.org>, joro@8bytes.org,
        masneyb@onstation.org, lkft-triage@lists.linaro.org,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
References: <CA+G9fYtScOpkLvx=__gP903uJ2v87RwZgkAuL6RpF9_DTDs9Zw@mail.gmail.com>
 <20200218182359.GC2635524@kroah.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <19d57dfd-12df-9237-3576-32b0feef90fa@arm.com>
Date:   Tue, 18 Feb 2020 18:31:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200218182359.GC2635524@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/02/2020 6:23 pm, Greg Kroah-Hartman wrote:
[...]
> Can you bisect to find the offending commit?

This particular presentation appears to be down to the DRM driver 
starting to call of_platform_depopulate(), but it's merely exposing 
badness in the IOMMU driver that's been there from day 1. I just sent a 
fix for that[1].

Robin.

[1] 
https://lore.kernel.org/linux-iommu/be92829c6e5467634b109add002351e6cf9e18d2.1582049382.git.robin.murphy@arm.com/
