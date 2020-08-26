Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD262252B2F
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 12:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgHZKNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 06:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbgHZKNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 06:13:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 036AD206EB;
        Wed, 26 Aug 2020 10:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598436817;
        bh=peug45VRSN0iCE09kxGA3shCAWV5Kp3pW1QImdvFz90=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bL7Z8gUpw97F2aNOP5VM+YC7qkb1vdV+H9e2DQoNLc5QMT94vEmnUlMzaxhIOeREI
         VwIj05/oxQ+imYucBMzeRjvlYqVmf3iiPPj86RuCnH13M7LbZ0bzo+xj8LODx0U4W5
         5r5glgzDsauO8jCW9A7QOcW/4tY5C6VyyqxJJEbA=
Date:   Wed, 26 Aug 2020 12:13:52 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200826101352.GA3351885@kroah.com>
References: <20200824.095229.708445861503653540.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824.095229.708445861503653540.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 09:52:29AM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.7
> and v5.8 -stable, respectively.

All now queued up, thanks.

Note, 5.7.y is now end-of-life after these patches are merged, so no
need to worry about that kernel tree anymore.

thanks,

greg k-h
