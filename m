Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1269601C9
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 09:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfGEHwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 03:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbfGEHwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jul 2019 03:52:44 -0400
Received: from localhost (unknown [122.167.76.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7C23218BC;
        Fri,  5 Jul 2019 07:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562313163;
        bh=sGsMo32UVw8Di9Jyj88e7Hy+JqyP8yaKWl3j6/DAklU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IBuV2J+/X9w5ItEQfBpdv+PDrQrTDmz/Nj0ie+AdJnshP4tvn9GJeeeu84BfSIXbK
         eE8t4k0+W6rjkjsegnPIbImjO7Sz+OPuOsrqXaGPYDgrEyaaMsTnUe6IPO59Y7Q2GF
         a1z9ckXsqsD9IzTs2vEeUOqTRXS/hW6BGAdZxduY=
Date:   Fri, 5 Jul 2019 13:19:27 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Sricharan R <sricharan@codeaurora.org>
Cc:     agross@kernel.org, david.brown@linaro.org,
        dan.j.williams@intel.com, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom: bam_dma: Fix completed descriptors count
Message-ID: <20190705074927.GC2911@vkoul-mobl>
References: <1561723786-22500-1-git-send-email-sricharan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561723786-22500-1-git-send-email-sricharan@codeaurora.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28-06-19, 17:39, Sricharan R wrote:
> One space is left unused in circular FIFO to differentiate
> 'full' and 'empty' cases. So take that in to account while
> counting for the descriptors completed.
> 
> Fixes the issue reported here,
> 	https://lkml.org/lkml/2019/6/18/669

Applied, thanks

-- 
~Vinod
