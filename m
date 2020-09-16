Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F22926C0CC
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 11:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgIPJiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 05:38:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgIPJiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 05:38:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A223922225;
        Wed, 16 Sep 2020 09:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600249090;
        bh=P48OkWYEGeoEzk2TJyoNi46YtHz8W18KDlpoQFxzfQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jXLqyGLxMtTcBNccf6WzZRghvmXlDt9YD0pa+DwpQhpobG842CHCXIqdxNnLMvsaD
         Luu2b07Pb8gINEYDDN/FuCKR6pSxVGUHZAEe8UMtO/Xqa6giBkGDPWWNJI2YFbHE7o
         K/SZamqmLUig3A2+4AOmDI1v4xA657mpj85krJAM=
Date:   Wed, 16 Sep 2020 11:38:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Daniel Mack <daniel@zonque.org>
Subject: Re: Please apply commit 1ed9ec9b08ad ("dsa: Allow forwarding of
 redirected IGMP traffic") to stable
Message-ID: <20200916093839.GB739330@kroah.com>
References: <CALW65jb8xv2tZPiimQcLHmpzcyhZG3t1HAZG_wdjE9sdXsQxPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jb8xv2tZPiimQcLHmpzcyhZG3t1HAZG_wdjE9sdXsQxPg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 04:41:23PM +0800, DENG Qingfang wrote:
> Hi,
> 
> Please apply commit 1ed9ec9b08ad ("dsa: Allow forwarding of redirected
> IGMP traffic") to stable as well, as it fixes IGMP snooping on Marvell
> switches.

What stable tree(s) do you wish to see this applied to?

thanks,

greg k-h
