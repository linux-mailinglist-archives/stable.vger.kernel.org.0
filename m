Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BC6302994
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbhAYSGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731129AbhAYSGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 13:06:01 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C44C061797;
        Mon, 25 Jan 2021 10:05:20 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id y19so28385898iov.2;
        Mon, 25 Jan 2021 10:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+aL0fFGSd2hHhX1foJGcaTOt1XHt4P+imCuVYIdpXgA=;
        b=sT7OiZSLtqZDgoBTi8QeiduUPtYM7a3AbWlVlkgqDtUCsn5SuRuyBIKc2Gwi4x0sis
         r9M1LmslSJay/vDCipMiHRJjn4lmYIGYyT1Eeyq3Wid5QEAGaRcSWZFyQaFbSInCwlQI
         qkmsC8lx5qL+Cl0ryn2305iHmWaUb5KaT9Dh5/Lk1W5ia+jybA6rtMiKibzzYg5oAS4Y
         60H9HNw0S/eSA5BulYIMWJd1fPddMvlvcDuoNH0358YuKivdAYEBIHqlNvXX3hPVyxPU
         8YU+A/mTpjeJFu6057q7Za6/z2s3PELIiLMum7oJJGKRw7L/Qm9MHRcxDSy/66ncGd4S
         DHqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+aL0fFGSd2hHhX1foJGcaTOt1XHt4P+imCuVYIdpXgA=;
        b=N3H4pubthNxAHyTi6zMeyQUSzM479xQhheRpopyF3nXyLXQIDbsGeTdHFucv3hbO4M
         gdC+dpwdKKQ0AVm93nnlzs4hiVcnZUC8PSjyEHs4gPOYfq0w6Kr3va2Fcz2C0JiHQVCB
         c2nbIX7tSC++43LzI5t1F9iSAXBf4n5eenps51AQ+wcJfI2g4a8XsMlEj7P+UGf5TXkh
         YBxgq6tVP5mBjvLKENQ4xuwJ+yYODlyUen/CKXKTYnKd6Gf1Px3dqvGRm1D5dRD76qdX
         WBCjuY6EtkbLl5n9UIYEOIHrbdEP+Tu5Nj13hhqXBhs79NWURG9VmTQsibkC41Yc5SbS
         zPUw==
X-Gm-Message-State: AOAM532deW99aQ80oyMMKqfDx+Tu1qbfWZoGCME0eFwi2mAUiD3KiFo8
        VJ8wf+gQoV+MqkRBxcWAvSkU0la5ZtsNIIKD2VE=
X-Google-Smtp-Source: ABdhPJy0m8NQdKU+D2Xr/21OA4cWpRmMdDC0FkfmQMKvssxUCySHvd9XbuqE6/F7SQ9hdImDkDU2lgsA1yL3Ggn9uX0=
X-Received: by 2002:a05:6e02:1aa8:: with SMTP id l8mr1402991ilv.251.1611597920147;
 Mon, 25 Jan 2021 10:05:20 -0800 (PST)
MIME-Version: 1.0
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali>
In-Reply-To: <20210125100540.55wbgdsem3htplx3@pali>
From:   Tom Hebb <tommyhebb@gmail.com>
Date:   Mon, 25 Jan 2021 10:05:08 -0800
Message-ID: <CAMcCCgTo87HmwexZS696ok16e9s_8gRgFd38uoLP34r7TbAzBg@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control blacklist
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bob Hepple <bob.hepple@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 2:05 AM Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
> > It has been reported[0] that the Dell XPS 15 L502X exhibits similar
> > freezing behavior to the other systems[1] on this blacklist. The issue
> > was exposed by a prior change of mine to automatically load
> > dell_smm_hwmon on a wider set of XPS models. To fix the regression, add
> > this model to the blacklist.
> >
> > [0] https://bugzilla.kernel.org/show_bug.cgi?id=3D211081
> > [1] https://bugzilla.kernel.org/show_bug.cgi?id=3D195751
> >
> > Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all XPS m=
odels")
> > Cc: stable@vger.kernel.org
> > Reported-by: Bob Hepple <bob.hepple@gmail.com>
> > Tested-by: Bob Hepple <bob.hepple@gmail.com>
> > Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> > ---
> >
> >  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hw=
mon.c
> > index ec448f5f2dc3..73b9db9e3aab 100644
> > --- a/drivers/hwmon/dell-smm-hwmon.c
> > +++ b/drivers/hwmon/dell-smm-hwmon.c
> > @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_fan_su=
pport_dmi_table[] __initdata =3D {
> >                       DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
> >               },
> >       },
> > +     {
> > +             .ident =3D "Dell XPS 15 L502X",
> > +             .matches =3D {
> > +                     DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > +                     DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XP=
S L502X"),
>
> Hello! Are you sure that it is required to completely disable fan
> support? And not only access to fan type label for which is different
> blaclist i8k_blacklist_fan_type_dmi_table?

This is a good question. We didn't try the other list. Bob is the one with =
the
affected system. Could you try moving the added block of code from
i8k_blacklist_fan_support_dmi_table a few lines up to
i8k_blacklist_fan_type_dmi_table, Bob, to see if the issue reappears or if =
it
remains fixed?

>
> And have you reported this issue to Dell support?
>
> > +             },
> > +     },
> >       { }
> >  };
> >
> > --
> > 2.30.0
> >

(Apologies for the previous HTML copy of this reply, to those directly CCed=
.)

-Tom
