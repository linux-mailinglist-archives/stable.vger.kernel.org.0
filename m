Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A29A624F88
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 02:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiKKB3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 20:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKKB3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 20:29:36 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E3960E8E;
        Thu, 10 Nov 2022 17:29:35 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id t5so3972514vsh.8;
        Thu, 10 Nov 2022 17:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jHD5mLLJZONA0/xtdbh0Srevx71YFYJ07K0NkniAf9c=;
        b=GwMk6CFn4Fnc6IN9tCgX19EH7VibmJZBqzocmwJvqRP3eNGSAUehrluMmLt2xKa+kE
         pocfyS6amZ1+0ETBiF4A3y/+LX18Rr+5Og7WgLRaNRgblEvAlaiK8Ead7q44d5UprvOF
         UIVTFjkuP4v81L89nWMwIZsiN7LjiqxyGOZlwVfpHF2+p3tJ/GTHNf1fweWimSoIsEax
         tgpyS1sxr4C4FBLDj6awpZGu3vVCqwCLVmwoBU0d4e9BXHebXbAuWZKnQSFVapa059t8
         spSjIzuOpzPcXXt0cgQNcdkVY+KL6aEvpUvqEBYA3vIItHxW4+pPek7yC/QdSxTebHpv
         JC6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jHD5mLLJZONA0/xtdbh0Srevx71YFYJ07K0NkniAf9c=;
        b=AIiDOm0C36Y9A5O4UKqJBGliLjUZuKbKYs/xwNPKPwg4WT/C7UcQkkLh8SznGmZ6d+
         zGVRa+YHZKd1NNX/MaB1hNsja5ydgUTN7CkDcwHCPaLz6GV/QKQW9r+CM0jOHVoirHQQ
         m/vWEggWIkKPRa2Jg0v9yxWuqDX+te1Mq1enH3/L0bJD6Jf8kE7tBv2ogcK6+YH6UErr
         47GXbiROoQa36bM5pji8fyhxDPMgg4nFZxqBwBuzVDFEOiijCjAilBOva/tSMEBlb7A0
         h8eXe3UKCDhXObG3tjoBSc68TvDR9IfzpQTljjRhnLTPW4uLVkTcufNryHk6TeY002rb
         KwRg==
X-Gm-Message-State: ACrzQf3xlw8V/x7/GvyVFYE2bUJK5Nd46dNwaA6r1f4/PQlx4NWqyEgG
        VBQjZEdnEVotNUpxvVpGkX9RxOBZsMHI3W4LJJA=
X-Google-Smtp-Source: AMsMyM6E1bv/HvEDjvsiy9t9G6cT/CryW9Tb6ev4GSZPn9yQ7e79YA8ZO/BwoSfEvLpXpL3uOFkgTWl+z/URbEi7tJ8=
X-Received: by 2002:a05:6102:3ca3:b0:3a7:c762:9209 with SMTP id
 c35-20020a0561023ca300b003a7c7629209mr4104254vsv.1.1668130174920; Thu, 10 Nov
 2022 17:29:34 -0800 (PST)
MIME-Version: 1.0
References: <1666620275-139704-1-git-send-email-pawell@cadence.com>
 <20221027072421.GA75844@nchen-desktop> <BYAPR07MB5381482129407B849BA9A616DD339@BYAPR07MB5381.namprd07.prod.outlook.com>
 <20221106090221.GA152143@nchen-desktop> <BYAPR07MB5381CD42617915D95122D56FDD3C9@BYAPR07MB5381.namprd07.prod.outlook.com>
 <CAL411-qttOGNyZH28bURje0Y3_zVF4XuzVS1zQh2DgPNN0smWw@mail.gmail.com> <BYAPR07MB53818794749C701BD908D112DD019@BYAPR07MB5381.namprd07.prod.outlook.com>
In-Reply-To: <BYAPR07MB53818794749C701BD908D112DD019@BYAPR07MB5381.namprd07.prod.outlook.com>
From:   Peter Chen <hzpeterchen@gmail.com>
Date:   Fri, 11 Nov 2022 09:28:30 +0800
Message-ID: <CAL411-o+ZjYP_R_n0Aae8b2zhQwYw373btX=4DA0hCKYzsuj+w@mail.gmail.com>
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

