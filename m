Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24F2166773
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 20:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgBTTrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 14:47:55 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46004 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728514AbgBTTrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Feb 2020 14:47:55 -0500
Received: by mail-ot1-f65.google.com with SMTP id 59so4788692otp.12
        for <stable@vger.kernel.org>; Thu, 20 Feb 2020 11:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/HoCewIWGRlWuEeXmrfv+UqiTIAJGSteGrzN7L3uWb0=;
        b=mXySGb13iy9gzRfPs3NaD1y2EggX6AKvHjK2u1VLG+nbxl1Ozio4YFC+bpiY6nAuoh
         H8U9TE7PFM6ukgW3QD7RplK4kbpKBnztIq8gnGDy7ryzo2BWB9Op472nO97axwVPW0G5
         yMmVR5EQ0CnAaK7RkLxy1KPv5MCHgRjPN8aaeex8FxKhQXc7IZXynjQ727XchLc+g4Wu
         uzmfoME7tpK3aN2zU2RD8qGvQZjQNU979Py4DIkA5RS8kfmleT72r6l0g9zWCFsI5jhy
         O1RuK871r/B9ertTVMZkw4yam8xqJZXkJNG9m8e/0iRotD5Zit0OhM8TsM642cIFm7Jr
         z3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/HoCewIWGRlWuEeXmrfv+UqiTIAJGSteGrzN7L3uWb0=;
        b=HqdSUMLbrkiqFZftwIpUHSdcnTmkj53Tjn0PIQ6nBIYhyVJ5NvLQXZiwL7twkbNGv7
         e2SD6vS+dqXOQPn0N1sW/QS3STFi+vnvTXedkKnuivBK6IzyeHbeNa2xTJRXkcylfwyN
         jnHDQ9zCNaHZkju1jWvlDv6m+wv6nbLShmlHiw5Y9b49Jw0grF3BcSVi4ejILO1RXBCC
         pMQ8qCMgs/On7ZkGenkiQ5cyJxPLUvLaI41nJNDKV0qYIxsyNE0xbO9YyBuEaxTgpKAX
         6a7RQFB7dWeGYCu5ofMtDDPbyc9LTRjWbySUAWKCzEPS6fUqRjD0ZVhj5WUmceB2Oeq8
         xJzg==
X-Gm-Message-State: APjAAAXWXHrry6pDwWP0nZOYsmYb0jyw/Nkv6G87ig0KLaWbFV5KdGA2
        sJajej0lTpv8/4D1Xx+TYFyOIp0qi/j4Ljc2lGApGA==
X-Google-Smtp-Source: APXvYqw5CxRUIemmv7HG5PfIV4B/gx4IGiH6uCPLkQuO0aFIY3aMomfngyuJazR1i8wHGWO4WuOgUePBOg9ayLAGRtw=
X-Received: by 2002:a9d:7695:: with SMTP id j21mr25627694otl.157.1582228074288;
 Thu, 20 Feb 2020 11:47:54 -0800 (PST)
MIME-Version: 1.0
References: <1582220224-1904-1-git-send-email-orson.unisoc@gmail.com> <20200220191513.GA3450796@kroah.com>
In-Reply-To: <20200220191513.GA3450796@kroah.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Thu, 20 Feb 2020 11:47:41 -0800
Message-ID: <CALAqxLViRgGE8FsukCJL+doqk_GqabLDCtXBWem+VOGf9xXZdg@mail.gmail.com>
Subject: Re: [PATCH] Revert "PM / devfreq: Modify the device name as
 devfreq(X) for sysfs"
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Orson Zhai <orson.unisoc@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, mingmin.ling@unisoc.com,
        orsonzhai@gmail.com, jingchao.ye@unisoc.com,
        Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 11:15 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 21, 2020 at 01:37:04AM +0800, Orson Zhai wrote:
> > This reverts commit 4585fbcb5331fc910b7e553ad3efd0dd7b320d14.
> >
> > The name changing as devfreq(X) breaks some user space applications,
> > such as Android HAL from Unisoc and Hikey [1].
> > The device name will be changed unexpectly after every boot depending
> > on module init sequence. It will make trouble to setup some system
> > configuration like selinux for Android.
> >
> > So we'd like to revert it back to old naming rule before any better
> > way being found.
> >
> > [1] https://lkml.org/lkml/2018/5/8/1042
> >
> > Cc: John Stultz <john.stultz@linaro.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Orson Zhai <orson.unisoc@gmail.com>
> >
> > ---
> >  drivers/devfreq/devfreq.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> > index cceee8b..7dcf209 100644
> > --- a/drivers/devfreq/devfreq.c
> > +++ b/drivers/devfreq/devfreq.c
> > @@ -738,7 +738,6 @@ struct devfreq *devfreq_add_device(struct device *dev,
> >  {
> >       struct devfreq *devfreq;
> >       struct devfreq_governor *governor;
> > -     static atomic_t devfreq_no = ATOMIC_INIT(-1);
> >       int err = 0;
> >
> >       if (!dev || !profile || !governor_name) {
> > @@ -800,8 +799,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
> >       devfreq->suspend_freq = dev_pm_opp_get_suspend_opp_freq(dev);
> >       atomic_set(&devfreq->suspend_count, 0);
> >
> > -     dev_set_name(&devfreq->dev, "devfreq%d",
> > -                             atomic_inc_return(&devfreq_no));
> > +     dev_set_name(&devfreq->dev, "%s", dev_name(dev));
> >       err = device_register(&devfreq->dev);
> >       if (err) {
> >               mutex_unlock(&devfreq->lock);
> > --
> > 2.7.4
> >
>
> Thanks for this, I agree, this needs to get back to the way things were
> as it seems to break too many existing systems as-is.
>
> I'll queue this up in my tree now, thanks.

Oof this old thing. I unfortunately didn't get back to look at the
devfreq name node issue or the compatibility links, since the impact
of the regression (breaking the powerHAL's interactions with the gpu)
wasn't as big as other problems we had. While the regression was
frustrating, my only hesitancy at this point is that its been this way
since 4.10, so reverting the problematic patch is likely to break any
new users since then.

thanks
-john
