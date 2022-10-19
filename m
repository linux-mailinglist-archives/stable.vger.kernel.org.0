Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BB5604E61
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 19:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJSRP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 13:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiJSRPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 13:15:52 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BE4181972;
        Wed, 19 Oct 2022 10:15:47 -0700 (PDT)
Received: from p508fdae2.dip0.t-ipconnect.de ([80.143.218.226] helo=phil.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1olCfL-0008VN-NU; Wed, 19 Oct 2022 19:15:39 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Quentin Schulz <foss+kernel@0leil.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        quentin.schulz@theobroma-systems.com
Subject: Re: [PATCH] arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency
Date:   Wed, 19 Oct 2022 19:15:38 +0200
Message-ID: <8130714.T7Z3S40VBb@phil>
In-Reply-To: <52349f5d-661f-3e38-9745-01a84ddf820f@theobroma-systems.com>
References: <20221019-upstream-puma-sd-40mhz-v1-0-754a76421518@theobroma-systems.com> <Y1AQHqm+cOmrrveJ@kroah.com> <52349f5d-661f-3e38-9745-01a84ddf820f@theobroma-systems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Quentin,

Am Mittwoch, 19. Oktober 2022, 17:59:54 CEST schrieb quentin.schulz@theobroma-systems.com:
> Hi Greg,
> 
> On 10/19/22 4:56 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Oct 19, 2022 at 04:27:27PM +0200, Quentin Schulz wrote:
> > > From: Quentin Schulz <quentin.schulz@theobroma-systems.com>
> > >
> > > From: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
> > 
> > You can not have 2 authors :(
> > 
> 
> That's a bug in b4 and my patch submission/mail sending workflow, I'll sort something out with the b4 community and send a new version of the patch soon. Thanks for the heads up!

I guess, Jakob is the original author?
If so, I can simply drop your authorship.


Heiko

> 
> [...]
> 
> > It has to be accepted before you are done :)
> > 
> 
> A "small" detail :)
> 
> Cheers,
> Quentin
> 




