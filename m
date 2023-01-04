Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6DB65CEF5
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 10:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbjADJCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 04:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238660AbjADJBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 04:01:36 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFE4B1E;
        Wed,  4 Jan 2023 01:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1672822849; x=1704358849;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+sboQuLLf8L8vEbmebrmtcbyrXlcTdugHxJikNm8Nas=;
  b=UchXKTskI8XRyYGWphksix3qJD0sItDJbGlDWZv6vYC0Ar15iQIu/PNY
   AUUrNEypVt/IFvUr6Dof9RUgF14Y0IEjBK4H5MZdXd4EvVhossxUigGUQ
   OakS2UWyIJZ4wYCa1PwTkiziVuSzDicrhV52XVYyTpA69GRkMUciyABUF
   8byFo1b83lyvnZQLp7lfYsHPevkFFC9C2fix58vrVS5RLq/59PQJkrqdC
   RMjdRwyoZr3BfrhLIfxGWtZjf2zKo0Ba0VXshiddN9lvNG1NXAm2QIX5p
   FcRnHAam8JACUeSJKuRSaZ28Ha0XSwiIjYjzYE0Xairpalzy6sSs1S3PA
   g==;
X-IronPort-AV: E=Sophos;i="5.96,299,1665439200"; 
   d="scan'208";a="28235618"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 04 Jan 2023 10:00:46 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 04 Jan 2023 10:00:46 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 04 Jan 2023 10:00:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1672822846; x=1704358846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+sboQuLLf8L8vEbmebrmtcbyrXlcTdugHxJikNm8Nas=;
  b=bEOldYHQoFwbGIPMPbW0sb5HKcXfH182EsXQrP6Bw8EF9XFCI7Y77XR6
   4eDtYxn56+hlLC5dNR5Nyjt/4iwoXrsjYwDAoMXtaFfZWDiBfkwNTuYtY
   29NkQiXj+asc8iCrzdejPX6+1kgSTvtIJcKygcxE04b6Q7/Zvl46Fp6Th
   R4y6+/gMVm8Cs6cUBdb2/uuy73zFNEA27tgZybqxe7H6DAB7x7qAl64pY
   VzlexG5Zlmz1DSEEbcVxFdpL/GonqxcKt1omZPqBPwhc5+tphw+eLmhB8
   LZ1a3/zHk/83K4DcUVEYIELNHsHoH6hU69GBsEEQjO1X7dgmYIIFSO9Mi
   g==;
X-IronPort-AV: E=Sophos;i="5.96,299,1665439200"; 
   d="scan'208";a="28235617"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 04 Jan 2023 10:00:45 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 9DF8D280056;
        Wed,  4 Jan 2023 10:00:45 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Doug Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>,
        Icenowy Zheng <uwu@icenowy.me>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform devices for DT nodes without 'vdd-supply'
Date:   Wed, 04 Jan 2023 10:00:43 +0100
Message-ID: <10807929.5MRjnR8RnV@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <Y7Rh+EkKKN5Gu8sz@google.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid> <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com> <Y7Rh+EkKKN5Gu8sz@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Matthias,

