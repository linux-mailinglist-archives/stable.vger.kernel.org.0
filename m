Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278A765B369
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 15:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbjABOit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 09:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjABOiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 09:38:23 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0121300;
        Mon,  2 Jan 2023 06:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1672670302; x=1704206302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nS3cdjPCgxeWFQVGp6kkWcgS22f4xwfU4K6Ctd7cTms=;
  b=oYWf+GfQ6qerBMn/bTPt7tem6AzHkm285PPGqk2K92Xn6aVr04myBNRF
   eC65c03RRJVy/WbaurdrtMPekl4n9ef2uvcPshKNfGAAb+ESAWyHnA2yh
   9Ae34nqZ5IkvtN7Yp1UgJhTJZdkbm0SOCySR57XPKhhq5M9weMfIyJO77
   41Gnbo4lNOsBjnNOW7EgyUoIHm9MfXlzl2vOBNZGsP7iPAcSPYIoXCybD
   cIQfnBCiPombdD/592NMPOQbbcQYeFh1EqPVI4MaYf5lk2e4hOUcQRgP0
   ujknk/m+VqAF/YFt7s++mN9yBzoVBBMvWBgfXi7H+tHqThDAjDWFhLF1l
   A==;
X-IronPort-AV: E=Sophos;i="5.96,294,1665439200"; 
   d="scan'208";a="28206221"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 02 Jan 2023 15:38:19 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 02 Jan 2023 15:38:20 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 02 Jan 2023 15:38:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1672670299; x=1704206299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nS3cdjPCgxeWFQVGp6kkWcgS22f4xwfU4K6Ctd7cTms=;
  b=Lfs1+oj2lWB6O+HBqVOIYFZieNP4UIPe3F87t6OyyHvNFJydeeMtu6Nh
   i2mmJrB/x6ZwhkdBDLXbgLkWDJT90eNAgS0iSAR+r2GB+hCWUwcLGafnL
   Qn4MHXtyBZ3AJdDTrG2klMMQfH66czVbUkqw8j6YjUgwXihLE+kP5IVFS
   CcAFWcXK0kJ6d3de921LYSuYbmHKTTpFaLLzz41eHT40VzK6BWPM01Rzn
   aopd7wzuOtrpd7Di3LxKvH1+6al+g4H1vkFS9JtQq8fmS2J++V/zEmYFD
   0uwxFEdRMb09woaRWDdCXvtAANBzSrs+j0GdGpivcerpvz4B3P2SMNGR6
   g==;
X-IronPort-AV: E=Sophos;i="5.96,294,1665439200"; 
   d="scan'208";a="28206220"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 02 Jan 2023 15:38:19 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id AAAE6280056;
        Mon,  2 Jan 2023 15:38:19 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Doug Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Icenowy Zheng <uwu@icenowy.me>,
        Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform devices for DT nodes without 'vdd-supply'
Date:   Mon, 02 Jan 2023 15:38:19 +0100
Message-ID: <1783674.3VsfAaAtOV@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <fdfe4b3c-1e7c-b9d5-6173-ce2c0e8dd52b@i2se.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid> <3724284.kQq0lBPeGt@steina-w> <fdfe4b3c-1e7c-b9d5-6173-ce2c0e8dd52b@i2se.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Stefan,

