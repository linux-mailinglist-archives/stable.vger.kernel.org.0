Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101C917449D
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 04:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgB2DEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 22:04:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgB2DEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 22:04:22 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C35D246A2;
        Sat, 29 Feb 2020 03:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582945461;
        bh=kZyVBjKpCu11e3yXvbPtA25/6YkWt0Z7eioOCA6VA/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MCULOtk+GEWu2HTjGEJGw3Hec3tkpo99td0xNUyx6fI9VLJVtT1hmmHBOJExWk4mi
         GzIC40qJBm1FYtB5IO39c8o2HvaAx8pOz6LPIUEPEqYrlXdiLu1Gy0XielVnbwK9KI
         khrItXHumjl0lJgjFu3qLKy/hNmrtYFskZsnatvw=
Date:   Fri, 28 Feb 2020 22:04:20 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org, Jann Horn <jannh@google.com>
Subject: Re: 5.4 backport of io_uring/io-wq fix
Message-ID: <20200229030420.GD21491@sasha-vm>
References: <48a01733-c0cb-e738-8c18-1abc3de1dcfb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <48a01733-c0cb-e738-8c18-1abc3de1dcfb@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 28, 2020 at 03:27:17PM -0700, Jens Axboe wrote:
>Hi,
>
>We don't have these two commits in 5.4-stable:
>
>ff002b30181d30cdfbca316dadd099c3ca0d739c
>9392a27d88b9707145d713654eb26f0c29789e50
>
>because they don't apply with the rework that was done in how io_uring
>handles offload. Since there's no io-wq in 5.4, it doesn't make sense to
>do two patches. I'm attaching my port of the two for 5.4-stable, it's
>been tested. Please queue it up for the next 5.4-stable, thanks!

I've copied this explanation into the commit message and queued it for
5.4, thanks Jens!

-- 
Thanks,
Sasha
