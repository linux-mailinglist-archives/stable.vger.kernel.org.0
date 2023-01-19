Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EE767352D
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 11:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjASKMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 05:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjASKMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 05:12:34 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D2B66FBE
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 02:12:32 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id c124so1811211ybb.13
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 02:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QXqwQrSwt+StZdyqV9+cOyJ8Y9ygdXIHln0bwVMaadk=;
        b=VbKLGzTUd+ENkWd/TQLrCp+xkGy68MxxMR6IOzx+XVxV21bj/k70RYjkY6nf1T8f8x
         i0h7O4r1qb2vIuE9I1KvAEZ1Y/0jAB3V+S9eeQGE4MbLSBxabtOEODMkzs0m0Rj8o41Q
         4QoEwPOkJILFtrZwswLmkP35CCDz1lUADGscA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QXqwQrSwt+StZdyqV9+cOyJ8Y9ygdXIHln0bwVMaadk=;
        b=qllzraxOwFGO/nEjj6rU789blt+dT6Rh4XdAfvYqBU/F8NzEC99pvNu/robOLpO7qJ
         6U3nY6j1B27ONIq4wlUx24Ac7OF+fHJIZG2Ikl26EWV8cqiDOgmB0vo/Ol2mY3H8qiVN
         Dgug9tevHY2B7Zf3XkimwcA1v5kO8WgF3DVISKVZ04YbGrAEiy5X/dUMM53RMcEMGagV
         Td+/DpYwcyJLy5vC+xsFLq6Kv9AslGgvWnTj/4UsI1YHZsQryKQnLmNp4b5M0MtdBl3P
         dFTD+hkOELYy2EWs+kmdY67FOHeyAql7edVbvauJqlsovSmR5Y3ov7hibVne/wsxAr6p
         HhPg==
X-Gm-Message-State: AFqh2kppMgn1ZXLxZ0dPIANnVjCpwkhErPRLRzM0ABkIV/gUM3KGC5Mp
        SP8uMoT/EXX/bQuCg3/FY7y6G9CrEydn9rF00kAjcyjsAPoiE6H8
X-Google-Smtp-Source: AMrXdXvn5sXL9TBsaUCiuAQ2d3cwIL8V0Gcd7yA+ccZmzJCC62ULWrvqai0dRL8hECGtW5TCsxz1GtUu0m1Ifsyn1uY=
X-Received: by 2002:a05:6902:90e:b0:7c8:3a6f:9b7b with SMTP id
 bu14-20020a056902090e00b007c83a6f9b7bmr1254860ybb.88.1674123151869; Thu, 19
 Jan 2023 02:12:31 -0800 (PST)
MIME-Version: 1.0
References: <20230118031514.1278139-1-pmalani@chromium.org>
 <Y8e+YlKiC6FHdQ5s@kuha.fi.intel.com> <CACeCKafPzxYWh5a4xmeggc+4zRou73kHnwV-G5xMfQDheGgGdg@mail.gmail.com>
 <Y8kMsw/wT35KN7VK@kuha.fi.intel.com> <CACeCKaceu1KCPtpavBn23qyM29Eacxhm6L9SN78ZQxdzRCOk6Q@mail.gmail.com>
In-Reply-To: <CACeCKaceu1KCPtpavBn23qyM29Eacxhm6L9SN78ZQxdzRCOk6Q@mail.gmail.com>
From:   Prashant Malani <pmalani@chromium.org>
Date:   Thu, 19 Jan 2023 02:12:20 -0800
Message-ID: <CACeCKaea_ZtzUZNAHMaDU9ff_BBs6sF_DqqMnkFcW_=_txVL4w@mail.gmail.com>
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

On Thu, Jan 19, 2023 at 1:55 AM Prashant Malani <pmalani@chromium.org> wrote:
>
> On Thu, Jan 19, 2023 at 1:26 AM Heikki Krogerus
> <heikki.krogerus@linux.intel.com> wrote:
> >
> > Hi Prashant,
> >
> > On Wed, Jan 18, 2023 at 10:26:21AM -0800, Prashant Malani wrote:
> > > Hi Heikki,
> > >
> > > Thanks for reviewing the patch.
> > >
> > > On Wed, Jan 18, 2023 at 1:39 AM Heikki Krogerus
> > > <heikki.krogerus@linux.intel.com> wrote:
> > > >
> > > > On Wed, Jan 18, 2023 at 03:15:15AM +0000, Prashant Malani wrote:
> > > FWIW, I think we can make the typec_altmode_update_active() calls from
> > > our (cros-ec-typec) port driver too, but displayport.c is parsing the header
> > > anyway, so it seemed repetitive. Just wanted to clarify the intention here.
> >
> > The alt modes may have been entered even if there are no drivers for
> > them, if for example the PD controller handles the mode entry. In
> > those cases the port driver needs to update the active state of the
> > partner alt mode.
>
> Ack. Thanks for explaining the rationale here.
>
> >
> > Since the port drivers have to handle that in some cases, for the sake
> > of consistency I thought that they might as well take care of it in
> > every case.
> >
> > On the other hand, it should be safe to do it in both the port driver
> > and the altmode driver.
> >
> > If you prefer that the altmode drivers always do this, I'm not against
> > it. But in that case could you patch tcpm.c while at it - in the same
> > series:
>
> Sure, I will send out a v2 with the below diff as Patch 2/2 (I will mark you as
> "Suggested-by" but as always LMK if you prefer another way to
> denote attribution).
>
> >
> > diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
> > index 904c7b4ce2f0c..0f5a9d4db105a 100644
> > --- a/drivers/usb/typec/tcpm/tcpm.c
> > +++ b/drivers/usb/typec/tcpm/tcpm.c
> > @@ -1693,14 +1693,11 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
> >                         }
> >                         break;
> >                 case CMD_ENTER_MODE:
> > -                       if (adev && pdev) {
> > -                               typec_altmode_update_active(pdev, true);
> > +                       if (adev && pdev)
> >                                 *adev_action = ADEV_QUEUE_VDM_SEND_EXIT_MODE_ON_FAIL;
> > -                       }
> >                         return 0;
> >                 case CMD_EXIT_MODE:
> >                         if (adev && pdev) {
> > -                               typec_altmode_update_active(pdev, false);
> >                                 /* Back to USB Operation */
> >                                 *adev_action = ADEV_NOTIFY_USB_AND_QUEUE_VDM;
> >                                 return 0;
> >
> > That's the only driver that will definitely always requires the
> > altmode drivers, so perhaps it would be good to drop the calls
> > from it at the same time.

On 2nd thought, would it be safe to drop the calls in tcpm.c ? Following
on from your PD controller example above, TCPM might be updating
the active state for an altmode which doesn't have an altmode driver
registered? Or does it only send out ENTER_MODE for alt modes
which have an altmode driver?

(Sorry if this is obvious to TCPM users, but I wanted to confirm before
proceeding with a v2).

> >
> > thanks,
> >
> > --
> > heikki
