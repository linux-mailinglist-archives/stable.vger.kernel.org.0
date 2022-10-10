Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648C85FA70A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 23:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJJVgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 17:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiJJVgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 17:36:12 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCA87D792;
        Mon, 10 Oct 2022 14:36:07 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qw20so26903112ejc.8;
        Mon, 10 Oct 2022 14:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eaKA3eg592NEgHw3Ggx57EkA5thH66cxyv45s8inS6M=;
        b=IMtFN13fpHi7td1QySWaDnM6O37Vwx5vAtmS+3LVL5IW9iTcXMTTknCT3rCBSccp4F
         EAKkKNc3PW3gYMTSy0oTMKU1llvVBbbLCsdMWPzVaXZklSr7ERUaZtBW2VRYhzrpaHgc
         qPPJf2l2Cd8trMP3g+8ZSJ7oHT9rDYKsRo8tQ4TPIMktCRu7YGkN6B7npjUllX+46sW4
         eg5F+3vZ6JE6AkxkmK6QFDr8qNPD7zudof0tjY0l/ZW2hsVWnYZNwGUhtYyDnI7Axp00
         n0660ndw9un52I+TYDGlTor0Ab+GWBl4RiGVKaIqLxTCR5XyD+bfo5cwSdm+pVlBtSVP
         AN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eaKA3eg592NEgHw3Ggx57EkA5thH66cxyv45s8inS6M=;
        b=feXM4bt9CxeZOWEQYUkolz5tOZMeFIUX2b4fbs/cSLLJEYq1zQjumQ3VO/y+AuVYQ0
         LRFrjCYJiRT8Nuoy0Zbq/eeEOT4Re4xeolk03y/5WB8Z3aukeJOzb5Vygf/ROdehGglZ
         2xiH3OzzuL+jm6n3trIksG2QidDGnzC7lTFN8xzPFgRkIdjIysw8WqyuW4Td9JqNorxD
         P79Jk6puL/Ewi1wCNA4i+qG9dNXjQk80R1U2U5+onP9IyboEYDTFhQ6Alsy47lt0Fqkc
         9pLQEmopWJlm1TiahJb4S/IRdrY9FZ5g94RzqGHsLB17eODhU9KiUtOWMtQwJdm/LRQx
         SqAw==
X-Gm-Message-State: ACrzQf05A4ZA5xA5eTns2VMFmQ3Ukdo/0O3O6kSue8Ky3k4mSFibvCMh
        nc4l24nn+z7IEb40ZuPj0OWtpCSodxV2cpRQ2LI=
X-Google-Smtp-Source: AMsMyM4DGg7Jh1t/BI6u1Xawoa1rez9M1KZDD9rYYUShp3+SMYQQwnUgsDGn1lVKz1Iqnf5rxh3RWr4s/3yloz3rbUY=
X-Received: by 2002:a17:907:2cd8:b0:78d:9c3c:d788 with SMTP id
 hg24-20020a1709072cd800b0078d9c3cd788mr9699644ejc.327.1665437765676; Mon, 10
 Oct 2022 14:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com> <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com> <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com> <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com> <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
 <ade865f1-8ed5-a8e3-e441-cb7688c6d001@gmail.com> <CAHQ1cqGSmNSg73DzURrcP=a-cCd6KdVUtUmnonhP54vWVDmEhw@mail.gmail.com>
 <4e73bbb9-eae1-6a90-d716-c721a1eeced3@gmail.com> <7e9519c6-f65f-5f83-1d17-a3510103469f@gmail.com>
In-Reply-To: <7e9519c6-f65f-5f83-1d17-a3510103469f@gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 10 Oct 2022 14:35:53 -0700
Message-ID: <CAHQ1cqE5=j9i8uYvBwdNUK8TrX3Wxy7iUML6K+gBQx-KRtkS7w@mail.gmail.com>
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

