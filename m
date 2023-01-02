Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 081B565ADE2
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 09:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjABIKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 03:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjABIKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 03:10:23 -0500
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635D71092;
        Mon,  2 Jan 2023 00:10:22 -0800 (PST)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-142b72a728fso32943507fac.9;
        Mon, 02 Jan 2023 00:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZtTHx1A0oyKOYLw1dpt5iF1+sTWCXwIRpM9O50P+ZA=;
        b=WJYeHQHsDiLZ5eEGs9xVj744mOsgtRgEXclOvivQxsmQuyCWwLPFUYLdQlN5ZxC2Fp
         fmDdt4fx62Foscrv7pwmgumVUJ7T9ucJ2/EV5HfLWRFd/sejVGGAySG7ytxG9YgWZzse
         jT8P4wECEsyh9kU1T7LN6LtLBajel/AOT67a8e3BzMDntMdjcKX1RYLKD7p2ZBjLRLw2
         cMNexaEXu7me41pNwkXMv9PBctP5i/g6RiMNLw0Gb4mxRU57llyqLc8/1T3AMP9ftRtX
         KSJpl34K1D7p8BZT4Az38vF9qB9/0yVU/tjAKI/i/0uZ38C4t6z016BhjuqhB0ot8wdc
         3UUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OZtTHx1A0oyKOYLw1dpt5iF1+sTWCXwIRpM9O50P+ZA=;
        b=xexD4nPABVzakIvojwUcragQXC1cwejzPst0qPQxIB4zTz5U6oRUCcEoCANEvCjOFs
         KrCrAZvopJbYMB5/jxCkp2T9SCwMvWKj7DGM/rJMKUNYdEJwOq+UaGKppbKGUYDO3aiS
         fyXzzHiI6ZGKMBguiyNHEFsH2xsL/aajxGflpwDwtrUq4gLgDigDvWpdwxruNshky1cT
         m1Q8bfmvb2z928F3cXGQuPkNmuBoF/b5/tE2lJX2I2G2KceUsXQ99IdVmTjqhBX4JlA9
         XnPvFl/pT9xyMIzWcKgPJhL/KwKWo00WB47YCjE4d3FT4Jd63vCgQz4fLcA1E5UUntyG
         0qmA==
X-Gm-Message-State: AFqh2kp7sRm1gr2X12LXEULkgrbFYCGpTzXsd5sYIT0fMewPjH45kEPx
        mIfkndv4dTLNOtw6U1tdPUsNsxsclnPhjEuVHkU=
X-Google-Smtp-Source: AMrXdXveQsBg/JMZ8uKcUxr4Xcuwt2rao9IkRsO9pWlS5t3nUQZIAfTV3PxsKV8YRuApI83lRgxk4hwhRDocfxNVCAA=
X-Received: by 2002:a05:6870:fd84:b0:14c:6b72:e5a2 with SMTP id
 ma4-20020a056870fd8400b0014c6b72e5a2mr2734387oab.1.1672647021178; Mon, 02 Jan
 2023 00:10:21 -0800 (PST)
MIME-Version: 1.0
References: <20221115100039.441295-1-pawell@cadence.com> <CAL411-o4BETLPd-V_4yR6foXbES=72-P4tq-fQ_W_p0P_3ZqEw@mail.gmail.com>
 <BYAPR07MB5381AE961B59046ECB615C65DD069@BYAPR07MB5381.namprd07.prod.outlook.com>
In-Reply-To: <BYAPR07MB5381AE961B59046ECB615C65DD069@BYAPR07MB5381.namprd07.prod.outlook.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Mon, 2 Jan 2023 16:10:10 +0800
Message-ID: <CAL411-rFz5Dde4F_uWbksxJG2uqbD7VsU2GG1JQ0mU3LpbeoUA@mail.gmail.com>
Subject: Re: [PATCH] usb: cdns3: remove fetched trb from cache before dequeuing
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     "peter.chen@kernel.org" <peter.chen@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>,
        "rogerq@kernel.org" <rogerq@kernel.org>,
        "a-govindraju@ti.com" <a-govindraju@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 17, 2022 at 8:27 PM Pawel Laszczak <pawell@cadence.com> wrote:
