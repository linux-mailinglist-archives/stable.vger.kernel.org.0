Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1077F65C78A
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 20:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjACTaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 14:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239083AbjACTab (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 14:30:31 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D3113DE8
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 11:30:30 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id r205so27896404oib.9
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 11:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ralston.id.au; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m7ZwI/3d5ZRCf0yxI1ai0kL0fT5rS0WsrJU7lWNFk4M=;
        b=N9bLaVOsVdePDS7BXQFXBFCPkjSWH/GqIpDqdL/WcEBvUZ94/z8+RJlmT94rsjkZNz
         uOa9iK4BgofdUwymsP32NTb51Eihk7OTko2NfRUjplTmIWGAgLXngyFnsXLhfxbVRo26
         G+rB8Os7QNOX6N3JB7a5sJGzwVtUjPo1QWBMg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m7ZwI/3d5ZRCf0yxI1ai0kL0fT5rS0WsrJU7lWNFk4M=;
        b=3eCiGgkEde+NVrMvIkIRrVcqOsQ5+ctM5UYGPaEZdTRzro1lYjf7Q4cBsM3feUqKAY
         +zKl9C7NU2f9ZrrUNhugVdF8vSMXL/dK3i8D2mikEuerYGwV/Cdy3RoH+4Vm/+fJQ0wF
         6OAo2vi9bhcnnAPWwkIyswFwo5A23t1w3fYgMhxcTq7Lr8MS6u7nK6S059n75Z3U5TFq
         TyH5M1dfZ9bfcXYZzl7hsuIu/n7/VNwSVMOGqczxXD1Zqde5SwpBu6jF/WJJn+b2PMhx
         leKwK9jAOz4+BL+1fBLtPrF0SLYCqK8wL2tx2U5zNG6Z59UMo+XgxhlmdqNt5HmOLRSm
         T7UQ==
X-Gm-Message-State: AFqh2kr/ONxLHLYZvKfGUOXqwkfmIVZDPD0G45hBqaTvhK84GuuEMrWN
        n7tVBELkw6al3vSzWKB2iIdYzVlqrScN1xqlSwM8jA==
X-Google-Smtp-Source: AMrXdXu1u697rSaneDA2cqYDMAV81q1Y4RbB367bFHud5eZ6ZBV0aEUZioE62U9BiZvd0os6H9zrblsBcS2/esbvlHQ=
X-Received: by 2002:a05:6808:609:b0:35c:dee:db96 with SMTP id
 y9-20020a056808060900b0035c0deedb96mr3176138oih.235.1672774230210; Tue, 03
 Jan 2023 11:30:30 -0800 (PST)
MIME-Version: 1.0
References: <CAC2975JXkS1A5Tj9b02G_sy25ZWN-ys+tc9wmkoS=qPgKCogSg@mail.gmail.com>
 <bf646395-1231-92f6-7c5a-5b7765596358@leemhuis.info> <87zgb0q7x4.wl-tiwai@suse.de>
 <CAC2975K24Gt3rGieAToHjb7FEHv84aqiRSQx7EOuR2Q7KByUXw@mail.gmail.com>
 <87sfgrrb5f.wl-tiwai@suse.de> <CAC2975+cUqiFC0LO-D-fi0swH+x=_FMuG+==mhg6HH4pc_YDRA@mail.gmail.com>
 <87bknfr6rd.wl-tiwai@suse.de> <CAC2975+CP0WKmXouX_8TffT1+VpU3EuOzyGHMv+VsAOBjCyhnA@mail.gmail.com>
 <878rijr6dz.wl-tiwai@suse.de> <CAC2975+Ybz2-jyJAwAUEu5S1XKfp0B-p4s-gAsMPfZdD61uNfQ@mail.gmail.com>
 <87zgazppuc.wl-tiwai@suse.de> <CAC2975+476CHDL3YM=uExHu96UB2rodAng9PVYHX+vGnSCppGA@mail.gmail.com>
 <CAC2975Ja-o6-qCWv2bUkt3ps7BcKvb96rao_De4SGVW1v8uE=A@mail.gmail.com> <CAC2975KFqvTitbJHJZ6a4Tuxsq=nPGvW3vjAAtkQxw=sBgeDqw@mail.gmail.com>
In-Reply-To: <CAC2975KFqvTitbJHJZ6a4Tuxsq=nPGvW3vjAAtkQxw=sBgeDqw@mail.gmail.com>
From:   Michael Ralston <michael@ralston.id.au>
Date:   Wed, 4 Jan 2023 06:29:54 +1100
Message-ID: <CAC2975Jw63j26DhvDjiLc7dXwaRz=eK0aWNuErQ8dkEn_Gemjg@mail.gmail.com>
Subject: Re: USB-Audio regression on behringer UMC404HD
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        alsa-devel@alsa-project.org, regressions@lists.linux.dev,
        stable@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Jan 2023 at 06:27, Michael Ralston <michael@ralston.id.au> wrote:
>
> On Wed, 4 Jan 2023 at 06:24, Michael Ralston <michael@ralston.id.au> wrote:
> >
> > I did a diff between the sound/usb directory for 6.0.16 and 6.1.2 and
> > reverted that entire directory.
> >
> > It is working with that change, so there must be something else.
> >
>
> Logs below...
>

This line from the logs stands out to me as different. Could this mean anything?

> Jan 04 06:20:27 leatherback kernel: usb 1-4: clock source 41 is not
> valid, cannot use

--
Michael
