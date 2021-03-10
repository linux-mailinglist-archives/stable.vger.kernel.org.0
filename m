Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4C1333C31
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 13:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhCJMFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 07:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232902AbhCJMFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 07:05:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CA2564FEE;
        Wed, 10 Mar 2021 12:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615377933;
        bh=l5vVhlzi47+ndhKnHdbL6alj5M0iTeVIjMlxASM81Ew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jNUTo4okGu3XCRwL7mE3LFJ2vSWD6blfMMHhHEymssa+3iYkJwmichJD9+DfP7l3o
         ZzxJw0UlCoX7xx+bESotwSD5q5tmEQPKhLzlnEPtUy4iovJees/sOZK9eCiohJrYBe
         TvKzZFleJlysrVvMqiavme3TjqT/3WgeDpRlsKKk=
Date:   Wed, 10 Mar 2021 13:05:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     stable <stable@vger.kernel.org>,
        Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@siol.net>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH FOR stable v5.11] media: cedrus: Remove checking for
 required controls
Message-ID: <YEi2CueFSqk/6lnb@kroah.com>
References: <f938a1ba-d9ae-3b39-a066-60504a9e6c12@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f938a1ba-d9ae-3b39-a066-60504a9e6c12@xs4all.nl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 11:49:38AM +0100, Hans Verkuil wrote:
> From: Jernej Skrabec <jernej.skrabec@siol.net>
> 
> [ Upstream commit 7072db89572135f28cad65f15877bf7e67cf2ff8 ]
> 
> According to v4l2 request api specifications, it's allowed to skip
> control if its content isn't changed for performance reasons. Cedrus
> driver predates that, so it has implemented mechanism to check if all
> required controls are included in one request.
> 
> Conform to specifications with removing that mechanism.
> 
> Note that this mechanism with static required flag isn't very good
> anyway because need for control is usually signaled in other controls.
> 
> Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> Without this patch the H264 cedrus support is non-compliant, and since 5.11
> was the first kernel with a stable H264 stateless codec ABI it would be
> good to have this merged for 5.11 so the cedrus driver can be used with
> H264.

Now queued up, thanks.

greg k-h
