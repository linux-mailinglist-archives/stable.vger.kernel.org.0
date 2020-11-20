Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625C22BA4C7
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 09:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgKTIhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 03:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgKTIhM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 03:37:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E2DA22249;
        Fri, 20 Nov 2020 08:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605861431;
        bh=XZ2PiimvrgJGtCfKsQFvGt16cLR2SiLUtr8rQz40khg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0v0IvOlmT/r1nkh/rGeykuWwzjGuKfkOce25VdiGIaHpSNxPNYdExxGPeE7ZPU0e7
         On6mCyYfiwsVFVilepCld1sKW4+GW5EKXwt+vDqfKemr8FONJiVf9eGPjMU+jpIpFr
         GXzSODwfx7K7bJ8+WT40bmOBbCI2aKWrpEhJMITg=
Date:   Fri, 20 Nov 2020 09:37:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Timo Rothenpieler <timo@rothenpieler.org>
Cc:     stable@vger.kernel.org, Eran Ben Elisha <eranbe@nvidia.com>,
        Jack Wang <xjtuwjp@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>, jgg@ziepe.ca
Subject: Re: Backport missing mlx5 fixes after 50b2412b7e7
Message-ID: <X7eAYoNA2RktjH5B@kroah.com>
References: <f1c78926-b95b-c4b0-c323-c7a5ca1c8856@rothenpieler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1c78926-b95b-c4b0-c323-c7a5ca1c8856@rothenpieler.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 18, 2020 at 07:28:30PM +0100, Timo Rothenpieler wrote:
> Hi,
> 
> After 50b2412b7e7862c5af0cbf4b10d93bc5c712d021 was backported to stable
> branches (I only tested 5.4), some serious issues started to arrise.
> 
> According to linux-rdma, the following two patches that need to go along
> with 50b2412b7e are missing:
> 
> > 1. 1d5558b1f0de net/mlx5: poll cmd EQ in case of command timeout
> > 2. 410bd754cd73 net/mlx5: Add retry mechanism to the command entry ...
> 
> I managed to apply those mostly cleanly after also applying two
> dependencies.
> So the complete list of needed commits for 5.4 is:
> 
> 1. 3ed879965cc4 net/mlx5: Use async EQ setup cleanup helpers ...
> 2. 1d5558b1f0de net/mlx5: poll cmd EQ in case of command timeout
> 3. d43b7007dbd1 net/mlx5: Fix a race when moving command ...
> 4. 410bd754cd73 net/mlx5: Add retry mechanism to the command entry ...
> 
> With those 4 commits applied, the issue is fixed.
> For reference, that's the output I get with 5.4.77:

All now queued up, thanks.

greg k-h
