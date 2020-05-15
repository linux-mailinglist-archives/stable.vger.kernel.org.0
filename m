Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF571D48C7
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 10:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgEOIsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 04:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbgEOIsX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 04:48:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F1C2054F;
        Fri, 15 May 2020 08:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589532503;
        bh=aTkW++N3XU8jEGVYQV4Zt4iwEcclpOOtZHBCB0mjvNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qd2aobjyA14H3LtACCDy6+WZ9l0tSIzq5p9gTAolGS/l4Vd+pV9cUdSsOtBD89rNk
         f/iUut9sdGUQvJgSMu8LhlbjWrw2h8AhToT5ZV7FfnW4KAbFXeglwPYLp33rTckVlQ
         wVzsX2ACSBt1XSGu34dltkxwfjkTEilNF3j5gBQw=
Date:   Fri, 15 May 2020 10:48:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Wu Bo <wubo40@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v4.4..v5.4] scsi: sg: add sg_remove_request in sg_write
Message-ID: <20200515084820.GB1474499@kroah.com>
References: <20200514150551.240275-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514150551.240275-1-linux@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 14, 2020 at 08:05:51AM -0700, Guenter Roeck wrote:
> From: Wu Bo <wubo40@huawei.com>
> 
> [ Upstream commit 83c6f2390040f188cc25b270b4befeb5628c1aee ]
> 
> If the __copy_from_user function failed we need to call sg_remove_request
> in sg_write.
> 
> Link: https://lore.kernel.org/r/610618d9-e983-fd56-ed0f-639428343af7@huawei.com
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> [groeck: Backport to v5.4.y and older kernels]
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> This patch fixes CVE-2020-12770, and the problem it fixes looks like a valid bug.
> Please apply to v5.4.y and older kernel branches.

Now queud up, thanks.

greg k-h
