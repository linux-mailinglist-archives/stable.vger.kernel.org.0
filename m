Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E051FAF88D
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 11:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfIKJKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 05:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbfIKJKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 05:10:35 -0400
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 280AC2168B;
        Wed, 11 Sep 2019 09:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568193034;
        bh=S4stZh3oLN7lPyJxmfb3Z7kYSWWZ3HzDyaCpRcFBm5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pOS36evJ5BEpZgAtmg6r7EenvmLRmLEOBr4PW0DRWsa2yusj8oTnHIwZFig/jKw6Y
         Zp5W2ocPwWxo89U5YoyRkgSUtbMLI4q/SyB4bSmfJIcWg3pNzrOXIczPjf8ZiAcrNg
         GGw8SreLgNoJGxAoo0jDC4toWSMhzpaowlKTfLyk=
Date:   Wed, 11 Sep 2019 10:10:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     stable@vger.kernel.org, mst@redhat.com, jasowang@redhat.com
Subject: Re: [PATCH 4.14] vhost/test: fix build for vhost test
Message-ID: <20190911091031.GB30714@kroah.com>
References: <20190911025055.26774-1-tiwei.bie@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911025055.26774-1-tiwei.bie@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 10:50:55AM +0800, Tiwei Bie wrote:
> commit 264b563b8675771834419057cbe076c1a41fb666 upstream.
> 
> Since vhost_exceeds_weight() was introduced, callers need to specify
> the packet weight and byte weight in vhost_dev_init(). Note that, the
> packet weight isn't counted in this patch to keep the original behavior
> unchanged.
> 
> Fixes: e82b9b0727ff ("vhost: introduce vhost_exceeds_weight()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/test.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 

Now queued up, thanks.

greg k-h
