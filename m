Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F8E3D92F9
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 18:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhG1QPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 12:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhG1QPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 12:15:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F271D604DB;
        Wed, 28 Jul 2021 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627488912;
        bh=vdcrXg2d9U03S/GKKIxahHfunein5M8eD3ON5PTIuH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hBI3qgd5qLAoZ9LJjp8fQeo7RpQ+8StynqTC92Siqk76KxMb/Qd4ryZtdg18D43Ok
         1dypXic3TVCV2eY6XW7q4x/Dttmq0gm3hi0DRUMbBbmoOuPeDNhO3k8Z2a6twTv8gr
         LeoCcVnUweoDWqTMxLAo06Y0nVeMliQENkhcaORo=
Date:   Wed, 28 Jul 2021 18:15:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     stable@vger.kernel.org, Guohan Lu <lguohan@gmail.com>,
        Madhava Reddy Siddareddygari <msiddare@cisco.com>,
        Venkat Garigipati <venkatg@cisco.com>,
        Billie Alsup <balsup@cisco.com>,
        Ruslan Babayev <ruslan@babayev.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Backport commit a2d2010d95cd (iio: dac: ds4422/ds4424 drop
 of_node check) to Linux 4.19
Message-ID: <YQGCjoaQ7U7kW+sT@kroah.com>
References: <7388a1e0-c0bf-86b0-bcca-319ab8ca6048@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7388a1e0-c0bf-86b0-bcca-319ab8ca6048@molgen.mpg.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 01:32:38PM +0200, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> Could you please backport commit a2d2010d95cd7ffe3773aba6eaee35d54e332c25
> (iio: dac: ds4422/ds4424 drop of_node check) to Linux 4.19? It’s needed for
> Cisco switches [1].

Now queued up, thanks.

greg k-h
