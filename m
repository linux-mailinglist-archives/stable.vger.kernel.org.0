Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA386B3D22
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjCJLCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjCJLB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:01:59 -0500
X-Greylist: delayed 587 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Mar 2023 03:01:58 PST
Received: from xry111.site (xry111.site [89.208.246.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429FF19F1B;
        Fri, 10 Mar 2023 03:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
        s=default; t=1678445528;
        bh=VuZja3sXqQlhVtzikzREMtzpXKysw1/VyiPZM/3sA1U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RnVuMsNPGk54+ehzz3TjuOP2MjlhW9gfRyqGmb6+gwcR5zS8IGlCHdpa4Hw+Bzvj/
         wWWRMKbnyMad3ciso3KSqPt4GOmskIb33h/xFA3/4x3n3dyVl3dYTP03Qi1HWeDzBB
         Tie7ajyj+nv1jpxBcbDelQKsjCS9c6BNjXgwgf5g=
Received: from [192.168.124.9] (unknown [113.140.11.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
        (Client did not present a certificate)
        (Authenticated sender: xry111@xry111.site)
        by xry111.site (Postfix) with ESMTPSA id 9CC2165AB3;
        Fri, 10 Mar 2023 05:52:06 -0500 (EST)
Message-ID: <2b4f2693c83d02bcfd088d19e8952c1c725ecad0.camel@xry111.site>
Subject: Re: Ping: [PATCH] PCI: kirin: Select REGMAP_MMIO for PCIE_KIRIN
From:   Xi Ruoyao <xry111@xry111.site>
To:     Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof =?gb2312?Q?Wilczy=A8=BDski?= <kw@linux.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Xiaowei Song <songxiaowei@huawei.com>, stable@vger.kernel.org
Date:   Fri, 10 Mar 2023 18:51:53 +0800
In-Reply-To: <ZAsKThAQPbGVUig8@lpieralisi>
References: <20230228043423.19335-1-xry111@xry111.site>
         <8996e9ba32cbdc24b828c9a37793b39f17eb33a8.camel@xry111.site>
         <ZAsKThAQPbGVUig8@lpieralisi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2023-03-10 at 11:45 +0100, Lorenzo Pieralisi wrote:
> On Tue, Mar 07, 2023 at 01:42:01PM +0800, Xi Ruoyao wrote:
> > Gentle ping.
> >=20
> > On Tue, 2023-02-28 at 12:34 +0800, Xi Ruoyao wrote:
> > > pcie-kirin.c invokes devm_regmap_init_mmio, so it's necessary to
> > > select
> > > REGMAP_MMIO or vmlinux fails to link with "undefined reference to
> > > `__devm_regmap_init_mmio_clk`.
> > >=20
> > > Cc: stable@vger.kernel.org=C2=A0# at least for 6.1 and 6.2
>=20
> I merged this (with a rewritten commit log, Fixes tag and
> CC stable - please have a look and check how this has to
> be written for future submissions):
>=20
> https://lore.kernel.org/linux-pci/167844411812.1209684.120173868209852416=
41.b4-ty@kernel.org
>=20
> This patch is dropped.

Oh, didn't noticed someone has already done this in 2022 :).

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University