Am Dienstag, 3. Januar 2023, 18:12:24 CET schrieb Matthias Kaehlcke:
> On Thu, Dec 22, 2022 at 11:26:26AM -0800, Doug Anderson wrote:
> > Hi,
> > 
> > On Wed, Dec 21, 2022 at 6:26 PM Matthias Kaehlcke <mka@chromium.org> 
wrote:
> > > The primary task of the onboard_usb_hub driver is to control the
> > > power of an onboard USB hub. The driver gets the regulator from the
> > > device tree property "vdd-supply" of the hub's DT node. Some boards
> > > have device tree nodes for USB hubs supported by this driver, but
> > > don't specify a "vdd-supply". This is not an error per se, it just
> > > means that the onboard hub driver can't be used for these hubs, so
> > > don't create platform devices for such nodes.
> > > 
> > > This change doesn't completely fix the reported regression. It
> > > should fix it for the RPi 3 B Plus and boards with similar hub
> > > configurations (compatible DT nodes without "vdd-supply"), boards
> > > that actually use the onboard hub driver could still be impacted
> > > by the race conditions discussed in that thread. Not creating the
> > > platform devices for nodes without "vdd-supply" is the right
> > > thing to do, independently from the race condition, which will
> > > be fixed in future patch.
> > > 
> > > Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> > > Link:
> > > https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com
> > > / Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> > > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > > ---
> > > 
> > > Changes in v2:
> > > - don't create platform devices when "vdd-supply" is missing,
> > > 
> > >   rather than returning an error from _find_onboard_hub()
> > > 
> > > - check for "vdd-supply" not "vdd" (Johan)
> > > - updated subject and commit message
> > > - added 'Link' tag (regzbot)
> > > 
> > >  drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > 
> > I'm a tad bit skeptical.
> > 
> > It somehow feels a bit too much like "inside knowledge" to add this
> > here. I guess the "onboard_usb_hub_pdevs.c" is already pretty
> > entangled with "onboard_usb_hub.c", but I'd rather the "pdevs" file
> > keep the absolute minimum amount of stuff in it and all of the details
> > be in the other file.
> > 
> > If this was the only issue though, I'd be tempted to let it slide. As
> > it is, I'm kinda worried that your patch will break Alexander Stein,
> > who should have been CCed (I've CCed him now) or Icenowy Zheng (also
> > CCed now). I believe those folks are using the USB hub driver
> > primarily to drive a reset GPIO. Looking at the example in the
> > bindings for one of them (genesys,gl850g.yaml), I even see that the
> > reset-gpio is specified but not a vdd-supply. I think you'll break
> > that?
> 
> Thanks for pointing that out. My assumption was that the regulator is
> needed for the driver to do anything useful, but you are right, the
> reset GPIO alone could be used in combination with an always-on regulator
> to 'switch the hub on and off'.
> 
> > In general, it feels like it should actually be fine to create the USB
> > hub driver even if vdd isn't supplied. Sure, it won't do a lot, but it
> > shouldn't actively hurt anything. You'll just be turning off and on
> > bogus regulators and burning a few CPU cycles. I guess the problem is
> > some race condition that you talk about in the commit message. I'd
> > rather see that fixed...
> 
> Yes, the race conditions needs to be fixed as well, I didn't have enough
> time to write and test a patch before taking a longer break for the
> holidays, so I only sent out this (supposed) partial mitigation.
> 
> > That being said, if we want to be more efficient and not burn CPU cycles
> > and memory in Stefan Wahren's case, maybe the USB hub driver itself could
> > return a canonical error value from its probe when it detects that it has
> > no useful job and then "onboard_usb_hub_pdevs" could just silently bail
> > out?
> 
> _probe() could return an error, however onboard_hub_create_pdevs() can't
> rely on that, since the actual onboard_hub driver might not have been
> loaded yet when the function is called.
> 
> It would be nice not to instantiate the pdev and onboard_hub USB instances
> if the DT node has neither a 'vdd-supply' nor 'reset-gpios'. If we aren't
> ok with doing that in onboard_hub_create_pdevs() then at least the 'raw'
> platform device would be created. onboard_hub_probe() could still
> bail if both properties are absent, _find_onboard_hub() would have to
> check it again to avoid the deferred probing 'loop' for the USB instances.

I'm not really fond of checking for optional features like 'vdd-supply' and 
'reset-gpios'. This issue will pop up again if some new optional feature is 
added again, e.g. power-domains.

> Alternatively we could 'just' fix the race condition involving the 'attach
> work' and the onboard_hub driver is fully instantiated even on (certain)
> boards where it does nothing. It's relatively rare that USB hub nodes are
> specified in the DT (unless the intention is to use this driver) and
> CONFIG_USB_ONBOARD_HUB needs to be set for the instances to be created,
> so maybe creating the useless instances is not such a big deal.

IMHO creating a pdev shouldn't harm in any case. It's similar to having a DT 
node without a corresponding driver enabled or even existing. Also adding USB 
devices to DT is something which is to be expected. usb-device.yaml exists 
since 2020 and the txt version since 2016.
Unfortunately I'm not able to reproduce this issue on a different platform 
where the same HUB but no reset-gpios is required. I also noticed that 
onboard-usb-hub raises the error
> Failed to attach USB driver: -22
for each hub it is supposed to support.

Best regards,
Alexander



