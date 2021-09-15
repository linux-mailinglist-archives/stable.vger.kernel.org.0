Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AD940C453
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 13:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhIOLWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 07:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237541AbhIOLWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 07:22:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 357D560F5B;
        Wed, 15 Sep 2021 11:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631704874;
        bh=a0nXaKvBXnMRgS+1dAk4cRxnjRysedmpzEn2cnyNJOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PeM0xM389WNNrjttNKNPuZgu1a8iTZjvCLkTaDABKxKAWN0N/ZVh1L7PlD9Oo2/GU
         P2YfHa3K+v2+gbAbanzdOItTUqwMUp/CFwgsrMJPU/wjXiUJoGisDOjotXSz9qRG5+
         LFM+EFmw2Q35YTYCdyXii+lkcFMkiXxOY89rsTRA=
Date:   Wed, 15 Sep 2021 13:21:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, stable@vger.kernel.org
Subject: Re: 5.14 stable backports
Message-ID: <YUHXIIs3Pb8ilCE4@kroah.com>
References: <b8b7d2ae-ac8c-9758-f57a-af1ae54d4743@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8b7d2ae-ac8c-9758-f57a-af1ae54d4743@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 09:50:37AM -0600, Jens Axboe wrote:
> And here's the 5.14 queue.

Now queued up, thanks!

greg k-h
