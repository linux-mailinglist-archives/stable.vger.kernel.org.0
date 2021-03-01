Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2623E327E38
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhCAMXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:23:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:44472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234111AbhCAMX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 07:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA00664E41;
        Mon,  1 Mar 2021 12:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614601368;
        bh=4yWe+5hkSngpWJ3aj8NWz5F8YvmcERdGrEWtPcHl/bM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sP8t6O+7yAG+dsNGhYnj/Qmg9L4qw4++/ZhFgTAz1CvSYBgHiSPWTKzQwHwAoAx5i
         58H7jfBw1WLqzPWMmrXHw5vmj8IkXVXYk2VNQjxu0G0XS3xSmG4DgOPUBQA8GdGjst
         XDvWud+9NAKQNe8TGSMp9SrmdoNMqHw+RBPXYGXQ=
Date:   Mon, 1 Mar 2021 13:22:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     stable@vger.kernel.org, mathieu.poirier@linaro.org,
        mike.leach@linaro.org, leo.yan@linaro.org
Subject: Re: [PATCH] coresight: etm4x: Handle accesses to TRCSTALLCTLR
Message-ID: <YDzcldkQsU1BfZmL@kroah.com>
References: <161452028074223@kroah.com>
 <20210301121549.2994673-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301121549.2994673-1-suzuki.poulose@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 01, 2021 at 12:15:49PM +0000, Suzuki K Poulose wrote:
> commit f72896063396b0cb205cbf0fd76ec6ab3ca11c8a upstream
> 
> TRCSTALLCTLR register is only implemented if
> 
>    TRCIDR3.STALLCTL == 0b1
> 
> Make sure the driver touches the register only it is implemented.
> 
> Link: https://lore.kernel.org/r/20210127184617.3684379-1-suzuki.poulose@arm.com
> Cc: stable@vger.kernel.org # v5.11-
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Mike Leach <mike.leach@linaro.org>
> Cc: Leo Yan <leo.yan@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  drivers/hwtracing/coresight/coresight-etm4x-core.c  | 9 ++++++---
>  drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 2 +-
>  2 files changed, 7 insertions(+), 4 deletions(-)

Now queued up to 5.10.y and 5.11.y, thanks.

greg k-h
