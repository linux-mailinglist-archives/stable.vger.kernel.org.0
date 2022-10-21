Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2B26080FA
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 23:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJUVzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 17:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJUVzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 17:55:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AB2183D91
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 14:55:28 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id z5-20020a17090a8b8500b00210a3a2364fso5173550pjn.0
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 14:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dT6ZKO8bMRr2n8aUWPzJ3HA/WiCoNo2nqfyT8qO6Y9I=;
        b=5L281OO8ws7T0y7/SJua3VBEA5/VgBaLIpo6N5UaQqaqzrxV1ugrvkM6uUtGc2zYFO
         EF3MxUT7UBRWrZ+Qrwl3QeyfUxyP1QvzcFFc84hhUHnH4sI55QDjVYgI0OrDA3CDxafH
         DJu/PqIjXj72xCSdn2becOw5+Vue32bTueGoE2F/DelOOU/viEmAAmQRkKFxNULvfm4H
         V09R3MuuK62hk1G86mbDqIS9+yZ75yS7/pj2W7vUGfn+Z9qmLp4pYPgFeRCgBlkojj9H
         6qgYoR3NF+AS+FTyVbAjjYyx9qW3Kkl9z43jUHU/dQKXZk/k0lsKaiYqqD02JDN0CCJ5
         N2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dT6ZKO8bMRr2n8aUWPzJ3HA/WiCoNo2nqfyT8qO6Y9I=;
        b=seEL9Vb+RSIgFHSKlXC2aI5qrX8RrgTOx/C4FnGk2gs4v658Bj8PZ0bT/Jj1+Awb5u
         b/iKqCTqran0c27ILmLISTCfQkQeLCbMNDKK+J5/x38gm7/pcjNEpaQWi+9swVXpIJd8
         RaaLTZjg0zO7WUSQuFnMtaCm867c0c6BZXag1j+zOTotAPXTR6qCWmcTDUEZtQ0Wll7i
         7vmoxDp0z60DgFaomYJrwAcGKyR0lVfLTtxfe9HsPDKJd2Lv+VAtb04dgPSVix10/KYg
         dePCz5XcVf/JmlEvpM66p7fEx0H8U5DY//59LJD309kOoOmm+x771z6NRyyJ/xX56NOC
         8H5A==
X-Gm-Message-State: ACrzQf3qQD/pyVsX9/WukDezvSUSROjr5lE1cHrsbJV8u4tHo0QXGvAJ
        XFMNJUG10k0Be7I3fstwYFknNsFJMjt7YincUy8GP5ePfG0=
X-Google-Smtp-Source: AMsMyM4aEKNZfPgfMIi0f1nZAyJu5CZ1gxkgE5zlnZPgIYE+aBrkHQRJGYZhrw770e1IHhTLYx3sR6MjnccOOvh/Ixo=
X-Received: by 2002:a17:90b:224d:b0:20d:8828:3051 with SMTP id
 hk13-20020a17090b224d00b0020d88283051mr23885685pjb.89.1666389327258; Fri, 21
 Oct 2022 14:55:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220701110341.3094023-1-s.hauer@pengutronix.de>
 <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
 <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com>
 <YtD/9KJZwlVj+6hS@kroah.com> <20220715074631.GA7333@pengutronix.de>
 <YtEdIujszEKSprbF@kroah.com> <770744970.283550.1657871950910.JavaMail.zimbra@nod.at>
 <20220902090252.75285234@xps-13>
In-Reply-To: <20220902090252.75285234@xps-13>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 21 Oct 2022 14:55:15 -0700
Message-ID: <CAJ+vNU0r3Enkwn+WzvEJYc_O4NurRyCssx2S-_ZS_cYCpk2-cA@mail.gmail.com>
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Tomasz_Mo=C5=84?= <tomasz.mon@camlingroup.com>
Cc:     Richard Weinberger <richard@nod.at>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        Han Xu <han.xu@nxp.com>, kernel <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>,
        k drobinski <k.drobinski@camlintechnologies.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
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

On Fri, Sep 2, 2022 at 12:03 AM Miquel Raynal <miquel.raynal@bootlin.com> w=
rote:
>
> Hey folks,
>
> richard@nod.at wrote on Fri, 15 Jul 2022 09:59:10 +0200 (CEST):
>
> > ----- Urspr=C3=BCngliche Mail -----
> > >> My IRC history doesn't go back far enough, but if I recall correctly
> > >> Miquel is on vacation, he would have picked up this patch for linux-=
next
> > >> otherwise.
> >
> > Exactly.
>
> Indeed, I was off for an extended period of time, I'm (very) slowly
> catching up now.
>
> >
> > > Ok, let me do a round of stable releases so that people don't get hit=
 by
> > > this now...
> >
> > Thanks a lot for doing so.
> >
> > > Hopefully this gets fixed up by 5.19-final.
> >
> > Sure, I'll pickup this patch.
>
> Thanks Greg & Richard for the handling of this issue.
>
> Cheers,
> Miqu=C3=A8l
>

Hello All,

As Tomasz stated previously 06781a5026350 was merged in v5.19-rc4 and
then was picked up by several stable kernels. While this made it into
the 5.15 and 5.18 stable branches it did not make it into the
following which are thus the are currently broken:
5.10.y
5.17.y

How do we get this patch applied to those stable branches as well to
resolve this?

Best regards,

Tim
