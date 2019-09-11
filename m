Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A296AFE3F
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfIKOBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 10:01:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35035 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727664AbfIKOBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 10:01:52 -0400
Received: by mail-io1-f66.google.com with SMTP id f4so45316706ion.2
        for <stable@vger.kernel.org>; Wed, 11 Sep 2019 07:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gVldwPHBEEmbVAp0mqxQZ8yLS+V+O/vse0Nw9BG4UF4=;
        b=hBNyoV0eH/Hs1sEwCVhxj9P0JoyfQUrF0U3/ZXzz5girYAggowVoFY2+1JI1EFRFpQ
         Fjsdy0gmaNawhrBqh3dirr4WnLeBVcC85YwTMGzVZcowXPgFcVvsoCQ2eF8suXeCJVkz
         JzE011UVXk9nKhJXe1Y50RbHaKbNCH5/fiOGC5eeYN5XB9LkSZHr4wCn93Q4fqtTOCHy
         ptj6s8zn2e1a8JDLxhyaflKp/gsslZYNCH3Xqp+OJsjpf3peoaBVI2T8yCpbdH7MD6Fo
         bl/p/zPK8SVvwuHoAbYY/baFe/qYTBigkc9dQIQv9bno/q7j4HmDRzajYYWIY4yFWnXz
         WJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gVldwPHBEEmbVAp0mqxQZ8yLS+V+O/vse0Nw9BG4UF4=;
        b=Ma02mwhZ7QG7eWzORJ8Fewc1I34tSrFb/xCLYihE3IJBlGD4dLio7I5U0mTm5JVr1D
         EjdUj+37PZKWDzZ+MQSuTzwBtoCq78mATI074ub+si++oxWWhLZI0BaGdAtXrjl8hJRK
         YDzUEDfBJmUSHQtC95/1CG+TYjluV1IGQypuePCXTusUPtAgs/B7xXcnk1KTtiEOmFsZ
         2Ks0CM512hS5Y0u9w8OD+yzijOhJrWLzMW7E04x2qOuvBGP/gNxvrX+X5+6ppqqj+98+
         nO35zXDsHJhdjue627yaZhRgblzUTF0+xWKUOWHoF+ggA0HyvIlVZFvGB/OVD+gUqTeo
         C7bQ==
X-Gm-Message-State: APjAAAUt2CUMkGAS4xvW/RpyNCdA8Q8npNKJOddEg/pos19hv0NAYjj+
        t0AI2Auveh5lDY2yY328wt2WYeleArrucFUqz1/WbQ==
X-Google-Smtp-Source: APXvYqxA0bdjqPHqQ2NueNxICWH/tLLMJq1Vz+tJAm+kZ8i8BExfLfIhffXcQQNYtvksdWYGm4ADVKWY6+G86Koreqs=
X-Received: by 2002:a05:6638:93b:: with SMTP id 27mr1396480jak.36.1568210511727;
 Wed, 11 Sep 2019 07:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190905161759.28036-1-mathieu.poirier@linaro.org>
 <20190905161759.28036-5-mathieu.poirier@linaro.org> <20190910143601.GD3362@kroah.com>
In-Reply-To: <20190910143601.GD3362@kroah.com>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Wed, 11 Sep 2019 08:01:40 -0600
Message-ID: <CANLsYkwkq2fLWsGXHxr2tSBLHdfe4JXgu8ehuD1FOEQeDAPNnA@mail.gmail.com>
Subject: Re: [BACKPORT 4.14.y 04/18] usb: dwc3: Allow disabling of
 metastability workaround
To:     Greg KH <greg@kroah.com>
Cc:     "# 4 . 7" <stable@vger.kernel.org>, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Sep 2019 at 08:36, Greg KH <greg@kroah.com> wrote:
>
> On Thu, Sep 05, 2019 at 10:17:45AM -0600, Mathieu Poirier wrote:
> > From: Roger Quadros <rogerq@ti.com>
> >
> > commit 42bf02ec6e420e541af9a47437d0bdf961ca2972 upstream
> >
> > Some platforms (e.g. TI's DRA7 USB2 instance) have more trouble
> > with the metastability workaround as it supports only
> > a High-Speed PHY and the PHY can enter into an Erratic state [1]
> > when the controller is set in SuperSpeed mode as part of
> > the metastability workaround.
> >
> > This causes upto 2 seconds delay in enumeration on DRA7's USB2
> > instance in gadget mode.
> >
> > If these platforms can be better off without the workaround,
> > provide a device tree property to suggest that so the workaround
> > is avoided.
> >
> > [1] Device mode enumeration trace showing PHY Erratic Error.
> >      irq/90-dwc3-969   [000] d...    52.323145: dwc3_event: event (00000901): Erratic Error [U0]
> >      irq/90-dwc3-969   [000] d...    52.560646: dwc3_event: event (00000901): Erratic Error [U0]
> >      irq/90-dwc3-969   [000] d...    52.798144: dwc3_event: event (00000901): Erratic Error [U0]
>
> Does the DT also need to get updated with this new id for this?  Is that
> a separate patch somewhere?

The upstream commit is:

b8c9c6fa2002 ARM: dts: dra7: Disable USB metastability workaround for USB2

Should I just send the latter or you prefer a resend with both patches?

Thanks,
Mathieu

>
> thanks,
>
> greg k-h
