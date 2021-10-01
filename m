Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A3C41E879
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 09:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352537AbhJAHkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 03:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhJAHkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 03:40:45 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA13C06177A
        for <stable@vger.kernel.org>; Fri,  1 Oct 2021 00:39:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w11so5735869plz.13
        for <stable@vger.kernel.org>; Fri, 01 Oct 2021 00:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V6Orf97LITG3TtcY2U9YlrpeTHclGOUtzKEGj7Adl8s=;
        b=UiTvl6Z8AB7T/q+57AvtQEbRh08tOHqwwZkwuBJpMW85c31LBaju0OhcGFd8+P7n7S
         MvcpPj4e4ehNyGUnkyEmYLWND60AG/qf8/9DdDz7w2WpN8GkuyjxhwPhJgiLcrgSwil7
         ulcrAq6vPJsZs932+QTB3rIH3Vz48yU0PwNixHXFK08dHjw03i0nBHhra8KJKJrC6xIO
         xiUlfvY93irjX2i/S+IpL9HSmmqFanSJ/CUVnLILFNbA7/7qu6nDrfwaPN8p8lh0oFur
         sZeF/RAnLCw5oPZNbbMjoaw/rz9ghCFLbBkcXPeAq1Rsv4Rjj03eM2Vf6oR2EiahOd8I
         LCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V6Orf97LITG3TtcY2U9YlrpeTHclGOUtzKEGj7Adl8s=;
        b=7IMn/Gg0BTf0cUiHMLkNryNYx8SWcnLdwcEAqTNugxyLqkUb31Dw6E3QA9a4rXXesl
         jCd6jMJPWTf1UvsArxujQS/kaGoWTK/s7AktM8Nzg3CaNAI0fBhD82aVCLCVSk/Q/yw0
         3A/4A7UjJevxC+bwdXoY6lkrwRoRRWa4IWpFnNxGS/IBM3uWrN8QPpm5QMKkoowmUJgE
         bFMOmVeHSAydk1NDxgJKKor0c0pz9NLtvZb23PCwsh2f3ZHawptLqqDnVxaIKxR8HQ0M
         /5+1sBcdsAyMVso0Tg0R7NBlu2VZt09pU7ZYlmuxcZAqROuvE+Aextu2CiG/rpw5F1po
         Xkrw==
X-Gm-Message-State: AOAM531Uf1c7HsfKdXem39WjvxvAMMBJV11AW3OLtuAeAztyGu5i4a3d
        41epHjmz+R8jq2moaesQqGQVbt91QJRy
X-Google-Smtp-Source: ABdhPJyFjolspmiRIi8F+dxzTNukyTgpEJ1Kwk3jEScz6c/AbbYUzNCcwFx//3g2Xh1Nen0MfbyGPA==
X-Received: by 2002:a17:90a:3483:: with SMTP id p3mr11838929pjb.80.1633073939902;
        Fri, 01 Oct 2021 00:38:59 -0700 (PDT)
Received: from thinkpad ([117.193.209.206])
        by smtp.gmail.com with ESMTPSA id az15sm6868282pjb.42.2021.10.01.00.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 00:38:58 -0700 (PDT)
Date:   Fri, 1 Oct 2021 13:08:54 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Thomas Perrot <thomas.perrot@bootlin.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] bus: mhi: pci_generic: increase timeout value for
 operations to 24000ms
Message-ID: <20211001073854.GD5821@thinkpad>
References: <20210805140231.268273-1-thomas.perrot@bootlin.com>
 <f358044a-78d0-ad63-a777-87b4b9d94745@aleksander.es>
 <73A52D61-FCAB-4A2B-BA96-0117F6942842@linaro.org>
 <CAAP7ucL1Zv6g8G0SWAjEAjr6OSVTyDmvmFkH+vMmmBwOH2=ZUQ@mail.gmail.com>
 <54c063613fe63282a1c26b312c772e89b662eae6.camel@bootlin.com>
 <CAMZdPi9AJcdVC2AS08ZtHU6sv1CMLhudgJHVpQF2zLfF+OV=Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi9AJcdVC2AS08ZtHU6sv1CMLhudgJHVpQF2zLfF+OV=Og@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 12:19:48PM +0200, Loic Poulain wrote:
> On Thu, 30 Sept 2021 at 10:08, Thomas Perrot <thomas.perrot@bootlin.com> wrote:
> >
> > Hello,
> >

[...]

> I agree, let's set a conservative high value for generic SDX55, so
> have wider support, that can be tuned per vendor IDs if necessary
> anyway.
> 

No. Since this device seems to have a dedicated config, let's increase the
timeout only for this device until we get reports for other devices.

> Regards,
> Loic
> 
> >
> > Moreover, Sierra EM919x modems use a custom controller configuration,
> > we are currently working on it. As our tests not being sufficiently
> > conclusive, so we have not yet submitted.
> >
> > Best regards,
> > Thomas
> >
> > > >
> > > > It was derived from testing I believe.
> > >
> > > Following your reasoning above, shouldn't this 24000ms timeout be
> > > applied only to the Sierra Wireless EM91xx devices (which may have
> > > custom firmware bits delaying the initialization a bit longer), and
> > > not to the generic SDX24, SDX55 and SDX65?
> > >
> > > If I'm not mistaken, Thomas is testing with a custom mhi_pci_generic
> > > entry for the EM91xx; as in
> > > https://forum.sierrawireless.com/t/sierra-wireless-airprime-em919x-pcie-support/24927
> > > .
> > > I'm also playing with that same entry on my own setup, but have other
> > > problems of my own :)
> > >
> > >
> > > --
> > > Aleksander
> > > https://aleksander.es
> >
> > --
> > Thomas Perrot, Bootlin
> > Embedded Linux and kernel engineering
> > https://bootlin.com
> >
