Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492C6162EEC
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgBRSn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:43:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbgBRSn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 13:43:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B49D21D56;
        Tue, 18 Feb 2020 18:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582051437;
        bh=aTM86BoyrTwzruHENYmelIh0HzLGd9t+clXn5N5NwmU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aeSF1kbpSuMsqrTZUpJzF+HqiFCrZm5kUT9u57IYv1q39pXmT+2BrqVI2hf5DKLXA
         epCfw1GrXEu6qEY5A5zKMtJbwO7H29wZ9a8h3Kls71uSiVYmpwc6GbGjJMXnQRfjij
         35R+hM6tCfRbjenUY/talvCHn83IQagI4rKaIhpM=
Date:   Tue, 18 Feb 2020 19:43:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org, robdclark@gmail.com,
        bjorn.andersson@linaro.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>,
        Will Deacon <will@kernel.org>, joro@8bytes.org,
        masneyb@onstation.org, lkft-triage@lists.linaro.org,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: drivers/iommu/qcom_iommu.c:348 qcom_iommu_domain_free+0x5c/0x70
Message-ID: <20200218184355.GA2667975@kroah.com>
References: <CA+G9fYtScOpkLvx=__gP903uJ2v87RwZgkAuL6RpF9_DTDs9Zw@mail.gmail.com>
 <20200218182359.GC2635524@kroah.com>
 <19d57dfd-12df-9237-3576-32b0feef90fa@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19d57dfd-12df-9237-3576-32b0feef90fa@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 06:31:51PM +0000, Robin Murphy wrote:
> On 18/02/2020 6:23 pm, Greg Kroah-Hartman wrote:
> [...]
> > Can you bisect to find the offending commit?
> 
> This particular presentation appears to be down to the DRM driver starting
> to call of_platform_depopulate(), but it's merely exposing badness in the
> IOMMU driver that's been there from day 1. I just sent a fix for that[1].
> 
> Robin.
> 
> [1] https://lore.kernel.org/linux-iommu/be92829c6e5467634b109add002351e6cf9e18d2.1582049382.git.robin.murphy@arm.com/

Can you also add a cc: stable tag to it so that I know to pick it up?

thanks,

greg k-h
