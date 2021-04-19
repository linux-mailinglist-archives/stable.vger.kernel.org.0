Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4925D363DDE
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 10:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238240AbhDSInx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 04:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbhDSInw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 04:43:52 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73FCC06174A;
        Mon, 19 Apr 2021 01:43:22 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id b17so23774139pgh.7;
        Mon, 19 Apr 2021 01:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VRokIKYRVWLtZ0DRiWEqTU2hDyvkFHznP5LEDRwjPo4=;
        b=IyPCYwLGPp7g7yNyOumEHNIto61N9Jukzc28weEtUHNrLBmA1LVgYAaUQJRLlpIYCo
         C1TyeNrAQazTLS3W40mHwKkMOqG2g6qIe9Up2hIWhuNXk+Z2iaWiQNSS6GUfoBq2HfZx
         /2fZJtM58wIVBZwG8enQUMV/0+cT2WzYKdGCRO6eNzwh4SVlBGR5ezV3mG3X/H8L3U2l
         nEN9GoY9L+7DBXTs6sD2EVaNhqH5jQNQkU22N736PvAbFQZnj3vrbFW4cOneAaLid5aN
         I2s7LBQAU5CrLDWFF4DgjjSOLguM/cpMV9uIEFgsnQl2lZakeBWxro6OXaGaEmsRJ4yb
         3ivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VRokIKYRVWLtZ0DRiWEqTU2hDyvkFHznP5LEDRwjPo4=;
        b=Hr2e2aBP1KlVBsTIXUKRgZ1jYdIkFfagJpyARwRYi7zmG/9KJK3/mc0kvbuwLNm6nK
         a+2E4067kGvk1flUmFH62Yb12jFHPDm2QOSi9hTSA9yUNmIWrHI7JJ+JP/7K1lSM8pN4
         ot9KUKvXXBSpGwzmqH9qGpE17aZ/LbXP7UgCvUQicHs6Rk2/JrjhTFCn8y+ntPfkiEj4
         UpagbXOkPxmnOLGclg3W3fJRI6fVTH943WcmOEaziXCJ8Hwsx+v4rTwudZFMNVNUCD2d
         nkHz9usX1G0fjktUJLc8w7WfeJGq48sHZF3zhIRoAkS3jxnzOWbiq8/Q7y5uhU8yeEgW
         8EAA==
X-Gm-Message-State: AOAM531KatZWDkJrHOKsJ8Z91eNQcvLZC+XdqaAvlRU5hZUsDKQFF3rN
        uilGYProyqQtXMImnC+w6/d+wlEx343xiBxbymw=
X-Google-Smtp-Source: ABdhPJzG1mIOpmmA1DIB1A2S9VsWNvmj0tHOyMuwJ/u4xBzTRH2wdyHJXHMgMhCKYfdaM+3DwcDfabgHA4jYQtbjuBo=
X-Received: by 2002:a63:a847:: with SMTP id i7mr6877569pgp.203.1618821802240;
 Mon, 19 Apr 2021 01:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <d053b843-2308-6b42-e7ff-3dc6e33e5c7d@synopsys.com> <0882cfae-4708-a67a-f112-c1eb0c7e6f51@gmail.com>
 <1c1d8e4a-c495-4d51-b125-c3909a3bdb44@synopsys.com> <db5849f7-ba31-8b18-ebb5-f27c4e36de28@gmail.com>
 <09755742-c73b-f737-01c1-8ecd309de551@gmail.com> <4a1245e3-023c-ec69-2ead-dacf5560ff9f@synopsys.com>
In-Reply-To: <4a1245e3-023c-ec69-2ead-dacf5560ff9f@synopsys.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 19 Apr 2021 11:43:05 +0300
Message-ID: <CAHp75Vfs559OL1_iwtmdvnLTELUFLHXaJfmW4_oqoC3NpyMhLw@mail.gmail.com>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Ferry Toth <fntoth@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Yu Chen <chenyu56@huawei.com>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 2:03 AM Thinh Nguyen <Thinh.Nguyen@synopsys.com> wrote:
> Ferry Toth wrote:
> > Op 17-04-2021 om 16:22 schreef Ferry Toth:
> >> Op 17-04-2021 om 04:27 schreef Thinh Nguyen:
> >>> Ferry Toth wrote:
> >>>> Op 16-04-2021 om 00:23 schreef Thinh Nguyen:
> >>>>> Thinh Nguyen wrote:

> > On the PC side this resulted to:
> >
> > apr 17 18:17:44 delfion kernel: usb 1-5: new high-speed USB device
> > number 12 using xhci_hcd
> > apr 17 18:17:44 delfion kernel: usb 1-5: New USB device found,
> > idVendor=1d6b, idProduct=0104, bcdDevice= 1.00
> > apr 17 18:17:44 delfion kernel: usb 1-5: New USB device strings: Mfr=1,
> > Product=2, SerialNumber=3
> > apr 17 18:17:44 delfion kernel: usb 1-5: Product: USBArmory Gadget
> > apr 17 18:17:44 delfion kernel: usb 1-5: Manufacturer: USBArmory
> > apr 17 18:17:44 delfion kernel: usb 1-5: SerialNumber: 0123456789abcdef
> > apr 17 18:17:49 delfion kernel: usb 1-5: can't set config #1, error -110
> >
> > Thanks for all your help!
>
> Looks like it's LPM related again. To confirm, try this:
> Disable LPM with this property "snps,usb2-gadget-lpm-disable"
> (Note that it's not the same as "snps,dis_enblslpm_quirk")
>
> Make sure that your testing kernel has this patch [1]
> 475e8be53d04 ("usb: dwc3: gadget: Check for disabled LPM quirk")

Thinh, Ferry, I'm a bit lost in this thread. Can you summarize what
patches I have to apply on top of v5.12-rc8 to mitigate issues,
mentioned in this thread?

(Sounds to me there are like ~5 patches floating around)

I'll try to find time to test on my side.

> [1] https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit/?h=usb-next&id=475e8be53d0496f9bc6159f4abb3ff5f9b90e8de


-- 
With Best Regards,
Andy Shevchenko
