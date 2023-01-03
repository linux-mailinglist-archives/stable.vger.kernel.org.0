Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79C565BB15
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 08:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236780AbjACHB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 02:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjACHB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 02:01:58 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DD9DE8D
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 23:01:56 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id tz12so71514254ejc.9
        for <stable@vger.kernel.org>; Mon, 02 Jan 2023 23:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KD2u2DXyEKdbwaHT9F1XdZgmAKy9PI83QN6QRpSZLbQ=;
        b=HHuadOVbYGkLsV8TLp6kqH0zRrxuX3Zfn8bacoRQm4ROK7lFrXSTu8GjsH2ZdhX5yj
         NLKoWBbgBxhBEVOxQYm94gOX+NeMekTPxVYbG+RKFTLlbHIR+3c8He4gOSxDhXLe7nLH
         DftWeweC+6pumSgjFNJdIK+YTXvNsoM94O6sqVip9iCjS0DsLg8tFcFm9wW/p2YmrSjY
         mXcHUvBnUuL7ZwbAFwTQyQZCHP+97UpD6b2TgAW6Hhkr2yaBOKI60J2ODFHGIeGfgIle
         1U5tKsSX5yRGeIFluf3h46Db88yaRQ12VMO7M7C7BPDlexu4SD+SbZbT+AuR6g4Dhs3g
         6KWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KD2u2DXyEKdbwaHT9F1XdZgmAKy9PI83QN6QRpSZLbQ=;
        b=q5B2M1PYC1Mcgt66SnDTKKJzhEP4jGIuQ0Xvt6MEMVEmpzP9CHW2pN/iGVAwygZXLj
         l9N4e9V/XllIxrUvayaQCxB2p/VFuTRKjJ634RVIJgCstatRh2iXVU7Ns6kFGDT0pkS7
         Wbo1wwLn4UWBV2BedHhg1rJDHlLqfGytwMvF1SjYB60KWnuKZA0demgmljI7k5QSBQfe
         i3ZAAYIqtO9QBGdLTPEE+GdqK3HDsdmCzEzGpscluVrhVtiBN/bTddfnfKdNTu9wJNfC
         rBYt8U5t+n+JNFKsK0ZlDkLPz0VBQiFqHm/wvFVq3piQQBbbPjHP1aqKVzQeHExD/vrf
         UVnA==
X-Gm-Message-State: AFqh2krfwF+jnO5kp7NlQ+qvmCZvH6tZ9rhS3iwH8BPid6pc3JHBX8yt
        ey/lylhPd/XdDvpJeWhWorZVAfnUDqbzHXZbrkl29nxS6zspREByinM=
X-Google-Smtp-Source: AMrXdXudg+e7Wq7kubQKAh4RAGzrSAKbVJYGYCQibNYZWqP+xWBynfHR5nPPF5Pq4I/HWh2zlSb/bcTg1l53prLozj8=
X-Received: by 2002:a17:906:364b:b0:7c1:133a:37bd with SMTP id
 r11-20020a170906364b00b007c1133a37bdmr2363579ejb.470.1672729314706; Mon, 02
 Jan 2023 23:01:54 -0800 (PST)
MIME-Version: 1.0
References: <20221222072912.1843384-1-hhhuuu@google.com> <Y6Qc1p4saGFTdh9n@lenoch>
 <23fe0fe3-f330-b58e-c366-3ac5bd80fe22@linux.intel.com> <Y6RFCjbMswOBoKdV@lenoch>
 <0fe978ed-8269-9774-1c40-f8a98c17e838@linux.intel.com> <1bf75820-dcb1-e6f3-d01b-6dd246fa3666@linux.intel.com>
