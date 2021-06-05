Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2061339C65B
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 08:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhFEGpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 02:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFEGpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Jun 2021 02:45:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C0F061380;
        Sat,  5 Jun 2021 06:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622875414;
        bh=TtRDgCW7OQ1zC3hQd1LY9Z/qTlTG9FRmSnSfEj5iwp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1+SThqw8h3ikUWbPOVEdqdULG5Hgdn/wqmaXQlXN4g+vcHHQF0USqMoEcVM7kF/aC
         nrwUW42x9XbF0DZtg2xT2j1W5jeW4goQ6uwT9UtmEj2nDIKCnDXdpB3X+OTGxsjJfb
         B1nDJSzTGMxLziHsBbovlo2ki1qKye1gUle+RwxI=
Date:   Sat, 5 Jun 2021 08:43:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pascal Giard <pascal.giard@etsmtl.ca>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Nguyen <daniel.nguyen.1@ens.etsmtl.ca>
Subject: Re: [PATCH] HID: sony: fix freeze when inserting ghlive ps3/wii
 dongles
Message-ID: <YLsdEtbAWJxLB+GF@kroah.com>
References: <20210604161023.1498582-1-pascal.giard@etsmtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604161023.1498582-1-pascal.giard@etsmtl.ca>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 04, 2021 at 12:10:23PM -0400, Pascal Giard wrote:
> This commit fixes a freeze on insertion of a Guitar Hero Live PS3/WiiU
> USB dongle. Indeed, with the current implementation, inserting one of
> those USB dongles will lead to a hard freeze. I apologize for not
> catching this earlier, it didn't occur on my old laptop.
> 
> While the issue was isolated to memory alloc/free, I could not figure
> out why it causes a freeze. So this patch fixes this issue by
> simplifying memory allocation and usage.
> 
> We remind that for the dongle to work properly, a control URB needs to
> be sent periodically. We used to alloc/free the URB each time this URB
> needed to be sent.
> 
> With this patch, the memory for the URB is allocated on the probe, reused
> for as long as the dongle is plugged in, and freed once the dongle is
> unplugged.
> 
> Signed-off-by: Pascal Giard <pascal.giard@etsmtl.ca>
> ---
>  drivers/hid/hid-sony.c | 98 +++++++++++++++++++++---------------------
>  1 file changed, 49 insertions(+), 49 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
