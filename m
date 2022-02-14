Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A665A4B537A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 15:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiBNOju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 09:39:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237294AbiBNOjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 09:39:49 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697FC22F;
        Mon, 14 Feb 2022 06:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1644849579;
        bh=WvAGs/FPg0GX1ZMr20QUj4nXtDOLpWLLU1XK5s3f9gU=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=e66pILgzA0BH8C3+Ykfq12zo7PyDR9BqMs0AS0evAAb8pe04Tbwx9YASTUxEC7AZM
         MKBPSvGBn3ysL95oaXmPnHN2aUhcfM+pKpt4v5ivHPaYiY+eqSLR8pRUhw2UErrd75
         ZN4C9nOHiAOJ0HaF/0ocU9sRw6+6deOEGRHVX7DY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.85]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MQv8x-1ngOjM2utr-00O0Mi; Mon, 14
 Feb 2022 15:39:39 +0100
Message-ID: <5f7c2cb2-c26f-212f-281e-86c0451541b3@gmx.de>
Date:   Mon, 14 Feb 2022 15:39:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:YLKBFPz9xPIld0a745NtClgH+L2vwysAF5zZjIQw6TXWZHC+ufh
 1C0RJBZN0aZT/evybnqomVJsq53nmchCZwO33Biy/+ur43ShPWsbpsoiV7y8IP8yBDFxOZy
 l6fzasN9/fWY6VujcG77a3ay+Xou5Q1BHiOwohihU0MbFGO7sttuC5nJiANDnzyiW4ZrMC+
 XQI+NLQ6iNI/v1iBVdZgg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WL3ClNEqKSc=:43MTy7CJD08yhS1/c2mGCf
 19YHC8TUNfIGZyYiRp0ByEL9JIRWtN5TcZCrAXqmNQ2x7pvzpPXFsBS+MqbtvcPfSAGZeBuV6
 q7ja5ZRI0G/rxrtulCTY7kjH+Ux6yvvFclRF7qVxCbsKX6OUxkwoshrgr9K0XMXZ2XQYkz7ta
 19wO9LkUfGdgA1451FoBoHT8pCuig93vsaqOt13BUmMuyqhclSwdEpiWaWRF1Ej5LoN84A4hJ
 AEd6O1V0dgO4aduhnzeJDJlfMIrsDS+VR5P4oRsExRmMvqS14mSNpeeOcXN8g7maeBHgsJFm/
 CYYT4+g9DKNB2gXyn0TOSBwMG24h8h3pJRJacKFvpVHXav1CutA1SgT8yU7GeqXMnU/RSka2b
 LH4LE89+MONkvEr79+R0/RLPSEi9rkETgo/pZhRYc3wz2YM3KO3WjQr3bSW8V3Sg5KlnXwpAq
 lopvo4hznQN98lFMqF9Co1tZn1heY1+CQ60Rj07TxKNHuWO+qtlrOVuxsCVMS7ws0yfr8GntJ
 Wvm5PlH1r/J2pFCxT7YuREjLODU7yXTziU7SK20bl5UgeDTaIz+Yy4CxjqfAszetInAn7JZ9m
 +g/BgpkER0XqCGGEQ/TrYU7wx1HLK+3lSI2fjXhQhtqhkOLnsqz1tIXNM/boyN3R57WWniww2
 idcNieG6KXNbmgFy3b2sytrzKf+0uh65JcTxgQogGci9gP4P7JwyBA8c337Z9sagg/81VhiOb
 MLvHq+bK9JjdMNo+eNDfG9SV5tH9/L65pxp0R5d7PedpoH4jaMpl2jVYUcnLR8sjWZ1S/g86S
 0/V2JSb1v+8QBWsPxvx3G3y9DkQmRZ9DZkANO4bRE5fz9nbYWSj8Ssw3SwpNpD8o+DhF7FSla
 io3BjnS3EdWoF5U/U/1dnLOq2kTioDbcCYoJGc4L2lxIyMhDLfLOz3AVOuHECuY9RMdpf183e
 ZFxUtyfn4m9TOQyDfmnxoXGJtemns5d4rZwYajpE12ufNbOMZFfEOHuHBxW5tDpdODO/geZrr
 GQ82Qji0SMMiWmHMYL57TduGbz0Fn88vPMp3R57tGOLhqhGwsnLhAcSY6VnIJr6tnjH9HLQU5
 09jbXu9wn14qQ4=
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_A1,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.10-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

regards
Ronald

