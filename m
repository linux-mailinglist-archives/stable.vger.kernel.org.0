Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A191B601B2D
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 23:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbiJQVVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 17:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJQVVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 17:21:10 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE9E2871B;
        Mon, 17 Oct 2022 14:21:09 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id l22so17872797edj.5;
        Mon, 17 Oct 2022 14:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NhknbbZU+DsEhwdrosFkJMRfKCF+WMIkDITeVElhgnk=;
        b=AzHn0H0UW8cxjO5EMQz/kYk4xHt9LF45+mpX4d/B5VSS4YlSEK3gUhvCg7K/KBg+4C
         AAhaSTDrLjUSmhCTI4K8wnGu/XYRsgVtvwuuDzQAH4pJHgBr/hNoYXBJXSs52iLzhHp/
         M3iZ8iwjp3MSgcLbvni7NSf0EfGPzQiA0zaIMyLhZwTh5LDmuNDsf53FySV9+XEmg4O1
         ILhqyx56wXSyw4DAFUDx5KyzKTMBx7jFbwJcbUKWQyNeR8pNXJNs3+gkJlnyNa9I6quZ
         Sy2WMI++o85z1Xk3nc7Cx4T3sHhvB+vNcDGxe6UXJarHy4aygXzd5CfcEhqBOAa+4EYe
         UKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NhknbbZU+DsEhwdrosFkJMRfKCF+WMIkDITeVElhgnk=;
        b=CQ9zpKa2967XwqpsZ7JA59avpjG4lI2D+v2X12hhVUUnNHDofmdT9NhPc2DHMUrfZe
         Am9KaXK7h6Fg6Lvv0jQ0apMXhdQ2H7UE1PfwzEpntGLdDuwjKBWmPmno7PRknnCm26zW
         z77ZaKFQ50vAA53SJbUS31WM+tBTgb+VnQbzjEkgYwJTuPDkn8dgD/fPd6EqevSuRwTn
         0zSz9Uj3g2TjJ6XyMsibbVef0Kp0GyHX0Va84hGRB+C3N7lvPpvwc1jYrFXqPZMHq5yQ
         ssSHCfPqGogEIrElqq+daUhjb2hCSItkRpjSW2A6652AK4geZz07xB+oLwRlMpQcmtXN
         5gGQ==
X-Gm-Message-State: ACrzQf19waerHzGVQcvNTgrxoHRiFeeZzfDba09FYn00XDdgfcdNBC5P
        4dKqo9/04pDaY8BjyLwG9aUnlxMHp/tYz9Wj3/A=
X-Google-Smtp-Source: AMsMyM61LIQXEqtwOrXlFojdXpZhyDs8urEYKA9+80uWCkaOTOykb4sqV4V6B1dlr/Tt2G1T7quaFQMvXyXvZ9BUeH0=
X-Received: by 2002:a05:6402:2402:b0:45c:a1ce:94d8 with SMTP id
 t2-20020a056402240200b0045ca1ce94d8mr11816746eda.50.1666041667506; Mon, 17
 Oct 2022 14:21:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com> <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com> <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com> <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
 <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com> <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
 <4e73bbb9-eae1-6a90-d716-c721a1eeced3@gmail.com> <7e9519c6-f65f-5f83-1d17-a3510103469f@gmail.com>
 <CAHQ1cqE5=j9i8uYvBwdNUK8TrX3Wxy7iUML6K+gBQx-KRtkS7w@mail.gmail.com>
 <644adb7b-0438-e37c-222c-71bf261369b0@gmail.com> <CAHQ1cqGSXoUTopwvrQtLww5M0Tf=6F505ziLn+wGHhW_8-JhFQ@mail.gmail.com>
 <113fe314-0f5c-f53f-db78-c93bd4515260@gmail.com> <CAHQ1cqF_FvG0G2CAQooOVR3E442ApNFf8EKK8PpxcOrUoL5jDA@mail.gmail.com>
 <bec17559-286c-b006-476f-3c26ae38e70d@gmail.com> <CAHQ1cqFqKv+J1=Qg5_sDUeKQ=64aSiGJq0pPH+OqEieZDM1Mfg@mail.gmail.com>
 <887510d7-b732-2b0e-e177-615de59cfaf8@gmail.com>
