Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24171E170F
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 23:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgEYVYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 17:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbgEYVYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 17:24:45 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01D8C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 14:24:45 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id v128so17002075oia.7
        for <stable@vger.kernel.org>; Mon, 25 May 2020 14:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2REKkQ0+9wzALZQ2vEAXIYDQRAugIkA5PrpeAmeVq3o=;
        b=cioKX/B8uxTB/BNzT2xIzWWcCPoFp4Ba3Lw0lnS37u7ZECIrtBlIU+E4/1xKqV1p1l
         3jTMTRYxrBPlm9X8lFNLni1bXSGdwA7Y6+nC7q6a0dGVWf+z8qZ+2LUAmnWv+Z2WXDaB
         4N5fDpPliDdEyo27Dkpi5gI+7DqQ2ftVdpGu3VNjCfwUNACpbvIdNYE5k+z6+Lt/EOQ1
         Z1sbbqGJ0pc7YRoe3NZeczW38J3aKKYdR6lBGlaS1Mv0b1Jm9G9odupTNBadn2iOUSo+
         vzuDKvZO6TLqFZyklJjDj8w+P8GzkAr1+EoMv13/LvZ+GwbZurVQHe9TFvgt3IBU75cP
         WaWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2REKkQ0+9wzALZQ2vEAXIYDQRAugIkA5PrpeAmeVq3o=;
        b=HXhGz9X4VUc7us+Q+S+0y/+RXY/+roo6b9t9R5nG1dY5o8SaNmVhBtGkyTgCvJHmfe
         Q7sHeqBhdChrhr3aTF1Bc348SUXnYAVQy4cQcTm2OBgMGlcWXmDrXLlytfTh0QIYxIt2
         pMPIyfXJMqRWNbJiFpBfgZFgYzjvlqzt7jEmngHhUdtLZZJhncz1s7VnGyywZ9lWCY94
         VNLOmPCpRXMsEspt6kS/GSO0a3tOXb+o8US8RD5EkrxWgEE29F8xlLtlr9DBL8wfB1Ib
         /Ub8sulubezuJdL+7rXuyktvrfcdKzuhfEfVyZZqMWoprwwVta0vAQOHyP8rmnHPInFR
         R3dQ==
X-Gm-Message-State: AOAM532AjQ2YQfoTmzb6lFJnTotbco3RUDpdnN+vAslt1rCipxf6bfwX
        fHQH8Y2F03sTzW1fm1xGH7240las4UEjtSHCRvr69g==
X-Google-Smtp-Source: ABdhPJyDhRe+m8fl0nMmLosEMQq4n3HHMqaTbbTOSoq/Vby/AqjWBl5Mw/Od4N/3fCXcXeVGLLzUvg4l9YMfN5PWKv0=
X-Received: by 2002:aca:d0d:: with SMTP id 13mr4271871oin.172.1590441884629;
 Mon, 25 May 2020 14:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200518080327.GA3126260@kroah.com> <20200519063000.128819-1-saravanak@google.com>
 <20200522204120.3b3c9ed6@apollo> <CAGETcx85trw=rCM1+dmemMGKstFCq=Nn7HR2fyDyV0rTTQYtEQ@mail.gmail.com>
 <41760105c011f9382f4d5fdc9feed017@walle.cc> <86f3036b44941870d12e432948a7cbb6@walle.cc>
 <CAGETcx-MbMXz-vw_1+EPKQMdeWXNFvhiP2UAJN=-563Y25VJDw@mail.gmail.com> <670bc1695b7bd45c19af1e5bb39fe896@walle.cc>
