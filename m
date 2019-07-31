Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A2D7BD48
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387463AbfGaJe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387452AbfGaJe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:34:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15B8B20657;
        Wed, 31 Jul 2019 09:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564565698;
        bh=5Ik30p5MWCv7LtOZUHHDd8fN5cfDtyBl0OxA1qG0u/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oTyAJ2J9vnr7zP+dUOnrJVJHoYGx7BN3tjBZEIhksiiwfo/WcfGL2rGX4i7wjyye6
         sxadHmEatUrxkxHjrPtW0tyUBvVyx85EEqUpX8io1jL5tQQieNo2chvJ8RyWWM/Il+
         p9LmNb3LYP1cNrudzh3o1gRLHKv+dKLoPuWwZ17s=
Date:   Wed, 31 Jul 2019 11:34:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qian Lu <luqia@amazon.com>
Cc:     stable@vger.kernel.org, trond.myklebust@hammerspace.com
Subject: Re: [PATCH 0/4] Fix NFSv4 lookup revalidation
Message-ID: <20190731093456.GE18269@kroah.com>
References: <20190731071327.28701-1-luqia@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731071327.28701-1-luqia@amazon.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 12:13:23AM -0700, Qian Lu wrote:
> Hello Greg,
> 
> Can you please consider including the following patches in the stable
> linux-4.14.y branch?
> 
> The following patch series attempts to address the issues raised by
> Stan Hu around NFSv4 lookup revalidation.
> 
> The first patch in the series should, in principle suffice to address
> the exact issue raised by Stan, however when looking at the
> implementation of nfs4_lookup_revalidate(), it becomes clear that we're
> not doing enough to revalidate the dentry itself when performing NFSv4.1
> opens either.
> 

You can not just ignore the 4.19.y kernel tree for these patches, as
when you all finally move forward from 4.14.y to 4.19.y, you would have
hit these same exact issues :(

I have also queued them up to 4.19.y.

Well, except for the last patch, that's not needed at all.

thanks,

greg k-h
