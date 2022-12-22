Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EFD65468F
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 20:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiLVT07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 14:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbiLVT0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 14:26:48 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1084713CF0
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 11:26:43 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id tz12so7166560ejc.9
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 11:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lkdYIiBNbyRc3wXAS6hL3mE7JDUZXVb9wv49/R8RZ1o=;
        b=QjvDiBT3HDQwH55j4taVz50qSDVwDb0rXUszHBIV2H0TPA0Vzy83NZty7fbrE/OvX1
         ybNEcUMQUG66j+YAu0Fh1wyKZw6GDIMvwa5da3ajXpLHw8qLXvUALin6k9nQTxVMJ/+E
         O+7KB1YLYM84TsSHAXT5g7tDcQXZJceeQKyqk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lkdYIiBNbyRc3wXAS6hL3mE7JDUZXVb9wv49/R8RZ1o=;
        b=P9fQ3fYL58ogMm6cBcXprHksZKsEy2bSqs48xFS6axkbk54YcwM3c12BWSfipeo8RK
         q4TdjnEt1YW3167Fy5Ig97ZKt6OvANPOhn6AOBD3vLnsI0pAtNGyyNdO/T93hXxaZAAx
         l5FOmZUQ24KqwlShRCUrbQF5YYJs1M6iLcaeQLwzZMcnYjZz4VWe07Im4gS4tM34qg33
         gOahtx5ZTH29hes5NEvQ6WuVjD7idHFg4NAIOdEcInFOc373Do+YfnkZS5HzI+YVLczm
         zYgoJUb3XOzIF5gQQ/srjU/tsq4jHL/fNGp3Cv1m9He0TYoOa5bh+5nP/zRZEUf3HTvo
         +a3g==
X-Gm-Message-State: AFqh2krpSBOc+lYvVwh3OzY183br1weovd/75YxlHw25vB00c4QoUFLC
        jmeIRHurSN7M/Y28akA5dEMjBcQq/WawD82oG8g=
X-Google-Smtp-Source: AMrXdXvUfuRS7ABKZ/F98F6FvEPggHVxKywyFymzdxoOXrryQoABiCo8RodaanLvpntOcQSrF/U8Gw==
X-Received: by 2002:a17:906:a842:b0:816:ef2a:631a with SMTP id dx2-20020a170906a84200b00816ef2a631amr5507200ejb.31.1671737202396;
        Thu, 22 Dec 2022 11:26:42 -0800 (PST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id kv11-20020a17090778cb00b007b4bc423b41sm532340ejc.190.2022.12.22.11.26.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 11:26:41 -0800 (PST)
Received: by mail-wr1-f53.google.com with SMTP id o5so2659522wrm.1
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 11:26:39 -0800 (PST)
X-Received: by 2002:a05:6000:1f9c:b0:26f:7de2:a55e with SMTP id
 bw28-20020a0560001f9c00b0026f7de2a55emr192058wrb.617.1671737199562; Thu, 22
 Dec 2022 11:26:39 -0800 (PST)
MIME-Version: 1.0
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
In-Reply-To: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 22 Dec 2022 11:26:26 -0800
X-Gmail-Original-Message-ID: <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com>
Message-ID: <CAD=FV=XNxZ3iDYAAqKWqDVLihJ63Du4L7kDdKO55avR9nghc5A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>, stable@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Icenowy Zheng <uwu@icenowy.me>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Dec 21, 2022 at 6:26 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>
> The primary task of the onboard_usb_hub driver is to control the
> power of an onboard USB hub. The driver gets the regulator from the
> device tree property "vdd-supply" of the hub's DT node. Some boards
> have device tree nodes for USB hubs supported by this driver, but
> don't specify a "vdd-supply". This is not an error per se, it just
> means that the onboard hub driver can't be used for these hubs, so
> don't create platform devices for such nodes.
>
> This change doesn't completely fix the reported regression. It
> should fix it for the RPi 3 B Plus and boards with similar hub
> configurations (compatible DT nodes without "vdd-supply"), boards
> that actually use the onboard hub driver could still be impacted
> by the race conditions discussed in that thread. Not creating the
> platform devices for nodes without "vdd-supply" is the right
> thing to do, independently from the race condition, which will
> be fixed in future patch.
>
> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> Link: https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com/
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>
> Changes in v2:
> - don't create platform devices when "vdd-supply" is missing,
>   rather than returning an error from _find_onboard_hub()
> - check for "vdd-supply" not "vdd" (Johan)
> - updated subject and commit message
> - added 'Link' tag (regzbot)
>
>  drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

I'm a tad bit skeptical.

It somehow feels a bit too much like "inside knowledge" to add this
here. I guess the "onboard_usb_hub_pdevs.c" is already pretty
entangled with "onboard_usb_hub.c", but I'd rather the "pdevs" file
keep the absolute minimum amount of stuff in it and all of the details
be in the other file.

If this was the only issue though, I'd be tempted to let it slide. As
it is, I'm kinda worried that your patch will break Alexander Stein,
who should have been CCed (I've CCed him now) or Icenowy Zheng (also
CCed now). I believe those folks are using the USB hub driver
primarily to drive a reset GPIO. Looking at the example in the
bindings for one of them (genesys,gl850g.yaml), I even see that the
reset-gpio is specified but not a vdd-supply. I think you'll break
that?

In general, it feels like it should actually be fine to create the USB
hub driver even if vdd isn't supplied. Sure, it won't do a lot, but it
shouldn't actively hurt anything. You'll just be turning off and on
bogus regulators and burning a few CPU cycles. I guess the problem is
some race condition that you talk about in the commit message. I'd
rather see that fixed... That being said, if we want to be more
efficient and not burn CPU cycles and memory in Stefan Wahren's case,
maybe the USB hub driver itself could return a canonical error value
from its probe when it detects that it has no useful job and then
"onboard_usb_hub_pdevs" could just silently bail out?
