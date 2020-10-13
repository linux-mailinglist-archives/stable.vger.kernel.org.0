Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BFC28CC4C
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 13:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731275AbgJMLLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 07:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731262AbgJMLLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 07:11:25 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD36AC0613D0
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 04:11:24 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id l15so1194923ybp.2
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 04:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KulN+jSrp6kXZZEXwKhEcm7gJqmGX8C6QkWid3bTiyY=;
        b=nk51rb0c4zBnb8qa50gfwhTaEFSuMJiLsyobEEYHj7M8qW5XSG2QVMz8QdWcfd/c4n
         euWAjzwhXhWnLoe6HQpmosS79tD5aJPZwhkfYlvSG3IZ5sdYkbUx3DjYiP5IVAkPpwul
         GIbXuwKp5CzJWaFaSUbRVUzUKmbYKCTCWbMrXwmkyhieNaXjMWVm3XOTBWaJnYqYIw5k
         R95f8KdV/M+aokWJiLCa3fq++670een6bHXyYpVxUDMOCsgZmtbckb/zDLtid2niNBZY
         BFwNSDNoFFDeXT/umSYZw/PpOPiB8TBocXcVjDl/W0f/wkMIddN8AIFpWVcCA+ZfiD96
         Kl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KulN+jSrp6kXZZEXwKhEcm7gJqmGX8C6QkWid3bTiyY=;
        b=pi4253Ug2UO2up3VaqZHy5iCFjwyw5LE09sxHljVsH5kumAXa81L2BeNlDATGB6Df3
         2OU8ugcZ9U4d/AFAvmFBHmqdbIckWG33375pF268DCvEyPTqI+PuO4cHkeMnQVY95Dhc
         iV/Rw5qMI9iwpVZos27LNknrQPjyAZZ1H1SZ+LQV4+4EPWjXvTsxN4Cg7nCcgEDQZmUA
         4O4ycJwJWjK4B4MS/c4Aoteq/niejgrluGadthWJcJINKrJJ48mDsj47dhaqu3M8r6mW
         lkuFbUqcd3/bajQmdSXzD+EJvq3Rk9vkvwgRXM53hhk9q1koSfv+JfMH1AiCx5y5SYlM
         pSVg==
X-Gm-Message-State: AOAM532CqD4YpGYqR1OogcTWdvI8j/j0OA+1s006Rrhl1AyTCI5kHIJi
        BL6yFHxQt8tJixeWmZLBEL9vt2VwCtgUqfzpkc4=
X-Google-Smtp-Source: ABdhPJwRVxhiE0QoUEs96/3SZxCOiKsgcWwxNJVrvltpxIrGvEV15dFUFleiRyhDcydGY9QCyjbH7WQkB2VAdfSFpwg=
X-Received: by 2002:a25:44:: with SMTP id 65mr37274013yba.6.1602587484165;
 Tue, 13 Oct 2020 04:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <20201013074600.9784-1-benchuanggli@gmail.com> <20201013080105.GA1681211@kroah.com>
 <CACT4zj8xjeRFnXekojFseHUTqouRwCwmXsCFVMWA+jhnW-DaDQ@mail.gmail.com> <20201013085806.GB1681211@kroah.com>
In-Reply-To: <20201013085806.GB1681211@kroah.com>
From:   Ben Chuang <benchuanggli@gmail.com>
Date:   Tue, 13 Oct 2020 19:11:13 +0800
Message-ID: <CACT4zj-ShpspM0PNA_Q4fkEAubiTfp_rxcZ6FkQgcKoYx7WaNA@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pci-gli: Set SDR104's clock to 205MHz and
 enable SSC for GL975x
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Ben Chuang <ben.chuang@genesyslogic.com.tw>,
        greg.tu@genesyslogic.com.tw, seanhy.chen@genesyslogic.com.tw,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 4:57 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Oct 13, 2020 at 04:33:38PM +0800, Ben Chuang wrote:
> > On Tue, Oct 13, 2020 at 4:00 PM Greg KH <gregkh@linuxfoundation.org> wr=
ote:
> > >
> > > On Tue, Oct 13, 2020 at 03:46:00PM +0800, Ben Chuang wrote:
> > > > From: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > >
> > > > commit 786d33c887e15061ff95942db68fe5c6ca98e5fc upstream.
> > > >
> > > > Set SDR104's clock to 205MHz and enable SSC for GL9750 and GL9755
> > > >
> > > > Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > > Link: https://lore.kernel.org/r/20200717033350.13006-1-benchuanggli=
@gmail.com
> > > > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > > ---
> > > > Hi Greg and Sasha,
> > > >
> > > > The patch is to improve the EMI of the hardware.
> > > > So it should be also required for some hardware devices using the v=
5.4.
> > > > Please tell me if have other questions.
> > >
> > > This looks like a "add support for new hardware" type of patch, right=
?
> >
> > No, this is for a mass production hardware.
>
> That does not make sense, sorry.
>
> Is this a bug that is being fixed, did the hardware work properly before
> 5.4 and now it does not?  Or has it never worked properly and 5.9 is the
> first kernel that it now works on?

It seems there is misunderstanding regarding =E2=80=9Chardware=E2=80=9D mea=
ns.
I originally thought that the "hardware" refers to GL975x chips.

This Genesys patch is to fix the EMI problem for GL975x controller on a sys=
tem.
There is a new Linux-based system now in development stage build in
the GL975x controller
encounter the EMI problem due to the Kernel 5.4 do not support Genesys
patch for EMI.
Hence we would like to add the patch to Kernel 5.4.

>
> > There are still some customer cases using v5.4 LTS hence we need to
> > add the patch for v5.4 LTS.
>
> Your customer problems are not the upstream kernel's problems, this is
> why they pay you :)

Thanks for  your reminder :)

>
> Have you read the stable kernel rules:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.ht=
ml
>
> What category does this patch fall into?

Hmm. I think It fixes an EMI issue of hardware (system).

>
> thanks,
>
> greg k-h

Best regards,
Ben
