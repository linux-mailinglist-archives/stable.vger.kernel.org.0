Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F5F5AF085
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 18:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbiIFQgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 12:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238932AbiIFQfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 12:35:13 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF952CE1A;
        Tue,  6 Sep 2022 09:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1662480678;
        bh=MkU7ECS939nWXrEZpYDk10XGNe95V/NGbaIeYfjPiAw=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=cI3fA8IyUsXgRR/0xF3ymGyngQhSTVAnGE726i0nZt6Bmini5KGfIJ328Ms+M5hl7
         bYyL8iojG9N2KwZGBVy76iDBWXpyZp0vBf74xjUHBl3rkFuvUJiy0OWhMhS6GaVhVI
         KWkSIRTVSZBiwR1BSbWgRm1N3s0ZuxYHVJFL4Zfw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.88]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N0X8u-1pGx622N6K-00wY7K; Tue, 06
 Sep 2022 18:11:18 +0200
Message-ID: <3536223b-7f9d-0360-0af1-7a506c876f4e@gmx.de>
Date:   Tue, 6 Sep 2022 18:11:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.19 000/155] 5.19.8-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:8YBriuKNc/JO90BYZrBc7V9vDgX3F7ewFZGuJSqNaMpoKs01typ
 75kkwKm0bOvorXQRD0JGF7yLjyHU36FbUiBHnqJzdGM/FwPjVYZ/jRpD877N1rXXTFCdm74
 V8XsVkhOAQlbmKM2XXvnOiHUZZ48ULLkY+X42uT0vTGz7XTJouXVvQKcX60V5fbN0u922pC
 Kd64GrExjrImRxLfqzUfA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CWQd+/8F9IE=:psnCuomS8LM7i8UAfkXaYW
 losK3Zbc3u1TgVJuis/bSvZkp2qIzm9Nrm/SnfRHPGheXwc5mdSjpOkvB1FBkJIl8gPOb6XF0
 nix2PtFq1PWYySw60OcyzEzAV4KAlg5pLr5TL5Lbg26+8zosgGFaBIHP3q7DXaR63op6Ii8sf
 27z2ppMjC2MOUgxUbG78RMlqsCeoY2/EiNNjVrgp5r9k+6mbvdXUeca9tsiukHjaZQVMI+IBh
 Dpemp5eBwS3Zxk6CU8ucszdlqBA3bS9UEjEC/U2S7AI8/hiACnR6ZMSLn9+gblGiyeN4DB3KA
 e7hIRogghzmzhPElXvfaq3FCLyeU4VYh3ZWD1aspEa/+LILWQjIg8KI56uFaVV3I788zt+GuH
 8cYd6bROmLqD/hDItz3vd/VpeAOJWe+MeMn+Awgx/eWAyTwaVpkSHae+47aWL9JeoeiInodbo
 8fhppvG1RMuRSaMn3egc3n+pt1OF7J6ZrmrFL67dedSQNC/UyyqKvIJ/yYoacKiKwiDJ5K4TX
 zZSR/Fo68p6bjVXjr8HlYrt2kMpruI9CzYsr4jYkD5GKgk/lXMiWJLG/Ml+eFqPohz2Eqio//
 bnLlQAB1VxXSe69EwDDeJ7BitZEOGTb/rH3JL2H25ijBewU4iwA6Zsn50ZyGAjL5C74wJdM61
 haQK2pfZ05sjCDbdMC65+KatZpaUwW+x8psVBnDEshkK8yLqui5rtLT/kG9ewcuTWEUudsmfT
 M5SJIOtE843/A8HWBna5UgshEEjQMT6kw/NEbobpJQ7rXOkCQFOCt/CdnAhRInwA4Oyl35i/o
 GEg+RVCKBFswXPMsFYinpKclVJ7gvvJrIopqHIGYBXbKQ6y2O3uYj3k0uC4bvZwqbBj2NXsFG
 gPrGJxWctJ/UvkuaiSg6IATpfH99E3o6+WKL8rANUobxXzTVoLeTz+LN/BTFAzfmndBs2n7wf
 5kjwbLFMoYUg1pNa0ygk9HeK0M7wknOukA9pU7rXIX5+8exp1Y3N2BFL/2/1GC9RC4YCqBFFR
 vXdTafFaWcfdIYp6V1WkvyH5TSTDGTuGfZcpDgAIMvUwl2kb3oTexl7RmgHbptZwo6XJgDvHC
 VCBUzdpbhWmgSNZ0jQzF/2ark2NyKWtPKMNaxvlaSa90Dppw138hMHxTOwXFHiifWIWpKaXQ6
 f+W2E=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.19.8-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

