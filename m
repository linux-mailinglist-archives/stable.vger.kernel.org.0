Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E7D4B5448
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 16:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242485AbiBNPMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 10:12:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241377AbiBNPMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 10:12:12 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8360C71
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 07:12:03 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id j2so47182383ybu.0
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 07:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UBjiQmW8y46Ip1DF4K/0pxnyYPVomVLjOgW0M3dZ1u0=;
        b=KtCP66Wxyc0rifCs56vfMd6KDU8aNhUB6lVbw8fFnB0NsIcpceY96dpYqFtB4WlRIT
         hmbfo7GHcZTFe2rM3Lva3nAcZIEP1xsatyd+NF8VJknv54Lu98465/kZimIjdAWHEgQX
         +L4NoLN5XEf9IpZ5mIAp7BHQF4op0x02dokCh7EsF4G8QbM5xFbpqC6bMyEUFKZHxjnx
         3kq0JJiESTeq9SxHOnSIynPh+kwXTDbXpPjt7nmdIWdNAZuRJ43TfcWlXb2DZEMXvAey
         fQyOeT/SZdg9b+MMynaLlYmuScvGUs5OBZB3X7ngyaOODavWQweiI7VebD2QAbl6Gkpx
         5aBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UBjiQmW8y46Ip1DF4K/0pxnyYPVomVLjOgW0M3dZ1u0=;
        b=stj/qN9tgawwAdpGTWuldotwSiE+6/Lu8DIQns2TiULmVn4sQ9DQI5QGivPLcyFmtW
         ZOpITCdNqnPbIEyac9u5dySKy85oVDB+h4D7ONl93/iFtzytK1+hEGgJnIw02ftH9I56
         KZaX7CfHQ1H8cbjQTaxyvBONrLCzCbNrYwLdGPKyQVTU8O2rQSMo3pI1bo13M8daCFtU
         Iu9TO1UtjdR8DTWP31lVrEoMznHSnZjih4EUmXG3xQFtzFbm5v+7c5naK9u1f4g+GnuK
         0EqR2pkUUOidpu7pnyAtcSrUDDg6ibp2wQk9GfUdPb2Cf+MyxX/0ZHhASTuUzGcDjl6j
         KzrA==
X-Gm-Message-State: AOAM533sPJgQzA1YHyzQATGSqLYXURNwp1Pgq2VtThyJW8gb3VGHFqP3
        SeAJ/EULAw04WdCpvNKyeYAmdAmhcaJd07yJH9nM0A==
X-Google-Smtp-Source: ABdhPJz+19IPb/+B+c6nDdIBywW7Rx+k0elXWWE0AdbE1hnFqfaoFgAXuLAFvEUh7HzRfgjAJEr/q2G8md8JBTg6p+w=
X-Received: by 2002:a0d:f601:: with SMTP id g1mr14030931ywf.441.1644851522503;
 Mon, 14 Feb 2022 07:12:02 -0800 (PST)
MIME-Version: 1.0
References: <720d0a9a42e33148fcac45cd39a727093a32bf32.1614965598.git.robin.murphy@arm.com>
 <a730070d718cb119f77c8ca1782a0d4189bfb3e7.1614965598.git.robin.murphy@arm.com>
 <0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com> <20210730143431.GB1517404@mutt>
 <8b358507-dbdf-b05b-c1da-2ec9903a2912@arm.com> <CADYN=9LE2JnE+vmv_UaeyJj_RpHcp+zZUv711VuQekLSiQ2bJA@mail.gmail.com>
 <CA+G9fYu7ctvOfdvBkDZ1nABz0TaYZ49FUKVTctn+mBTCmk9JCQ@mail.gmail.com> <20220214141303.3lmnassl4qibsp3y@bogus>
In-Reply-To: <20220214141303.3lmnassl4qibsp3y@bogus>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 14 Feb 2022 20:41:51 +0530
Message-ID: <CA+G9fYsUX2vHjNwZ7u=JtACEyfe9SkSHtYnwJXJ1JytF9+pSAQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: dts: juno: Enable more SMMUs
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
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

On Mon, 14 Feb 2022 at 19:43, Sudeep Holla <sudeep.holla@arm.com> wrote:
>
> On Mon, Feb 14, 2022 at 07:36:00PM +0530, Naresh Kamboju wrote:
> > Hi Robin,
> >
> > Since we did not get a reply on this email thread.
> > and those intermittent failures are causing a lot of noise in reports summary.
> > We will wait one more week and stop running 64k page size testing on
> > Juno-r2 devices.
> >
> > > > > diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > > > index 8e7a66943b01..d3148730e951 100644
> > > > > --- a/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > > > +++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > > > @@ -545,8 +545,7 @@ pcie_ctlr: pcie@40000000 {
> > > > >                           <0x02000000 0x00 0x50000000 0x00 0x50000000 0x0 0x08000000>,
> > > > >                           <0x42000000 0x40 0x00000000 0x40 0x00000000 0x1 0x00000000>;
> > > > >                  /* Standard AXI Translation entries as programmed by EDK2 */
> > > > > -               dma-ranges = <0x02000000 0x0 0x2c1c0000 0x0 0x2c1c0000 0x0 0x00040000>,
> > > > > -                            <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> > > > > +               dma-ranges = <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> > > > >                               <0x43000000 0x8 0x00000000 0x8 0x00000000 0x2 0x00000000>;
> > > > >                  #interrupt-cells = <1>;
> > > > >                  interrupt-map-mask = <0 0 0 7>;
> > > > >
> >
> > Reference email thread,
> > https://lore.kernel.org/stable/0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com/
> >
>
> I was about to tag the fix for this and was just reading this thread. I will
> send the pull request soon. Sorry for the delay, it is in next for some time
> now. Are you seeing the issue even in linux-next ?

Due to load balance / test queue maintenance on Juno-r2 devices,
We have stopped running 64k page testing on mainline and next instead
running on stable-rc builds.

Allow me a day to test Linux next 64k page size build testing on
Juno-r2 and get back to you.

- Naresh
