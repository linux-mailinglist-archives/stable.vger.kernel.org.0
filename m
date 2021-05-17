Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDD7382C79
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 14:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhEQMq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 08:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhEQMq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 08:46:28 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6F6C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 05:45:12 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id z3so6336042oib.5
        for <stable@vger.kernel.org>; Mon, 17 May 2021 05:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bBBm+WeHyz4lkqmetRMun1w+G5fl+4ObKMk21jjZXDo=;
        b=fDbCmPvV4q2OS4aLWE1KQwF12pUd3FlZ3XEq5OSfSnQWLygroXQAxUjkaWInH4JTW+
         czwfirUH+JmeQHhesZIDvZ5f06eI/+ixi3b+52hLFDXTZCU8SSQ0JZuoiT+p4h5v859y
         76D5BEpAZu6CFEkO8CXJ6yTXCzZ3eKnyEBS/4CHBt4ftJh2h+X83Wx7isDL65AtTDX8n
         XxVahAFSD+ZQsTU3W0VCwPUsPRO5NAYOb5LSG6ShoT0U43PnrWA3sFdDzizrj21VtEnM
         dSBbS61q+LPDIHTIRfZdaHCGmzwOCuEo6Rd9xx650MSncVMwy/zXjf2YN6YLeL4/FuWb
         ZRrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bBBm+WeHyz4lkqmetRMun1w+G5fl+4ObKMk21jjZXDo=;
        b=nPFsy8M6T8Xo6Kf3TbWlMDxP4djDEM4upUFAt61myJb51EgbOfTZPvs8aT4hEUjPB9
         zXdJwp54MwwyHzxXkMQRsS5XmWfta6gut/psMThfZZgfLE/PLHKONEIPZVtsYRV+194q
         NRwHhbAmoz/3Wkj6xEKqMc1iBViATkpnH7qI/DJoxJvHrum/hHSW0vksXb+cef6tua8d
         f4Y6y4atf9X2YCuieBe7wm31Wo8S2TkwsXgaiBnnYIXAQYO2SWJvwC/aLGXSHNOG4v7t
         Kw1PPizIY5UmzIum7GtuYvgyq0LoRUGulTHUcp9BpnST+KnPaKy+AG/E4BB3MJJyLpPg
         y1eg==
X-Gm-Message-State: AOAM531eRMq9YcC63aR1IB7ctDjwQF+vX6EWUkMrT7n302oNteV/C868
        QCEMKtwVqJUlsCtqDyGeVjs/6gHkKy5wm4WQN/zSnv0O/Ec=
X-Google-Smtp-Source: ABdhPJxzJP4HwiriiP7w14de/Kr5lE657Tw5IZx4On2XQ3FQGHiwAjvO0FlwLXQfh0ttqKMd8IExwVUxrfsx02NYRbw=
X-Received: by 2002:aca:f156:: with SMTP id p83mr42943541oih.91.1621255511852;
 Mon, 17 May 2021 05:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <e0e9ecf4-cfd7-b31a-29b0-ead4a6c0ee40@charleswright.co>
 <1621180418@msgid.manchmal.in-ulm.de> <YKI/D64ODBUEHO9M@kroah.com>
 <1621251453@msgid.manchmal.in-ulm.de> <1621251685@msgid.manchmal.in-ulm.de>
 <CA+res+RHyF22T-sGwCG5zA6EBrk_gWbnZETX_iAgdRdWaPLbfw@mail.gmail.com> <1621254246@msgid.manchmal.in-ulm.de>
In-Reply-To: <1621254246@msgid.manchmal.in-ulm.de>
From:   Jack Wang <jack.wang.usish@gmail.com>
Date:   Mon, 17 May 2021 14:45:01 +0200
Message-ID: <CA+res+QRm3VyJSjMaKLYm=KY5+T5nX+6-QhOgrgBcP+d2Ganag@mail.gmail.com>
Subject: Re: 5.10.37 won't boot on my system, but 5.10.36 with same config does
To:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc:     stable <stable@vger.kernel.org>, iommu@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de> =E4=BA=8E2021=E5=B9=
=B45=E6=9C=8817=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=882:25=E5=86=99=
=E9=81=93=EF=BC=9A
>
> Jack Wang wrote...
>
> > Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de> =E4=BA=8E2021=E5=
=B9=B45=E6=9C=8817=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=881:52=E5=86=
=99=E9=81=93=EF=BC=9A
> > >
> > > Christoph Biedl wrote...
> > >
> > > > Thanks for taking care, unfortunately no improvement with 5.10.38-r=
c1 here.
> > >
> > > So in case this is related to the .config, I'm attaching it. Hardware=
 is,
> > > as said before, an old Thinkpad x200, vendor BIOS and no particular m=
odifications.
> > > After disabling all vga/video/fbcon parameters I see the system suffe=
rs
> > > a kernel panic but unfortunately only the last 25 lines are visible.
> > > Possibly (typos are mine)
> > >
> > >     RIP: 0010:__domain_mapping+0xa7/0x3a0
> > >
> > > is a hint into the right direction?
> > This looks intel_iommu related, can you try boot with
> > "intel_iommu=3Doff" in kernel parameter?
>
> Gotcha. System boots up fine then.
>
>     Christoph
So it's caused by this commit[1], and it should be fixed by latest
5.10.38-rc1 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git/log/?h=3Dlinux-5.10.y
[1]https://lore.kernel.org/stable/20210515132855.4bn7ve2ozvdhpnj4@nabokov.f=
ritz.box/
