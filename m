Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BF32864BF
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 18:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgJGQnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 12:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbgJGQnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 12:43:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C34AA206BE;
        Wed,  7 Oct 2020 16:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602089012;
        bh=FF0smCLuqLzFnIopRKFeih8U1IUPmc22aYzyIfAeSKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b4QIO1pGVdo+dXqg/Ys5Kmurh+uhvf9UD9WMbyn6sOejbyRvsgREX4b9343lCC4/2
         +Ty2ezanXk+yt3WMsFMixswCxn6W387+KJtm0AlhmjCTKTX1vsEbWEok1YUzcRqIpZ
         dphJ26SXUUyptsDSQ9hRTKM5ShHkDyrRZ0lINVBc=
Date:   Wed, 7 Oct 2020 18:44:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: Request for inclusion for 5.4-stable
Message-ID: <20201007164417.GA50479@kroah.com>
References: <690b1e06-742d-6b1f-2f09-83edcc562d95@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <690b1e06-742d-6b1f-2f09-83edcc562d95@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 07, 2020 at 09:36:23AM -0600, Jens Axboe wrote:
> Hi,
> 
> Can you queue up this series for 5.4-stable? It fixes some issues
> with an earlier patch that was queued up for 5.4-stable.

These aren't upstream, right?

Are they a special 5.4-only stuff?

And I need a signed-off-by: from you at the very least :)

thanks,

greg k-h
