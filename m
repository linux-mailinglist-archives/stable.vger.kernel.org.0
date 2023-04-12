Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55E46DE92C
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 03:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjDLBzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 21:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjDLBzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 21:55:16 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF7D26B8
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 18:55:15 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-504fce3d7fbso171070a12.2
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 18:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681264513; x=1683856513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DCRgCd8nApy7TzIvIs1yvnfBLl2jT7+YOoX4vupYous=;
        b=dVeRnczi9X1vCcRP5rlKjAm6s3NxyK5XM0FhCqATZrFj7i015vBdufb3N+NhNbcop2
         tTmFO92+rhWLisaBsqrOkvdsJ42RRjltikomO2YcRHg5tcP0Y7X+XEvUjqDEYXlGLCqm
         doRRq74umLPEjgn8ismz4+x89kq0x7x1hWkk6qTaUwLFNxytYdBX4qb9drX5f+XToaea
         2K1dZ3IPkahWJx/eWeuMDl3EA6vMw7pMnnpRbSWxa7umoZdfJPvRbEoHThAvil9Rooe2
         74OMZr9wIalpa2/XtASWuOpbvc3K+9div3AnWfZA2eS/hI2Gno5vqc0CvN5AX/SICILQ
         kghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681264513; x=1683856513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DCRgCd8nApy7TzIvIs1yvnfBLl2jT7+YOoX4vupYous=;
        b=dqUyPd9qkasG/caJMTePd/uA0Ivsi/KhKotGXpLD+TD8XR2rhsPMxZtGz+9W1uE6Wo
         6dq7J358M8idtvBTj5x14qKr9V1Ps7sFVuBjYU9doURKtVcusB0QS8xXNbIUw8VsS8t4
         C8/KSbQqSeaygBvTa4uyeVFo+H54ehn8c8ukBSIPMKi++Wb5B2mPCiSa03CZdoBi3AJy
         oPlb7JyKaQMPY923r2uj5HI1+qFWkumKgNf1OM5s8E2ONrzoOjTnuF3VW1n2HNTgMllg
         05Yy7RjV6u+HwsFiODtzXG7uxgWyc/nEtxEXGgUsaVNn/94ohAWPDLPQkhd4WDFtPmYt
         7xiw==
X-Gm-Message-State: AAQBX9ekGTWzQXQ6HEwsw3zQQGpI8OvrMz89zyT5Jhr3xLqBpdSH3mLk
        wiz0W4wUVi4oeFS9g7EeVHJ7MS/Z24HuiVWZkwLR6g==
X-Google-Smtp-Source: AKy350Y+g8z3Uq9R+kjToSGpsQndXFivtJt7Bqh25e/wo6CwcBvv8j7ucbZS4t8fMZpD38C9jYGUEvuKKUDVRRcWJE0=
X-Received: by 2002:a50:baec:0:b0:504:9390:180f with SMTP id
 x99-20020a50baec000000b005049390180fmr5065023ede.2.1681264513494; Tue, 11 Apr
 2023 18:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230411083145.2214105-1-hhhuuu@google.com> <ce727a7b-6954-4e4d-85c7-f91011b87108@rowland.harvard.edu>
In-Reply-To: <ce727a7b-6954-4e4d-85c7-f91011b87108@rowland.harvard.edu>
From:   Jimmy Hu <hhhuuu@google.com>
Date:   Wed, 12 Apr 2023 09:55:02 +0800
Message-ID: <CAJh=zj+sVjmLAnY8pXWKbuhVsYStv3Ei5C6KqyugwURd8B-0wA@mail.gmail.com>
Subject: Re: [PATCH] usb: core: hub: Disable autosuspend for VIA VL813 USB3.0 hub
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     gregkh@linuxfoundation.org, badhri@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 9:55=E2=80=AFPM Alan Stern <stern@rowland.harvard.e=
du> wrote:
>
> On Tue, Apr 11, 2023 at 08:31:45AM +0000, Jimmy Hu wrote:
> > The VIA VL813 USB3.0 hub appears to have an issue with autosuspend and
> > detecting USB3 devices. This can be reproduced by connecting a USB3
> > device to the hub after the hub enters autosuspend mode.
> >
> > //connect the hub
> > [  106.854204] usb 2-1: new SuperSpeed Gen 1 USB device number 2 using =
xhci-hcd
> > [  107.084993] usb 2-1: New USB device found, idVendor=3D2109, idProduc=
t=3D0813, bcdDevice=3D90.15
> > [  107.094520] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
> > [  107.111836] usb 2-1: Product: USB3.0 Hub
> > [  107.116835] usb 2-1: Manufacturer: VIA Labs, Inc.
> > [  107.314230] hub 2-1:1.0: USB hub found
> > [  107.321356] hub 2-1:1.0: 4 ports detected
> >
> > //the hub enters autosuspend mode
> > [  107.738873] hub 2-1:1.0: hub_suspend
> > [  107.922097] usb 2-1: usb auto-suspend, wakeup 1
> >
> > //connect a USB3 device
> > [  133.120060] usb 2-1: usb wakeup-resume
> > [  133.160033] usb 2-1: Waited 0ms for CONNECT
> > [  133.165423] usb 2-1: finish resume
> > [  133.176919] hub 2-1:1.0: hub_resume
> > [  133.188026] usb 2-1-port3: status 0263 change 0041
> > [  133.323585] hub 2-1:1.0: state 7 ports 4 chg 0008 evt 0008
> > [  133.342423] usb 2-1-port3: link state change
> > [  133.358154] usb 2-1-port3: status 0263, change 0040, 5.0 Gb/s
>
> This status value indicates that the port is in the U3 suspend state.
> Maybe the port needs to be put back into U0 before it can be reset.
>
> > [  133.875150] usb 2-1-port3: not reset yet, waiting 10ms
> > [  133.895502] usb 2-1-port3: not reset yet, waiting 10ms
> > [  133.918239] usb 2-1-port3: not reset yet, waiting 200ms
> > [  134.139529] usb 2-1-port3: not reset yet, waiting 200ms
> > [  134.365296] usb 2-1-port3: not reset yet, waiting 200ms
> > [  134.590185] usb 2-1-port3: not reset yet, waiting 200ms
> > [  134.641330] hub 2-1:1.0: state 7 ports 4 chg 0000 evt 0008
> > [  134.658880] hub 2-1:1.0: hub_suspend
> > [  134.792908] usb 2-1: usb auto-suspend, wakeup 1
> >
> > Disabling autosuspend for this hub resolves the issue.
>
> It may be possible to fix the problem.  You should try that before
> giving up.
>
> Alan Stern

[  133.120060] usb 2-1: usb wakeup-resume
[  133.160033] usb 2-1: Waited 0ms for CONNECT
[  133.165423] usb 2-1: finish resume
[  133.176919] hub 2-1:1.0: hub_resume
When a USB3 device is connected to the hub,  it did finish the resume
and should be put back into U0, but it seems to have failed.
