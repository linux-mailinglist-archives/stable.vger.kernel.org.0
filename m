Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63CC4BAEFA
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 02:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiBRBFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 20:05:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiBRBFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 20:05:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1B12BE827;
        Thu, 17 Feb 2022 17:04:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A5A61B3B;
        Fri, 18 Feb 2022 01:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB16C340E8;
        Fri, 18 Feb 2022 01:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645146290;
        bh=N4cuNEd7G76uAap18rTecTTT3WxlZgWBWv4QnkhqrMk=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=XF5uaIqPZfrfFug06WIqlPWTvjBrg94hj4TNBc/EGp6gpFUEIt+EnbRG2o2fG4oJm
         DpzBKXIcf054kQNl83/JLtOKxriO8c70rS/9eaY6ryLdXtwtYIe8HugmGOF8uvmxsZ
         EvkgRkwKsuEdr8S2dZW3mwhwtOMSnn84GbIwEbD9VykO6HlsD/7BI4IvmA+Xnw9363
         mv8y+05M6S/6pUKiI5mFG3X7MsG5Hi8i462xdQV0F9AcOUbEAxsRfQaCraYuu8/tZA
         vtK8Mu5gm3MGAnkcg2VbgvI+ZM6i2xUcxQSzyAmDQ7v7dE8dfI/uyusR9/EOqqbTas
         9U91JgPZgM9Lg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220205171849.687805-2-lis8215@gmail.com>
References: <Yf5yJKWAfxfQUVHU@kroah.com> <20220205171849.687805-1-lis8215@gmail.com> <20220205171849.687805-2-lis8215@gmail.com>
Subject: Re: [PATCH v4 1/1] clk: jz4725b: fix mmc0 clock gating
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        linux-mips@vger.kernel.org, linux-clk@vger.kernel.org,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Siarhei Volkau <lis8215@gmail.com>
To:     Paul Cercueil <paul@crapouillou.net>,
        Siarhei Volkau <lis8215@gmail.com>
Date:   Thu, 17 Feb 2022 17:04:48 -0800
User-Agent: alot/0.10
Message-Id: <20220218010450.9DB16C340E8@smtp.kernel.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Siarhei Volkau (2022-02-05 09:18:49)
> The mmc0 clock gate bit was mistakenly assigned to "i2s" clock.
> You can find that the same bit is assigned to "mmc0" too.
> It leads to mmc0 hang for a long time after any sound activity
> also it  prevented PM_SLEEP to work properly.
> I guess it was introduced by copy-paste from jz4740 driver
> where it is really controls I2S clock gate.
>=20
> Fixes: 226dfa4726eb ("clk: Add Ingenic jz4725b CGU driver")
> Signed-off-by: Siarhei Volkau <lis8215@gmail.com>
> Tested-by: Siarhei Volkau <lis8215@gmail.com>
> Reviewed-by: Paul Cercueil <paul@crapouillou.net>
> Cc: stable@vger.kernel.org
> ---

In the future please don't send patches in reply to previous versions. I
don't see in thread view that this has been sent many times.

Applied to clk-fixes
