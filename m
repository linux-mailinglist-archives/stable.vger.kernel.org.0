Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B894128CA4E
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 10:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390846AbgJMIdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 04:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390540AbgJMIdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 04:33:50 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949B8C0613D0
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 01:33:50 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id n65so11760668ybg.10
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 01:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uhd5tajPl3p2EhRAOxhBLCa9aRjZCog0fqMGqUJWmCM=;
        b=qIDn7OF/hyM3k838UwYegKn6w9NtHxWnD0yJx0cZAsSMDAXCgwdRVC5aunFKBFpI3a
         HRtxvDqDoB62WyEmLLj7RJ68thkaa2LT0L1jgaP9xgfX2WzxdS+LZANTrwa27cq38rx/
         apYLInCLOzo9QSkyJLKvhlTtZFHNSodOxgK8GW/tNo9xNFecGWn+nbfKS2NAYtsriPgP
         w++ImeBDkccQDGDuzUYoTjYXfEUA+yCQ7g4QM0ibKvVSywIazAlNg1vG3wUGFj3FbfBQ
         a2GaOmLdp88uODD7bNnT+zcwmY9uwRVV21x5h2Y1YLg1Px6vejdSmFwxZlK4lGchchMZ
         FoRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uhd5tajPl3p2EhRAOxhBLCa9aRjZCog0fqMGqUJWmCM=;
        b=oa43sEIxP8raYsT4eCrx+UNNuFDMq3uzEizMwKcFHZcR3rYoPB3ie9RVyz3LECDgTh
         IU/615akC4O3y+xzYB5PL0zo4KEspoopIaqvmDGbMK9hHPQLIAzIn0EYMjnvd7d7d0po
         Rvpjk+oNByjIcYLkd5+TW+S6BVA2X83k/G09z4NlEKLaf4InHT/mvMUqPgZmgq8r22LJ
         OX5BQeITALvQCo467TOBYqHoGvnuBllumEAx0feXM2/5+QFb9PC43L8pZH5mDlPX+iic
         sAZIzchKZSgGhGRegtwEkGpB0/SIkmTz97bsGPed+BMPUoOFoR8rlsJBu7Dgtq3IQnCu
         7tIw==
X-Gm-Message-State: AOAM531nLENNbQr8Kbh3YrGRa5hVfJua3cSX71i3ZvD1jevkBEYoNLsl
        UApRunB63RUY8Z5SVBkV97obgu2OZNs1zY0Nf3c=
X-Google-Smtp-Source: ABdhPJy1fnByeKpGO9MSWfwbt2WhoI5vU3M+KjmO2lXW1KqatJCIEdKl1EmU4ouJRAprdDZrQVswl1c5GSipz6y7HgI=
X-Received: by 2002:a25:8546:: with SMTP id f6mr39649045ybn.476.1602578029866;
 Tue, 13 Oct 2020 01:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <20201013074600.9784-1-benchuanggli@gmail.com> <20201013080105.GA1681211@kroah.com>
In-Reply-To: <20201013080105.GA1681211@kroah.com>
From:   Ben Chuang <benchuanggli@gmail.com>
Date:   Tue, 13 Oct 2020 16:33:38 +0800
Message-ID: <CACT4zj8xjeRFnXekojFseHUTqouRwCwmXsCFVMWA+jhnW-DaDQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pci-gli: Set SDR104's clock to 205MHz and
 enable SSC for GL975x
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Ben Chuang <ben.chuang@genesyslogic.com.tw>,
        greg.tu@genesyslogic.com.tw, seanhy.chen@genesyslogic.com.tw,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 4:00 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Oct 13, 2020 at 03:46:00PM +0800, Ben Chuang wrote:
> > From: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> >
> > commit 786d33c887e15061ff95942db68fe5c6ca98e5fc upstream.
> >
> > Set SDR104's clock to 205MHz and enable SSC for GL9750 and GL9755
> >
> > Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > Link: https://lore.kernel.org/r/20200717033350.13006-1-benchuanggli@gmail.com
> > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > Cc: <stable@vger.kernel.org> # 5.4.x
> > ---
> > Hi Greg and Sasha,
> >
> > The patch is to improve the EMI of the hardware.
> > So it should be also required for some hardware devices using the v5.4.
> > Please tell me if have other questions.
>
> This looks like a "add support for new hardware" type of patch, right?

No, this is for a mass production hardware.
There are still some customer cases using v5.4 LTS hence we need to
add the patch for v5.4 LTS.

>
> If so, why not just use the 5.9 or newer kernel?  This is really big for
> a stable patch.
>
> thanks,
>
> greg k-h

Best regards,
Ben
