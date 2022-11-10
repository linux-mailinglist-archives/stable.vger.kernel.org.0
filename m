Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 522E262388D
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 02:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiKJBDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 20:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiKJBDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 20:03:47 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11F9165AA;
        Wed,  9 Nov 2022 17:03:44 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id g26so59034vkm.12;
        Wed, 09 Nov 2022 17:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ga1eSOq8SQMKvFupLUvr/s6K7BhSFkwDPBTu2UUI57w=;
        b=OIes9SHtUrT04ykeMb3sNwNvgpdq98hlwYeAoA2Z6OKy4pywpR9ILPB9ugH01Y2bjk
         jH7U8qQUC6t2iaCBlEWP6EqdhuE2S+xISP8QotfUTTGTM2bEQz+Sx6wFyMU7y5wI+REX
         Uj4sW4y1P6GYWx6F9rSdKyGc15ARTtCiSPAyHvn6pfmtHVImjztnlt+b5/WORPVRIU4l
         6JnyHkOlcWMm3BFWiWVcvaeO7MXHQYWRSW+1TeAzmeozzbNeIesr/FCij3tG6VSgpOfa
         sNgLWvS3wI4EcAa8tJHRHrjkwnIOtXS9zLX+EwixPwUteBZh1zvgXg7E/RpfLGsdUBD1
         zcLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ga1eSOq8SQMKvFupLUvr/s6K7BhSFkwDPBTu2UUI57w=;
        b=AkpuCTlELB2OTeRZr4n21rr9i6azTiCHFSRGTsr7JV5nY4Fj5Lp0ZcikCwKb2wQlnF
         yW5oCqanPN75DsnByaZCxGZPdHbtNB6FbIPlYj2ktUBUVrYeq883kH29tt2Gxhf7iqs+
         pXFtTYn5vBKqa5F5rEyFf3qTYGiFKlSug6pYUo8ponFBsvAemPsoZbIA+lYheDLQxq3V
         N2RvFXOrywLqC+STiAAzCizoaZdn6b8vdK9dJUPoHubAFRddQ0ora9aIKrXkeGhFcmES
         XyshhkwfTBi7S+xZvfWh7VoiJDlSUaDnJjNgbLWyr2fz4U/pB9kuZHZ121MaMR/T3tf1
         oQbQ==
X-Gm-Message-State: ACrzQf2OM88P1XfiEavkPhCQh/rLyfv8sdDc0psMrhei1veYXHKAx0ju
        obuzVoH0v7uPabxxlVttyB4FWNuqXslyty317/8=
X-Google-Smtp-Source: AMsMyM5KgKQxJezvDSv7tV9vGPGq7gElIXUnslLNufHFaWPquMPDx873Fsh4VyI0AHoF2Ie79xZtomIGvZq/vQK1N4k=
X-Received: by 2002:a05:6122:9a4:b0:3b8:53e6:6ad0 with SMTP id
 g36-20020a05612209a400b003b853e66ad0mr14346409vkd.41.1668042223886; Wed, 09
 Nov 2022 17:03:43 -0800 (PST)
MIME-Version: 1.0
References: <1666620275-139704-1-git-send-email-pawell@cadence.com>
 <20221027072421.GA75844@nchen-desktop> <BYAPR07MB5381482129407B849BA9A616DD339@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20221106090221.GA152143@nchen-desktop> <BYAPR07MB5381CD42617915D95122D56FDD3C9@BYAPR07MB5381.namprd07.prod.outlook.com>
