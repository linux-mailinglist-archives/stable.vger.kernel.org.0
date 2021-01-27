Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4350E306765
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 00:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhA0XA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 18:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233248AbhA0W6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 17:58:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBB9E64DD6;
        Wed, 27 Jan 2021 22:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611788285;
        bh=nGzFcZ6/AbcsatBSuFjcKCrzAXMUHOxxmvxhOjY/iT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tv0GjGU7pmjR4ba+DDAGwLL+KYOtKP/YlQ9gWRr0imyLO0rvWy/GB6YzO/JLNM1UK
         ZIyM1oaUpmX5tkV/qp1Z45vBeR9bOKvvNqdv4ot0m3F5UiteUDjpFG4fv+2j9bRcQv
         EG/tHabd8kSEukFtS0L2mcUtKIbPPXNtG/hw1dHZ6VcrG0nvi30LQKDxKQg7F+0Ux0
         eejzfg4vQmiUddqRbs/bhYvtc/jSeBprx4Qs0sSZolHfjC83I34zkkqyvcFV/yWKBp
         VO7A31PSVgmk8Qq2oS8oOVmfwJDDHHCvSuR432AHVGBpv7YPA7Toih8KKTPsf1Bj/9
         0UYyMHnPZr8EA==
Received: by pali.im (Postfix)
        id C9478768; Wed, 27 Jan 2021 23:58:02 +0100 (CET)
Date:   Wed, 27 Jan 2021 23:58:02 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Bob Hepple <bob.hepple@gmail.com>
Cc:     Tom Hebb <tommyhebb@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] hwmon: (dell-smm) Add XPS 15 L502X to fan control
 blacklist
Message-ID: <20210127225802.wcnr6mw7dp7nnk2e@pali>
References: <a09eea7616881d40d2db2fb5fa2770dc6166bdae.1611456351.git.tommyhebb@gmail.com>
 <20210125100540.55wbgdsem3htplx3@pali>
 <CAMcCCgTo87HmwexZS696ok16e9s_8gRgFd38uoLP34r7TbAzBg@mail.gmail.com>
 <CAHzpm2hk4+0FyFrcGYN-JJfx5Ka8yoM8mTsYZA_4WHfWYGa4yQ@mail.gmail.com>
 <CAHzpm2h2X8ZKEtRxnD-mwyEv=B8J+tH_spFGD2VzfwGdRAaHMw@mail.gmail.com>
 <CAMcCCgQRDRi1LpxJBTvKcB+dALJJsn=n5Q=Wyvfcw9LGqqjq7Q@mail.gmail.com>
 <20210127091933.haq6nmbmx3cskh5t@pali>
 <CAHzpm2j9N3ywMy6HLruCt1VaQLmB1-xVusvXUb8wa2ores+KAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHzpm2j9N3ywMy6HLruCt1VaQLmB1-xVusvXUb8wa2ores+KAQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Bob!

On Thursday 28 January 2021 08:40:36 Bob Hepple wrote:
> Hi Pali,
> 
> No, I have not contacted Dell about this and I'm not sure that they
> would be terribly interested given that my machine is 12 years old -
> but I'll have a go if I can find the right place to do it.

If it is 12 years old machine then I doubt that anybody would do any
support for it...

> Do you have a good email or other Dell target to report it?

In this post is information how to contact Dell Linux support team which
can open (internal) BIOS issue:

https://github.com/dell/libsmbios/issues/48#issuecomment-391328501

But it is possible that still only available for USA.

Mario (superm1 on github) is active also in kernel and can help with
firmware issues on new machines.

But for this your 12 years old machine is proposed blacklist quirk the
only option.

I just do not know if this issue was already fixed in new BIOS which is
available on new machines. And therefore I'm worried if these issues
would continue to appear also on other machines, or we are just
collecting list of old machines.

Just I do not want to see situation when manufacture says "it is
working, nothing needed to fix" and it would work just because of
blacklist... As such scenario would lead only to increasing blacklist
without ability to start fixing issues.

