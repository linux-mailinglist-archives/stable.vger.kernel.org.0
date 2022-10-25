Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A05660D6B5
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiJYWCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiJYWCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:02:41 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1CEE031
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:02:40 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id g62so9285686pfb.10
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GULGi86qMTyl7yyM+IR6+fSHJnsFKzqqvsOZYIrPIEA=;
        b=yMkIBo+9K/7j4XtPEWCALFJ8qi8nKrlDbujqGihobWEAHVxMGYkVwLm7Xfadbxez36
         psK4XmcMcprxBRL4C27mDuTG84I1wwIRlc5CZiyiIeRl0DCFYnTjPHStOXafDZCni6hP
         9eujcK8XhH0cphTjmjHMrOAKHkHXtpwLd0fDuQ96z7SpJhHYSpzY8ntxwm9h3OXVwtKD
         Rk8wzYlwFR984r0sfnCVx+crp7EtQ6i2KDKMeF77bJLNWXeWuRP7zRq12ls9iE5qDsXm
         hddOC7/vI4iUJz1CZNRXkfyK5QrrZBei2DNnWarihFtLyA/Z9KsjzBwn8h20ifUPZ0sl
         d0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GULGi86qMTyl7yyM+IR6+fSHJnsFKzqqvsOZYIrPIEA=;
        b=1gNyixI1WiQj3PxDLTGnZXVTL12C91Ysd6LB3K3S6fS3BaOMkOb2tiWuFTx1QgNPf6
         E0SxNDxDUFfejcvv37wdjRBXpiHcgZYssY8WP7nCzAGIXgfKPpMDY/pd08KHkiCK1WtU
         nxsUYmIQlOZXkVZnJc9jFRcUr+A5W3lETH2oG8uLWRb/uasca6cLoA1HN24UFwllLG1Y
         O3Eqdy5bF6/iW4klIrfPmK3p6iQPOpuE5mZajoL0FJf7Q9f1RMIW7b+0D+xNZOXcCcUn
         eMEKqRThnragLNhvtkBE+UZoejN/2bNSnO5fnLmgh6GavmR4cDQQdHDcA1A/uBb3EYCR
         0vaQ==
X-Gm-Message-State: ACrzQf0Q0w723jgPpQJtY7T5dHtydIAon/R6BIuWm5FJJhm3FpG9Kzte
        yi9ohc0l/S3+iZZplMwJST6vTVXWl+NAUsMlBXZ1UQ==
X-Google-Smtp-Source: AMsMyM5uOo4rfSRMj6gzeQ037m7SbQEtvITCCr8NDm7Z6h1PJvuafoJ8AQingLCjrWnrTvAh/HXbnqt/o4mbJThtvHU=
X-Received: by 2002:a05:6a00:851:b0:563:6c6a:2b7b with SMTP id
 q17-20020a056a00085100b005636c6a2b7bmr40763296pfk.45.1666735359645; Tue, 25
 Oct 2022 15:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220701110341.3094023-1-s.hauer@pengutronix.de>
 <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
 <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com>
 <YtD/9KJZwlVj+6hS@kroah.com> <20220715074631.GA7333@pengutronix.de>
 <YtEdIujszEKSprbF@kroah.com> <770744970.283550.1657871950910.JavaMail.zimbra@nod.at>
 <20220902090252.75285234@xps-13> <CAJ+vNU0r3Enkwn+WzvEJYc_O4NurRyCssx2S-_ZS_cYCpk2-cA@mail.gmail.com>
 <20221024100114.627f87bd@xps-13>
In-Reply-To: <20221024100114.627f87bd@xps-13>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 25 Oct 2022 15:02:27 -0700
Message-ID: <CAJ+vNU2R=FVSpRVWh8RBJ7XZmRRjkqHce1WTGXDKrjeHRbuzSw@mail.gmail.com>
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Tomasz_Mo=C5=84?= <tomasz.mon@camlingroup.com>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        Han Xu <han.xu@nxp.com>, kernel <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>,
        k drobinski <k.drobinski@camlintechnologies.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 24, 2022 at 1:01 AM Miquel Raynal <miquel.raynal@bootlin.com> w=
rote:
>
> Hi Tim,
>
> tharvey@gateworks.com wrote on Fri, 21 Oct 2022 14:55:15 -0700:
>
> > On Fri, Sep 2, 2022 at 12:03 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote:
> > >
> > > Hey folks,
> > >
> > > richard@nod.at wrote on Fri, 15 Jul 2022 09:59:10 +0200 (CEST):
> > >
> > > > ----- Urspr=C3=BCngliche Mail -----
> > > > >> My IRC history doesn't go back far enough, but if I recall corre=
ctly
> > > > >> Miquel is on vacation, he would have picked up this patch for li=
nux-next
> > > > >> otherwise.
> > > >
> > > > Exactly.
> > >
> > > Indeed, I was off for an extended period of time, I'm (very) slowly
> > > catching up now.
> > >
> > > >
> > > > > Ok, let me do a round of stable releases so that people don't get=
 hit by
> > > > > this now...
> > > >
> > > > Thanks a lot for doing so.
> > > >
> > > > > Hopefully this gets fixed up by 5.19-final.
> > > >
> > > > Sure, I'll pickup this patch.
> > >
> > > Thanks Greg & Richard for the handling of this issue.
> > >
> > > Cheers,
> > > Miqu=C3=A8l
> > >
> >
> > Hello All,
> >
> > As Tomasz stated previously 06781a5026350 was merged in v5.19-rc4 and
> > then was picked up by several stable kernels. While this made it into
> > the 5.15 and 5.18 stable branches it did not make it into the
> > following which are thus the are currently broken:
> > 5.10.y
> > 5.17.y
> >
> > How do we get this patch applied to those stable branches as well to
> > resolve this?
>
> It is likely that the original patch (targeting a mainline kernel) did
> not apply to those branches. In this case you can adapt the fix to the
> concerned kernels and send it to stable@ (following the Documentation
> guidelines for backports).
>
> Thanks,
> Miqu=C3=A8l

Miqu=C3=A8l,

Thanks for the pointer. You are correct that this patch which resolves
the regression does not apply directly to 5.4/5.10/5.17 stable trees.
I'm looking over
https://www.kernel.org/doc/html/v4.10/process/stable-kernel-rules.html
and I'm not clear what I need to put in the commit to make it clear
that it only applies to those specific trees. Do I simply adjust the
'Fixes' tag to address the commit from that specific stable branch and
send one for each stable branch (thus each would have a different sha
in the Fixes tag) while also adding the 'commit <sha> upstream' to the
top?

Best Regards.

Tim
