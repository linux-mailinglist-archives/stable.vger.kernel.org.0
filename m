Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6743A9F03
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 11:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732655AbfIEJ6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 05:58:19 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42085 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732586AbfIEJ6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 05:58:19 -0400
Received: by mail-ot1-f68.google.com with SMTP id c10so1544586otd.9
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 02:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hnbGMV0ke6efL1y6IAGd1/5aAnuIrZOt2ZdaXM11mnY=;
        b=Zb2EdgevwrOivl4Hpeog1dvZrPbCgAaPFDKZ1C3ZASNOtO2lBM0J3kYJVSSl85H+Hi
         2j0MZZ9oPjruXgBhJ2YdPy4c1ZQEedLBNfOIWHibLTpWiTleNytKbk/lEYL+bIXCzaGK
         hg1eJxfQ8pOKwflrGHxEW/+SJxCHXiuabJynduPkE2cFzvwL4UNCjHhWLI0A/2q9jq3I
         zjeaYdf+zlKS2TmGcZq1miIb/UQQroStKlhR9UjuAf3SwFvld9Enx2BWqFz5poWUlSjT
         ABHCTAJi+YAiRLHF+ZFwta119HWm/0QIkeEb7EMzOIICCuwCZKUPwF6nw8Musy5MUuBn
         OtWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hnbGMV0ke6efL1y6IAGd1/5aAnuIrZOt2ZdaXM11mnY=;
        b=oUFH9090tqY3qwlsAHV5T5/3+MQxEmmx+svz7+NNmKDP4RK3+p3y4m/3lhFKr0oNQN
         5FKfbe8LSb2hzNFH4wwjRWHsyZskiH4gwHOHSPxn90WgPPw3eiNjkDQ+waLNrjBIlkoI
         eNFC77+29lbCT9bhGgEnQvxdmfVIXHcqlG2aOIL+gn3GkasQh5VDPYb0T4J3liJen+8+
         Ks/7w7AuXjDGXOSPSavJ99oYs60a3hjmtb7CrsWmFdRtWoMJmz9CXpLql7saO6teaH/6
         DGzVePN+agnuHs/1z+ywfG9apdhr+TFxqGTldwymXJbYqfaYg7Vf/Ob54ZXOLuMeT4Kf
         JqEw==
X-Gm-Message-State: APjAAAU1ZaUtrGezw02gXLsZ0FM/SHEHOncf3xQgx6eCWSRiulK23hOx
        8xMA3y09L2OATVbkBi5nnYZFL4Cs1ZyPYVlcodbB07/2gLgCmw==
X-Google-Smtp-Source: APXvYqzCDH1YCCSMsIEkv4xJY+H+7KZ47ifg63IfI8eOQxPZyPeNDZYxzm7hF0g59E5d7DvOBE8Tw7cuqXc2nDu40Vc=
X-Received: by 2002:a9d:6304:: with SMTP id q4mr1681677otk.269.1567677497646;
 Thu, 05 Sep 2019 02:58:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1567649728.git.baolin.wang@linaro.org> <4fe6ec82960301126b9f4be52dd6083c30e17420.1567649729.git.baolin.wang@linaro.org>
 <20190905090130.GF1701@localhost>
In-Reply-To: <20190905090130.GF1701@localhost>
From:   Baolin Wang <baolin.wang@linaro.org>
Date:   Thu, 5 Sep 2019 17:58:05 +0800
Message-ID: <CAMz4kuJGmQxfy5mi1aZNL8SA8MQBSTTyDeWcHHEtG2aXsFZgug@mail.gmail.com>
Subject: Re: [BACKPORT 4.14.y v2 6/6] serial: sprd: Modify the baud rate
 calculation formula
To:     Johan Hovold <johan@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, lanqing.liu@unisoc.com,
        linux-serial@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

On Thu, 5 Sep 2019 at 17:01, Johan Hovold <johan@kernel.org> wrote:
>
> On Thu, Sep 05, 2019 at 11:11:26AM +0800, Baolin Wang wrote:
> > From: Lanqing Liu <lanqing.liu@unisoc.com>
> >
> > [Upstream commit 5b9cea15a3de5d65000d49f626b71b00d42a0577]
> >
> > When the source clock is not divisible by the expected baud rate and
> > the remainder is not less than half of the expected baud rate, the old
> > formular will round up the frequency division coefficient. This will
> > make the actual baud rate less than the expected value and can not meet
> > the external transmission requirements.
> >
> > Thus this patch modifies the baud rate calculation formula to support
> > the serial controller output the maximum baud rate.
> >
> > Signed-off-by: Lanqing Liu <lanqing.liu@unisoc.com>
> > Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> > ---
> >  drivers/tty/serial/sprd_serial.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
> > index e902494..72e96ab8 100644
> > --- a/drivers/tty/serial/sprd_serial.c
> > +++ b/drivers/tty/serial/sprd_serial.c
> > @@ -380,7 +380,7 @@ static void sprd_set_termios(struct uart_port *port,
> >       /* ask the core to calculate the divisor for us */
> >       baud = uart_get_baud_rate(port, termios, old, 0, SPRD_BAUD_IO_LIMIT);
> >
> > -     quot = (unsigned int)((port->uartclk + baud / 2) / baud);
> > +     quot = port->uartclk / baud;
>
> Are you sure the original patch is even correct?
>
> By replacing the divisor rounding with truncation you are introducing
> larger errors for some baud rates, something which could possibly even
> break working systems.

Our UART clock source is 26M, and there is no difference for lower
than 3M baud rate between dividing closest or dividing down. But we
have one special use case is our BT/GPS want to set 3.25M baud rate,
but we have to select 3M baud rate in baud_table since no 3.25M
setting. So in this case if we use the old formula, we will only get
about 2.8M baud rate, which can not meet our requirement. If we change
the dividing down method, we can get 3.25M baud rate.

I have to say this is a workaroud for our special case, and can solve
our problem. If you have any good suggestion, we can change to a
better solution. Thanks.

>
> Perhaps the original patch should even be reverted, but in any case
> backporting this to stable looks questionable.
>
> >
> >       /* set data length */
> >       switch (termios->c_cflag & CSIZE) {
>
> Johan



-- 
Baolin Wang
Best Regards
