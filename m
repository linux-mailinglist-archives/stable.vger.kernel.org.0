Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA762C677D
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 15:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730725AbgK0OJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 09:09:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730041AbgK0OJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 09:09:18 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6896721D7A;
        Fri, 27 Nov 2020 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606486156;
        bh=e+VLPdMhINDWjlIa5BKUy9Ybv39zUcaLWzldKbUIojw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sqUMJf71eYQRyDI1QkYcsPTUXw9MIwGH0G9QBMjItded8OHynQK2n3pGQSxJ6qfkv
         4id18cqynLG5GxaXxDBdskJ/uOuLnA/uIcex/DAOK4n/0TWPtGJn16L6bFaFaXxFXm
         oIVXgqhzRW8gQzLJDES9VdZDvNBrAjkfKj4o8EZA=
Date:   Fri, 27 Nov 2020 15:09:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Missing fixes commit on linux-4.19.y
Message-ID: <X8EIikqJig6iNCOD@kroah.com>
References: <86287ab712444551b3740703a8092aa8@dh-electronics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86287ab712444551b3740703a8092aa8@dh-electronics.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 01:50:10PM +0000, Christoph Niedermaier wrote:
> Hello,
> 
> Is it possible to apply the following commit on the branch linux-4.19.y?
> de9f8eea5a44 ("drm/atomic_helper: Stop modesets on unregistered connectors harder")
> 
> This commit is applied to the other LTS kernels, but is missing on
> linux-4.19.y.

I see it showing up in the 4.20 release, so of course anything newer
than that will work, what other trees do you see this applied in?

> Without this patch my i.MX6ULL SoM doesn't initialize
> the display correctly after booting.

It does not apply cleanly to the 4.19.y tree, can you provide a working
backport so that we could apply it?

thanks,

greg k-h
