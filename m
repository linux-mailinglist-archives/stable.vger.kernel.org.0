Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B5C5B81C4
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 09:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiINHHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 03:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiINHHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 03:07:06 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A2995A8BF
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 00:07:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 83C319C0B43;
        Wed, 14 Sep 2022 03:07:01 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ft28LJwfk2qL; Wed, 14 Sep 2022 03:07:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id E573E9C0B63;
        Wed, 14 Sep 2022 03:07:00 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com E573E9C0B63
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1663139221; bh=uK6OKvZ/Tmz6P3WHMVsWK4CHFdSfw81Fo+QlKnC8mog=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=I1OGPwkqibmWJanOPiL4xhTVzoW1AqAv8LkFyT3505a/OT0zjLyTzgMzkQWtYVCIO
         AC2CdU2LrHexj2Z0t3L+B8p43EEwmOfMYhuZ/O+xXZ5BiGycRwzEXsGP/hAPYHcwxm
         LM+YMQGzmln/HMPRpv75YclAO1s72qOymvW1W502baHtZj33Ort0BvvxQPvXBl8QIb
         l7GkmMd3xSSjaToTybeGoqeNqSzu+zrspQo5MOKgb30y2LNScJ3X49bVAKYc65xtX8
         XqC3GkfxUWdEqpLIpj8lNKuljB0pPiBIGymb/cHFPcKrCurZ9OI9eMwHqjw1mKH4o8
         a6uKguIeesLWw==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id uLch0vF-3zhL; Wed, 14 Sep 2022 03:07:00 -0400 (EDT)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id C13A99C0B43;
        Wed, 14 Sep 2022 03:07:00 -0400 (EDT)
Date:   Wed, 14 Sep 2022 03:07:00 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>
Message-ID: <1021996164.282624.1663139220592.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <YyBp0mhD2cWibBB9@kroah.com>
References: <1223536756.162378.1662977228581.JavaMail.zimbra@savoirfairelinux.com> <20220913081747.39198-1-enguerrand.de-ribaucourt@savoirfairelinux.com> <YyBp0mhD2cWibBB9@kroah.com>
Subject: Re: [PATCH v3] net: dp83822: disable rx error interrupt
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4372 (ZimbraWebClient - FF104 (Linux)/8.8.15_GA_4372)
Thread-Topic: dp83822: disable rx error interrupt
Thread-Index: rSXRNcKPFaU/c4BJ5tbkZzuU0reVxg==
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
> Cc: "stable" <stable@vger.kernel.org>, "Andrew Lunn" <andrew@lunn.ch>, "Jakub Kicinski" <kuba@kernel.org>
> Sent: Tuesday, September 13, 2022 1:30:26 PM
> Subject: Re: [PATCH v3] net: dp83822: disable rx error interrupt

> On Tue, Sep 13, 2022 at 10:17:48AM +0200, Enguerrand de Ribaucourt wrote:
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

> Backport to what? This is already in 5.10, where do you want this
> commit applied to?

> thanks,

> greg k-h

Hi,

I would like this commit to be applied to 5.4. It should also apply to 4.19.

Thanks,
Enguerrand de Ribaucourt