>
> >
> >On Tue, Nov 15, 2022 at 6:01 PM Pawel Laszczak <pawell@cadence.com>
> >wrote:
> >>
> >> After doorbell DMA fetches the TRB. If during dequeuing request driver
> >> changes NORMAL TRB to LINK TRB but doesn't delete it from controller
> >> cache then controller will handle cached TRB and packet can be lost.
> >>
> >> The example scenario for this issue looks like:
> >> 1. queue request - set doorbell
> >> 2. dequeue request
> >> 3. send OUT data packet from host
> >> 4. Device will accept this packet which is unexpected 5. queue new
> >> request - set doorbell 6. Device lost the expected packet.
> >>
> >> By setting DFLUSH controller clears DRDY bit and stop DMA transfer.
> >>
> >> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> >> cc: <stable@vger.kernel.org>
> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >> ---
> >>  drivers/usb/cdns3/cdns3-gadget.c | 12 ++++++++++++
> >>  1 file changed, 12 insertions(+)
> >>
> >> diff --git a/drivers/usb/cdns3/cdns3-gadget.c
> >> b/drivers/usb/cdns3/cdns3-gadget.c
> >> index 5adcb349718c..ccfaebca6faa 100644
> >> --- a/drivers/usb/cdns3/cdns3-gadget.c
> >> +++ b/drivers/usb/cdns3/cdns3-gadget.c
> >> @@ -2614,6 +2614,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
> >>         u8 req_on_hw_ring =3D 0;
> >>         unsigned long flags;
> >>         int ret =3D 0;
> >> +       int val;
> >>
> >>         if (!ep || !request || !ep->desc)
> >>                 return -EINVAL;
> >> @@ -2649,6 +2650,13 @@ int cdns3_gadget_ep_dequeue(struct usb_ep
> >*ep,
> >>
> >>         /* Update ring only if removed request is on pending_req_list =
list */
> >>         if (req_on_hw_ring && link_trb) {
> >> +               /* Stop DMA */
> >> +               writel(EP_CMD_DFLUSH, &priv_dev->regs->ep_cmd);
> >> +
> >> +               /* wait for DFLUSH cleared */
> >> +               readl_poll_timeout_atomic(&priv_dev->regs->ep_cmd, val=
,
> >> +                                         !(val & EP_CMD_DFLUSH), 1,
> >> + 1000);
> >> +
> >>                 link_trb->buffer =3D cpu_to_le32(TRB_BUFFER(priv_ep-
> >>trb_pool_dma +
> >>                         ((priv_req->end_trb + 1) * TRB_SIZE)));
> >>                 link_trb->control =3D
> >> cpu_to_le32((le32_to_cpu(link_trb->control) & TRB_CYCLE) | @@ -2660,6
> >> +2668,10 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
> >>
> >>         cdns3_gadget_giveback(priv_ep, priv_req, -ECONNRESET);
> >>
> >> +       req =3D cdns3_next_request(&priv_ep->pending_req_list);
> >> +       if (req)
> >> +               cdns3_rearm_transfer(priv_ep, 1);
> >> +
> >
> >Why the above changes are needed?
> >
>
> Do you mean the last line or this patch?
>
> Last line:
> DMA is stopped, so driver arm the queued transfers
>

Sorry, I have been very busy recently, so the response may not be in time.
I mean why it needs to re-arm the transfers after DMA is stopped?

Peter


> If you means this patch:
> Issue was detected by customer test. I don=E2=80=99t know whether it was
> only test or the real application.
>
> The problem happens because user application queued the transfer
> (endpoint has been armed), so controller fetch the TRB.
> When user application removed this request the TRB was still
> processed by controller. If at that time the host will send data packet
> then controller will accept it, but it shouldn't because the usb_request
> associated with TRB cached by controller was removed.
> To force the controller to drop this TRB DFLUSH is required.
>
> Pawel
>
> >
> >>  not_found:
> >>         spin_unlock_irqrestore(&priv_dev->lock, flags);
> >>         return ret;
> >> --
> >> 2.25.1
> >>
