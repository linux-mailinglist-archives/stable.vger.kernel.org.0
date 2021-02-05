Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E514D310742
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 10:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhBEI73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 03:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229596AbhBEI72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 03:59:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 612F564F3C;
        Fri,  5 Feb 2021 08:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612515528;
        bh=1IT4vx5rc0AO9pauXBzJcqBZY89Uv/20RddWctDWPOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sF81kLoLqqRd3sTLE+KzFrr/XZiHtuNtaH1tb2IjiowxBX8HJynXRipZMdjMd2CVd
         69W7m2oLX9RWMfKgumqQxEcQPUo1/Z/DOlR4UlughzijitUo0sjq+HtshIRY8fDoYY
         lQCt7fcdeD80pqa9ncX1ovmr5QbpN9rFamOPmy68=
Date:   Fri, 5 Feb 2021 09:58:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     rafael.j.wysocki@intel.com, saravanak@google.com,
        stable@vger.kernel.org, stephan@gerhold.net
Subject: Re: FAILED: patch "[PATCH] driver core: Extend
 device_is_dependent()" failed to apply to 4.14-stable tree
Message-ID: <YB0IxGjIrydUUKZg@kroah.com>
References: <161158456921623@kroah.com>
 <YBwdf9Qx0XG72AWH@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBwdf9Qx0XG72AWH@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 04:14:55PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 25, 2021 at 03:22:49PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport along with:
> e16f4f3e0b7d ("base: core: Remove WARN_ON from link dependencies check") for
> easy backporting.

Both queued up, thanks!

greg k-h
