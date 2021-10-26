Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233A943B55F
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 17:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhJZPVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 11:21:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235688AbhJZPV2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Oct 2021 11:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CA6260724;
        Tue, 26 Oct 2021 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635261544;
        bh=UhbFij+58y/yF+6IAXkCzONRtVdRGegsfmO3zZfruUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CB4nR8qziB2iIGhXSJKzf3CHqflyJNVQGvv2GYpTvo22UMOzQX3vt4w6BGd3GsObh
         kObja+PQEd7TRa9ALSWvsHzrL0FK1PjIjzHP8bN/zGktE/QCCnGpERxe/CLd13JnMO
         ccIf8DufvybZvG7eYJnD+ERGR+xg89lhzULwIyOs=
Date:   Tue, 26 Oct 2021 17:19:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] usbnet: sanity check for maxpacket
Message-ID: <YXgcZuPl+R/w28ye@kroah.com>
References: <e3ae5f6e-1e96-9d7e-c126-6b4fb00f83a0@linaro.org>
 <YXeVmDtzkC1sUBCv@kroah.com>
 <68be83ab-c0b1-78f7-0234-8e915339d570@linaro.org>
 <YXgY2cirSesI+L+E@kroah.com>
 <6e76d1d0-fb73-13b4-0881-6bdd8b69588f@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e76d1d0-fb73-13b4-0881-6bdd8b69588f@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 26, 2021 at 08:08:37AM -0700, Tadeusz Struk wrote:
> On 10/26/21 08:03, Greg KH wrote:
> > On Tue, Oct 26, 2021 at 07:52:00AM -0700, Tadeusz Struk wrote:
> > > On 10/25/21 22:43, Greg KH wrote:
> > > > > It should be applied to stable kernels: 5.14, 5.10, 5.4, 4.19, 4.14, 4.9, 4.4
> > > > It's already in the latest stable -rc releases, do you not see it there?
> > > 
> > > I haven't checked the rc releases, just the latest stable versions.
> > > Now I also see Sasha Levin's submissions on the stable mailing list archive.
> > > All good. Sorry for the noise.
> > 
> > Also note that there is a bug in this commit, so it was dropped from the
> > stable queues until the fix for this hits Linus's tree.
> > 
> 
> Good to know. Ideally we could also add some netif_warn() message for the user.

Why?  It's an "obviously broken" device that is created just to try to
harm the kernel.  No need to be noisy about it.

thanks,

greg k-h
