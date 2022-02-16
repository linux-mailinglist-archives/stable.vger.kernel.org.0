Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0314B8B7E
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 15:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiBPOdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 09:33:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbiBPOdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 09:33:23 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF8AC139CFE;
        Wed, 16 Feb 2022 06:32:50 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D66B106F;
        Wed, 16 Feb 2022 06:32:50 -0800 (PST)
Received: from bogus (unknown [10.57.3.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 341D43F718;
        Wed, 16 Feb 2022 06:32:47 -0800 (PST)
Date:   Wed, 16 Feb 2022 14:31:58 +0000
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
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
Subject: Re: [PATCH 2/2] arm64: dts: juno: Enable more SMMUs
Message-ID: <20220216143158.izrmexbqem3l5kz7@bogus>
References: <720d0a9a42e33148fcac45cd39a727093a32bf32.1614965598.git.robin.murphy@arm.com>
 <a730070d718cb119f77c8ca1782a0d4189bfb3e7.1614965598.git.robin.murphy@arm.com>
 <0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com>
 <20210730143431.GB1517404@mutt>
 <8b358507-dbdf-b05b-c1da-2ec9903a2912@arm.com>
 <CADYN=9LE2JnE+vmv_UaeyJj_RpHcp+zZUv711VuQekLSiQ2bJA@mail.gmail.com>
 <CA+G9fYu7ctvOfdvBkDZ1nABz0TaYZ49FUKVTctn+mBTCmk9JCQ@mail.gmail.com>
 <20220214141303.3lmnassl4qibsp3y@bogus>
 <CA+G9fYsUX2vHjNwZ7u=JtACEyfe9SkSHtYnwJXJ1JytF9+pSAQ@mail.gmail.com>
 <CA+G9fYsz89w-4-2GggA4ELOkNJ+pD4+u0=PEBZqiSDJea-aCoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsz89w-4-2GggA4ELOkNJ+pD4+u0=PEBZqiSDJea-aCoA@mail.gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 05:02:53PM +0530, Naresh Kamboju wrote:
> Hi Sudeep,
> 
> On Mon, 14 Feb 2022 at 20:41, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Mon, 14 Feb 2022 at 19:43, Sudeep Holla <sudeep.holla@arm.com> wrote:
> > >
> > > On Mon, Feb 14, 2022 at 07:36:00PM +0530, Naresh Kamboju wrote:
> > > > Hi Robin,
> > > >
> > > > Since we did not get a reply on this email thread.
> > > > and those intermittent failures are causing a lot of noise in reports summary.
> > > > We will wait one more week and stop running 64k page size testing on
> > > > Juno-r2 devices.
> > > >
> > > > > > > diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > > > > > index 8e7a66943b01..d3148730e951 100644
> > > > > > > --- a/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > > > > > +++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
> > > > > > > @@ -545,8 +545,7 @@ pcie_ctlr: pcie@40000000 {
> > > > > > >                           <0x02000000 0x00 0x50000000 0x00 0x50000000 0x0 0x08000000>,
> > > > > > >                           <0x42000000 0x40 0x00000000 0x40 0x00000000 0x1 0x00000000>;
> > > > > > >                  /* Standard AXI Translation entries as programmed by EDK2 */
> > > > > > > -               dma-ranges = <0x02000000 0x0 0x2c1c0000 0x0 0x2c1c0000 0x0 0x00040000>,
> > > > > > > -                            <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> > > > > > > +               dma-ranges = <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> > > > > > >                               <0x43000000 0x8 0x00000000 0x8 0x00000000 0x2 0x00000000>;
> > > > > > >                  #interrupt-cells = <1>;
> > > > > > >                  interrupt-map-mask = <0 0 0 7>;
> > > > > > >
> > > >
> > > > Reference email thread,
> > > > https://lore.kernel.org/stable/0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com/
> > > >
> > >
> > > I was about to tag the fix for this and was just reading this thread. I will
> > > send the pull request soon. Sorry for the delay, it is in next for some time
> > > now. Are you seeing the issue even in linux-next ?
> 
> I have tested Linux next arm64 64k page size builds on Juno-r2 and confirm that
> the reported issue is fixed now.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing. I have already sent the pull request to Arnd yesterday.

-- 
Regards,
Sudeep
