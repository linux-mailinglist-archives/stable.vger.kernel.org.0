Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD29B2C30B7
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 20:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404348AbgKXT3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 14:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404230AbgKXT3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 14:29:22 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7208CC0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 11:29:22 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id h20so3536924qkk.4
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 11:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fuuNZV4eEK4UVZGkfEnEcBZWlhzFoL43u5dblz7GAk8=;
        b=UQbnJlP9THWnq1F4PPTOSydU3o3thDLf9/8PX9PlQNDkbCLEt1OPxzNG2IxNYdMoF9
         31aijhdfOFCPpMwhmq3QH5wA9U/jjb+F5UNu6X+ABsras4SFTvCI5oRcBRzZzA6Xanwg
         bITB9P8F7R6oC/ygaGC1Ltn76rt5HB4rJPPujdhGyoJ3RvcKeaXa3rEtNnrirlEDMqqh
         9LSb8JYUZ97XXj+sZGLAn2PeyGbVrp2MErEKOaGCGGwlwXyYycSOrER4CPMr7hLFhzDJ
         SgDouu+V7EU/UssT26xOp+3lGWZnNIBkLBtiwKs7USETjAJlXIvWNu3h1bDTV43RlTRd
         2ubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fuuNZV4eEK4UVZGkfEnEcBZWlhzFoL43u5dblz7GAk8=;
        b=FoPm4Cm+zRcOR0br3Ws8PMdnjZ5+K2kBWvtFTueLYZmHu1Gk9bhRVKTcSSVw48Q++S
         Gu5fCOhIGilgomtwsZ2o/VqXqjpjqtU4sfqa3XHxRt6MGpO/BbOCpbMvRZ+G8Rp+VXtl
         0JZ3eTOqIxkvkPAoqsm4Kz0UWhZ2ZJ6z9IcUymS6uydzror1/s+Pz/MdN64UaowvMWKV
         BipUz1LQ35skKNSGr/WO7/3cuL8a1u4RF3H9yF3Udt4WFcYHMUZHT1FZD7tM0ZJWotWr
         wt+3/Y2aPVjCGz2DbS8ApqlfysaR6UuqHk4s03bPOU9ML4CZMX/Cq7o+ajh7E4ugtmqb
         9SfQ==
X-Gm-Message-State: AOAM533CL08wwChpE1yStKGaP6ahG07vQatnf58PbTRR6ZQ2bqUCkOtf
        tPHzAfEn0LFwEAeYJ38hqewL99mJq3mSN7XUr5k=
X-Google-Smtp-Source: ABdhPJxPG78JP40buJR1xZsshKolpzyMIy2pPFSD1OCMUApxZsqChY93G7BMS+LTTgd+mJfbFwgCF+9nwAH1mNVxX4E=
X-Received: by 2002:a25:9344:: with SMTP id g4mr7382680ybo.342.1606246161708;
 Tue, 24 Nov 2020 11:29:21 -0800 (PST)
MIME-Version: 1.0
References: <160612300715987@kroah.com> <20201124134123.ie5jvzygygayajo5@debian>
 <X71Lv314xaqrtn9B@kroah.com> <CADVatmMFEYRSKcq4mkZqs0feVPSWX9miG49ffbCR0utLtFSgfA@mail.gmail.com>
In-Reply-To: <CADVatmMFEYRSKcq4mkZqs0feVPSWX9miG49ffbCR0utLtFSgfA@mail.gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 24 Nov 2020 19:28:44 +0000
Message-ID: <CADVatmNVjKBAZPh2voCHaFdAaU3pz2fs0sdL58eLSD4d-W8LQg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] spi: bcm-qspi: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Lukas Wunner <lukas@wunner.de>, Mark Brown <broonie@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, kdasu.kdev@gmail.com,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 24, 2020 at 6:53 PM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Tue, Nov 24, 2020 at 6:06 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Nov 24, 2020 at 01:41:23PM +0000, Sudip Mukherjee wrote:
> > > Hi Greg,
> > >
> > > On Mon, Nov 23, 2020 at 10:16:47AM +0100, gregkh@linuxfoundation.org wrote:
> > > >
> > > > The patch below does not apply to the 5.4-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > >
> > > Here is the backport for all the stable tree from v4.9.y to v5.4.y.
> >
> > THis didn't apply to 4.9.y, are you sure you tried that?
> >
> > Anyway, queued up for all other branches, thanks!
>
> I was modifying one of my script which pulls in the stablerc and
> stable-queue and I have completely messed up today  :(
> Please drop this from v4.14.y. It will fail to build there. I had been
> working on the version for v4.14.y and v4.9.y, but I will keep it
> aside for today.
> Really sorry for the confusion.

v4.19.y also. :(
I have rechecked and only v5.4.y is ok.

-- 
Regards
Sudip
