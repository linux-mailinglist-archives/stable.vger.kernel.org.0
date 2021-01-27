Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5E63056C3
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 10:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhA0JWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 04:22:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234905AbhA0JUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 04:20:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DAB32075B;
        Wed, 27 Jan 2021 09:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611739176;
        bh=tM1ozBWi0uNXg+q6YwCl7gQK0QJHNvuk0ARRzfvOIGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E0QsD4JmQWrPsrwfkMc2X4WAYeHGU337JKTcNXDH2J5yb3+Bf82hY8aQsmrNisX0A
         nfmwljPRi6atQpAOuFiFLkDyhBbzEF1uDP2AiKNciMOavpRHDNoZXnJn38B1ug6mPz
         ka7rb0jZWIfFVi6ENpnk3USHaKX1w61DkOnMXQ7VlcGNqppncGaDSkhJ0xPASj7JYv
         c7aLoCHPyd96wZtKR1hbvnrhd9AB2OLCujGFVl7iq0XShpeHA/MSmh0Tanqxbb09LU
         g45fDzhU/PE+BPGCTO29a1ccig97GEzCtvfFWERv64ap6030ytWVHdSz+T3/Wi2wRa
         fWa3q6J3Zq5cg==
Received: by pali.im (Postfix)
        id D03AC5CD; Wed, 27 Jan 2021 10:19:33 +0100 (CET)
Date:   Wed, 27 Jan 2021 10:19:33 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Tom Hebb <tommyhebb@gmail.com>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bob Hepple <bob.hepple@gmail.com>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control
 blacklist
Message-ID: <20210127091933.haq6nmbmx3cskh5t@pali>
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali>
 <CAMcCCgTo87HmwexZS696ok16e9s_8gRgFd38uoLP34r7TbAzBg@mail.gmail.com>
 <CAHzpm2hk4+0FyFrcGYN-JJfx5Ka8yoM8mTsYZA_4WHfWYGa4yQ@mail.gmail.com>
 <CAHzpm2h2X8ZKEtRxnD-mwyEv=B8J+tH_spFGD2VzfwGdRAaHMw@mail.gmail.com>
 <CAMcCCgQRDRi1LpxJBTvKcB+dALJJsn=n5Q=Wyvfcw9LGqqjq7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMcCCgQRDRi1LpxJBTvKcB+dALJJsn=n5Q=Wyvfcw9LGqqjq7Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 26 January 2021 00:15:13 Tom Hebb wrote:
> Bob reports that blacklisting the fan type label is not sufficient.
> See his message to me below.

Ok! Thank you for confirmation.

And my second question which I have asked:
And have you reported this issue to Dell support?

> On Mon, Jan 25, 2021 at 3:38 PM Bob Hepple <bob.hepple@gmail.com> wrote:
> >
> > Hi Tom,
> >
> > Big nope this end with L502x in i8k_blacklist_fan_type_dmi_table:
> >
> > Jan 26 09:35:47 achar kernel: psmouse serio1: TouchPad at
> > isa0060/serio1/input0 lost synchronization, throwing 1 bytes>
> >
> > ... and lots of trackpad stall/stutters.
> >
> > Cheers
> >
> >
> > Bob
> >
> >
> >
> > On Tue, 26 Jan 2021 at 08:09, Bob Hepple <bob.hepple@gmail.com> wrote:
> > >
> > > ... compiling now ... results in a coupla hours
> > >
> > > Cheers
> > >
> > >
> > > Bob
> > >
> > > On Tue, 26 Jan 2021 at 04:05, Tom Hebb <tommyhebb@gmail.com> wrote:
> > > >
> > > > On Mon, Jan 25, 2021 at 2:05 AM Pali Rohár <pali@kernel.org> wrote:
> > > > >
> > > > > On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
> > > > > > It has been reported[0] that the Dell XPS 15 L502X exhibits similar
> > > > > > freezing behavior to the other systems[1] on this blacklist. The issue
> > > > > > was exposed by a prior change of mine to automatically load
> > > > > > dell_smm_hwmon on a wider set of XPS models. To fix the regression, add
> > > > > > this model to the blacklist.
> > > > > >
> > > > > > [0] https://bugzilla.kernel.org/show_bug.cgi?id=211081
> > > > > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=195751
> > > > > >
> > > > > > Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all XPS models")
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Reported-by: Bob Hepple <bob.hepple@gmail.com>
> > > > > > Tested-by: Bob Hepple <bob.hepple@gmail.com>
> > > > > > Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> > > > > > ---
> > > > > >
> > > > > >  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
> > > > > >  1 file changed, 7 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
> > > > > > index ec448f5f2dc3..73b9db9e3aab 100644
> > > > > > --- a/drivers/hwmon/dell-smm-hwmon.c
> > > > > > +++ b/drivers/hwmon/dell-smm-hwmon.c
> > > > > > @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_fan_support_dmi_table[] __initdata = {
> > > > > >                       DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
> > > > > >               },
> > > > > >       },
> > > > > > +     {
> > > > > > +             .ident = "Dell XPS 15 L502X",
> > > > > > +             .matches = {
> > > > > > +                     DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > > > > > +                     DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L502X"),
> > > > >
> > > > > Hello! Are you sure that it is required to completely disable fan
> > > > > support? And not only access to fan type label for which is different
> > > > > blaclist i8k_blacklist_fan_type_dmi_table?
> > > >
> > > > This is a good question. We didn't try the other list. Bob is the one with the
> > > > affected system. Could you try moving the added block of code from
> > > > i8k_blacklist_fan_support_dmi_table a few lines up to
> > > > i8k_blacklist_fan_type_dmi_table, Bob, to see if the issue reappears or if it
> > > > remains fixed?
> > > >
> > > > >
> > > > > And have you reported this issue to Dell support?
> > > > >
> > > > > > +             },
> > > > > > +     },
> > > > > >       { }
> > > > > >  };
> > > > > >
> > > > > > --
> > > > > > 2.30.0
> > > > > >
> > > >
> > > > (Apologies for the previous HTML copy of this reply, to those directly CCed.)
> > > >
> > > > -Tom
