Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF506734DC
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 10:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjASJzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 04:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjASJzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 04:55:54 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3D55D106
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 01:55:53 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 20so1880945ybl.0
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 01:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gUMk1/bi5g5h2y9BS6a518UMzb1yi0+ArEb6kSFCYTA=;
        b=hxk7z6pogAGXNsbFa2NUorj+q891Jf2Kx66+E9euuWPJgOu31CzAc9Sguknk6DcRrc
         k6BfM7NV2ImBfVJBNSMtKxArPi69QhV4lZCgVkwgXRlylXxAREtRNfatWdnETIvDn0DN
         BET2w4ie5jTYs8hkxvuTye8meojQ9lV3CRf6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gUMk1/bi5g5h2y9BS6a518UMzb1yi0+ArEb6kSFCYTA=;
        b=0U3BVGZBsLZo38VAjkkbkSWvn3ZyaAcLbvLOX6iEDPT3A+NhIjRpe3ZYLc2hGVqqfq
         HM8akuFbpyWVWyC+KfaBcc46jAvPHz3oG5ESATasOi6tFEtLtv3CKnw5B0QG28N/IUEB
         9yOF1VcVtu5ILx0UJWnSv+ALAFf448mF5TPU24ogsyeQ1XjgSF0w1fYI6lQQjVOhHhpf
         xni3LfidFeAHMJD7HOty1NuhQmSwB9AWIkYtiMQa1C8Un4v/zCZVa2GBILxY7hrW6AV/
         JD+MwAFlcNP0+9fGK4cdu1aybLt/7xEZai5JYcOmjKRpwWV5b3b83HnDXLCil4UB/ohn
         npmg==
X-Gm-Message-State: AFqh2koZrDzE1uw0vIhg7MeIjiqBZ/8fENhSRoxQwkHYDXerufnntJYY
        1qVgGzVo98+Gqos5IsNM62nNZcmh2Ay1gs+zaP4/rg==
X-Google-Smtp-Source: AMrXdXu2wOZm8SvlpFm+Y/g4LaM8lC0oZde0PPAZDmHwD9+lPipdeWVB/AmiwXG2X1HAKRYLf4v4bAA0huQL41e10JQ=
X-Received: by 2002:a5b:384:0:b0:7d2:ea96:9038 with SMTP id
 k4-20020a5b0384000000b007d2ea969038mr1011610ybp.56.1674122152439; Thu, 19 Jan
 2023 01:55:52 -0800 (PST)
MIME-Version: 1.0
References: <20230118031514.1278139-1-pmalani@chromium.org>
 <Y8e+YlKiC6FHdQ5s@kuha.fi.intel.com> <CACeCKafPzxYWh5a4xmeggc+4zRou73kHnwV-G5xMfQDheGgGdg@mail.gmail.com>
 <Y8kMsw/wT35KN7VK@kuha.fi.intel.com>
In-Reply-To: <Y8kMsw/wT35KN7VK@kuha.fi.intel.com>
From:   Prashant Malani <pmalani@chromium.org>
Date:   Thu, 19 Jan 2023 01:55:41 -0800
Message-ID: <CACeCKaceu1KCPtpavBn23qyM29Eacxhm6L9SN78ZQxdzRCOk6Q@mail.gmail.com>
Subject: Re: [PATCH] usb: typec: altmodes/displayport: Update active state
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 19, 2023 at 1:26 AM Heikki Krogerus
<heikki.krogerus@linux.intel.com> wrote:
>
> Hi Prashant,
>
> On Wed, Jan 18, 2023 at 10:26:21AM -0800, Prashant Malani wrote:
> > Hi Heikki,
> >
> > Thanks for reviewing the patch.
> >
> > On Wed, Jan 18, 2023 at 1:39 AM Heikki Krogerus
> > <heikki.krogerus@linux.intel.com> wrote:
> > >
> > > On Wed, Jan 18, 2023 at 03:15:15AM +0000, Prashant Malani wrote:
> > FWIW, I think we can make the typec_altmode_update_active() calls from
> > our (cros-ec-typec) port driver too, but displayport.c is parsing the header
> > anyway, so it seemed repetitive. Just wanted to clarify the intention here.
>
> The alt modes may have been entered even if there are no drivers for
> them, if for example the PD controller handles the mode entry. In
> those cases the port driver needs to update the active state of the
> partner alt mode.

Ack. Thanks for explaining the rationale here.

>
> Since the port drivers have to handle that in some cases, for the sake
> of consistency I thought that they might as well take care of it in
> every case.
>
> On the other hand, it should be safe to do it in both the port driver
> and the altmode driver.
>
> If you prefer that the altmode drivers always do this, I'm not against
> it. But in that case could you patch tcpm.c while at it - in the same
> series:

Sure, I will send out a v2 with the below diff as Patch 2/2 (I will mark you as
"Suggested-by" but as always LMK if you prefer another way to
denote attribution).

>
> diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> index 904c7b4ce2f0c..0f5a9d4db105a 100644
> --- a/drivers/usb/typec/tcpm/tcpm.c
> +++ b/drivers/usb/typec/tcpm/tcpm.c
> @@ -1693,14 +1693,11 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
>                         }
>                         break;
>                 case CMD_ENTER_MODE:
> -                       if (adev && pdev) {
> -                               typec_altmode_update_active(pdev, true);
> +                       if (adev && pdev)
>                                 *adev_action = ADEV_QUEUE_VDM_SEND_EXIT_MODE_ON_FAIL;
> -                       }
>                         return 0;
>                 case CMD_EXIT_MODE:
>                         if (adev && pdev) {
> -                               typec_altmode_update_active(pdev, false);
>                                 /* Back to USB Operation */
>                                 *adev_action = ADEV_NOTIFY_USB_AND_QUEUE_VDM;
>                                 return 0;
>
> That's the only driver that will definitely always requires the
> altmode drivers, so perhaps it would be good to drop the calls
> from it at the same time.
>
> thanks,
>
> --
> heikki
