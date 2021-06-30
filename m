Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CC43B7F9B
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 11:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhF3JG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 05:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233717AbhF3JGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 05:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5169F60230;
        Wed, 30 Jun 2021 09:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625043864;
        bh=NPtuVyJ1SquEZYecXwu/psgsGngWAT93saUxxDZv6KU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZzGuiQyk3IecS34Q5M1uBeOsVgULTGCXRcRNDuLVG1AA/qdrRpHwyuQK2jSCBw1kB
         JJUiKlu9OtGU0Evz/xsDRKCHEX4+Ib6DQfT2lClXkgpzBUX55elfDl+ZfZLRlk8a8O
         tOYFzhhHXTaKAg010F1+iw7K2CdG01NmQSDhoSoE=
Date:   Wed, 30 Jun 2021 11:04:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     lyude@redhat.com, jani.nikula@intel.com, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Force DPCD backlight mode for Samsung 16727
 panel
Message-ID: <YNwzlqgBF/54qFMX@kroah.com>
References: <20210519095305.47133-1-aaron.ma@canonical.com>
 <57b373372cb64e8a48d12e033a23e7711332b0ec.camel@redhat.com>
 <33f42229-780f-9b4e-69db-db3fad32bf3a@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33f42229-780f-9b4e-69db-db3fad32bf3a@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 30, 2021 at 12:29:05PM +0800, Aaron Ma wrote:
> Hi Greg:
> 
> Could this patch get a chance to be applied on stable kernel?
> It only for 5.11- kernel, not for Linus' tree.

What is the git commit id for it in Linus's tree?

And if this is not for Linus's tree, please resubmit it and document the
heck out of why it is not valid for Linus's tree and exactly what stable
trees you want this applied to (hint, 5.11 is long end-of-life and 5.12
only has about 1-2 more weeks left...)

thanks,

greg k-h
