Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA3D41C563
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 15:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344081AbhI2NTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 09:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344098AbhI2NTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 09:19:17 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2CFC061755
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 06:17:36 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y35so8665925ede.3
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 06:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJLiiUeulvsE5Jpu0obENQGGvYdNvxhst0WjqmLYdUg=;
        b=v4YOzY3zC6nHOPzxbDz2rLrlZesaa8fIiHRxmFuNP2QGO6VtJVWDIV+pshTho5RnWf
         rsoqAlNkLsvprRAYGCqBF3ByuYuDoKYcqPODlO9vOIsLlU1tDjlKXCUrdsOOd/MxPSpn
         +VkPTIsG3TQUVstZP9VzxEGq/LgTcFW1woySilmgFdsHvSiW/0BxB9pSis8zwVQdpcTq
         bIfl++Tvy+17cMLlBrtmJ0CkjAkD5dCwii60pp3b1RqHd0yhds1IjLm9phacZd2jjnUU
         0ikndzbT8Bk4jfMwC76f1dDJSUJO9r89SJd53LvPcKuwNmszBsrIJPqT4Ftna3tH87Pf
         BTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJLiiUeulvsE5Jpu0obENQGGvYdNvxhst0WjqmLYdUg=;
        b=mVzvLNoV66Cc/JdFrIVOffFvqP3kLYBStRNe1GshfS/73xob2APvazFKlR3vgGj0RI
         5CVIr1q4+heLxWSdRZUfKQQe+AhP0suct/j0WnRr8Ds1UGbiR2s0RdK5Gp3Tzukfyp6k
         79fOvlBQabIlQ277YnNeUWQwP3xL0Ha5lhGygkzhk/fLGqlX1gzr3Gn0LxE/abrWhqyY
         ocjRTuNfXZo3gXmiI5+IBvr2Jklejrv/BOY+XJKUP8gH+X666cAXXC3S59deW37g0V14
         ISxjZtT2VfY5gKUVCXTMj5mhvPBYPZnoTeUBHup922shPGU5VqSfCrtSLZyvZSxMfa7V
         ZG3A==
X-Gm-Message-State: AOAM531TjhtIO/nxGoqkMcUhAVQJW+MhIJfVTZTkmYMQZO2cZjGLFbCp
        2xKNKdTrZTonJqqc9v1TBz7LVTI30LNaQx+Q2X37aw==
X-Google-Smtp-Source: ABdhPJyPDEvncO7qg4K5DedWjH02dF6b/iP9HhGB6aoRgnqmLyh9HPFi0+KHqSz5GwTR7RxcSwp5RMJrerMI0Ni2o7o=
X-Received: by 2002:a17:906:6d0:: with SMTP id v16mr13841146ejb.258.1632921435817;
 Wed, 29 Sep 2021 06:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210805140231.268273-1-thomas.perrot@bootlin.com>
 <f358044a-78d0-ad63-a777-87b4b9d94745@aleksander.es> <73A52D61-FCAB-4A2B-BA96-0117F6942842@linaro.org>
In-Reply-To: <73A52D61-FCAB-4A2B-BA96-0117F6942842@linaro.org>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Wed, 29 Sep 2021 15:17:04 +0200
Message-ID: <CAAP7ucL1Zv6g8G0SWAjEAjr6OSVTyDmvmFkH+vMmmBwOH2=ZUQ@mail.gmail.com>
Subject: Re: [PATCH] bus: mhi: pci_generic: increase timeout value for
 operations to 24000ms
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Thomas Perrot <thomas.perrot@bootlin.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        hemantk@codeaurora.org, Loic Poulain <loic.poulain@linaro.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Mani,

> >> diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
> >> index 4dd1077354af..e08ed6e5031b 100644
> >> --- a/drivers/bus/mhi/pci_generic.c
> >> +++ b/drivers/bus/mhi/pci_generic.c
> >> @@ -248,7 +248,7 @@ static struct mhi_event_config modem_qcom_v1_mhi_events[] = {
> >>
> >>   static const struct mhi_controller_config modem_qcom_v1_mhiv_config = {
> >>      .max_channels = 128,
> >> -    .timeout_ms = 8000,
> >> +    .timeout_ms = 24000,
> >
> >
> >This modem_qcom_v1_mhiv_config config applies to all generic SDX24, SDX55 and SDX65 modules.
> >Other vendor-branded SDX55 based modules in this same file (Foxconn SDX55, MV31), have 20000ms as timeout.
> >Other vendor-branded SDX24 based modules in this same file (Quectel EM12xx), have also 20000ms as timeout.
> >Maybe it makes sense to have a common timeout for all?
> >
>
> Eventhough the baseport coming from Qualcomm for the modem chipsets are same, it is possible that the vendors might have customized the firmware for their own usecase. That could be the cause of the delay for modem booting.
>
> So I don't think we should use the same timeout of 2400ms for all modems.
>

Please note it's 24000ms what's being suggested here, not 2400ms.

> >Thomas, is the 24000ms value taken from experimentation, or is it a safe enough value? Maybe 20000ms as in other modules would have been enough?
> >
>
> It was derived from testing I believe.

Following your reasoning above, shouldn't this 24000ms timeout be
applied only to the Sierra Wireless EM91xx devices (which may have
custom firmware bits delaying the initialization a bit longer), and
not to the generic SDX24, SDX55 and SDX65?

If I'm not mistaken, Thomas is testing with a custom mhi_pci_generic
entry for the EM91xx; as in
https://forum.sierrawireless.com/t/sierra-wireless-airprime-em919x-pcie-support/24927.
I'm also playing with that same entry on my own setup, but have other
problems of my own :)


--
Aleksander
https://aleksander.es