In-Reply-To: <BYAPR07MB5381CD42617915D95122D56FDD3C9@BYAPR07MB5381.namprd07.prod.outlook.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Thu, 10 Nov 2022 09:02:40 +0800
Message-ID: <CAL411-qttOGNyZH28bURje0Y3_zVF4XuzVS1zQh2DgPNN0smWw@mail.gmail.com>
Subject: Re: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
To:     Pawel Laszczak <pawell@cadence.com>
Cc:     Peter Chen <peter.chen@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 7, 2022 at 1:39 PM Pawel Laszczak <pawell@cadence.com> wrote:
>
> >
> >
> >On 22-10-27 08:46:17, Pawel Laszczak wrote:
> >>
> >> >
> >> >On 22-10-24 10:04:35, Pawel Laszczak wrote:
> >> >> Patch modifies the TD_SIZE in TRB before ZLP TRB.
> >> >> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
> >> >> processing ZLP TRB by controller.
> >> >>
> >> >> cc: <stable@vger.kernel.org>
> >> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
> >> >> USBSSP DRD Driver")
> >> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >> >>
> >> >> ---
> >> >> Changelog:
> >> >> v2:
> >> >> - returned value for last TRB must be 0
> >> >>
> >> >>  drivers/usb/cdns3/cdnsp-ring.c | 7 ++++++-
> >> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >> >>
> >> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c
> >> >> b/drivers/usb/cdns3/cdnsp-ring.c index 04dfcaa08dc4..aa79bce89d8a
> >> >> 100644
> >> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
> >> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> >> >> @@ -1769,8 +1769,13 @@ static u32 cdnsp_td_remainder(struct
> >> >> cdnsp_device *pdev,
> >> >>
> >> >>   /* One TRB with a zero-length data packet. */
> >> >>   if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
> >> >> -     trb_buff_len == td_total_len)
> >> >> +     trb_buff_len == td_total_len) {
> >> >> +         /* Before ZLP driver needs set TD_SIZE=1. */
> >> >> +         if (more_trbs_coming)
> >> >> +                 return 1;
> >> >> +
> >> >>           return 0;
> >> >> + }
> >> >
> >> >Does that fix the issue you want at bulk transfer, which has
> >> >zero-length packet at the last packet? It seems not align with your previous
> >fix.
> >> >Would you mind explaining more?
> >>
> >> Value returned by function cdnsp_td_remainder is used as TD_SIZE in
> >> TRB.
> >>
> >> The last TRB in TD should have TD_SIZE=0, so trb for ZLP should have
> >> set also TD_SIZE=0. If driver set TD_SIZE=0 on before the last one TRB
> >> then the controller stops the transfer and ignore trb for ZLP packet.
> >>
> >> To fix this, the driver in such case must set TD_SIZE = 1 before the
> >> last TRB.
> >
> >       if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
> > -         trb_buff_len == td_total_len)
> > +         trb_buff_len == td_total_len) {
> > +             /* Before ZLP driver needs set TD_SIZE=1. */
> > +             if (more_trbs_coming)
> > +                     return 1;
> > +
> >               return 0;
> > +     }
> >
> >How your above fix could return TD_SIZE as 1 for last non-ZLP TRB?
> >Which conditions are satisfied?
>
> For last non-ZLP TRB TD_SIZE should be 0 or 1.
>
> We have three casess:
> 1.
>         TRB1 - length > 1
>         TRb2 - ZLP
>
> In this case TRB1 should have set TD_SIZE = 1. In this case the condition
>         if (more_trbs_coming)
>                 return 1;
>
> returns TD_SIZE=1. In this case more_trb_comming for TRB1 is 1 and for TRB2 is 0
>

This one is my question. How below condition is true for your case 1:

 if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
          trb_buff_len == td_total_len)


Peter



>
> 2.
>         TRB1 - length >1 and we don't except ZLP
>
> In this case TD_SIZE should be set to 0 for TRB1 and function returns 0, more_trbs_comming for TRB1 will be set to 0.
>
> 3 More TRBs without ZLP:
>         e.g.
>         TRB1  -  length > 0,  more_trbs_comming = 1 - TD_SIZE  > 0
>         TRB2 -  length > 0, more_trbs_comming = 1  - TD_SIZE > 0
>         TRB3 - length >= 0, more_trbs_comming = 0 -  TD_SIZE  = 0
>
> Pawel
>
> >
> >Peter
> >
> >> e.g.
> >>
> >> TD -> TRB1  transfer_length = 64KB, TD_SIZE =0
> >>           TRB2 transfer_length =0, TD_SIZE = 0  - controller will
> >>                  ignore this transfer and stop transfer on previous one
> >>
> >> TD -> TRB1  transfer_length = 64KB, TD_SIZE =1
> >>           TRB2 transfer_length =0, TD_SIZE = 0  - controller will
> >>                  execute this trb and send ZLP
> >>
> >> As you noticed previously, previous fix for last TRB returned TD_SIZE
> >> = 1 in some cases.
> >> Previous fix was working correct but was not compliance with
> >> controller specification.
> >>
> >> >
> >> >>
> >> >>   maxp = usb_endpoint_maxp(preq->pep->endpoint.desc);
> >> >>   total_packet_count = DIV_ROUND_UP(td_total_len, maxp);
> >> >> --
> >> >> 2.25.1
> >> >>
> >> >
> >> >--
> >> >
> >>
> >> Thanks,
> >> Pawel Laszczak
> >
> >--
> >
> >Thanks,
> >Peter Chen
>
> Regards,
> Pawel Laszczak
