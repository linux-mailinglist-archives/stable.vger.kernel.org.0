Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1849A3629EF
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 23:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344071AbhDPVIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 17:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343949AbhDPVIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 17:08:49 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A883BC061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 14:08:22 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id n8so46890351lfh.1
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 14:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GIZrjUDCmrDij98cL3rVzMqpjH1jlgrzOBLrE7CdxxA=;
        b=trtQ+oYrg2yw2Ke9GZm7CAiVi6x4ZKrPhYZg7RV2M9mPFgWAxAf6ZQX+JU3lYUJlis
         Tqdg/CZN8NMuDpdz0uoxYAPI2mm4k7fW/bTQ6PET4j3JFzNfi57x8BGHf1JJzEuKm+2n
         bs/IJf+erCn/ims5tm4OWOa8YfGNkV46ZAy4SHir22AE1Vns7UTPoOOm31yKB8U0hF7P
         7OqdoGYc+VCHA8tsJJIqCrVxH4fKjWWGtBTUxnt2WV5KYPFYpHPs9rKdwWclrsh/w5AU
         PgROnDWBFVoHPlIxxzwsNnofM0/5/5AdOqpYmjtpD/9LmgGKIXO5z01Pa2DcymXvgI0z
         I3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GIZrjUDCmrDij98cL3rVzMqpjH1jlgrzOBLrE7CdxxA=;
        b=nsvMXkGS5lpEFi0ldCW/1Xs+VGmMBAAQpnyJ+hButcJzinp+LayqOU1PDPzNLeePOi
         z1XVHY3l2W1Whufvdw8KnNenlw7a4JR7AgIPyRY587iG216RZl1IJfIV5ZZegRpS6Uvc
         BrnGCRVt4Z772vT7Tqb0dFSfBfJYYJv8FBKpzUREf9F/7jKcCjPYqX0LUai2WXtGnKny
         oETT2NQ1zCP0Plswd/GlyK3+UIN63v54GmjNIeezDjms0ONuCV124OuJgtyiZ9FrLkVd
         YSSr5giFmCSHqbxA1pg3eMAlnp3s0XyhrXhAX/9yLZoOngC5w1VkdvYQzqqRk0hq7PK4
         awsw==
X-Gm-Message-State: AOAM530DqIPZhoOEjLwZO4cZ8vXpFgScS/fc8LFUYrcS4yJXcUuYywI5
        Lt8G8MdZoZFWtTFufYxQ0deg1/DPhf5esYSE4WlOSw==
X-Google-Smtp-Source: ABdhPJygraGZI/HN1UzuY9h+7kLqQ/WR5dXLlF/Ct+wzbHBhTH5t+IQbntlc/zJWksrYWuVChyGZjjRE3U/3seQOWIQ=
X-Received: by 2002:a05:6512:303:: with SMTP id t3mr4141955lfp.7.1618607299749;
 Fri, 16 Apr 2021 14:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <87zgxymrph.fsf@kernel.org> <CALAqxLUQn+m_JsjVrMSDc+Z=Ezo3jDD1e22ey7SZsruoEfQLjg@mail.gmail.com>
 <2a990344-8d57-2ab5-b5c5-3e6b43698f93@synopsys.com>
