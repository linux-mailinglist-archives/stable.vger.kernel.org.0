Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E344B52BC
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354884AbiBNOGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:06:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiBNOGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:06:19 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4DE4A901
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 06:06:12 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id j2so46564577ybu.0
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 06:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9M5OW/p/N+317mqw1a7QGwFIU/E34FcnEw0pMzdlDnM=;
        b=XX2XWY3WEwfuGdCxy/g536HNRWOaAtAH42XA+oGj+uwqJfaSZF8dQ0L2/gdNtV+7rB
         VJDbHURITZAj7S3thHnskzdeveYUD7SBi8iM3r97pkGz0ehx3CdRcagu9RUtqM9jvJCk
         CxbAEi6ry/UyS6B/kQ5vwGigHJ6YXvG6pZ5ivH6FznJsyD0vu1Gum+0wIhqa5dUw+xUs
         HF4BsE+rPLn7v4RjyQBVPOh1zxRvmYJtTODZ7l1MQArcQAv55WYghBQO1kDdEgbWoEnV
         QBcNmz5iCEhga5UbzIZLe0WxyvpVH3+BhdDGBKIAMgsa2vobgfMwaILu2cn9NZFSVbZU
         EDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9M5OW/p/N+317mqw1a7QGwFIU/E34FcnEw0pMzdlDnM=;
        b=uD0IXICnKEHtUudVBWK2DW81ELUx8el0BN0QTNrIwh1bW7QG6TKsJuRk9O/KHhEJLq
         kco43KtsJkw9E8y0htumSvE1nAVOKvXJKjHlGi8b/VqfXawnJZ5VP4lxGlxFDjwOA31w
         Oo+PmtCRxPx+vCQYLmypSqdvlNHNq4HM/pB8fLbA4y5F25e7dr94dK3lm0maawfrOvCI
         o+Pste4oTRSYPr4Wsk3xnEZ5elV5AExhn6YoJranmK8zYphAF/akmYy8k0hHSd6hOGH3
         fDy+CK1bgnxc1JZrKW7WkReClgFRhC73tXdmf4f1FDrRTtq5bEH5QOG6QTojzunClVpq
         lpeA==
X-Gm-Message-State: AOAM5335XxtblUbH8ya8LdwA9Pq/QKQnjDalnjtCgAQTvu6yQ2O9DE/J
        ujxnFiEgwfk1dVbA+e5W3cE9+L/zNdZt+tT6PFFumw==
X-Google-Smtp-Source: ABdhPJybkgqEwTJ0yZ5TqAONojA2iJ+32VTFfDuw6K3jdn4eeVbSn+HBrHa1lvMNw+ZFvbw/Z/C9kzy+yQp4GlPqJGc=
X-Received: by 2002:a25:f404:: with SMTP id q4mr12321552ybd.146.1644847570937;
 Mon, 14 Feb 2022 06:06:10 -0800 (PST)
MIME-Version: 1.0
References: <720d0a9a42e33148fcac45cd39a727093a32bf32.1614965598.git.robin.murphy@arm.com>
 <a730070d718cb119f77c8ca1782a0d4189bfb3e7.1614965598.git.robin.murphy@arm.com>
 <0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com> <20210730143431.GB1517404@mutt>
 <8b358507-dbdf-b05b-c1da-2ec9903a2912@arm.com> <CADYN=9LE2JnE+vmv_UaeyJj_RpHcp+zZUv711VuQekLSiQ2bJA@mail.gmail.com>
In-Reply-To: <CADYN=9LE2JnE+vmv_UaeyJj_RpHcp+zZUv711VuQekLSiQ2bJA@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 14 Feb 2022 19:36:00 +0530
Message-ID: <CA+G9fYu7ctvOfdvBkDZ1nABz0TaYZ49FUKVTctn+mBTCmk9JCQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: dts: juno: Enable more SMMUs
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        lkft-triage@lists.linaro.org,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Robin,

Since we did not get a reply on this email thread.
and those intermittent failures are causing a lot of noise in reports summary.
We will wait one more week and stop running 64k page size testing on
Juno-r2 devices.

> > > diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > index 8e7a66943b01..d3148730e951 100644
> > > --- a/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > +++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > @@ -545,8 +545,7 @@ pcie_ctlr: pcie@40000000 {
> > >                           <0x02000000 0x00 0x50000000 0x00 0x50000000 0x0 0x08000000>,
> > >                           <0x42000000 0x40 0x00000000 0x40 0x00000000 0x1 0x00000000>;
> > >                  /* Standard AXI Translation entries as programmed by EDK2 */
> > > -               dma-ranges = <0x02000000 0x0 0x2c1c0000 0x0 0x2c1c0000 0x0 0x00040000>,
> > > -                            <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> > > +               dma-ranges = <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> > >                               <0x43000000 0x8 0x00000000 0x8 0x00000000 0x2 0x00000000>;
> > >                  #interrupt-cells = <1>;
> > >                  interrupt-map-mask = <0 0 0 7>;
> > >

Reference email thread,
https://lore.kernel.org/stable/0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com/

- Naresh
