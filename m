Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BBC574046
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 01:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiGMX5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 19:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGMX5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 19:57:02 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC9B4D4D5;
        Wed, 13 Jul 2022 16:57:01 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id oy13so537204ejb.1;
        Wed, 13 Jul 2022 16:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z86mKblHBYOAAN3KH0exFGa+ySzzd2OPDuMCYnxF2eo=;
        b=VmUlwpdixn3QC60HKdeE1cHM8yrgbDEyAwm0eMxmtg+5aPK27tKda3WQVob2wsZGuH
         p2IOdDwZ224EqCdK4Y2wm02VUZa2cELDCdl4FWvjvg+KCVGAu76mHWij+zRX9A9ZVd2J
         hxmHJEh+GeJtyyBmi7D91KgL0QDdqX/Cb8SD2LS5vsxwreJeuJePA9FISyhZ0wkk4rHk
         BjGbe+ynbrme4EbSEcUjCphfRpml/E4KMXjK5Titcg9RO+N29qImtlGLrK0tzgjcJcii
         3tbFDHToZ/ZxkVPA/2Yf4yDlXqAeELpCvDrEOTGa1FkrIugoriC0eu5ifBahmo0oKUDL
         ptMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z86mKblHBYOAAN3KH0exFGa+ySzzd2OPDuMCYnxF2eo=;
        b=YZceGZg4TbE+i2tPsjcIe/cBLqbiUNWUtKuPGB1ax8JD4VGQVFnnpN7tAtDPO/AxaO
         BY9JrtzJ0dksezUh0PqL1CCyG/GOV4nYeqmQ+/qsJT4obbbfN31Z6OwMi7mpSX3R42o2
         oWnjuW0rxy/tBhL35oUej4t15NpLPGpPiOf3f6Uw1Nbi2nuVE7Lss0mcGbQkMJL/Cqw2
         xfQpEzCPY32KQvonQ4iR+nA9cyzLeH/+zX6yHYWim54+4t0XegxtT7/lZf0pTWYTFTdE
         RLTAuHKIRX9b5h5XM/3LRbWlnyuGuM83NYvGKb6YANPD93zc2cBJCUkaaWzJjSLDgUTn
         DuRw==
X-Gm-Message-State: AJIora9/9umdIig3Y3VWksny6bYNF2RGeRnHsbaObqDtFrKbqbQpg7v+
        Pocftl84PReULvd8EesfCGtMfGXeGrHIx3pn/cVXNMFqgF/6FA==
X-Google-Smtp-Source: AGRyM1v5zP3X+O4Y/a/iJJOpZ/eXsVsCEdU3tMrvQqnFKdXanoWjvd6L/O+HycYaHT5iEl3w7rl1+bE6paQd6r0wCYc=
X-Received: by 2002:a17:907:72d1:b0:72b:6da5:9bb with SMTP id
 du17-20020a17090772d100b0072b6da509bbmr5605606ejc.681.1657756620373; Wed, 13
 Jul 2022 16:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <CALF=6jEe5G8+r1Wo0vvz4GjNQQhdkLT5p8uCHn6ZXhg4nsOWow@mail.gmail.com>
 <02190bee-2e1b-bea3-b716-a7c7f5aa2ff0@redhat.com> <CALF=6jG5gmqqXo5cSFFRWRM96K0rzx3WabNdwAmdZQH=unFG7g@mail.gmail.com>
 <3ddcdb24-cab3-509d-d694-edd4ab85df0a@redhat.com> <eb760bcd-8817-65ed-471e-60e8d9bdae79@redhat.com>
In-Reply-To: <eb760bcd-8817-65ed-471e-60e8d9bdae79@redhat.com>
From:   Ben Greening <bgreening@gmail.com>
Date:   Wed, 13 Jul 2022 16:56:23 -0700
Message-ID: <CALF=6jF1TTgc4_mXRcx=6EV64Cj=VWLU3zXi7AoyM1F3bdgT=A@mail.gmail.com>
Subject: Re: [Regression] ACPI: video: Change how we determine if brightness
 key-presses are handled
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        rafael@kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Hans,

Applying the latest
0001-ACPI-video-Change-how-we-determine-if-brightness-key.patch you
sent me off-list (my fault, forgot to reply all) and
0001-ACPI-video-Use-native-backlight-on-Dell-Inspiron-N40.patch makes
it all work again. And a bonus that I don't need any extra kernel
parameters anymore.

> It would also be interesting if you can start evemu-record on the
> Dell WMI Hotkeys device before pressing any of the brightness keys.
>
> There might still be a single duplicate event reported there on
> the first press. I don't really see a way around that (without causing
> all brightness key presses on some panasonic models to be duplicated),
> but I'm curious if it is a problem at all...

I rebooted and ran evemu-record before pressing the brightness keys
and "Dell WMI hotkeys" didn't show any events at all.

Thanks for the fix!
Ben

On Wed, Jul 13, 2022 at 6:49 AM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi Ben,
>
> On 7/13/22 15:29, Hans de Goede wrote:
> > Hi,
> >
> > On 7/13/22 15:08, Ben Greening wrote:
> >> Hi Hans, thanks for getting back to me.
> >>
> >> evemu-record shows events for both "Video Bus" and "Dell WMI hotkeys":
> >>
> >> Video Bus
> >> E: 0.000001 0001 00e0 0001 # EV_KEY / KEY_BRIGHTNESSDOWN   1
> >> E: 0.000001 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
> >> E: 0.000020 0001 00e0 0000 # EV_KEY / KEY_BRIGHTNESSDOWN   0
> >> E: 0.000020 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
> >>
> >> Dell WMI hotkeys
> >> E: 0.000001 0004 0004 57349 # EV_MSC / MSC_SCAN             57349
> >> E: 0.000001 0001 00e0 0001 # EV_KEY / KEY_BRIGHTNESSDOWN   1
> >> E: 0.000001 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
> >> E: 0.000020 0001 00e0 0000 # EV_KEY / KEY_BRIGHTNESSDOWN   0
> >> E: 0.000020 0000 0000 0000 # ------------ SYN_REPORT (0) ---------- +0ms
> >>
> >> Adding video.report_key_events=1 with acpi_backlight=video makes
> >> things work like you said it would.
> >>
> >>
> >> With acpi_backlight=video just has intel_backlight.
> >>
> >> Without acpi_backlight=video:
> >>     intel_backlight:
> >>         max_brightness: 4882
> >>         backlight control works with echo
> >>         brightness keys make no change to brightness value
> >>
> >>     dell_backlight:
> >>         max_brightness: 15
> >>         backlight control doesn't work immediately, but does on reboot
> >> to set brightness at POST.
> >>         brightness keys change brightness value, but you don't see the
> >> change until reboot.
> >
> > Ok, so your system lacks ACPI video backlight control, yet still reports
> > brightness keypresses through the ACPI Video Bus. Interesting (weird)...
> >
> > I think I believe I know how to fix the regression, 1 patch coming up.
>
> Can you please give the attached patch a try, with
> video.report_key_events=1 *removed* from the commandline ?
>
> It would also be interesting if you can start evemu-record on the
> Dell WMI Hotkeys device before pressing any of the brightness keys.
>
> There might still be a single duplicate event reported there on
> the first press. I don't really see a way around that (without causing
> all brightness key presses on some panasonic models to be duplicated),
> but I'm curious if it is a problem at all...
>
> Regards,
>
> Hans
>
>
>
>
>
