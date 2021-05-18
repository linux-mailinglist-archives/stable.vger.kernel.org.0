Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FAD3877C3
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 13:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240463AbhERLfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 07:35:22 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:57629 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240092AbhERLfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 07:35:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id F1C8058055C;
        Tue, 18 May 2021 07:34:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 18 May 2021 07:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=p
        kdRjnuTG13nf47V64EPvbETtZfVwRqN7wdxtyB5N0Q=; b=M3Aexoq+CbUhkC5ZF
        Af12ClcqnfZWRaJScOAYfoTczY0k4niWVrzvsqydFuM6rMLgZujxx9xZHrN0aZmp
        RoVw7gkcpajphzjK7yil4A9Tg1ylXqGLUbub8+s6JgQaY19Y0V271EG8ZWbgrHPv
        jhGmIiMawkfodkDZKopB8+Y4aRIK9Vg0eaWNAnPARjrO/zMVg5cjCkBLLFpiHib3
        HtnhM11cT4O94w/1Cu9mkOKBy1BnKRWZbvSkFEIdbrc4EYWPROurbTS3Cn4U+ttb
        YT+TRXRtZrqxytPZxZul573A2d8jUKMzGG6bRI8DjyYNcnjNg3a9VzpdAbBLWw8p
        nJHJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=pkdRjnuTG13nf47V64EPvbETtZfVwRqN7wdxtyB5N
        0Q=; b=SFj3Sa/2f2Jo7n2qiKHa0Q6HHvzywB/ZYqlsiCIgCjJ6r6HOgqvLYl+jA
        k8RPdlEXZKkg26/geQvILAO4NBEU2Ngxdv5fC6eAa5d7ToB8spQZpkhdhxg89hDe
        0DEWtrSlBZISYoTawE31aDpLle7BzHQvS5Jv8H6JfwikCuGEFBQZlBkwsHntUOOK
        7SOO298wOi4t0kufTMQrvJsa4LDQK5Op2fvPb5OvsmQHmeyOl9lsli6uhjZLH0Fx
        rMGXUSplo3XOyHyBhXeygCkZ4sgbQcdinpSsk16Z2I0mr5jZsUPaODEPMIGx7ve6
        etpgDIAidB/8FdyC+PgvKGlHJZeaw==
X-ME-Sender: <xms:KqajYLfHqJlZaj4P8Y9j050sBGRAMYSaLuTc8-U9WQgDKBtEJ9OByw>
    <xme:KqajYBOP9SZOYsnIsf_7Lx9VW5VnJAhecJDbCC-QbwMcChnx29DLn501BPHtL-oib
    H2hZ_ws1anX5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeijedggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueehke
    ehlefffeeiudetfeekjeffvdeuheejjeffheeludfgteekvdelkeduuddvnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:KqajYEhV_YsAwFWMHfJrunBkhPhVUcHPCjSzOFWBnOpvGOl71kwwCw>
    <xmx:KqajYM9rv4ihl2jjBLO4lfMVRg3lYRePR3a9RnW6WPFdrgc7A9PB0g>
    <xmx:KqajYHuldFVt9-sociNHh3QJ4iYFZXqGSGA1o6QpN2EN_YV26VSUuw>
    <xmx:KqajYFIeU863feZQ9HIpPtkaZpyNBD5Ny86yERHUL1iiOEeJqW0ZnA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Tue, 18 May 2021 07:34:02 -0400 (EDT)
Date:   Tue, 18 May 2021 13:34:00 +0200
From:   Greg KH <greg@kroah.com>
To:     Patryk Duda <pdk@semihalf.com>
Cc:     Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-kernel@vger.kernel.org, upstream@semihalf.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] platform/chrome: cros_ec_proto: Send command again when
 timeout occurs