On Mon, Oct 10, 2022 at 1:52 PM Ferry Toth <fntoth@gmail.com> wrote:
>
> Hi
>
> Op 10-10-2022 om 13:04 schreef Ferry Toth:
> > Hi
> >
> > On 10-10-2022 07:02, Andrey Smirnov wrote:
> >> On Fri, Oct 7, 2022 at 6:07 AM Ferry Toth <fntoth@gmail.com> wrote:
> >>>
> >>> On 07-10-2022 04:11, Thinh Nguyen wrote:
> >>>> On Thu, Oct 06, 2022, Ferry Toth wrote:
> >>>>> Hi
> >>>>>
> >>>>> On 06-10-2022 04:12, Thinh Nguyen wrote:
> >>>>>> On Wed, Oct 05, 2022, Ferry Toth wrote:
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>>        Thanks!
> >>>>>>>
> >>>>>>>        Does the failure only happen the first time host is
> >>>>>>> initialized? Or can
> >>>>>>>        it recover after switching to device then back to host mode?
> >>>>>>>
> >>>>>>> I can switch back and forth and device mode works each time,
> >>>>>>> host mode remains
> >>>>>>> dead.
> >>>>>> Ok.
> >>>>>>
> >>>>>>>        Probably the failure happens if some step(s) in
> >>>>>>> dwc3_core_init() hasn't
> >>>>>>>        completed.
> >>>>>>>
> >>>>>>>        tusb1210 is a phy driver right? The issue is probably
> >>>>>>> because we didn't
> >>>>>>>        initialize the phy yet. So, I suspect placing
> >>>>>>> dwc3_get_extcon() after
> >>>>>>>        initializing the phy will probably solve the dependency
> >>>>>>> problem.
> >>>>>>>
> >>>>>>>        You can try something for yourself or I can provide
> >>>>>>> something to test
> >>>>>>>        later if you don't mind (maybe next week if it's ok).
> >>>>>>>
> >>>>>>> Yes, the code move I mentioned above "moves dwc3_get_extcon()
> >>>>>>> until after
> >>>>>>> dwc3_core_init() but just before dwc3_core_init_mode(). AFAIU
> >>>>>>> initially
> >>>>>>> dwc3_get_extcon() was called from within dwc3_core_init_mode()
> >>>>>>> but only for
> >>>>>>> case USB_DR_MODE_OTG. So with this change order of events is
> >>>>>>> more or less
> >>>>>>> unchanged" solves the issue.
> >>>>>>>
> >>>>>> I saw the experiment you did from the link you provided. We want
> >>>>>> to also
> >>>>>> confirm exactly which step in dwc3_core_init() was needed.
> >>>>> Ok. I first tried the code move suggested by Andrey (didn't work).
> >>>>> Then
> >>>>> after reading the actual code I moved a bit further.
> >>>>>
> >>>>> This move was on top of -rc6 without any reverts. I did not make
> >>>>> additional
> >>>>> changes to dwc3_core_init()
> >>>>>
> >>>>> So current v6.0 has: dwc3_get_extcon - dwc3_get_dr_mode - ... -
> >>>>> dwc3_core_init - .. - dwc3_core_init_mode (not working)
> >>>>>
> >>>>> I changed to: dwc3_get_dr_mode - dwc3_get_extcon - .. -
> >>>>> dwc3_core_init - ..
> >>>>> - dwc3_core_init_mode (no change)
> >>>>>
> >>>>> Then to: dwc3_get_dr_mode - .. - dwc3_core_init - .. -
> >>>>> dwc3_get_extcon -
> >>>>> dwc3_core_init_mode (works)
> >>>>>
> >>>>> .. are what I believe for this issue irrelevant calls to
> >>>>> dwc3_alloc_scratch_buffers, dwc3_check_params and dwc3_debugfs_init.
> >>>>>
> >>>> Right. Thanks for narrowing it down. There are still many steps in
> >>>> dwc3_core_init(). We have some suspicion, but we still haven't
> >>>> confirmed
> >>>> the exact cause of the failure. We can write a proper patch once we
> >>>> know
> >>>> the reason.
> >>> If you would like me to test your suspicion, just tell me what to do
> >>> :-)
> >>
> >> OK, Ferry, I think I'm going to need clarification on specifics on
> >> your test setup. Can you share your kernel config, maybe your
> >> "/proc/config.gz", somewhere? When you say you are running vanilla
> >> Linux, do you mean it or do you mean vanilla tree + some patch delta?
> >
> > For v6.0 I can get the exacts tonight. But earlier I had this for v5.17:
> >
> > https://github.com/htot/meta-intel-edison/blob/master/meta-intel-edison-bsp/recipes-kernel/linux/linux-yocto_5.17.bb
> >
> >
> > There are 2 patches referred in #67 and #68. One is related to the
> > infinite loop. The other is I believe also needed to get dwc3 to work.
> >
> > All the kernel config are applied as .cfg.
> >
> > Patches and cfs's here:
> >
> > https://github.com/htot/meta-intel-edison/tree/master/meta-intel-edison-bsp/recipes-kernel/linux/files
> >
>
> Updated Yocto recipe for v6.0 here:
>
> https://github.com/htot/meta-intel-edison/blob/honister/meta-intel-edison-bsp/recipes-kernel/linux/linux-yocto_6.0.bb
>
> #75-#77 are the 2 reverts from Andy, + one SOF revert (not related to
> this thread).

Please drop all of this
https://github.com/htot/meta-intel-edison/blob/honister/meta-intel-edison-bsp/recipes-kernel/linux/linux-yocto_6.0.bb#L69-L77
and re do the testing. Assuming things are still broken, that's how
you want to do the bisecting.
