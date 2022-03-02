Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A6B4CA135
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 10:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbiCBJs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 04:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240679AbiCBJs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 04:48:57 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90EB517F1
        for <stable@vger.kernel.org>; Wed,  2 Mar 2022 01:48:11 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id q4so786401qki.11
        for <stable@vger.kernel.org>; Wed, 02 Mar 2022 01:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oVymzacBmHlfSEBN0NUcViscc1BlJREjJA6+b6RGOmg=;
        b=lH5DolKu4GucUcGAYB8qk59s8XtSvR869JERp/4TjB7WskRbn5ZgLVt6kXK9xJ18O3
         cxlR3BVT8A0PcwMoxW5zI1OUeYs8deDoQezkZvSG6hsZFbxh/9jyJdonfcaFRaYroNqb
         jyGDdRGHljrPPv3Kb67e9TBpsqY2JyqSZi4kmcEdulDggqhYftClcW0RO6GzqLzP+5sp
         nK5cVlr6ZpafHTu9tAdmFUn/s4RSkonPcceX+IUy2vPkCxfRQ6TNv+LxeebgcoIPHqer
         /X5B8kIy5WDB9E4GYnf+IrNVvb8ElBA7eS3y4efZxrFbwRMVm379kkxiorwNVy1J05jQ
         HyhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oVymzacBmHlfSEBN0NUcViscc1BlJREjJA6+b6RGOmg=;
        b=AJoH5mu9vWob0qcKvwZvjeQffgQX2Pp2ImSjIGPnUk33/9dZmr1i01vpcOU5ka1/gh
         +mGlTVXNIpqBlWqxYA4MEA7fwfX3FL7B7+wRaNZW9CfFyVAcwGPT2lQYJi/gtBRTEJ7K
         q+RgYapdHI7L6261Epd0OeyujofR7/hYHTJ7pFiOAhgJ1AgMORB/fnfgbYq3akyhsKHF
         UiyTANrvmBI+Zeg/2CaLeREWBVZ2E6veasMaHXD+RiPR3uAV4oBu0++yaU033DBj0vOh
         yIqbUHPpp5DrdNdTGoKoJQ5O8N9N0moQfSjGBoyNDiQpGk/0CxkihwMPNpUGuTBkSzPi
         CehQ==
X-Gm-Message-State: AOAM5302c5l+toYDSi4IKZoPpXwQzrhPqObflO4fZNpqdVVLNxAvzSGG
        Dk6xw9DGq7KDMZAPBfUxFCXUEhjCPwciSggBWa4=
X-Google-Smtp-Source: ABdhPJx/pEUn1i67pNsrNqnYiXzLF6TghYUJj3yJJfruidml1Sm70A+Vs+O5+EsKSENApxxvcVOcgVf5xIWaPhzW/4s=
X-Received: by 2002:a05:620a:22f3:b0:62c:ed1c:d3d3 with SMTP id
 p19-20020a05620a22f300b0062ced1cd3d3mr15620770qki.450.1646214490706; Wed, 02
 Mar 2022 01:48:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ad4:5443:0:0:0:0:0 with HTTP; Wed, 2 Mar 2022 01:48:10 -0800 (PST)
From:   Anna Zakharchenko <fpar.org@gmail.com>
Date:   Wed, 2 Mar 2022 10:48:10 +0100
Message-ID: <CALr0R0rFZSQuc5OuN6YMBNKAozNM0O6M3iBTdQVjcqLDUjqNqw@mail.gmail.com>
Subject: Re: Help me in Ukraine
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.8 required=5.0 tests=ADVANCE_FEE_4_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,


I am a Russian widow trapped in Ukraine's Donbass region amid Vladimir
Putin's senseless conflict. During the 2014 battle in the Donbass, I
lost my husband, a prominent Ukrainian businessman, who died without
having children with me. I am currently in an underground bunker in
Donetsk Oblast, a separatist war zone recognized by Russian President
Vladimir Putin. I urgently request your assistance in moving my family
trust fund worth =C2=A33,500,000.00 from the UK to your country to prevent
European Union sanctions from seizing my money because I am a Russian
citizen.

Please help me save and protect this money. You will receive 30% of
the total money as a reward for your efforts, while you must keep 70%
for me until the conflict is over. For more information, you can
contact me directly at (anna@sc2000.net).


Cordially
Anna Zakharchenko
My email address is: anna@sc2000.net