Am Montag, 2. Januar 2023, 12:44:33 CET schrieb Stefan Wahren:
> Hello Alexander,
>=20
> Am 02.01.23 um 10:20 schrieb Alexander Stein:
> > Hi everybody,
> >=20
> > Am Freitag, 23. Dezember 2022, 08:46:45 CET schrieb Icenowy Zheng:
> >> =E5=9C=A8 2022-12-22=E6=98=9F=E6=9C=9F=E5=9B=9B=E7=9A=84 11:26 -0800=
=EF=BC=8CDoug Anderson=E5=86=99=E9=81=93=EF=BC=9A
> >>=20
> >>> Hi,
> >>>=20
> >>> On Wed, Dec 21, 2022 at 6:26 PM Matthias Kaehlcke <mka@chromium.org>
> >>>=20
> >>> wrote:
> >>>> The primary task of the onboard_usb_hub driver is to control the
> >>>> power of an onboard USB hub. The driver gets the regulator from the
> >>>> device tree property "vdd-supply" of the hub's DT node. Some boards
> >>>> have device tree nodes for USB hubs supported by this driver, but
> >>>> don't specify a "vdd-supply". This is not an error per se, it just
> >>>> means that the onboard hub driver can't be used for these hubs, so
> >>>> don't create platform devices for such nodes.
> >>>>=20
> >>>> This change doesn't completely fix the reported regression. It
> >>>> should fix it for the RPi 3 B Plus and boards with similar hub
> >>>> configurations (compatible DT nodes without "vdd-supply"), boards
> >>>> that actually use the onboard hub driver could still be impacted
> >>>> by the race conditions discussed in that thread. Not creating the
> >>>> platform devices for nodes without "vdd-supply" is the right
> >>>> thing to do, independently from the race condition, which will
> >>>> be fixed in future patch.
> >>>>=20
> >>>> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> >>>> Link:
> >>>> https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.=
com
> >>>> /
> >>>> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> >>>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> >>>> ---
> >>>>=20
> >>>> Changes in v2:
> >>>> - don't create platform devices when "vdd-supply" is missing,
> >>>>=20
> >>>>    rather than returning an error from _find_onboard_hub()
> >>>>=20
> >>>> - check for "vdd-supply" not "vdd" (Johan)
> >>>> - updated subject and commit message
> >>>> - added 'Link' tag (regzbot)
> >>>>=20
> >>>>   drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
> >>>>   1 file changed, 13 insertions(+)
> >>>=20
> >>> I'm a tad bit skeptical.
> >>>=20
> >>> It somehow feels a bit too much like "inside knowledge" to add this
> >>> here. I guess the "onboard_usb_hub_pdevs.c" is already pretty
> >>> entangled with "onboard_usb_hub.c", but I'd rather the "pdevs" file
> >>> keep the absolute minimum amount of stuff in it and all of the
> >>> details
> >>> be in the other file.
> >>>=20
> >>> If this was the only issue though, I'd be tempted to let it slide. As
> >>> it is, I'm kinda worried that your patch will break Alexander Stein,
> >>> who should have been CCed (I've CCed him now) or Icenowy Zheng (also
> >>> CCed now). I believe those folks are using the USB hub driver
> >>> primarily to drive a reset GPIO. Looking at the example in the
> >>> bindings for one of them (genesys,gl850g.yaml), I even see that the
> >>> reset-gpio is specified but not a vdd-supply. I think you'll break
> >>> that?
> >>=20
> >> Well technically in my final DT a regulator is included (to have the
> >> Vbus enabled when enabling the hub), however I am still against this
> >> patch, because the driver should work w/o vdd-supply (or w/o reset-
> >> gpios), and changing this behavior is a DT binding stability breakage.
> >=20
> > I second that. The bindings don't require neither vdd-supply nor
> > reset-gpios.
> >=20
> > But I have to admit I lack to understand the purpose of this series in =
the
> > first place. What is the benefit or fix?
>=20
> did you followed the provided link from the patch?

Ah, I didn't notice that. Thanks. Admittedly I've yet to fully understand t=
hat=20
race condition, but Matthias already suspects this series might not be enou=
gh,=20
even for boards which do use vdd-supply.

Just for the record, this series breaks my board if, as suspected by Doug=20
Anderson and Icenowy Zheng, there is no vdd-supply. The reset line will nev=
er=20
be touched.

Best regards,
Alexander

> Best regards
>=20
> > Best regards,
> > Alexader
> >=20
> >> In addition the kernel never fails because of a lacking regulator
> >> unless explicitly forbid dummy regulators.
> >>=20
> >> BTW USB is a discoverable bus, and if a hub do not need special
> >> handlement, it just does not need to appear in the DT, thus no onboard
> >> hub DT node.
> >>=20
> >>> In general, it feels like it should actually be fine to create the
> >>> USB
> >>> hub driver even if vdd isn't supplied. Sure, it won't do a lot, but
> >>> it
> >>> shouldn't actively hurt anything. You'll just be turning off and on
> >>> bogus regulators and burning a few CPU cycles. I guess the problem is
> >>> some race condition that you talk about in the commit message. I'd
> >>> rather see that fixed... That being said, if we want to be more
> >>> efficient and not burn CPU cycles and memory in Stefan Wahren's case,
> >>> maybe the USB hub driver itself could return a canonical error value
> >>> from its probe when it detects that it has no useful job and then
> >>> "onboard_usb_hub_pdevs" could just silently bail out?
> >>=20
> >> I agree.




