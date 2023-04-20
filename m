Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8156E9841
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 17:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjDTP0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 11:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDTP03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 11:26:29 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FD33AA8
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:26:28 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 5614622812f47-38ded2d8bcaso663304b6e.0
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 08:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682004388; x=1684596388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/KfYaP1TPUyaOgULACpAai/DFofpxEc3gjRhI9Tu9Q=;
        b=nF/eO+nEwtwCrtWtA5tX5YUhOwTENG5CaLuUFbmox3i/ioYaug7iJR1iYF0Vyru568
         69MEa2s9f476ijEz8R6kELWR7yOwxvUa+QFVTX3812y3ykVJQtC1COuEHi00hK0hz8Fj
         fu3UbVrcMqCrEq+IeNih8QgBPdYCl2ACW6PlQeYYB/P7g1M1EOGhE4JniXnk1PiqLZCf
         msWUimM6f+kyJYEpFrDInVhFa4w9E7Nbo8UyeO+TqO6c/PEpHyKL2vRCzLSN2DdB5sMZ
         jd2rBeNxVIitf5kamslGYpIIuiNYgsGMKJWgFe5R00MFug+mIbjoeAhbDldfutUSSqUW
         UmCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682004388; x=1684596388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b/KfYaP1TPUyaOgULACpAai/DFofpxEc3gjRhI9Tu9Q=;
        b=cnP2eM7YtynTUG/86Igs9ZmR4e/LNZYYDdnj8tIbv47jrrpFJ+rWqvkzUfeaT5+lyK
         1odly5TghfaTVB3Ka+NZCSmK8k3thFfFQBb9+Jb0VQw81Zra8x/zibsF6lwzGoFZ2s2N
         G7sBrdioWYO2Tn29FYKI+4euFyTWwkWU0asU6DNY7V3NLREHQzrjJlPDQ9kKIPREsM//
         Deb+HKP0tLizg417DF6Nc9EeF6VDtCBti+dHs6SysX3NIXVBjeeCrCBnPsPLR1yAXFUR
         444IwQhakDAzGZfRfC4Xpp6VHm3uXM4kOn3d8Zq+AYPyWQow1bQP/mboAAMFWWWhMhLs
         fXmA==
X-Gm-Message-State: AAQBX9drB+VzYdaq8WKyxuptU4U91Le7PFCyen8hwEzhyXJk8ellu9yV
        G9S6fD/IxWCwV3KtmOSofvl6wqDk7VKvu3p3aDjxyLB3
X-Google-Smtp-Source: AKy350YPBnt9ydsfOHOlU6gFcaqvAvv456Qx+ldUaQra1+1Hm/DtZChG2yN9MHErBEBASHO5kVEEq5dyEtgX4fmfrIw=
X-Received: by 2002:a54:4189:0:b0:38e:8377:3102 with SMTP id
 9-20020a544189000000b0038e83773102mr428606oiy.4.1682004388178; Thu, 20 Apr
 2023 08:26:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230418221522.1287942-1-gpiccoli@igalia.com> <BL1PR12MB514405B37FC8691CB24F9DADF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
 <be4babae-4791-11f3-1f0f-a46480ce3db2@igalia.com> <BL1PR12MB51443694A5FEFA899704B3EBF7629@BL1PR12MB5144.namprd12.prod.outlook.com>
 <9b9a28f5-a71f-bb17-8783-314b1d30c51f@igalia.com> <ZEEzNSEq-15PxS8r@kroah.com>
 <94b63d19-4151-c294-50eb-c325ea9c699f@igalia.com> <ZEFUGSlqQu3v8ryf@kroah.com>
In-Reply-To: <ZEFUGSlqQu3v8ryf@kroah.com>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Thu, 20 Apr 2023 11:26:16 -0400
Message-ID: <CADnq5_N3jFxdNVXbcMK_C0C7mMarNRxCu+F3WvY-WQPkg-L4kg@mail.gmail.com>
Subject: Re: [PATCH 6.1.y] drm/amdgpu/vcn: Disable indirect SRAM on Vangogh
 broken BIOSes
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Zhu, James" <James.Zhu@amd.com>, "Liu, Leo" <Leo.Liu@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 20, 2023 at 11:04=E2=80=AFAM gregkh@linuxfoundation.org
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Apr 20, 2023 at 09:59:17AM -0300, Guilherme G. Piccoli wrote:
> > On 20/04/2023 09:42, gregkh@linuxfoundation.org wrote:
> > > [...]
> > >> @Greg, can you pick this one? Thanks!
> > >
> > > Which "one" are you referring to here?
> > >
> > > confused,
> > >
> > > greg k-h
> >
> > This one, sent in this email thread.
>
> I don't have "this email thread" anymore, remember, some of us get
> thousand+ emails a day...
>
> > The title of the patch is "drm/amdgpu/vcn: Disable indirect SRAM on
> > Vangogh broken BIOSes", target is 6.1.y and (one of the) upstream
> > hash(es) is 542a56e8eb44 heh
>
> But that commit says it fixes a problem in the 6.2 tree, why is this
> relevant for 6.1.y?

It fixes a generic issue with certain sbios versions.

Alex

>
> thanks,
>
> greg k-h