> I don't
> have access to official Dell support as my warranty ran out about 10
> years ago. Perhaps there's an existing Dell bug report that references
> the original https://bugzilla.kernel.org/show_bug.cgi?id=195751 ??? I
> could add my report there if someone has already informed Dell about
> the other instances of the bug.
> 
> Thanks
> 
> 
> 
> Bob
> 
> On Wed, 27 Jan 2021 at 19:19, Pali Rohár <pali@kernel.org> wrote:
> >
> > On Tuesday 26 January 2021 00:15:13 Tom Hebb wrote:
> > > Bob reports that blacklisting the fan type label is not sufficient.
> > > See his message to me below.
> >
> > Ok! Thank you for confirmation.
> >
> > And my second question which I have asked:
> > And have you reported this issue to Dell support?
> >
> > > On Mon, Jan 25, 2021 at 3:38 PM Bob Hepple <bob.hepple@gmail.com> wrote:
> > > >
> > > > Hi Tom,
> > > >
> > > > Big nope this end with L502x in i8k_blacklist_fan_type_dmi_table:
> > > >
> > > > Jan 26 09:35:47 achar kernel: psmouse serio1: TouchPad at
> > > > isa0060/serio1/input0 lost synchronization, throwing 1 bytes>
> > > >
> > > > ... and lots of trackpad stall/stutters.
> > > >
> > > > Cheers
> > > >
> > > >
> > > > Bob
> > > >
> > > >
> > > >
> > > > On Tue, 26 Jan 2021 at 08:09, Bob Hepple <bob.hepple@gmail.com> wrote:
> > > > >
> > > > > ... compiling now ... results in a coupla hours
> > > > >
> > > > > Cheers
> > > > >
> > > > >
> > > > > Bob
> > > > >
> > > > > On Tue, 26 Jan 2021 at 04:05, Tom Hebb <tommyhebb@gmail.com> wrote:
> > > > > >
> > > > > > On Mon, Jan 25, 2021 at 2:05 AM Pali Rohár <pali@kernel.org> wrote:
> > > > > > >
> > > > > > > On Saturday 23 January 2021 18:46:08 Thomas Hebb wrote:
> > > > > > > > It has been reported[0] that the Dell XPS 15 L502X exhibits similar
> > > > > > > > freezing behavior to the other systems[1] on this blacklist. The issue
> > > > > > > > was exposed by a prior change of mine to automatically load
> > > > > > > > dell_smm_hwmon on a wider set of XPS models. To fix the regression, add
> > > > > > > > this model to the blacklist.
> > > > > > > >
> > > > > > > > [0] https://bugzilla.kernel.org/show_bug.cgi?id=211081
> > > > > > > > [1] https://bugzilla.kernel.org/show_bug.cgi?id=195751
> > > > > > > >
> > > > > > > > Fixes: b8a13e5e8f37 ("hwmon: (dell-smm) Use one DMI match for all XPS models")
> > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > Reported-by: Bob Hepple <bob.hepple@gmail.com>
> > > > > > > > Tested-by: Bob Hepple <bob.hepple@gmail.com>
> > > > > > > > Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
> > > > > > > > ---
> > > > > > > >
> > > > > > > >  drivers/hwmon/dell-smm-hwmon.c | 7 +++++++
> > > > > > > >  1 file changed, 7 insertions(+)
> > > > > > > >
> > > > > > > > diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
> > > > > > > > index ec448f5f2dc3..73b9db9e3aab 100644
> > > > > > > > --- a/drivers/hwmon/dell-smm-hwmon.c
> > > > > > > > +++ b/drivers/hwmon/dell-smm-hwmon.c
> > > > > > > > @@ -1159,6 +1159,13 @@ static struct dmi_system_id i8k_blacklist_fan_support_dmi_table[] __initdata = {
> > > > > > > >                       DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "XPS13 9333"),
> > > > > > > >               },
> > > > > > > >       },
> > > > > > > > +     {
> > > > > > > > +             .ident = "Dell XPS 15 L502X",
> > > > > > > > +             .matches = {
> > > > > > > > +                     DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> > > > > > > > +                     DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L502X"),
> > > > > > >
> > > > > > > Hello! Are you sure that it is required to completely disable fan
> > > > > > > support? And not only access to fan type label for which is different
> > > > > > > blaclist i8k_blacklist_fan_type_dmi_table?
> > > > > >
> > > > > > This is a good question. We didn't try the other list. Bob is the one with the
> > > > > > affected system. Could you try moving the added block of code from
> > > > > > i8k_blacklist_fan_support_dmi_table a few lines up to
> > > > > > i8k_blacklist_fan_type_dmi_table, Bob, to see if the issue reappears or if it
> > > > > > remains fixed?
> > > > > >
> > > > > > >
> > > > > > > And have you reported this issue to Dell support?
> > > > > > >
> > > > > > > > +             },
> > > > > > > > +     },
> > > > > > > >       { }
> > > > > > > >  };
> > > > > > > >
> > > > > > > > --
> > > > > > > > 2.30.0
> > > > > > > >
> > > > > >
> > > > > > (Apologies for the previous HTML copy of this reply, to those directly CCed.)
> > > > > >
> > > > > > -Tom
