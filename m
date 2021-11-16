Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF86453973
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 19:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbhKPSiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 13:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239188AbhKPSiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 13:38:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB6C261AA2;
        Tue, 16 Nov 2021 18:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637087755;
        bh=0oiE6Y7yg7IX5QF6pzGvTbVuG0YtMgjXdkxGyR3YgDw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1PHpp0GMnZXo0Nx+m7iYlw6L4YuDb8dpVCFEMHscIBhCvcWhWQ6r50a+B8UZpcOYl
         zpQSvcEemF2DVypqdv/2CtZ/P1YQMSMv6NvQZz7ilIyrvF3l8r/+IA/qnn+4AFL6Bb
         zARR6V0NasaefETIYX5zf3wQuGeoSFPq13KiekC8=
Date:   Tue, 16 Nov 2021 19:35:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Szabolcs Sipos <labuwx@balfug.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] Bluetooth: btusb: Add support for TP-Link UB500 Adapter
Message-ID: <YZP6CL+CDMyzQ6aA@kroah.com>
References: <aa3f6986-1e9b-4aaa-e498-fd99385f4063@denx.de>
 <YWPrSHGbno3dODKr@kroah.com>
 <62685363-e1b3-bc97-431e-a7c8faccb78d@balfug.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62685363-e1b3-bc97-431e-a7c8faccb78d@balfug.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 06:41:08PM +0100, Szabolcs Sipos wrote:
> On 10/11/21 09:44, Greg Kroah-Hartman wrote:
> > On Sun, Oct 10, 2021 at 10:59:06PM +0200, Marek Vasut wrote:
> > > Hello everyone,
> > > 
> > > The following new device USB ID has landed in linux-next recently:
> > > 
> > > 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
> > > 
> > > It would be nice if it could be backported to stable. I verified it works on
> > > 5.14.y as a simple cherry-pick .
> > 
> > A patch needs to be in Linus's tree before we can add it to the stable
> > releases.  Please let us know when it gets there and we will be glad to
> > pick it up.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hello Greg,
> 
> The patch has reached Linus's tree:
> 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
> 
> Could you please add it to stable (5.15.y)?

I will queue it up for the next set of kernels after the current ones are
released.

thansk,

greg k-h
