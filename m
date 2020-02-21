Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B255E168A90
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 00:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgBUXz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 18:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgBUXz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 18:55:57 -0500
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1244207FD;
        Fri, 21 Feb 2020 23:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582329356;
        bh=/VVepq+FCWFteAi2zMlc3PgAKOt8Z3Rt1ZqXWUn3ysk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KTa0Vxgcm+kTqDsDnCbwMtCyM99ToA5yDhPRippdZbwwxCAEZR4gqUXB1m/spTN2C
         8cROeXo0ICeGPAgyY5UOn139Vl4VViBtRyf+2+wD2Nqz+NFXKMeqVcEJgOJbuK657I
         4inAwd4X9Bf6E1GXP0nuLhv2FByzfz/dRkB6lmZU=
Received: by mail-lf1-f41.google.com with SMTP id l16so2731331lfg.2;
        Fri, 21 Feb 2020 15:55:55 -0800 (PST)
X-Gm-Message-State: APjAAAVdq40CEJTNAo18S/insWpmoJyaimR2kl/NqWHSMYr6pGXARZLd
        7Ul12BuELwU2Y57HMhCwShQ31Ccyu1TObHQ30SU=
X-Google-Smtp-Source: APXvYqy80HvupdWLoACdb1lPqBsAa+P5Rsl8zfrXjEf0dHWDar/npUDuCPd1QM4MpmaGEOdWQo6iE/gN8M9xnOdAtIs=
X-Received: by 2002:a19:c714:: with SMTP id x20mr113109lff.107.1582329353907;
 Fri, 21 Feb 2020 15:55:53 -0800 (PST)
MIME-Version: 1.0
References: <1582220224-1904-1-git-send-email-orson.unisoc@gmail.com>
 <20200220191513.GA3450796@kroah.com> <CALAqxLViRgGE8FsukCJL+doqk_GqabLDCtXBWem+VOGf9xXZdg@mail.gmail.com>
 <CGME20200221070652epcas1p11e82863794f130373055c0b7bdedff23@epcas1p1.samsung.com>
 <20200221070646.GA4103708@kroah.com> <1b9e510a-71bb-5aa8-ef85-a9a9c623f313@samsung.com>
 <20200221111313.GA110504@kroah.com>
In-Reply-To: <20200221111313.GA110504@kroah.com>
From:   Chanwoo Choi <chanwoo@kernel.org>
Date:   Sat, 22 Feb 2020 08:55:22 +0900
X-Gmail-Original-Message-ID: <CAGTfZH0Ev2sCH073WdUjZJS5MNnJ9vzgsc_ApYkg+na2Fk4J+g@mail.gmail.com>
Message-ID: <CAGTfZH0Ev2sCH073WdUjZJS5MNnJ9vzgsc_ApYkg+na2Fk4J+g@mail.gmail.com>
Subject: Re: [PATCH] Revert "PM / devfreq: Modify the device name as
 devfreq(X) for sysfs"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Chanwoo Choi <cw00.choi@samsung.com>,
        John Stultz <john.stultz@linaro.org>,
        Orson Zhai <orson.unisoc@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        mingmin.ling@unisoc.com, orsonzhai@gmail.com,
        jingchao.ye@unisoc.com, Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 21, 2020 at 8:13 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 21, 2020 at 05:11:02PM +0900, Chanwoo Choi wrote:
