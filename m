Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3354EDF43
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbiCaRAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 13:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240385AbiCaRAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 13:00:45 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74C630544
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 09:58:56 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id c10so533609ejs.13
        for <stable@vger.kernel.org>; Thu, 31 Mar 2022 09:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vAUEMGVmv3luLDWumw9EYzVQpWz4Yr1CWqgaSqnZceQ=;
        b=NxK1KH708VkNCN6yrS/zDO82xolgnN7kkPj7X1YytO28mDVTKJBEFJx3VvaL3d1fdP
         qxw5cXxAfhhwYD/F+PcdC4velYOARzlkSV6AhhZpCmVoKdzRsDm57fvefERVft6Z6nyZ
         A9dWNcLRQL9aFMDsrfGMmT6U5iHlWRtp+7BnOv1iuslsPDeDu88VVxmZFk1dKX8uNb1m
         FhHTW6gn+ffW2U8DZmSYMOYiByBFAWmFCbdQl0pjZrAAW5ZrODCUAJtRs4Nk3UYV1+EX
         dcEnYy0enLNH5/JyRaNj099cAyFym2ZbSpjEhjbA/EJGLGe72trgGF5kWqWaOOkjGiLB
         HYAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vAUEMGVmv3luLDWumw9EYzVQpWz4Yr1CWqgaSqnZceQ=;
        b=LHaejmOFDqXg5DVf6qfz1e47H4U5oMeQWBEEE+62vubbOp1O8FhkNvgoLpbjF7GFKt
         VptscXutWB+v7AN6qi1eSYI4P+iVcbxp4cL+AmsEVou76LiZfHmhpwpSqX+CWOOf/G3U
         GcpKg5D+jsNjHGUC+cTIhro9z6QMWtFbd4FyBp/gcEnow1O4CI0wS5FHwvxCq2UsbTBP
         CCXFpVPx/voky7dCDSoQ/D14QOCgPSpZjJe2yadswr3yt7VTrqzIM8i+j+V0SOmy6CuG
         NFBkTVywADhanTY+Nxvba3jpuVqwZsLGGK63MEcbXgEexala5WGd5AoDC/d2/k83orgQ
         jwbA==
X-Gm-Message-State: AOAM533NAQTSnYJpLrXRqyH06vS3oCDGRYQTrJFZnvFw0EVBd1SH1lNX
        GaHjRZGN29R9xFmI8kG/El+LKVaSmL2yUcrNgxJa9A==
X-Google-Smtp-Source: ABdhPJzlsEiL7iyx6CgmS5USAoYj8u3Wgu6jjZ5NhLYttjza0jDurzKAWjmvDD+8OeKKX0RMBEERdLYlUzWb3c2g7Hw=
X-Received: by 2002:a17:907:1606:b0:6df:f528:4033 with SMTP id
 hb6-20020a170907160600b006dff5284033mr5784411ejc.433.1648745935000; Thu, 31
 Mar 2022 09:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <s5hzgl6eg48.wl-tiwai@suse.de> <CAOvb9yiO_n48JPZ3f0+y-fQ_YoOmuWF5c692Jt5_SKbxdA4yAw@mail.gmail.com>
 <s5hr16ieb8o.wl-tiwai@suse.de> <YkVzl4NEzwDAp/Zq@kuha.fi.intel.com>
 <s5hmth6eaiz.wl-tiwai@suse.de> <YkV1rsq1SeTNd8Ud@kuha.fi.intel.com>
 <s5hk0cae9pw.wl-tiwai@suse.de> <s5h7d8adzdl.wl-tiwai@suse.de>
 <s5hzgl6ciho.wl-tiwai@suse.de> <YkXJr2KhSzHJHxRF@google.com> <YkXY730wWhgJkRUy@kroah.com>
