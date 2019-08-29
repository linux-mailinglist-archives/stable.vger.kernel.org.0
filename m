Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B079A2A85
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 01:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfH2XGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 19:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfH2XGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 19:06:14 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16AB52166E;
        Thu, 29 Aug 2019 23:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567119973;
        bh=2DIq5j2X+QpOMWqhkHBK01w0HUI6PPxaH+sxt3qGcWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J2cuYDBDMucFe8qdtZix2rddEIdxZw7/FHFvox1hljQ0HZ3Ccu84Be+GBM/aAV7zP
         IOg0Nnxp9u5sVvu+eoLvxTXAioLQ8iwQCyBYOrhtiBPs0XSHQwlPeRWE6nYBuA5E6J
         ojLmEC2KEMGrHULrn7ic7VfHjrp+tC0vRwH1L7S0=
Date:   Thu, 29 Aug 2019 19:06:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     stable@vger.kernel.org, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie, jsarha@ti.com, tomi.valkeinen@ti.com,
        vinholikatti@gmail.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BACKPORT 4.19.y 2/3] scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE
 define value
Message-ID: <20190829230612.GQ5281@sasha-vm>
References: <20190829200001.17092-1-mathieu.poirier@linaro.org>
 <20190829200001.17092-3-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190829200001.17092-3-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 02:00:00PM -0600, Mathieu Poirier wrote:
>From: Pedro Sousa <sousa@synopsys.com>
>
>commit ebcb8f8508c5edf428f52525cec74d28edea7bcb upstream
>
>Fix RX_TERMINATION_FORCE_ENABLE define value from 0x0089 to 0x00A9
>according to MIPI Alliance MPHY specification.
>
>Fixes: e785060ea3a1 ("ufs: definitions for phy interface")
>Signed-off-by: Pedro Sousa <sousa@synopsys.com>
>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

I've queued this for 4.14-4.19, thanks!

--
Thanks,
Sasha