In-Reply-To: <1bf75820-dcb1-e6f3-d01b-6dd246fa3666@linux.intel.com>
From:   Jimmy Hu <hhhuuu@google.com>
Date:   Tue, 3 Jan 2023 15:01:43 +0800
Message-ID: <CAJh=zjLfkD7LsA+5M8f8Wy2FvQMM0AvhpZLVueF9Zw4RK5c5iA@mail.gmail.com>
Subject: Re: [PATCH v2] usb: xhci: Check endpoint is valid before
 dereferencing it
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     Ladislav Michl <oss-lists@triops.cz>, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org, badhri@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 29, 2022 at 7:49 PM Mathias Nyman
<mathias.nyman@linux.intel.com> wrote:
>
> On 22.12.2022 15.18, Mathias Nyman wrote:
> > On 22.12.2022 13.52, Ladislav Michl wrote:
> >> On Thu, Dec 22, 2022 at 01:08:47PM +0200, Mathias Nyman wrote:
> >>> On 22.12.2022 11.01, Ladislav Michl wrote:
> >>>> On Thu, Dec 22, 2022 at 07:29:12AM +0000, Jimmy Hu wrote:
> >>>>> When the host controller is not responding, all URBs queued to all
> >>>>> endpoints need to be killed. This can cause a kernel panic if we
> >>>>> dereference an invalid endpoint.
> >>>>>
> >>>>> Fix this by using xhci_get_virt_ep() helper to find the endpoint and
> >>>>> checking if the endpoint is valid before dereferencing it.
> >>>>>
> >>>>> [233311.853271] xhci-hcd xhci-hcd.1.auto: xHCI host controller not responding, assume dead
> >>>>> [233311.853393] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000e8
> >>>>>
> >>>>> [233311.853964] pc : xhci_hc_died+0x10c/0x270
> >>>>> [233311.853971] lr : xhci_hc_died+0x1ac/0x270
> >>>>>
> >>>>> [233311.854077] Call trace:
> >>>>> [233311.854085]  xhci_hc_died+0x10c/0x270
> >>>>> [233311.854093]  xhci_stop_endpoint_command_watchdog+0x100/0x1a4
> >>>>> [233311.854105]  call_timer_fn+0x50/0x2d4
> >>>>> [233311.854112]  expire_timers+0xac/0x2e4
> >>>>> [233311.854118]  run_timer_softirq+0x300/0xabc
> >>>>> [233311.854127]  __do_softirq+0x148/0x528
> >>>>> [233311.854135]  irq_exit+0x194/0x1a8
> >>>>> [233311.854143]  __handle_domain_irq+0x164/0x1d0
> >>>>> [233311.854149]  gic_handle_irq.22273+0x10c/0x188
> >>>>> [233311.854156]  el1_irq+0xfc/0x1a8
> >>>>> [233311.854175]  lpm_cpuidle_enter+0x25c/0x418 [msm_pm]
> >>>>> [233311.854185]  cpuidle_enter_state+0x1f0/0x764
> >>>>> [233311.854194]  do_idle+0x594/0x6ac
> >>>>> [233311.854201]  cpu_startup_entry+0x7c/0x80
> >>>>> [233311.854209]  secondary_start_kernel+0x170/0x198
> >>>>>
> >>>>> Fixes: 50e8725e7c42 ("xhci: Refactor command watchdog and fix split string.")
> >>>>> Cc: stable@vger.kernel.org
> >>>>> Signed-off-by: Jimmy Hu <hhhuuu@google.com>
> >>>>> ---
> >>>>>    drivers/usb/host/xhci-ring.c | 5 ++++-
> >>>>>    1 file changed, 4 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> >>>>> index ddc30037f9ce..f5b0e1ce22af 100644
> >>>>> --- a/drivers/usb/host/xhci-ring.c
> >>>>> +++ b/drivers/usb/host/xhci-ring.c
> >>>>> @@ -1169,7 +1169,10 @@ static void xhci_kill_endpoint_urbs(struct xhci_hcd *xhci,
> >>>>>        struct xhci_virt_ep *ep;
> >>>>>        struct xhci_ring *ring;
> >>>>> -    ep = &xhci->devs[slot_id]->eps[ep_index];
> >>>>> +    ep = xhci_get_virt_ep(xhci, slot_id, ep_index);
> >>>>> +    if (!ep)
> >>>>> +        return;
> >>>>> +
> >>>>
> >>>> xhci_get_virt_ep also adds check for slot_id == 0. It changes behaviour,
> >>>> do we really want to skip that slot? Original code went from 0 to
> >>>> MAX_HC_SLOTS-1.
> >>>>
> >>>> It seems to be off by one to me. Am I missing anything?
> >>>
> >>> slot_id 0 is always invalid, so this is a good change.
> >>
> >> I see. Now reading more carefully:
> >> #define HCS_MAX_SLOTS(p)    (((p) >> 0) & 0xff)
> >> #define MAX_HC_SLOTS        256
> >> So the loop should go:
> >>     for (i = 1; i <= HCS_MAX_SLOTS(xhci->hcs_params1); i++)
> >
> > yes
> >
> >>
> >>>> Also, what about passing ep directly to xhci_kill_endpoint_urbs
> >>>> and do the check in xhci_hc_died? Not even compile tested:
> >>>
> >>> passing ep to a function named kill_endpoint_urbs() sound like the
> >>> right thing to do, but as a generic change.
> >>>
> >>> I think its a good idea to first do a targeted fix for this null pointer
> >>> issue that we can send to stable fist.
> >>
> >> Agree. But I still do not understand the root cause. There is a check
> >> for NULL xhci->devs[i] already, so patch does not add much more, except
> >> for test for slot_id == 0. And the eps array is just array of
> >> struct xhci_virt_ep, not a pointers to them, so &xhci->devs[i]->eps[j]
> >> should be always valid pointer. However struct xhci_ring in each eps
> >> is allocated and not protected by any lock here. Is that correct?
> >
> > I think root cause is that freeing xhci->devs[i] and including rings isn't
> > protected by the lock, this happens in xhci_free_virt_device() called by
> > xhci_free_dev(), which in turn may be called by usbcore at any time
> >
> > So xhci->devs[i] might just suddenly disappear
> >
> > Patch just checks more often if xhci->devs[i] is valid, between every endpoint.
> > So the race between xhci_free_virt_device() and xhci_kill_endpoint_urbs()
> > doesn't trigger null pointer deref as easily.
>
> Jimmy Hu,
>
> Any chance you could try if the change below works for you instead of
> using xhci_get_virt_ep().
> I don't have a easy way to trigger the issue-
>
>
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 79d7931c048a..50b41213e827 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -3974,6 +3974,7 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
>         struct xhci_hcd *xhci = hcd_to_xhci(hcd);
>         struct xhci_virt_device *virt_dev;
>         struct xhci_slot_ctx *slot_ctx;
> +       unsigned long flags;
>         int i, ret;
>
>         /*
> @@ -4000,7 +4001,11 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
>                 virt_dev->eps[i].ep_state &= ~EP_STOP_CMD_PENDING;
>         virt_dev->udev = NULL;
>         xhci_disable_slot(xhci, udev->slot_id);
> +
> +       spin_lock_irqsave(&xhci->lock, flags);
>         xhci_free_virt_device(xhci, udev->slot_id);
> +       spin_unlock_irqrestore(&xhci->lock, flags);
> +
>   }
>
>
> Thanks
> Mathias

Mathias,

Sorry. I also don't have an easy way to trigger this issue.

Thanks,
Jimmy
