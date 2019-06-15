Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C618D470D0
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfFOP3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:29:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfFOP3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jun 2019 11:29:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42742183F;
        Sat, 15 Jun 2019 15:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560612561;
        bh=6r8X5Y8c5o2dB1cxuJv4bl3Dlu6Tth2OeiBXjX1xsMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ir+VzFWn5s8dU9FR221rJfZ1zUKfybWUaBCZ7JziBAoWma5UndHpd/68Tl6xZsO+z
         KDk5Optu/s5JZM7bX1VxcWfkXlZNSjbECKCDZbucwnTDWVHh/2joMS+Yg5dz2AiCZG
         8dEhKD6cahHD1OEESroqERnoTH/lLtxXJ9L8Kn7Y=
Date:   Sat, 15 Jun 2019 17:29:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     James Feeney <james@nurealm.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Sasha Levin <sashal@kernel.org>,
        Jiri Kosina <jikos@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: input: make sure the wheel high resolution
 multiplier is set
Message-ID: <20190615152918.GB5171@kroah.com>
References: <20190423154615.18257-1-benjamin.tissoires@redhat.com>
 <CAO-hwJLCL95pAzO9kco2jo2_uCV2=3f5OEf=P=AoB9EpEjFTAw@mail.gmail.com>
 <43a56e9b-6e44-76b7-efff-fa8996183fbc@nurealm.net>
 <CAO-hwJK614pzseUsGqH65fCnrm=N7970i4_mqi0m1gdkY=J0ag@mail.gmail.com>
 <b6410e5d-b165-7a9b-2ef5-eb44c8de7753@nurealm.net>
 <20190615055019.GC23883@kroah.com>
 <e158e981-47e6-a7f8-6416-4eff7af2c5d0@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e158e981-47e6-a7f8-6416-4eff7af2c5d0@mageia.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 15, 2019 at 12:03:04PM +0300, Thomas Backlund wrote:
> Den 15-06-2019 kl. 08:50, skrev Greg KH:
> > On Fri, Jun 14, 2019 at 04:09:35PM -0600, James Feeney wrote:
> > > Hey Everyone
> > > 
> > > On 4/24/19 10:41 AM, Benjamin Tissoires wrote:
> > > > > > For a patch to be picked up by stable, it first needs to go in Linus'
> > > > > > tree. Currently we are working on 5.1, so any stable patches need to
> > > > > > go in 5.1 first. Then, once they hit Linus' tree, the stable team will
> > > > > > pick them and backport them in the appropriate stable tree.
> > > 
> > > Hmm - so, I just booted linux 5.1.9, and this patch set is *still* missing from the kernel.
> > > 
> > > Is there anything that we can do about this?
> > 
> > What is the git commit id of the patch in Linus's tree?
> > 
> > As I said before, it can not be backported until it shows up there
> > first.
> > 
> 
> That would be:
> d43c17ead879ba7c076dc2f5fd80cd76047c9ff4
> 
> and
> 
> 39b3c3a5fbc5d744114e497d35bf0c12f798c134

Thanks, now queued up.

greg k-h
