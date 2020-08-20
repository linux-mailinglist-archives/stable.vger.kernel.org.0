Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0252F24B12A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgHTIgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgHTIg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 04:36:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5987A207FB;
        Thu, 20 Aug 2020 08:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597912588;
        bh=Hvuj+/Q2sU26szPxSw3kTQN2H4p39N8iVIe7jZV5K9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LqhyRnElBumpuDoX2uEISWdYEN9HzoZ8kjCBgDmqeTkUlmjksNrUbRmJdkZTr8Xwq
         oYx2qvl5ADpPBo4RuBVeZISMwnvJ8lryUHXSyVm7tGzDKqjfjAdAZFjE72AIl4rMqL
         HvgEpMkJnohkS20cnBbMJn5eGgILK+dQARwgUdAo=
Date:   Thu, 20 Aug 2020 10:36:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: Re: [PATCH v2] drm/amdgpu: fix ordering of psp suspend
Message-ID: <20200820083649.GJ4049659@kroah.com>
References: <20200806144939.466297-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806144939.466297-1-alexander.deucher@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 10:49:39AM -0400, Alex Deucher wrote:
> The ordering of psp_tmr_terminate() and psp_asd_unload()
> got reversed when the patches were applied to stable.
> 
> This patch does not exist in Linus' tree because the ordering
> is correct there.  It got reversed when the patches were applied
> to stable.  This patch is for stable only.
> 
> Fixes: 22ff658396b446 ("drm/amdgpu: asd function needs to be unloaded in suspend phase")
> Fixes: 2c41c968c6f648 ("drm/amdgpu: add TMR destory function for psp")
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org # 5.7.x
> Cc: Huang Rui <ray.huang@amd.com>
> ---
> 
> Make the description more explicit as to why this patch is only for stable.

Now queued up, thanks!

greg k-h
