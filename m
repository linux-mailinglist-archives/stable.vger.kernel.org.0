Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4798665C3F1
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 17:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbjACQcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 11:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbjACQcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 11:32:47 -0500
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2C72C9
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:32:44 -0800 (PST)
Date:   Tue, 03 Jan 2023 16:32:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.kalamlacki.eu;
        s=protonmail2; t=1672763562; x=1673022762;
        bh=dBm1H4jUzR4hqDPAV3Xtpxg5xorYt/CZ/xFouR9XYco=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=ruGqdATXMEpyf/bEO9/I41jGaKAyiBnht95CFHe/eVhhVGel13T01idW0LB4SGlkc
         T8freKPl475zpkMVfJB27T/4g2NLEksYrPtP/+4NT2WDCs8h5RoxRf6wQ8KfvRakE2
         S2Ddxze9VxZk3aqSZDqPXT3iAjbUZqBc25XBWx4KvFBKL/1wRxtWQ4UUrYLrhB8iLs
         DQMrxwIOtqZG01jtW5WxSmyolQAAlNch4Zt4vKSwr0opOB7I1rBMKdR8kY9litC+jE
         Xa+RJCA13mo1Q4qpQg4NaliGpGxiPJ3AO5CqHpkGLoeHGAu9AATfi4cYNkCMroGUmw
         dxbpbcrZwt5+A==
To:     Greg KH <gregkh@linuxfoundation.org>
From:   =?utf-8?Q?=C5=81ukasz_Kalam=C5=82acki?= <lukasz@pm.kalamlacki.eu>
Cc:     Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org
Subject: Re: Cannot compile 6.1.2 kernel release
Message-ID: <eeb6a5b7-01d0-54bf-5c91-48ca8bd70fc1@pm.kalamlacki.eu>
In-Reply-To: <Y7FIo0Eup6TKswTA@kroah.com>
References: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu> <20230101065337.GA20539@1wt.eu> <d3f0d0a5-a15f-9735-5f12-b1c00a474531@pm.kalamlacki.eu> <Y7FIo0Eup6TKswTA@kroah.com>
Feedback-ID: 42407704:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 1.01.2023 09:47, Greg KH wrote:
> On Sun, Jan 01, 2023 at 08:14:12AM +0000, =C5=81ukasz Kalam=C5=82acki wro=
te:
>> On 1.01.2023 07:53, Willy Tarreau wrote:
>>> On Sat, Dec 31, 2022 at 04:58:51PM +0000, Lukasz Kalamlacki wrote:
>>>> Hey,
>>>>
>>>>
>>>> Do you have an issue compiling 6.1.2 linux kernel?
>>>>
>>>> I cannot compile it.
>>> For me it compiles and boots. You'll need to share your config and erro=
r
>>> report if you want to get some help.
>>>
>>> Willy
>> I was trying to compile on Debian Bullseye where default gcc is version
>> 10, when I upgraded gcc to version 12 from sid repo i Was able to
>> compile too. On stable Debian without addition during compile
>> "segmentation fault" occurs at the compilation of cx8-i2c.c file. You
>> can try on kvm or virtualbox this compilation.
> Sounds like a gcc bug you should be notifying the gcc developers about.
>
> good luck!
>
> greg k-h
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1027456

