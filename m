Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1B51BF075
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 08:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgD3GoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 02:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3GoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 02:44:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8AD02173E;
        Thu, 30 Apr 2020 06:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588229064;
        bh=IqeWVxqr1JfV+2wplkea2yJe7fwmG1e3eZ6k9jTCSYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QaCiDUYnnIAbGfQPcdnTdG0t0GlI1cIeX2q5vC7uXjGMrfj2omO2+3As355nSKAVX
         w/jKbU49Lu/demm/9rnCaKFhGVvpimjZ832Z1qwPrileWD0pL9kNM32D3onfcTnq0/
         l0+PMEPWJyo78GUv3fYi5KruBOip7IpGpJiXALvg=
Date:   Thu, 30 Apr 2020 08:44:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4] bcache: initialize 'sb_page' in register_bcache()
Message-ID: <20200430064421.GF2377651@kroah.com>
References: <041443374fde130be3bc864b6ac8ffba6640c2b0.1588184799.git.tom.saeger@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <041443374fde130be3bc864b6ac8ffba6640c2b0.1588184799.git.tom.saeger@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 29, 2020 at 06:38:17PM +0000, Tom Saeger wrote:
> commit 393b8509be33 (bcache: rework error unwinding in register_bcache)
> 
> introduced compile warning:
> warning: 'sb_page' may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> Use 'sb_page' initialization prior to 393b8509be33.
> 
> Fixes: 393b8509be33 (bcache: rework error unwinding in register_bcache)
> Cc: <stable@vger.kernel.org> # 5.4.x
> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> ---
> 
> This addresses warning only seen in 5.4.22+.  Upstream avoids
> this in a different way.

What is the "different way"?

And why am I not seeing this warning in my builds?  What version of gcc
are you using?

thanks,

greg k-h
