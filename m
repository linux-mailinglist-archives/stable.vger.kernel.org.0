Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39892311BD3
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 08:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhBFHD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 02:03:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhBFHD1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Feb 2021 02:03:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3367764E3F;
        Sat,  6 Feb 2021 07:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612594964;
        bh=qq5+BpoyeRhoy/pWiz72G/JpYiCAnD3d+m3YzV/6i4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lyNbsJNRQM5xtu0kECEMlxpM4gcqTPpEUc7eBXD3Ch9/3WtWqdEk2sMY6XOrcTYCb
         f2TIf8f0F4adT/JbOXjpF4dc4xskl/boq8sb0fRdLZtNQrXCUzWlomM45yNUkSTz6O
         NjZKKj9TpHv2dNdZoFIevRvJAK4vUmbAxkHx+Fic=
Date:   Sat, 6 Feb 2021 08:02:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Pawson <dave.pawson@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: How to help with new kernel?
Message-ID: <YB4/ESyrjZJ1uMQK@kroah.com>
References: <CAEncD4esY38Z-Z9t=KOXriZczry7htCYfCh7+B=eC_kUds5miQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEncD4esY38Z-Z9t=KOXriZczry7htCYfCh7+B=eC_kUds5miQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 03:50:55PM +0000, Dave Pawson wrote:
> Do you really want companies only?

No, I will accept help from anyone who relies on the stable kernels.

> If you detail how to install the new kernel
> (and any other prerequisites) and if 'ordinary use'
> is sufficient, I'm sure others would help.

That is already well documented, heck, I wrote a whole book on how to do
that and it's free online :)

thanks,

greg k-h