> > On 2/21/20 4:06 PM, Greg Kroah-Hartman wrote:
> > > On Thu, Feb 20, 2020 at 11:47:41AM -0800, John Stultz wrote:
> > >> On Thu, Feb 20, 2020 at 11:15 AM Greg Kroah-Hartman
> > >> <gregkh@linuxfoundation.org> wrote:
> > >>>
> > >>> On Fri, Feb 21, 2020 at 01:37:04AM +0800, Orson Zhai wrote:
> > >>>> This reverts commit 4585fbcb5331fc910b7e553ad3efd0dd7b320d14.
> > >>>>
> > >>>> The name changing as devfreq(X) breaks some user space applications,
> > >>>> such as Android HAL from Unisoc and Hikey [1].
> > >>>> The device name will be changed unexpectly after every boot depending
> > >>>> on module init sequence. It will make trouble to setup some system
> > >>>> configuration like selinux for Android.
> > >>>>
> > >>>> So we'd like to revert it back to old naming rule before any better
> > >>>> way being found.
> > >>>>
> > >>>> [1] https://protect2.fireeye.com/url?k=00fa721e-5d2a7af6-00fbf951-000babff32e3-95e4b92259b05656&u=https://lkml.org/lkml/2018/5/8/1042
> > >>>>
> > >>>> Cc: John Stultz <john.stultz@linaro.org>
> > >>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >>>> Cc: stable@vger.kernel.org
> > >>>> Signed-off-by: Orson Zhai <orson.unisoc@gmail.com>
> > >>>>
> > >>>> ---
> > >>>>  drivers/devfreq/devfreq.c | 4 +---
> > >>>>  1 file changed, 1 insertion(+), 3 deletions(-)
> > >>>>
> > >>>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> > >>>> index cceee8b..7dcf209 100644
> > >>>> --- a/drivers/devfreq/devfreq.c
> > >>>> +++ b/drivers/devfreq/devfreq.c
> > >>>> @@ -738,7 +738,6 @@ struct devfreq *devfreq_add_device(struct device *dev,
> > >>>>  {
> > >>>>       struct devfreq *devfreq;
> > >>>>       struct devfreq_governor *governor;
> > >>>> -     static atomic_t devfreq_no = ATOMIC_INIT(-1);
> > >>>>       int err = 0;
> > >>>>
> > >>>>       if (!dev || !profile || !governor_name) {
> > >>>> @@ -800,8 +799,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
> > >>>>       devfreq->suspend_freq = dev_pm_opp_get_suspend_opp_freq(dev);
> > >>>>       atomic_set(&devfreq->suspend_count, 0);
> > >>>>
> > >>>> -     dev_set_name(&devfreq->dev, "devfreq%d",
> > >>>> -                             atomic_inc_return(&devfreq_no));
> > >>>> +     dev_set_name(&devfreq->dev, "%s", dev_name(dev));
> > >>>>       err = device_register(&devfreq->dev);
> > >>>>       if (err) {
> > >>>>               mutex_unlock(&devfreq->lock);
> > >>>> --
> > >>>> 2.7.4
> > >>>>
> > >>>
> > >>> Thanks for this, I agree, this needs to get back to the way things were
> > >>> as it seems to break too many existing systems as-is.
> > >>>
> > >>> I'll queue this up in my tree now, thanks.
> > >>
> > >> Oof this old thing. I unfortunately didn't get back to look at the
> > >> devfreq name node issue or the compatibility links, since the impact
> > >> of the regression (breaking the powerHAL's interactions with the gpu)
> > >> wasn't as big as other problems we had. While the regression was
> > >> frustrating, my only hesitancy at this point is that its been this way
> > >> since 4.10, so reverting the problematic patch is likely to break any
> > >> new users since then.
> > >
> > > Looks like most users just revert that commit in their trees:
> > >     https://protect2.fireeye.com/url?k=1012ad0f-4dc2a5e7-10132640-000babff32e3-35779c5ed675ef0f&u=https://source.codeaurora.org/quic/la/kernel/msm-4.14/commit/drivers/devfreq?h=msm-4.14&id=ccf273f6d89ad0fa8032e9225305ad6f62c7770c
> > >
> > > So we should be ok here.
> >
> > I'm sorry about changing the devfreq node name.
> >
> > OK. Do you pick this patch to your tree?
>
> Yes, I can do that.

If you agree, how about merging it to devfreq.git
for preventing the potential merge conflict with other devfreq patches?

>
> > or If not, I'll apply it to devfreq-next branch for v5.7-rc1.
> >
> > And do you apply it to kernel of linux-stable tree since 4.11?
>
> Yeah, I'll mark it for stable.

Thanks.

>
> Can I get an ack from you for this?

OK. but, if it will be merged to devfreq.git,
can I get an ack from you?

>
> thanks,
>
> greg k-h



-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