In-Reply-To: <670bc1695b7bd45c19af1e5bb39fe896@walle.cc>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 25 May 2020 14:24:08 -0700
Message-ID: <CAGETcx-4NURYve-cTy3GTExiKJ_QR1uRTqhDEYLmCuiXy8X5tg@mail.gmail.com>
Subject: Re: [PATCH v3] driver core: Fix SYNC_STATE_ONLY device link implementation
To:     Michael Walle <michael@walle.cc>
Cc:     stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 25, 2020 at 12:05 PM Michael Walle <michael@walle.cc> wrote:
>
> Am 2020-05-25 20:39, schrieb Saravana Kannan:
> > On Mon, May 25, 2020 at 4:31 AM Michael Walle <michael@walle.cc> wrote:
> >>
> >> Am 2020-05-23 00:47, schrieb Michael Walle:
> >> > Am 2020-05-23 00:21, schrieb Saravana Kannan:
> >> >> On Fri, May 22, 2020 at 11:41 AM Michael Walle <michael@walle.cc>
> >> >> wrote:
> >> >>>
> >> >>> Am Mon, 18 May 2020 23:30:00 -0700
> >> >>> schrieb Saravana Kannan <saravanak@google.com>:
> >> >>>
> >> >>> > When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
> >> >>> > core: Add device link support for SYNC_STATE_ONLY flag"),
> >> >>> > device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
> >> >>> > device link to the supplier's and consumer's "device link" list.
> >> >>> >
> >> >>> > This causes multiple issues:
> >> >>> > - The device link is lost forever from driver core if the caller
> >> >>> >   didn't keep track of it (caller typically isn't expected to). This
> >> >>> > is a memory leak.
> >> >>> > - The device link is also never visible to any other code path after
> >> >>> >   device_link_add() returns.
> >> >>> >
> >> >>> > If we fix the "device link" list handling, that exposes a bunch of
> >> >>> > issues.
> >> >>> >
> >> >>> > 1. The device link "status" state management code rightfully doesn't
> >> >>> > handle the case where a DL_FLAG_MANAGED device link exists between a
> >> >>> > supplier and consumer, but the consumer manages to probe successfully
> >> >>> > before the supplier. The addition of DL_FLAG_SYNC_STATE_ONLY links
> >> >>> > break this assumption. This causes device_links_driver_bound() to
> >> >>> > throw a warning when this happens.
> >> >>> >
> >> >>> > Since DL_FLAG_SYNC_STATE_ONLY device links are mainly used for
> >> >>> > creating proxy device links for child device dependencies and aren't
> >> >>> > useful once the consumer device probes successfully, this patch just
> >> >>> > deletes DL_FLAG_SYNC_STATE_ONLY device links once its consumer device
> >> >>> > probes. This way, we avoid the warning, free up some memory and avoid
> >> >>> > complicating the device links "status" state management code.
> >> >>> >
> >> >>> > 2. Creating a DL_FLAG_STATELESS device link between two devices that
> >> >>> > already have a DL_FLAG_SYNC_STATE_ONLY device link will result in the
> >> >>> > DL_FLAG_STATELESS flag not getting set correctly. This patch also
> >> >>> > fixes this.
> >> >>> >
> >> >>> > Lastly, this patch also fixes minor whitespace issues.
> >> >>>
> >> >>> My board triggers the
> >> >>>   WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
> >> >>>
> >> >>> Full bootlog:
> >> > [..]
> >> >
> >> >> Thanks for the log and report. I haven't spent too much time thinking
> >> >> about this, but can you give this a shot?
> >> >> https://lore.kernel.org/lkml/20200520043626.181820-1-saravanak@google.com/
> >> >
> >> > I've already tried that, as this is already in linux-next. Doesn't fix
> >> > it,
> >> > though.
> >>
> >> btw. this only happens on linux-next (tested with next-20200522), not
> >> on
> >> 5.7-rc7 (which has the same two patches of yours)
> >
> > I wouldn't be surprised if the difference is due to
> > fw_devlink_pause/resume() calls in driver/of/property.c. It chops off
> > ~1s in boot time by changing the order in which device links are
> > created from DT. So, I think it's just masking the issue.
> >
> > On linux-next where you see the issue, can you get the logs with this
> > change:
> > +++ b/drivers/base/core.c
> > @@ -907,7 +907,10 @@ void device_links_driver_bound(struct device *dev)
> >                          */
> >                         device_link_drop_managed(link);
> >                 } else {
> > -                       WARN_ON(link->status !=
> > DL_STATE_CONSUMER_PROBE);
> > +                       WARN(link->status != DL_STATE_CONSUMER_PROBE,
> > +                               "sup:%s - con:%s f:%d s:%d\n",
> > +                               dev_name(supplier),
> > dev_name(link->consumer),
> > +                               link->flags, link->status);
> >                         WRITE_ONCE(link->status, DL_STATE_ACTIVE);
> >                 }
> >
> > My goal is to figure out the order in which the device links between
> > the supplier and consumers devices are created and how that's changing
> > the flag and status. Then I can come up with a fix.
>
> Here we go (hopefully, my mail client won't screw up the line wrapping):

Thanks for the logs!

Ok, that definitely gave me some more info.
1. It's happening only for this iommu which in some cases can create
device links before fw_devlink through the use of
BUS_NOTIFY_ADD_DEVICE.
2. The issue doesn't seem to be between STATELESS and SYNC_STATE_ONLY
flags (because STATELESS flag is not set).
3. There seems to be a MANAGED link created by arm-smmu.c before/after
the SYNC_STATE_ONLY link is created.

In which case, the SYNC_STATE_ONLY link is supposed to be a NOP, but
that doesn't seem to be the case for some reason.

Can you add these debug messages and give me the logs? Hopefully
this'll be my last log request. I tried reproducing this in hardware I
have, but I couldn't reproduce it.

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -348,6 +348,10 @@ struct device_link *device_link_add(struct device
*consumer,
        if (flags & DL_FLAG_AUTOREMOVE_SUPPLIER)
                flags &= ~DL_FLAG_AUTOREMOVE_CONSUMER;

+       if (strstr(dev_name(supplier), "5000000.iommu")) {
+               dev_info(consumer, "Link attempted to %s 0x%x\n",
dev_name(supplier), flags);
+       }
+
        list_for_each_entry(link, &supplier->links.consumers, s_node) {
                if (link->consumer != consumer)
                        continue;
@@ -460,6 +464,10 @@ struct device_link *device_link_add(struct device
*consumer,
        dev_dbg(consumer, "Linked as a consumer to %s\n", dev_name(supplier));

 out:
+       if (strstr(dev_name(supplier), "5000000.iommu") && link) {
+               dev_info(consumer, "Link done to %s 0x%x %d\n",
dev_name(supplier), link->flags, link->status);
+       }
+
        device_pm_unlock();
        device_links_write_unlock();

Thanks,
Saravana
