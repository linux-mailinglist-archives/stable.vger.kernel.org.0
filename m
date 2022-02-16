Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA404B86B4
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 12:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbiBPLdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 06:33:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231556AbiBPLdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 06:33:18 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDCF1AB217
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 03:33:05 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id j2so5265426ybu.0
        for <stable@vger.kernel.org>; Wed, 16 Feb 2022 03:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=674Fl170FM85N3RqdRnoVviMkGCxcWyEh6yo5TEOFT8=;
        b=m+O5ZXJ3y6Ay2MlyItpq0ACWrBov3P5ke6TnpYwKaVg3VC/0ulQZQB/A/9fmy+2Egn
         iMhYmVE58aXQeKe+Ya4xFa16yXiEwjzSGuwiL5uD+OWuSia4WyJW4fJGVuhVX6gQpEFw
         fJ7Jq5wPpInjUAx0MTwqcUjbLCKh799onw2brXoUlK1gJCBZ61wNOZDvW0+ID4/6RVgO
         +f92zK6kR5DqYQPDGseB5OpzYsdByKlWys2n4mHum1oFeSSBjWtCBqF4m3VTeyIxuSBZ
         ql4bp0vOGB8vhJzir62nTcOznlhlnb3elwFg2KG78xP/MsNcpHvvOvTztaspjBh2AxLr
         qBcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=674Fl170FM85N3RqdRnoVviMkGCxcWyEh6yo5TEOFT8=;
        b=j/q3iUM+f/gE4hLzPRvt9A0JTOQHP4QM9TtF9ZqkN6diSyRdCVG5Oo/JPuqBIynEMN
         n5zJI9uEI0tn599o6fquTLt70AsrB5emtmzBOYs88K6JjnXNrrhQCTeB/seZymyqpYMM
         igx3gPXbFsRLikm5YC/d9CtqSSWTmb1c3xKQ7G9q9VHYIH/xr7hJ7Pi35DOE401dpcPo
         6B7FH1o7yhikRDxUfMPIbos/UaDy01ugJzxoZD3rDGVo3MBsPcbOYIybLoX0SGGoNQeq
         9YruYALgCwBYIeuM/7Hsaq0RWb9LAFm/ucAWC+ZIZ9p0yoFPQC3TISjoAsU+OHx0vtrw
         PEyg==
X-Gm-Message-State: AOAM532G5aOx5BzHhc85nSBP6/I8g6/joRfZLjTWs+e7Px6g1Ogd1T3m
        iBcusA/ckmR5ppbjZ1u+vWtONIe0+shT60vnYQ4rRg==
X-Google-Smtp-Source: ABdhPJwHA7U1nVP7k6/PR/U/PTgFSxFN6cvuIlRcpDFhII6JURLw5FytD0tCqhl7men1feQqR1H1TPA6qB202EkHLNM=
X-Received: by 2002:a81:5454:0:b0:2d0:e7d6:ebac with SMTP id
 i81-20020a815454000000b002d0e7d6ebacmr2063610ywb.166.1645011184956; Wed, 16
 Feb 2022 03:33:04 -0800 (PST)
MIME-Version: 1.0
References: <720d0a9a42e33148fcac45cd39a727093a32bf32.1614965598.git.robin.murphy@arm.com>
 <a730070d718cb119f77c8ca1782a0d4189bfb3e7.1614965598.git.robin.murphy@arm.com>
 <0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com> <20210730143431.GB1517404@mutt>
 <8b358507-dbdf-b05b-c1da-2ec9903a2912@arm.com> <CADYN=9LE2JnE+vmv_UaeyJj_RpHcp+zZUv711VuQekLSiQ2bJA@mail.gmail.com>
 <CA+G9fYu7ctvOfdvBkDZ1nABz0TaYZ49FUKVTctn+mBTCmk9JCQ@mail.gmail.com>
 <20220214141303.3lmnassl4qibsp3y@bogus> <CA+G9fYsUX2vHjNwZ7u=JtACEyfe9SkSHtYnwJXJ1JytF9+pSAQ@mail.gmail.com>
In-Reply-To: <CA+G9fYsUX2vHjNwZ7u=JtACEyfe9SkSHtYnwJXJ1JytF9+pSAQ@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 16 Feb 2022 17:02:53 +0530
Message-ID: <CA+G9fYsz89w-4-2GggA4ELOkNJ+pD4+u0=PEBZqiSDJea-aCoA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sudeep,

On Mon, 14 Feb 2022 at 20:41, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Mon, 14 Feb 2022 at 19:43, Sudeep Holla <sudeep.holla@arm.com> wrote:
> >
> > On Mon, Feb 14, 2022 at 07:36:00PM +0530, Naresh Kamboju wrote:
> > > Hi Robin,
> > >
> > > Since we did not get a reply on this email thread.
> > > and those intermittent failures are causing a lot of noise in reports summary.
> > > We will wait one more week and stop running 64k page size testing on
> > > Juno-r2 devices.
> > >
> > > > > > diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > > > > index 8e7a66943b01..d3148730e951 100644
> > > > > > --- a/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > > > > +++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > > > > @@ -545,8 +545,7 @@ pcie_ctlr: pcie@40000000 {
> > > > > >                           <0x02000000 0x00 0x50000000 0x00 0x50000000 0x0 0x08000000>,
> > > > > >                           <0x42000000 0x40 0x00000000 0x40 0x00000000 0x1 0x00000000>;
> > > > > >                  /* Standard AXI Translation entries as programmed by EDK2 */
> > > > > > -               dma-ranges = <0x02000000 0x0 0x2c1c0000 0x0 0x2c1c0000 0x0 0x00040000>,
> > > > > > -                            <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> > > > > > +               dma-ranges = <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> > > > > >                               <0x43000000 0x8 0x00000000 0x8 0x00000000 0x2 0x00000000>;
> > > > > >                  #interrupt-cells = <1>;
> > > > > >                  interrupt-map-mask = <0 0 0 7>;
> > > > > >
> > >
> > > Reference email thread,
> > > https://lore.kernel.org/stable/0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com/
> > >
> >
> > I was about to tag the fix for this and was just reading this thread. I will
> > send the pull request soon. Sorry for the delay, it is in next for some time
> > now. Are you seeing the issue even in linux-next ?

I have tested Linux next arm64 64k page size builds on Juno-r2 and confirm that
the reported issue is fixed now.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

- Naresh Kamboju

--
Linaro LKFT
https://lkft.linaro.org
