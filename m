Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51C3348BE5
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 09:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhCYIuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 04:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhCYIuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 04:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC23061A02;
        Thu, 25 Mar 2021 08:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616662203;
        bh=Qv9R/FicJI6H+nnDBeJdvJftZLYH+gQS3YPv2waCtr4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gz/OFqHC1pvl4DC7L+Ezk3VnFuXgffftgYOUNLc6LlkFYAZeo5vrIGwGp0a7YP+yT
         guqZRL9som1gMGnHdGnHwl9DkHwsjdO+Msce3d9jGyGmYodcIt5pMfq1Mgledmi5ZB
         /8X4RZIGg6u8GiMdYeiqSCxuCWfFW4n3w9OSPJmA=
Date:   Thu, 25 Mar 2021 09:50:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.11 073/120] drm/ttm: Warn on pinning without holding a
 reference
Message-ID: <YFxOuFsO2I7LlEis@kroah.com>
References: <20210322121929.669628946@linuxfoundation.org>
 <20210322121932.109281887@linuxfoundation.org>
 <8c3da8bc-0bf3-496f-1fd6-4f65a07b2d13@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c3da8bc-0bf3-496f-1fd6-4f65a07b2d13@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 25, 2021 at 09:14:59AM +0100, Christian König wrote:
> Hi Greg,
> 
> sorry just realized this after users started to complain. This patch
> shouldn't been backported to 5.11 in the first place.
> 
> The warning itself is a good idea, but we also have patch for drivers and
> TTM in the pipeline for 5.12 so that the warning isn't triggered any more.
> 
> Without backporting all of that we now get a rain of warnings in 5.11.9.
> 
> My suggestion is to revert this patch from the 5.11 branch.

Thanks, will go do so right now and push out a new 5.11 release with
that in it to keep the noise down for you.

greg k-h