On Thu, Nov 10, 2022 at 1:38 PM Pawel Laszczak <pawell@cadence.com> wrote:
>
> >On Mon, Nov 7, 2022 at 1:39 PM Pawel Laszczak <pawell@cadence.com>
> >wrote:
> >>
> >> >
> >> >
> >> >On 22-10-27 08:46:17, Pawel Laszczak wrote:
> >> >>
> >> >> >
> >> >> >On 22-10-24 10:04:35, Pawel Laszczak wrote:
> >> >> >> Patch modifies the TD_SIZE in TRB before ZLP TRB.
> >> >> >> The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
> >> >> >> processing ZLP TRB by controller.
> >> >> >>
> >> >> >> cc: <stable@vger.kernel.org>
> >> >> >> Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence
> >> >> >> USBSSP DRD Driver")
> >> >> >> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> >> >> >>
> >> >> >> ---
> >> >> >> Changelog:
> >> >> >> v2:
> >> >> >> - returned value for last TRB must be 0
> >> >> >>
> >> >> >>  drivers/usb/cdns3/cdnsp-ring.c | 7 ++++++-
> >> >> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >> >> >>
> >> >> >> diff --git a/drivers/usb/cdns3/cdnsp-ring.c
> >> >> >> b/drivers/usb/cdns3/cdnsp-ring.c index
> >> >> >> 04dfcaa08dc4..aa79bce89d8a
> >> >> >> 100644
> >> >> >> --- a/drivers/usb/cdns3/cdnsp-ring.c
> >> >> >> +++ b/drivers/usb/cdns3/cdnsp-ring.c
> >> >> >> @@ -1769,8 +1769,13 @@ static u32 cdnsp_td_remainder(struct
> >> >> >> cdnsp_device *pdev,
> >> >> >>
> >> >> >>   /* One TRB with a zero-length data packet. */
> >> >> >>   if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
> >> >> >> -     trb_buff_len == td_total_len)
> >> >> >> +     trb_buff_len == td_total_len) {
> >> >> >> +         /* Before ZLP driver needs set TD_SIZE=1. */
> >> >> >> +         if (more_trbs_coming)
> >> >> >> +                 return 1;
> >> >> >> +
> >> >> >>           return 0;
> >> >> >> + }
> >> >> >
> >> >> >Does that fix the issue you want at bulk transfer, which has
> >> >> >zero-length packet at the last packet? It seems not align with
> >> >> >your previous
> >> >fix.
> >> >> >Would you mind explaining more?
> >> >>
> >> >> Value returned by function cdnsp_td_remainder is used as TD_SIZE in
> >> >> TRB.
> >> >>
> >> >> The last TRB in TD should have TD_SIZE=0, so trb for ZLP should
> >> >> have set also TD_SIZE=0. If driver set TD_SIZE=0 on before the last
> >> >> one TRB then the controller stops the transfer and ignore trb for ZLP
> >packet.
> >> >>
> >> >> To fix this, the driver in such case must set TD_SIZE = 1 before
> >> >> the last TRB.
> >> >
> >> >       if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
> >> > -         trb_buff_len == td_total_len)
> >> > +         trb_buff_len == td_total_len) {
> >> > +             /* Before ZLP driver needs set TD_SIZE=1. */
> >> > +             if (more_trbs_coming)
> >> > +                     return 1;
> >> > +
> >> >               return 0;
> >> > +     }
> >> >
> >> >How your above fix could return TD_SIZE as 1 for last non-ZLP TRB?
> >> >Which conditions are satisfied?
> >>
> >> For last non-ZLP TRB TD_SIZE should be 0 or 1.
> >>
> >> We have three casess:
> >> 1.
> >>         TRB1 - length > 1
> >>         TRb2 - ZLP
> >>
> >> In this case TRB1 should have set TD_SIZE = 1. In this case the condition
> >>         if (more_trbs_coming)
> >>                 return 1;
> >>
> >> returns TD_SIZE=1. In this case more_trb_comming for TRB1 is 1 and for
> >> TRB2 is 0
> >>
> >
> >This one is my question. How below condition is true for your case 1:
> >
> > if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
> >          trb_buff_len == td_total_len)
>
> For TRB1:
>    more_trbs_coming = true
>    transferred == 0 && trb_buff_len == 0  - false - it does not matter in this case
>    trb_buff_len == td_total_len - true

Why trb_buff_len equals to td_total_length? Considering the bulk
transfer with request length
larger than 64KB.

Peter

>   so whole condition is true.
>
>   Because more_trb_comming = true so:
>              if (more_trbs_coming)
>                         return 1;
> returns TD_SIZE = 1
>
> For TRB2 - ZLP:
>    more_trbs_coming = false
>    transferred == 0 && trb_buff_len == 0  - false - it does not matter in this case
>    trb_buff_len == td_total_len - true
>
>   Because more_trb_comming = false so function returns TD_SIZE = 0  for last ZLP trb.
>
> Pawel
