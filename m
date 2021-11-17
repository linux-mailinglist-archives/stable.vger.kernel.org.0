Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14D1454C90
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 18:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbhKQR4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 12:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239754AbhKQR4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 12:56:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DE98613A4;
        Wed, 17 Nov 2021 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637171616;
        bh=++2gLWuiglQaaBpHhwXNqpFhpXFdNmhN6+wUEyrxwuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v83oCC0LHAp1oxFTCnl1Umh3SHLc6/n/Vrxw/7VxJ5E/GPXfPtnh6Pmjnf2G2+3yv
         SnwlmwZV5Q6RqNxfNYOY7sdqiHUpJYCDOd46pMdV3HefJZU9jz4ADI3ycGwum6Jlfw
         j1UXzh/sf7IPt60Ma988IQ5aFO/mdFil/tv807JE=
Date:   Wed, 17 Nov 2021 18:53:34 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org
Subject: Re: s390 build failures in v4.9.y.queue, v4.14.y.queue
Message-ID: <YZVBnoLuJbuataXj@kroah.com>
References: <20211117150109.GA222117@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117150109.GA222117@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 07:01:09AM -0800, Guenter Roeck wrote:
> Hi,
> 
> I see the following build failure in v4.9.y and v4.14.y stable queues.
> 
> arch/s390/mm/gmap.c: In function '__gmap_zap':
> arch/s390/mm/gmap.c:665:9: error: implicit declaration of function 'vma_lookup'
> 
> In v4.14.y, there is an additional failure:
> 
> arch/s390/mm/pgtable.c: In function 'pgste_perform_essa':
> arch/s390/mm/pgtable.c:910:8: error: implicit declaration of function 'vma_lookup'

Thanks, offending patches now dropped.

greg k-h