In-Reply-To: <2a990344-8d57-2ab5-b5c5-3e6b43698f93@synopsys.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Fri, 16 Apr 2021 14:08:06 -0700
Message-ID: <CALAqxLUgKsJS5Hy=N1KDNP7+v1Y0TxW19m9iD0S4ySq-5qhgjQ@mail.gmail.com>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 16, 2021 at 12:49 PM Thinh Nguyen <Thinh.Nguyen@synopsys.com> wrote:
>
> John Stultz wrote:
> > On Fri, Apr 16, 2021 at 3:47 AM Felipe Balbi <balbi@kernel.org> wrote:
> >>
> >>
> >> Hi,
> >>
> >> Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> >>
> >>> From: Yu Chen <chenyu56@huawei.com>
> >>> From: John Stultz <john.stultz@linaro.org>
> >>>
> >>> According to the programming guide, to switch mode for DRD controller,
> >>> the driver needs to do the following.
> >>>
> >>> To switch from device to host:
> >>> 1. Reset controller with GCTL.CoreSoftReset
> >>> 2. Set GCTL.PrtCapDir(host mode)
> >>> 3. Reset the host with USBCMD.HCRESET
> >>> 4. Then follow up with the initializing host registers sequence
> >>>
> >>> To switch from host to device:
> >>> 1. Reset controller with GCTL.CoreSoftReset
> >>> 2. Set GCTL.PrtCapDir(device mode)
> >>> 3. Reset the device with DCTL.CSftRst
> >>> 4. Then follow up with the initializing registers sequence
> >>>
> >>> Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
> >>> switching from host to device. John Stult reported a lockup issue seen
> >>> with HiKey960 platform without these steps[1]. Similar issue is observed
> >>> with Ferry's testing platform[2].
> >>>
> >>> So, apply the required steps along with some fixes to Yu Chen's and John
> >>> Stultz's version. The main fixes to their versions are the missing wait
> >>> for clocks synchronization before clearing GCTL.CoreSoftReset and only
> >>> apply DCTL.CSftRst when switching from host to device.
> >>>
> >>> [1] https://urldefense.com/v3/__https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/__;!!A4F2R9G_pg!L4TLb25Nkq0DF2qrCPWW13PUq4idhDn5QSZhgvnVAy7wJiYFOSSouSptwo9nOzIdPD4j$
> >>> [2] https://urldefense.com/v3/__https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/__;!!A4F2R9G_pg!L4TLb25Nkq0DF2qrCPWW13PUq4idhDn5QSZhgvnVAy7wJiYFOSSouSptwo9nO21VT8q7$
> >>>
> >>> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> >>> Cc: Ferry Toth <fntoth@gmail.com>
> >>> Cc: Wesley Cheng <wcheng@codeaurora.org>
> >>> Cc: <stable@vger.kernel.org>
> >>> Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
> >>> Signed-off-by: Yu Chen <chenyu56@huawei.com>
> >>> Signed-off-by: John Stultz <john.stultz@linaro.org>
> >>> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> >>
> >> I still have concerns about the soft reset, but I won't block you guys
> >> from fixing Hikey's problem :-)
> >>
> >> The only thing I would like to confirm is that this has been verified
> >> with hundreds of swaps happening as quickly as possible. DWC3 should
> >> still be functional after several hundred swaps.
> >>
> >> Can someone confirm this is the case? (I'm assuming this can be
> >> scripted)
> >
> > I unfortunately don't have an easy way to automate the switching right
> > off. But I'll try to hack up the mux switch driver to provide an
> > interface we can script against.
> >
>
> FYI, you can do the following:
>
> 1) Enable "usb-role-switch" DT property if not already done so
> 2) Add userspace control:
>
> diff --git a/drivers/usb/dwc3/drd.c b/drivers/usb/dwc3/drd.c
> index e2b68bb770d1..b203e3d87291 100644
> --- a/drivers/usb/dwc3/drd.c
> +++ b/drivers/usb/dwc3/drd.c
> @@ -555,6 +555,7 @@ static int dwc3_setup_role_switch(struct dwc3 *dwc)
>                 mode = DWC3_GCTL_PRTCAP_DEVICE;
>         }
>
> +       dwc3_role_switch.allow_userspace_control = true;
>         dwc3_role_switch.fwnode = dev_fwnode(dwc->dev);
>         dwc3_role_switch.set = dwc3_usb_role_switch_set;
>         dwc3_role_switch.get = dwc3_usb_role_switch_get;
>
> 3) Write a script to do the following:
>
> # echo host > /sys/class/usb_role/<UDC>/role
>
> and
>
> # echo device > /sys/class/usb_role/<UDC>/role

Thanks so much for this. So I ran both of those commands in a while
loop for awhile and didn't see any trouble.

HiKey960 is interesting as well because we have a mux switch, which is
sort of an intermediary roll switcher (it gets the role switch signal
from the tcpci_rt1711h, tweaks some gpios and then signals the dwc3).
So I also did the above tweaks to the mux-switch and had it switching
between device/none and validated the onboard hub came up and down
along with the dwc3 core.

Everything still looks good here.

thanks
-john

thanks
-john
