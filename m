Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680915B57DB
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 12:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiILKHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 06:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiILKHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 06:07:12 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD031A83F
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 03:07:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 48CFA9C0B3D;
        Mon, 12 Sep 2022 06:07:09 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 7HNV0LUGL52m; Mon, 12 Sep 2022 06:07:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id B99019C0B54;
        Mon, 12 Sep 2022 06:07:08 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com B99019C0B54
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1662977228; bh=7+PQXFa+jB0SELVEkY4HCTGYBD9F0G+TtFgUltZtnro=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=X7KPXzdDCFs3rkJwJh1NxN2xD52cjNgQy2mmSyoheBnojyC9noj8TXVqpglj0uPyM
         d0Rfq8M2FT4hOQbv0KCOLHuo+KzT3o2Cii17Vyn63ofZkRCEQ23smF3cOO7NkzZNQw
         em12jkjeDbCziUTaQF3fxr31aGM0BNMXuIHe8AdO688k3e7Wpif1wGmTc36FYkinDO
         RvZpsByCjVpVG142nQKq624dbYnMEt7sPIQb5fq3pmiyZx90Z9vQp6A9nA9MPY/IHO
         GevzsDNP59JlO8EcEuH9ilhwsHaOYGniKl/KIeUnS89XAXTH/aIJNujr17MUMpQFPh
         64wX9GR2K2Yhw==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NXUxuGPM1k8A; Mon, 12 Sep 2022 06:07:08 -0400 (EDT)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 988D09C0B3D;
        Mon, 12 Sep 2022 06:07:08 -0400 (EDT)
Date:   Mon, 12 Sep 2022 06:07:08 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
Message-ID: <1223536756.162378.1662977228581.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <Yxohrg//utRPoJYc@kroah.com>
References: <20220907104558.256807-1-enguerrand.de-ribaucourt@savoirfairelinux.com> <20220907104558.256807-3-enguerrand.de-ribaucourt@savoirfairelinux.com> <Yxohrg//utRPoJYc@kroah.com>
Subject: Re: [PATCH v3 2/2] net: dp83822: disable rx error interrupt
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4372 (ZimbraWebClient - FF104 (Linux)/8.8.15_GA_4372)
Thread-Topic: dp83822: disable rx error interrupt
Thread-Index: k1Z6aLzBthNiyT+dg9thOyrXJHbuPQ==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: "Greg KH" <gregkh@linuxfoundation.org>
> To: "Enguerrand de Ribaucourt" <enguerrand.de-ribaucourt@savoirfairelinux.com>
> Cc: stable@vger.kernel.org, "Andrew Lunn" <andrew@lunn.ch>, "Jakub Kicinski" <kuba@kernel.org>
> Sent: Thursday, September 8, 2022 7:09:02 PM
> Subject: Re: [PATCH v3 2/2] net: dp83822: disable rx error interrupt

> On Wed, Sep 07, 2022 at 12:45:59PM +0200, Enguerrand de Ribaucourt wrote:
> > Some RX errors, notably when disconnecting the cable, increase the RCSR
> > register. Once half full (0x7fff), an interrupt flood is generated. I
> > measured ~3k/s interrupts even after the RX errors transfer was
> > stopped.

> > Since we don't read and clear the RCSR register, we should disable this
> > interrupt.

> > Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
>> Signed-off-by: Enguerrand de Ribaucourt
> > <enguerrand.de-ribaucourt@savoirfairelinux.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > [backport of 5.10 commit 0e597e2affb90d6ea48df6890d882924acf71e19]
> > ---
> > drivers/net/phy/dp83822.c | 3 +--
> > 1 file changed, 1 insertion(+), 2 deletions(-)

> Does not apply to 5.4.y or 4.19.y :(

I could apply the patch with no problems on those versions. I also could cherry-pick
the commit on the branch queue/5.4 from stable/linux-stable-rc.git without conflicts.

I can't reproduce the issue you seem to be facing when applying those patches. Would you
mind helping me finding what's wrong with the patch on those branches?

Thanks,

Enguerrand de Ribaucourt
