Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483F05FFBD2
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 21:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJOTyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 15:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJOTyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 15:54:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069D31ADA1;
        Sat, 15 Oct 2022 12:54:49 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k2so17100056ejr.2;
        Sat, 15 Oct 2022 12:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=era+bHkgnU20D91HzKyZ/L95IhZJ+qsSoSw3gLGE9R4=;
        b=drCl9hD7YVkMd6M51Ol46DL6F61BeXZ4v8L9yfn20swj04ygSwozu0raQsP+nMv93F
         xzZ5lcBLjI+Vk0UtH24ocVfTQc0dOwh/sEc+MR9hfK0EItfY2hBAyDlQ2oODdK2Pfg7U
         wN2r1zEGTcrNQtSGBhOD+ClMEC/pJbP7JIH6c+qG03nb5At8FCH/EJTpn+yYfeZPP7M+
         F6ziCkBoISnH89fJFC09sJ858ZgPDVhc6KLGXQV1tgjuidKd9fQQ4JGtHf0ANhGJdR9R
         1xj3IP7j5D1txIfKo7EBo0QBuEdADsf3KQs+uP2AEgPgFAQBv96xWoB6I98xF5Rpi5Ky
         CeAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=era+bHkgnU20D91HzKyZ/L95IhZJ+qsSoSw3gLGE9R4=;
        b=tVGabshBA2wRNUMuOTPbsL3mtD6Z3gsVaOcuD33Ci9+FRAsfraNt1O1HemBcizgmW1
         JI3fRu7TJj1vJ6RnDzW5CgRUoVnm0UFNAmwz6/Wse1/a6dgcFeKxQEhbfY0qYvoKW9W8
         Mv+AhXCggd40Rq2mRSZpzVtRNCDBDdVrdnjn8lUuW6HCYnXAd4/sjHXdk8PtAaST04+i
         fszSdl1mzX/16j+CCScFohqC0qvi8ejsqerwvI1EeCPyijEBnelzkNPAqPKfS7359zQt
         /oXnDh9W3g+izRf/vnmRzL/S/IFszmleUT6i0vKPYVyiLcZ8CiGpIdapiDZuqCPA8Qvz
         RsUA==
X-Gm-Message-State: ACrzQf3GErpseqv6D9dh2i13tKM9aoaEcT50uggpATWoStEuNwE5h+ah
        aVlBYy13fpY0uM6RzXI+XPJ19uTIDbw8qcWJayI=
X-Google-Smtp-Source: AMsMyM5OfF/s5QPiqq4B01Lz9hx1BoMDniQEyTmUkDWcS3k9DETJmigpEXIA+cKR/gNBTrCW+hVE33RhybuQJDaVMPA=
X-Received: by 2002:a17:907:75f5:b0:78d:fc53:7d96 with SMTP id
 jz21-20020a17090775f500b0078dfc537d96mr3053049ejc.718.1665863687321; Sat, 15
 Oct 2022 12:54:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com> <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com> <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com> <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com> <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
 <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com> <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
 <4e73bbb9-eae1-6a90-d716-c721a1eeced3@gmail.com> <7e9519c6-f65f-5f83-1d17-a3510103469f@gmail.com>
 <CAHQ1cqE5=j9i8uYvBwdNUK8TrX3Wxy7iUML6K+gBQx-KRtkS7w@mail.gmail.com>
 <644adb7b-0438-e37c-222c-71bf261369b0@gmail.com> <CAHQ1cqGSXoUTopwvrQtLww5M0Tf=6F505ziLn+wGHhW_8-JhFQ@mail.gmail.com>
 <113fe314-0f5c-f53f-db78-c93bd4515260@gmail.com> <CAHQ1cqF_FvG0G2CAQooOVR3E442ApNFf8EKK8PpxcOrUoL5jDA@mail.gmail.com>
 <bec17559-286c-b006-476f-3c26ae38e70d@gmail.com>
In-Reply-To: <bec17559-286c-b006-476f-3c26ae38e70d@gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Sat, 15 Oct 2022 12:54:35 -0700
Message-ID: <CAHQ1cqFqKv+J1=Qg5_sDUeKQ=64aSiGJq0pPH+OqEieZDM1Mfg@mail.gmail.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 12:35 PM Ferry Toth <fntoth@gmail.com> wrote:
>
> <SNIP>
> > My end goal here is to find a way to test vanilla v6.0 with the two
> > patches reverted on your end. I thought that during my testing I saw
> > tusb1210 print those timeout messages during its probe and that
> > disabling the driver worked to break the loop, but I went back to
> > double check and it doesn't work so scratch that idea. Configuring
> > extcon as a built-in breaks host functionality with or without patches
> > on my end, so I'm not sure it could be a path.
> >
> > I won't have time to try things with
> > 0043b-TODO-driver-core-Break-infinite-loop-when-deferred-p.patch until
> > the weekend, meanwhile can you give this diff a try with vanilla (no
> > reverts) v6.0:
> >