In-Reply-To: <887510d7-b732-2b0e-e177-615de59cfaf8@gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 17 Oct 2022 14:20:55 -0700
Message-ID: <CAHQ1cqFNjy7ddSot5zDekLvnqHpz5xJP+Fi6vnh+6JwVeozjcA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
To:     Ferry Toth <fntoth@gmail.com>
Cc:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 16, 2022 at 1:59 PM Ferry Toth <fntoth@gmail.com> wrote:
>
>
> Op 15-10-2022 om 21:54 schreef Andrey Smirnov:
> > On Thu, Oct 13, 2022 at 12:35 PM Ferry Toth <fntoth@gmail.com> wrote:
> >> <SNIP>
> >>> My end goal here is to find a way to test vanilla v6.0 with the two
> >>> patches reverted on your end. I thought that during my testing I saw
> >>> tusb1210 print those timeout messages during its probe and that
> >>> disabling the driver worked to break the loop, but I went back to
> >>> double check and it doesn't work so scratch that idea. Configuring
> >>> extcon as a built-in breaks host functionality with or without patche=
s
> >>> on my end, so I'm not sure it could be a path.
> >>>
> >>> I won't have time to try things with
> >>> 0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch unti=
l
> >>> the weekend, meanwhile can you give this diff a try with vanilla (no
> >>> reverts) v6.0:
> >>>
> > OK, got a chance to try things with that patch. Both v6.0 and v6.0
> > with my patches reverted work the same, my Kingston DataTraveller USB
> > stick enumerates and works as expected.
> >
> Iow you don't need the patch at all to get usb to work. There has got to
> be a difference in our configs.
>

My patch? Yeah, it should have zero effect on anything.
!DWC3_VER_IS_PRIOR(DWC3, 330A) is false for Merrifield, so the logical
change from my patch is a no-op. It's a pure coincidence that it
resolved the probe loop that
0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch is
for.

> Did you have a chance to look at mine (here:
> https://drive.google.com/file/d/1aKJWMqiAXnReeLCvxshzjKwGxIWQ7eJk/view?us=
p=3Dsharing)
>
> Else, send me yours.
>

I've been using your config in all of the testing.

> >>> modified   drivers/phy/ti/phy-tusb1210.c
> >>> @@ -127,6 +127,7 @@ static int tusb1210_set_mode(struct phy *phy, enu=
m
> >>> phy_mode mode, int submode)
> >>>     u8 reg;
> >>>
> >>>     ret =3D tusb1210_ulpi_read(tusb, ULPI_OTG_CTRL, &reg);
> >>> + WARN_ON(ret < 0);
> >>>     if (ret < 0)
> >>>     return ret;
> >>>
> >>> @@ -152,7 +153,10 @@ static int tusb1210_set_mode(struct phy *phy,
> >>> enum phy_mode mode, int submode)
> >>>     }
> >>>
> >>>     tusb->otg_ctrl =3D reg;
> >>> - return tusb1210_ulpi_write(tusb, ULPI_OTG_CTRL, reg);
> >>> + ret =3D tusb1210_ulpi_write(tusb, ULPI_OTG_CTRL, reg);
> >>> + WARN_ON(ret < 0);
> >>> + return ret;
> >>> +
> >>>    }
> >>>
> >>>    #ifdef CONFIG_POWER_SUPPLY
> >>>
> >>> ? I'm curious to see if there's masked errors on your end since dwc3
> >>> driver doesn't check for those.
> >> root@yuna:~# dmesg | grep -i -E 'warn|assert|error|tusb|dwc3'
> >> 8250_mid: probe of 0000:00:04.0 failed with error -16
> >> platform regulatory.0: Direct firmware load for regulatory.db failed
> >> with error -2
> >> brcmfmac mmc2:0001:1: Direct firmware load for
> >> brcm/brcmfmac43340-sdio.Intel Corporation-Merrifield.bin failed with
> >> error -2
> >> sof-audio-pci-intel-tng 0000:00:0d.0: error: I/O region is too small.
> >> sof-audio-pci-intel-tng 0000:00:0d.0: error: failed to probe DSP -19
> >>
> >>
> >>>> This is done through configfs only when the switch is set to device =
mode.
> >>> Sure, but can it be disabled? We are looking for unknown variables, s=
o
> >>> excluding this would be a reasonable thing to do.
> >> It's not enabled until I flip the switch to device mode.
> > OK to cut this back and forth short, I think it'd be easier to just
> > ask you to run what I run. Here's vanilla v6.0 bzImage and initrd
> > (built with your config + CONFIG_PHY_TUSB1210=3Dy) I tested with
>
> What do you mean by this? My config is with
>
> CONFIG_GENERIC_PHY=3Dy
> CONFIG_PHY_TUSB1210=3Dy
>

