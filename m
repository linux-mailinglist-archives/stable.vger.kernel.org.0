Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA5B5B57BB
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 12:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiILKCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 06:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiILKCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 06:02:19 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA272612C
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 03:02:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id DAD909C03F9;
        Mon, 12 Sep 2022 06:02:16 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id NEPtLf1xOc3I; Mon, 12 Sep 2022 06:02:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 63A6E9C0AD9;
        Mon, 12 Sep 2022 06:02:16 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 63A6E9C0AD9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1662976936; bh=364DNPurQ/EA5DfgOEc31Ds9GJlFBWfQwYS8i3qNDYk=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=p4Th2WlXMnIuDuxUTVvqsWmZyttRffmEvFgn4UTmbHfLHmmj92bfq3vceh9pRyaRY
         2bjiZJ4+k63mS3SzyDX6MrvlcorgtjqISy9Y+75eq18dBxeUxMrhLO9EXHTMqTBTQp
         k69INhihrVAWRsqf8OZQooD8/ZD52/kWPEfc3Z7qLd7Vq16izFBFxop8QNzqm2CeHK
         H4i2hjVwx5caKp88d1BBHa6sQudXc/Ii9r9EPZXMW2Dp05j5LVLyjINlJXuT0lzIL2
         4qmd0AhE+/CKOBzKF0j4IhaawaIpBaH+Qoy9gifqXFAJQOcbNj0D/Y5VOVxemTV4Kk
         NSrg3ZPNl1aDA==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6z3ItevosvkA; Mon, 12 Sep 2022 06:02:16 -0400 (EDT)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 4017E9C03F9;
        Mon, 12 Sep 2022 06:02:16 -0400 (EDT)
Date:   Mon, 12 Sep 2022 06:02:16 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Message-ID: <985933791.162319.1662976936214.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <YxohY8Loyg3SBuld@kroah.com>
References: <20220907104558.256807-1-enguerrand.de-ribaucourt@savoirfairelinux.com> <YxohY8Loyg3SBuld@kroah.com>
Subject: Re: [PATCH v3 0/2] net: dp83822: backport fix interrupt floods
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.15_GA_4372 (ZimbraWebClient - FF104 (Linux)/8.8.15_GA_4372)
Thread-Topic: dp83822: backport fix interrupt floods
Thread-Index: nMG1BhrC8DFHJzykdDxNSy9DVeJ+PA==
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
> Cc: stable@vger.kernel.org, "Andrew Lunn" <andrew@lunn.ch>
> Sent: Thursday, September 8, 2022 7:07:47 PM
> Subject: Re: [PATCH v3 0/2] net: dp83822: backport fix interrupt floods

> On Wed, Sep 07, 2022 at 12:45:57PM +0200, Enguerrand de Ribaucourt wrote:
> > This series backports the following fixes from 5.10 to 5.4.
> > This backport should also apply to 4.19.

> > A git conflict was solved involving DP83822_ANEG_COMPLETE_INT_EN which was moved
> > to a conditional in 5.10.

> > Original commit IDs:
>> c96614eeab663646f57f67aa591e015abd8bd0ba net: dp83822: disable false carrier
> > interrupt
>> 0e597e2affb90d6ea48df6890d882924acf71e19 net: dp83822: disable rx error
> > interrupt



> These are alread in 5.10.y, they showed up in 5.10.129. Should I just
> take these into 5.4.y and 4.19.y instead?

> thanks,

> greg k-h

Indeed, I would like these changes to be included in 5.4.y and 4.19.y as I use 5.4.y.

Thank you for processing these patches.

Enguerrand de Ribaucourt