OK, got a chance to try things with that patch. Both v6.0 and v6.0
with my patches reverted work the same, my Kingston DataTraveller USB
stick enumerates and works as expected.

> > modified   drivers/phy/ti/phy-tusb1210.c
> > @@ -127,6 +127,7 @@ static int tusb1210_set_mode(struct phy *phy, enum
> > phy_mode mode, int submode)
> >    u8 reg;
> >
> >    ret = tusb1210_ulpi_read(tusb, ULPI_OTG_CTRL, &reg);
> > + WARN_ON(ret < 0);
> >    if (ret < 0)
> >    return ret;
> >
> > @@ -152,7 +153,10 @@ static int tusb1210_set_mode(struct phy *phy,
> > enum phy_mode mode, int submode)
> >    }
> >
> >    tusb->otg_ctrl = reg;
> > - return tusb1210_ulpi_write(tusb, ULPI_OTG_CTRL, reg);
> > + ret = tusb1210_ulpi_write(tusb, ULPI_OTG_CTRL, reg);
> > + WARN_ON(ret < 0);
> > + return ret;
> > +
> >   }
> >
> >   #ifdef CONFIG_POWER_SUPPLY
> >
> > ? I'm curious to see if there's masked errors on your end since dwc3
> > driver doesn't check for those.
> root@yuna:~# dmesg | grep -i -E 'warn|assert|error|tusb|dwc3'
> 8250_mid: probe of 0000:00:04.0 failed with error -16
> platform regulatory.0: Direct firmware load for regulatory.db failed
> with error -2
> brcmfmac mmc2:0001:1: Direct firmware load for
> brcm/brcmfmac43340-sdio.Intel Corporation-Merrifield.bin failed with
> error -2
> sof-audio-pci-intel-tng 0000:00:0d.0: error: I/O region is too small.
> sof-audio-pci-intel-tng 0000:00:0d.0: error: failed to probe DSP -19
>
>
> >> This is done through configfs only when the switch is set to device mode.
> > Sure, but can it be disabled? We are looking for unknown variables, so
> > excluding this would be a reasonable thing to do.
> It's not enabled until I flip the switch to device mode.

OK to cut this back and forth short, I think it'd be easier to just
ask you to run what I run. Here's vanilla v6.0 bzImage and initrd
(built with your config + CONFIG_PHY_TUSB1210=y) I tested with
https://drive.google.com/drive/folders/1H28AL1coPPZ2kLTYskDuDdWo-oE7DRPH?usp=sharing
let's see how it behaves on your setup. There's also the U-Boot binary
I use in that folder in case you want to give it a try.

Now on Merrifield dwc3_get_extcon() doesn't do anything but call
extcon_get_extcon_dev() which doesn't touch any hardware or interact
with other drivers, so assuming

> So current v6.0 has: dwc3_get_extcon - dwc3_get_dr_mode - ... -
> dwc3_core_init - .. - dwc3_core_init_mode (not working)
>
> I changed to: dwc3_get_dr_mode - dwc3_get_extcon - .. - dwc3_core_init -
> .. - dwc3_core_init_mode (no change)
>
> Then to: dwc3_get_dr_mode - .. - dwc3_core_init - .. - dwc3_get_extcon -
> dwc3_core_init_mode (works)

still holds(did you double check that with vanilla v6.0?) the only
difference that I can see is execution timings. It seems to me it's
either an extra delay added by execution of  extcon_get_extcon_dev()
(unlikely) or multiple partial probes that include dwc3_core_init()
that change things. You can try to check the latter by adding an
artificial probe deferral point after dwc3_core_init(). Something like
(didn't test this):

modified   drivers/usb/dwc3/core.c
@@ -1860,6 +1860,10 @@ static int dwc3_probe(struct platform_device *pdev)
  goto err3;

  ret = dwc3_core_init(dwc);
+ static int deferral_counter = 0;
+ if (deferral_counter++ < 9) /* I counted 9 deferrals in my testing */
+ ret = -EPROBE_DEFER;
+
  if (ret) {
  dev_err_probe(dev, ret, "failed to initialize core\n");
  goto err4;
