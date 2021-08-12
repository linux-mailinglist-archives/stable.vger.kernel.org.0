Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB1B3EA333
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 12:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbhHLK5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 06:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235757AbhHLK5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Aug 2021 06:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1BEF60EE2;
        Thu, 12 Aug 2021 10:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628765799;
        bh=JQ49RIs4tScxZTrVQLLfWjfpp/JzJQocwkDGrnp+ydc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Ty1jQW8ja4W7AHe+IT9Yfv7tT0qip/V8KcYyR3eZCkMKU9XdrHtcXFmKmsXhU5m3
         A8vX1iH+k7oE11CkdUB7i7PKkEaz6rUKqugBU+8SY6EV5tOuih6it77igBwoAEbkHO
         CaajIAmAMJ9MA8rNkYALtgj8UCUop18TBynkonGs=
Date:   Thu, 12 Aug 2021 12:56:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: Re: [PATCH 4.19 36/54] tee: add tee_shm_alloc_kernel_buf()
Message-ID: <YRT+ZLYEFcmyFrig@kroah.com>
References: <20210810172944.179901509@linuxfoundation.org>
 <20210810172945.369365872@linuxfoundation.org>
 <20210811072434.GB10829@duo.ucw.cz>
 <20210811133427.GG5469@sequoia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811133427.GG5469@sequoia>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 08:34:27AM -0500, Tyler Hicks wrote:
> On 2021-08-11 09:24:34, Pavel Machek wrote:
> > Hi!
> > 
> > > commit dc7019b7d0e188d4093b34bd0747ed0d668c63bf upstream.
> > > 
> > > Adds a new function tee_shm_alloc_kernel_buf() to allocate shared memory
> > > from a kernel driver. This function can later be made more lightweight
> > > by unnecessary dma-buf export.
> > 
> > 5.10 contains follow-up patches actually using the export, but 4.19
> > does not. I believe it should be dropped from 4.19.
> 
> That's correct. Those follow-up patches that made use of this function
> were only needed back to 5.4.

Now dropped, thanks.

greg k-h
