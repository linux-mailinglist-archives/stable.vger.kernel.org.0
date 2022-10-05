Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0101E5F4DC8
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 04:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiJECje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 22:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJECjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 22:39:33 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35CB5725F;
        Tue,  4 Oct 2022 19:39:28 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id e18so21198935edj.3;
        Tue, 04 Oct 2022 19:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=D0ZIJOYUZpFYaYhZHcteg3Q0SZxAR5z+5PYYUc0zJ8g=;
        b=SCBf8R/APnOyLchJYY7c4h8IB2yAIrejSu4nhioc3EZMKLQzmO2NxNUO41MOEQAHDa
         q/dS1HAJfGYRwxMXTPVKbtEoXxsTXWRLcGswjY5yTIsVtGn9wLEehvWdCbUYoeHq+dJD
         yto0NxB0KS60t4C2pxvn4PhN9AGiiF3FQYtY724azB5vHRcc6cZcTua5sLVqA2/ofkJR
         ATPKW3uDHdLii8htcMmaB/DnKkGfxCBzUv8xl7v0M1UAdqVtoIfq7oIANkv4MUcRdeDH
         SF1bSwLZIyUmNjzSkOEW27aQ5M2mKf2dSpYgZgxat8nNCg+kWmN+QxovbnnAMIq1X+n/
         Cs8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=D0ZIJOYUZpFYaYhZHcteg3Q0SZxAR5z+5PYYUc0zJ8g=;
        b=OjKvAFZRDmNN8KvS5TDkM8MFTeCaUzs25PPPsi0GprjAVi/B4nXz5i6N+yw2IJMJ5m
         o/Ix+cdTRHQphEYbzHeWNvgL3kUc1ll5W81sHOuNwpdnInTNzUz1hzr2SRESa+1h0fuD
         H3BGyT0GkD3zpllRXHeJVmGrUZDoH2hqVQUNUats5cOut0oKKVM/z4ZAP1g/htfIoafQ
         b8uTpkUpYZlX63YA4z39X/LwZi/CT+f1biQtuxuZzKy3Jk8AjVVITBAG92AMNvxn6FNA
         NVfkNB6PUdCzjD9VNK/ZdKzX5GIjA6DIYF/H7MViuyDzRi5O6uXE7zcg59ztHy6RlKPg
         HxvA==
X-Gm-Message-State: ACrzQf2ttabRc1ViT0hdgg/jxiZ3NdlST74okJjxXeqc0KKl/zoiVBnu
        g/t8f+F+/qTCg0CQQmHs+DWYzLV9Shw5rIIXgTE=
X-Google-Smtp-Source: AMsMyM5xS/HHP61aEUO1qhjdYAJGqXhVpjj9VJvRigByguUTYDTCeaB6tofMSf1TIOoDLwSqEvmD6mdcT2VToYjrbf8=
X-Received: by 2002:a05:6402:27ca:b0:451:7b58:1b01 with SMTP id
 c10-20020a05640227ca00b004517b581b01mr27276721ede.61.1664937567125; Tue, 04
 Oct 2022 19:39:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com> <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com> <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
In-Reply-To: <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 4 Oct 2022 19:39:14 -0700
Message-ID: <CAHQ1cqG9-SDM4_zUfCvxP7XD-U+PPOWqWDBFKU73ecomDpt9Jw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Ferry Toth <fntoth@gmail.com>,
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

On Tue, Oct 4, 2022 at 7:12 PM Thinh Nguyen <Thinh.Nguyen@synopsys.com> wrote:
>
> On Tue, Oct 04, 2022, Ferry Toth wrote:
> > Hi
> >
> > Op 04-10-2022 om 10:28 schreef Andy Shevchenko:
> > > On Mon, Oct 03, 2022 at 09:57:35PM +0000, Thinh Nguyen wrote:
> > > > On Tue, Sep 27, 2022, Andy Shevchenko wrote:
> > > > > This reverts commit 0f01017191384e3962fa31520a9fd9846c3d352f.
> > > > >
> > > > > As pointed out by Ferry this breaks Dual Role support on
> > > > > Intel Merrifield platforms.
> > > > Can you provide more info than this (any debug info/description)? It
> > > > will be difficult to come back to fix with just this to go on. The
> > > > reverted patch was needed to fix a different issue.
> >
> > On Merrifield we have a switch with extcon driver to switch between host and
> > device mode. Now with commit 0f01017, device mode works. In host mode the
> > root hub appears, but no devices appear. In the logs there are no messages
> > from tusb1210, but there should be because lately there normally are
> > (harmless) error messages. Nothing in the logs point in the direction of
> > tusb1210 not being probed.
> >
> > The discussion is here: https://urldefense.com/v3/__https://lkml.org/lkml/2022/9/24/237__;!!A4F2R9G_pg!avfDjiGwi8xu0grHYrQQTZEEUnmaKu82xxdty0ZltxyU8BkoFD6AMq4a-7STYiKxNQpdYXgP1QG_IZbroEM$
> >
> > I tried moving some code as suggested without result: https://urldefense.com/v3/__https://lkml.org/lkml/2022/9/24/434__;!!A4F2R9G_pg!avfDjiGwi8xu0grHYrQQTZEEUnmaKu82xxdty0ZltxyU8BkoFD6AMq4a-7STYiKxNQpdYXgP1QG_boaK8Qw$
> >
> > And with success: https://urldefense.com/v3/__https://lkml.org/lkml/2022/9/25/285__;!!A4F2R9G_pg!avfDjiGwi8xu0grHYrQQTZEEUnmaKu82xxdty0ZltxyU8BkoFD6AMq4a-7STYiKxNQpdYXgP1QG_MbbbZII$
> >
> > So, as Andrey Smirnov writes "I think we'd want to figure out why the
> > ordering is important if we want to justify the above fix."
> >
> > > It's already applied, but Ferry probably can provide more info if you describe
> > > step-by-step instructions. (I'm still unable to test this particular type of
> > > features since remove access is always in host mode.)
> > >
> > I'd be happy to test.
>
> Thanks!
>
> Does the failure only happen the first time host is initialized? Or can
> it recover after switching to device then back to host mode?
>
> Probably the failure happens if some step(s) in dwc3_core_init() hasn't
> completed.
>
> tusb1210 is a phy driver right? The issue is probably because we didn't
> initialize the phy yet. So, I suspect placing dwc3_get_extcon() after
> initializing the phy will probably solve the dependency problem.
>
> You can try something for yourself or I can provide something to test
> later if you don't mind (maybe next week if it's ok).

FWIW, I just got the same HW Ferry has last week and am planning to
work on this over the weekend.