$ cat config-6.0.0-edison-acpi-standard | grep 1210
# CONFIG_PHY_TUSB1210 is not set
$ md5sum config-6.0.0-edison-acpi-standard
3c989c708302c1f9e73c6113e71aed9d  config-6.0.0-edison-acpi-standard

I had to manually enable it, that's what I meant by my comment.

> > https://drive.google.com/drive/folders/1H28AL1coPPZ2kLTYskDuDdWo-oE7DRP=
H?usp=3Dsharing
> > let's see how it behaves on your setup. There's also the U-Boot binary
>
> Ok, it's getting weirder and weirder. The following is with my U-Boot
> and your kernel/initrd
>
> 1) I placed them in /boot which is on my btrfs partition on the emmc (my
> U-Boot has btrfs enabled)
>
> Linux kernel version 6.0.0-edison-acpi-standard
> (andreysm@neptunefw-builder) #8 SMP PREEMPT_DYNAMIC Sat Oct 15 18:47:19
> UTC 2022
> Building boot_params at 0x00090000
> Loading bzImage at address 100000 (12064480 bytes)
> Initial RAM disk at linear address 0x06000000, size 25165824 bytes
> Kernel command line: "quiet root=3D/dev/mmcblk0p8
> rootflags=3Dsubvol=3D@,compress=3Dlzo rootfstype=3Dbtrfs console=3DttyS2,=
115200n8
> earlyprintk=3DttyS2,115200n8,keep loglevel=3D4 systemd.unit=3Dmulti-user.=
target"
> Kernel loaded at 00100000, setup_base=3D00090000
>

You shouldn't be using root from you storage since:
  a) the initrd I uploaded is self-containing, it doesn't need anything els=
e
  b) your local data is another variable we don't want to introduce

just "rootfstype=3Dramfs" should be enough for this and

 root=3D/dev/mmcblk0p8 rootflags=3Dsubvol=3D@,compress=3Dlzo rootfstype=3Db=
trfs

should be dropped.

> Usb drive is not detected regardless booting with stick plugged or
> plugging later on.
>
> # lsusb
> Bus 001 Device 001: ID 1d6b:0002
> Bus 002 Device 001: ID 1d6b:0003
>
> No TUSB1210 probed
>
> # dmesg | grep dwc3
> #
>
> 2) I placed them in my vfat rescue partition
>
> Linux kernel version 6.0.0-edison-acpi-standard
> (andreysm@neptunefw-builder) #8 SMP PREEMPT_DYNAMIC Sat Oct 15 18:47:19
> UTC 2022
> Building boot_params at 0x00090000
> Loading bzImage at address 100000 (12064480 bytes)
> Initial RAM disk at linear address 0x06000000, size 25165824 bytes
> Kernel command line: "debugshell=3D0 tty1 console=3DttyS2,115200n8
> root=3D/dev/mmcblk0p7 rootfstype=3Dvfat systemd.unit=3Dmulti-user.target"
> Kernel loaded at 00100000, setup_base=3D00090000
>
> Usb drive is detected.