In-Reply-To: <YkXY730wWhgJkRUy@kroah.com>
From:   Won Chung <wonchung@google.com>
Date:   Thu, 31 Mar 2022 09:58:43 -0700
Message-ID: <CAOvb9yiHXAWMn2_GcOnx5FYzfbp-2TmtN-OH90r31OqgbXQ3yQ@mail.gmail.com>
Subject: Re: [PATCH v2] sound/hda: Add NULL check to component match callback function
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Benson Leung <bleung@google.com>, Takashi Iwai <tiwai@suse.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 9:38 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Mar 31, 2022 at 08:33:03AM -0700, Benson Leung wrote:
> > Hi Takashi,
> >
> > On Thu, Mar 31, 2022 at 04:19:15PM +0200, Takashi Iwai wrote:
> > > On Thu, 31 Mar 2022 15:29:10 +0200,
> > > Takashi Iwai wrote:
> > > >
> > > > On Thu, 31 Mar 2022 11:45:47 +0200,
> > > > Takashi Iwai wrote:
> > > > >
> > > > > On Thu, 31 Mar 2022 11:34:38 +0200,
> > > > > Heikki Krogerus wrote:
> > > > > >
> > > > > > On Thu, Mar 31, 2022 at 11:28:20AM +0200, Takashi Iwai wrote:
> > > > > > > On Thu, 31 Mar 2022 11:25:43 +0200,
> > > > > > > Heikki Krogerus wrote:
> > > > > > > >
> > > > > > > > On Thu, Mar 31, 2022 at 11:12:55AM +0200, Takashi Iwai wrote:
> > > > > > > > > > > > -     if (!strcmp(dev->driver->name, "i915") &&
> > > > > > > > > > > > +     if (dev->driver && !strcmp(dev->driver->name, "i915") &&
> > > > > > > > > > >
> > > > > > > > > > > Can NULL dev->driver be really seen?  I thought the components are
> > > > > > > > > > > added by the drivers, hence they ought to have the driver field set.
> > > > > > > > > > > But there can be corner cases I overlooked.
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > thanks,
> > > > > > > > > > >
> > > > > > > > > > > Takashi
> > > > > > > > > >
> > > > > > > > > > Hi Takashi,
> > > > > > > > > >
> > > > > > > > > > When I try using component_add in a different driver (usb4 in my
> > > > > > > > > > case), I think dev->driver here is NULL because the i915 drivers do
> > > > > > > > > > not have their component master fully bound when this new component is
> > > > > > > > > > registered. When I test it, it seems to be causing a crash.
> > > > > > > > >
> > > > > > > > > Hm, from where component_add*() is called?  Basically dev->driver must
> > > > > > > > > be already set before the corresponding driver gets bound at
> > > > > > > > > __driver_probe_deviec().  So, if the device is added to component from
> > > > > > > > > the corresponding driver's probe, dev->driver must be non-NULL.
> > > > > > > >
> > > > > > > > The code that declares a device as component does not have to be the
> > > > > > > > driver of that device.
> > > > > > > >
> > > > > > > > In our case the components are USB ports, and they are devices that
> > > > > > > > are actually never bind to any drivers: drivers/usb/core/port.c
> > > > > > >
> > > > > > > OK, that's what I wanted to know.  It'd be helpful if it's more
> > > > > > > clearly mentioned in the commit log.
> > > > > >
> > > > > > Agree.
> > > > > >
> > > > > > > BTW, the same problem must be seen in MEI drivers, too.
> > > > > >
> > > > > > Wasn't there a patch for those too? I lost track...
> > > > >
> > > > > I don't know, I just checked the latest Linus tree.
> > > > >
> > > > > And, looking at the HD-audio code, I still wonder how NULL dev->driver
> > > > > can reach there.  Is there any PCI device that is added to component
> > > > > without binding to a driver?  We have dev_is_pci() check at the
> > > > > beginning, so non-PCI devices should bail out there...
> > > >
> > > > Further reading on, I'm really confused.  How data=NULL can be passed
> > > > to this function?  The data argument is the value passed from the
> > > > component_match_add_typed() call in HD-audio driver, hence it must be
> > > > always the snd_hdac_bus object.
> > > >
> > > > And, I guess the i915 string check can be omitted completely, at
> > > > least, for HD-audio driver.  It already have a check of the parent of
> > > > the device and that should be enough.
> > >
> > > That said, something like below (supposing data NULL check being
> > > superfluous), instead.
> > >
> > >
> > > Takashi
> > >
> > > --- a/sound/hda/hdac_i915.c
> > > +++ b/sound/hda/hdac_i915.c
> > > @@ -102,18 +102,13 @@ static int i915_component_master_match(struct device *dev, int subcomponent,
> > >     struct pci_dev *hdac_pci, *i915_pci;
> > >     struct hdac_bus *bus = data;
> > >
> > > -   if (!dev_is_pci(dev))
> > > +   if (subcomponent != I915_COMPONENT_AUDIO || !dev_is_pci(dev))
> > >             return 0;
> > >
> >
> > If I recall this bug correctly, it's not the usb port perse that is falling
> > through this !dev_is_pci(dev) check, it's actually the usb4-port in a new
> > proposed patch by Heikki and Mika to extend the usb type-c component to
> > encompass the usb4 specific pieces too. Is it possible usb4 ports are considered
> > pci devices, and that's how we got into this situation?
> >
> > Also, a little more background information: This crash happens because in
> > our kernel configs, we config'd the usb4 driver as =y (built in) instead of
> > =m module, which meant that the usb4 port's driver was adding a component
> > likely much earlier than hdac_i915.
>
> So is this actually triggering on 5.17 right now?  Or is it due to some
> other not-applied changes you are testing at the moment?
>
> confused,
>
> greg k-h

Hi Greg,

I believe it is not causing an issue in 5.17 at the moment. It is
triggered when we try to apply new changes and test it locally.
(registering a component for usb4_port)

Thanks,
Won
