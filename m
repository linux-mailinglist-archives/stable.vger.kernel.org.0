Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8304F5438
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 06:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344858AbiDFEpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 00:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360966AbiDFDoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 23:44:05 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71B816B152;
        Tue,  5 Apr 2022 17:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649203919;
        bh=lQZC9KF3fkpp3qkV+BLTCo7NkUkmtr0bB09V3SZnVCY=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=cnGDvje0keNcFijjyhXnLHAG8r/nL0zsJTCxsXIMcILiclPaf+JAm9c6frMQJ9q+I
         GMTutl8pRgHhaXeeXnxJvVMdm5uUxFzE5MBIv+M6A4Q4/ukFPBgl5wdwbeLfWFFHvI
         xNgj/ZpADI9aCTmc02Qe10uXActUd0m8OG5tweLY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.239]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N49lJ-1o2OOE2uGn-0105Zq; Wed, 06
 Apr 2022 02:11:59 +0200
Message-ID: <ca184e4d-1691-f44a-6054-b7cae52f5077@gmx.de>
Date:   Wed, 6 Apr 2022 02:11:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.17 0000/1126] 5.17.2-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:cYu9JdORc1SmR6BiCGPQiPskdZm+eavF6AOJyRHFXDBuita0uCy
 bHTYWxbw+Z/KjUN+XDezDDimJupB61QO/covhoz8VMbH7n3PPHf0hbbqitmkmoIvsflcHAR
 uk8uYDYjgRAJ/CXul5bKLbayP+pvPjYkDNGHb22DRTP721+5IaMRECB82MbiQzjZ+/f8XnP
 sWWZIj7ulfSdcy806baRQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qnKmeB+oY6I=:MZ26Fl6Oiw4udMXe9NQlPC
 lM1BKFUII6Eh9f53H1c7laOrQcXDySDgkVqBF1epo/y3JuEPVQRuUMpbyZ4mnHbwJVAPtsIyR
 mrlTUNswGPGeBilTlDvuW/ggAOCwFToYCzWq1TbdQTjhZ1i6HpMSlF15sYutchgBON/MNx3Qi
 MjtP8MvH16tj9a3yMoKZe10gnsbNlyRw8J2qe3Z/hfB+ynBnKWbqyaOpUOGcBCGrChbYNdCd5
 nXHLbvVtK3+M77c1SIFUUQiuQjs2Ons5vucAD5gWheZ3PDMQU02bXPBjCg1wQkLaEjbujxJ9z
 peWVPz9n8PrwIf05DAl5Rg8TVSgfJcb92TtMoiXJH8LH2Rp/evPFBEas+G4W8neuZoVUjglsr
 LH31gUSpFIdQVOFzEjhyqyaCns9ysMe5mrnkzXPQ8hWJyzkO2PIMCV3rGhMYX+KgpqioDsPNr
 oIbJbQU4bKNd2v+CZtd3pwUqQpXSlMHBd9KhNsBz4aJjzN9GKtOiJOzbD0DpWMJUXKucBjlp6
 Hhsno3FhFtv8RLma7tfbq2JTkcQXNIfBYD9a8oGFkbDKWB+8h4s3YSLDq4tLSnFzUadPEdJsH
 1BiHMu3Ll6yK71SNF7+xUsiMl3XzRyz5ACwBlMR5usA2Q2IgZapnsI7XcnyQw5BNeYpY2T8uQ
 5kUh68CKf8L0L8uggNGMWXklu+2n0JM1FIPXLqjv8bgT/Lt0f3EvXB8B0Zc7fdPI+lsJxJjrH
 25METSOyJpU4FacHYroEzzPOaez794jW53z2pq4MhEhp4FNYBy2i72tY/7thUKxannniM6h/m
 GLTqW4zfdZxGGeDgC944r6YTcH8Nv6ynH66P8MIkVeLaq4JC1suv8p3RF16eqKWd+4wP0ZI7/
 soVKmCxfZjaIzsV3r/ojHW6maz5puLgBNTwdeVnkYQdZ/IacQjUsdJlvswmn2q+n7Tpt73cp8
 C8ZC6Ex9GEZP1mKvPQ/axtPrHetWwDsWO2592BHu4ZaqJJX8/A3/rChASd2YoyUcEScTvXe7Z
 kJ7sCxJlrvzYd9CLHXr775XIkqw+gkEx1UjfCoOI6n4H48pMwL65JeTtegkzVxJjSPDxuljcY
 IGd7+NCbSEsWBU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_A1,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.17.2-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 36 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


Ronald

