Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0DAE17145B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgB0JvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbgB0JvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 04:51:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66CFA2467F;
        Thu, 27 Feb 2020 09:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582797069;
        bh=RngL2JpeW1BpgEOT9TD4SzqCr71SKUWyD4iPYcm0tK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJYbT7vokbCgcwOcCEgiPXVkfWQiWjbOdGlCeEJvD1/d8LEKO4BGBbiAVbBdrP6HP
         vS/Qc5+OsGQwmz99cbDzcfTRzYLY8wv2e/fVnhwpga8aQr6IzKlvK3rwOhhbjA7cUL
         UQp2zGg1eDiqpdMU3Jr7qOAGGq29FM+ejWYUDj+w=
Date:   Thu, 27 Feb 2020 10:51:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: device link patches on 4.19.99 breaks functionality
Message-ID: <20200227095107.GB579982@kroah.com>
References: <CAGETcx-0dKRWo=tTVcfJQhQUsMtX_LtL6yvDkb3CMbvzREsvOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-0dKRWo=tTVcfJQhQUsMtX_LtL6yvDkb3CMbvzREsvOQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 01:21:00AM -0800, Saravana Kannan wrote:
> 4.19.99 seems to have picked up quite a few device link patches.
> However, one of them [1] broke the ability to add stateful and
> stateless links between the same two devices. Looks like the breakage
> was fixed in the mainline kernel in subsequent commits [2] and [3].
> 
> Can we pull [2] and [3] into 4.19 please? And any other intermediate
> device link patches up to [3].
> 
> [1] - 6fdc440366f1a99f344b629ac92f350aefd77911
> [2] - 515db266a9da
> [3] - fb583c8eeeb1 (this fixed a bug in [2])

"up to"?

515db266a9da does not apply to 4.19, so should I just drop [1] instead?

Or, can you provided a backported set of patches so I know exactly what
to apply?

thanks,

greg k-h
