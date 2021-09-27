Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2435419526
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 15:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbhI0Nfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 09:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234103AbhI0Nfm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 09:35:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2E0160230;
        Mon, 27 Sep 2021 13:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632749645;
        bh=xlyLlWPqsugLoahwYzmOASjZMEO2SMr9LWipzCy6+18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DcoWKTCT+WJ126BONXbW+Ngv8usfWStSuEBOXu62n6CrPqiPxwymPld1BeVUBpTlE
         Fy26n8BvV10uddIghPCLkaMROchPoSIpKKnC7b96qvO8vuiOyJJCPvPNEp+b7Hg2dx
         /mC2OtmarR6sZ1NwlIyg47tfV2qr2vwogPg4Zl3w=
Date:   Mon, 27 Sep 2021 15:34:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     heikki.krogerus@linux.intel.com, jon@solid-run.com,
        rafael.j.wysocki@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH] software node: balance refcount for managed sw nodes
Message-ID: <YVHISkh2QngryHsR@kroah.com>
References: <20210927102249.12939-1-laurentiu.tudor@nxp.com>
 <YVG2XCK1nF4vVYP0@kroah.com>
 <97a611be-3deb-111e-5619-f0f015393e24@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a611be-3deb-111e-5619-f0f015393e24@nxp.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 03:42:42PM +0300, Laurentiu Tudor wrote:
> 
> On 9/27/2021 3:17 PM, Greg KH wrote:
> > On Mon, Sep 27, 2021 at 01:22:49PM +0300, Laurentiu Tudor wrote:
> >> software_node_notify(), on KOBJ_REMOVE drops the refcount twice on managed
> >> software nodes, thus leading to underflow errors. Balance the refcount by
> >> bumping it in the device_create_managed_software_node() function.
> >>
> >> The error [1] was encountered after adding a .shutdown() op to our
> >> fsl-mc-bus driver.
> >>
> >> [Backported to stable from mainline commit
> >> 5aeb05b27f81 ("software node: balance refcount for managed software nodes")]
> 
> But ...

Ah, missed that up here in the middle of the changelog text, sorry.

greg k-h