Yep, that's exactly my point about extra variables. So it looks like
something in your root btrfs partition is triggering this issue. I
don't really know the contents of your root file system, so don't
really have any suggestions there. Maybe old kernel modules are
getting picked up? Or something else is interfering =C2=AF\_(=E3=83=84)_/=
=C2=AF

>
> # lsusb
> Bus 001 Device 001: ID 1d6b:0002
> Bus 001 Device 002: ID 125f:312b
> Bus 002 Device 001: ID 1d6b:0003
>
> TUSB1210 probed
>
> # dmesg | grep dwc3
> [    8.605845] tusb1210 dwc3.0.auto.ulpi: GPIO lookup for consumer reset
> [    8.605876] tusb1210 dwc3.0.auto.ulpi: using ACPI for GPIO lookup
> [    8.605927] tusb1210 dwc3.0.auto.ulpi: using lookup tables for GPIO
> lookup
> [    8.605941] tusb1210 dwc3.0.auto.ulpi: No GPIO consumer reset found
> [    8.605956] tusb1210 dwc3.0.auto.ulpi: GPIO lookup for consumer cs
> [    8.605970] tusb1210 dwc3.0.auto.ulpi: using ACPI for GPIO lookup
> [    8.606011] tusb1210 dwc3.0.auto.ulpi: using lookup tables for GPIO
> lookup
> [    8.606024] tusb1210 dwc3.0.auto.ulpi: No GPIO consumer cs found
> [    8.669317] tusb1210 dwc3.0.auto.ulpi: error -110 writing val 0x41 to
> reg 0x80
>
> ## note: options debugshell, root and rootfstype are normally handled by
> a script in my initrd, so I guess here noop.
>
> > I use in that folder in case you want to give it a try.
> >
> > Now on Merrifield dwc3_get_extcon() doesn't do anything but call
> > extcon_get_extcon_dev() which doesn't touch any hardware or interact
> > with other drivers, so assuming
> >
> >> So current v6.0 has: dwc3_get_extcon - dwc3_get_dr_mode - ... -
> >> dwc3_core_init - .. - dwc3_core_init_mode (not working)
> >>
> >> I changed to: dwc3_get_dr_mode - dwc3_get_extcon - .. - dwc3_core_init=
 -
> >> .. - dwc3_core_init_mode (no change)
> >>
> >> Then to: dwc3_get_dr_mode - .. - dwc3_core_init - .. - dwc3_get_extcon=
 -
> >> dwc3_core_init_mode (works)
> > still holds(did you double check that with vanilla v6.0?) the only
> I didn't check
> > difference that I can see is execution timings. It seems to me it's
> > either an extra delay added by execution of  extcon_get_extcon_dev()
> > (unlikely) or multiple partial probes that include dwc3_core_init()
> > that change things. You can try to check the latter by adding an
> > artificial probe deferral point after dwc3_core_init(). Something like
> > (didn't test this):
> >
> > modified   drivers/usb/dwc3/core.c
> > @@ -1860,6 +1860,10 @@ static int dwc3_probe(struct platform_device *pd=
ev)
> >    goto err3;
> >
> >    ret =3D dwc3_core_init(dwc);
> > + static int deferral_counter =3D 0;
> > + if (deferral_counter++ < 9) /* I counted 9 deferrals in my testing */
> > + ret =3D -EPROBE_DEFER;
> > +
> >    if (ret) {
> >    dev_err_probe(dev, ret, "failed to initialize core\n");
> >    goto err4;
>
> Not sure how you wanted this tested. So I assume on vanilla booting from
> btrfs on eemc. It crashes but maybe the trace is usefull. After crash it
> continues but no USB appears at all.
>

I think you'll have to experiment with that code placement to emulate
a deferred probe for the old location of "get extcon".  I'd focus on
figuring out the root filesystem variable first before trying to get
this to work.

To be explicit, at this point I don't think the revert is really
warranted. I'm also happy to reply/help you with suggestions, but you
are going to have to start driving this.