Message-ID: <YKOmKHPCPx3FuTV3@kroah.com>
References: <20210518090925.15480-1-pdk@semihalf.com>
 <YKOI9ndTg8s1uUvx@kroah.com>
 <CAGOBvLq8hyRs7MZoZE0o0h0s9y1bL9eV3ex2A3FsmfjtofxsAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGOBvLq8hyRs7MZoZE0o0h0s9y1bL9eV3ex2A3FsmfjtofxsAg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 01:22:30PM +0200, Patryk Duda wrote:
> wt., 18 maj 2021 o 11:29 Greg KH <greg@kroah.com> napisał(a):
> >
> > On Tue, May 18, 2021 at 11:09:25AM +0200, Patryk Duda wrote:
> > > Sometimes kernel is trying to probe Fingerprint MCU (FPMCU) when it
> > > hasn't initialized SPI yet. This can happen because FPMCU is restarted
> > > during system boot and kernel can send message in short window
> > > eg. between sysjump to RW and SPI initialization.
> > >
> > > Cc: <stable@vger.kernel.org> # 4.4+
> > > Signed-off-by: Patryk Duda <pdk@semihalf.com>
> > > ---
> > > Fingerprint MCU is rebooted during system startup by AP firmware (coreboot).
> > > During cold boot kernel can query FPMCU in a window just after jump to RW
> > > section of firmware but before SPI is initialized. The window was
> > > shortened to <1ms, but it can't be eliminated completly.
> > >
> > > Communication with FPMCU (and all devices based on EC) is bi-directional.
> > > When kernel sends message, EC will send EC_SPI* status codes. When EC is
> > > not able to process command one of bytes will be eg. EC_SPI_NOT_READY.
> > > This mechanism won't work when SPI is not initailized on EC side. In fact,
> > > buffer is filled with 0xFF bytes, so from kernel perspective device is not
> > > responding. To avoid this problem, we can query device once again. We are
> > > already waiting EC_MSG_DEADLINE_MS for response, so we can send command
> > > immediately.
> > >
> > > Best regards,
> > > Patryk
> > >  drivers/platform/chrome/cros_ec_proto.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
> > > index aa7f7aa77297..3384631d21e2 100644
> > > --- a/drivers/platform/chrome/cros_ec_proto.c
> > > +++ b/drivers/platform/chrome/cros_ec_proto.c
> > > @@ -279,6 +279,18 @@ static int cros_ec_host_command_proto_query(struct cros_ec_device *ec_dev,
> > >       msg->insize = sizeof(struct ec_response_get_protocol_info);
> > >
> > >       ret = send_command(ec_dev, msg);
> > > +     /*
> > > +      * Send command once again when timeout occurred.
> > > +      * Fingerprint MCU (FPMCU) is restarted during system boot which
> > > +      * introduces small window in which FPMCU won't respond for any
> > > +      * messages sent by kernel. There is no need to wait before next
> > > +      * attempt because we waited at least EC_MSG_DEADLINE_MS.
> > > +      */
> > > +     if (ret == -ETIMEDOUT) {
> > > +             dev_warn(ec_dev->dev,
> > > +                      "Timeout to get response from EC. Retrying.\n");
> >
> > If a user sees this, what can they do?  No need to spam the kernel logs,
> > just retry.
> User can do nothing about it. I will remove this in next version of patch.
> >
> > > +             ret = send_command(ec_dev, msg);
> >
> > But wait, why just retry once?  Why not 10 times?  100?  1000?  How
> > about a simple loop here instead, with a "sane" number of retries as a
> > max.
> EC based devices are designed to respond always or return appropriate
> status code
> when they can't process command. But this assumes that SPI is always
> ready to work.
> It's true for Embedded Controller, but not for Fingerprint MCU. So we
> can retry once,
> in case of sending message, when FPMCU is in narrow window (~1ms) when SPI is
> not initialized.
> 
> Every send_command() call can take about 200ms when device is not responding,
> so next retry will happen after 200ms, at least. If 200ms is not
> enough for FPMCU
> to initialize SPI, it's definitely something wrong with FPMCU

Ok, then just loop for 2 for this, should make it more obvious.

thanks,

greg k-h
