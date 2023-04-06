Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFBF6D926D
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 11:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjDFJOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 05:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDFJOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 05:14:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63808180;
        Thu,  6 Apr 2023 02:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F225B60ABF;
        Thu,  6 Apr 2023 09:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1288CC433EF;
        Thu,  6 Apr 2023 09:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680772475;
        bh=NjIpP1xY2SNxegAx9tZnoAzlAcNwzRxkbAg7qEkA59k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ncxKjv0ibLLebSZ4GPlWy0iL06qNLIa4t0MwEhvqSrmC30yGMU7MLLjTitMdrG7B4
         AN6toqr5fQl1PqxfbXhCn3wPGaomuwv8Hj728sgrl0z6B2dAshtMlhP1aauIGTemt8
         BH2nSzN3EXQ2fVtNYthKu4GaXF+j/FRfSa4TYBO4=
Date:   Thu, 6 Apr 2023 11:14:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Ricardo =?iso-8859-1?Q?Ca=F1uelo?= 
        <ricardo.canuelo@collabora.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: meson: Fix the UART compatible strings
Message-ID: <2023040604-washtub-undivided-5763@gregkh>
References: <20211227180026.4068352-1-martin.blumenstingl@googlemail.com>
 <20211227180026.4068352-2-martin.blumenstingl@googlemail.com>
 <20230405132900.ci35xji3xbb3igar@rcn-XPS-13-9305>
 <fdffc009-47cf-e88d-5b9e-d6301f7f73f2@leemhuis.info>
 <44556911-e56e-6171-07dd-05cc0e30c732@collabora.com>
 <71816e38-f919-11a4-1ac9-71416b54b243@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71816e38-f919-11a4-1ac9-71416b54b243@leemhuis.info>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 06, 2023 at 11:06:50AM +0200, Thorsten Leemhuis wrote:
> [CCing the stable list as well as Greg and Sasha so they can correct me
> if I write something stupid]
> 
> On 06.04.23 10:27, Ricardo Cañuelo wrote:
> > 
> > On 5/4/23 19:14, Thorsten Leemhuis wrote:
> >> Wait, what? A patch (5225e1b87432 ("ARM: dts: meson: Fix the UART
> >> compatible strings")) that was merged for v5.17-rc4 and is not in the
> >> list of patches that were in 4.14.312-rc1
> >> (https://lore.kernel.org/all/20230403140351.636471867@linuxfoundation.org/
> >> ) is meant to suddenly cause this? How is this possible? Am I totally on
> >> the wrong track here and misunderstanding something, or is this a
> >> bisection that went horribly sideways?
> > 
> > I didn't say this was introduced in 4.14.312-rc1, this has been failing
> > for a long time and it was merged for 4.14.267:
> > https://lwn.net/Articles/884977/
> > 
> > Sorry I wasn't clear before.
> 
> Ahh, no worries and thx for this. But well, in that case let me get back
> to something from your report:
> 
> >>> KernelCI detected that this patch introduced a regression in
> >>> stable-rc/linux-4.14.y on a meson8b-odroidc1.
> >>> After this patch was applied the tests running on this platform don't
> >>> show any serial output.
> >>> 
> >>> This doesn't happen in other stable branches nor in mainline, but 4.14
> >>> hasn't still reached EOL and it'd be good to find a fix.
> 
> Well, the stable maintainers may correct me if I'm wrong, but as far as
> I know in that case it's the duty of the stable team (which was not even
> CCed on the report afaics) to look into this for two reasons:
> 
> * the regression does not happened in mainline (and maybe never has)
> 
> * mainline developers never signed up for maintaining their work in
> longterm kernels; quite a few nevertheless help in situation like this,
> at least for recent series and if they asked for a backport through a
> "CC: <stable@" tag – but the latter doesn't seem to be the case here
> (not totally sure, but it looks like AUTOSEL picked this up) and it's a
> quite old series.

That is all true.

So can the original report be sent to stable@vger.kernel.org and we can
take it from there?

thanks,

greg k-h
