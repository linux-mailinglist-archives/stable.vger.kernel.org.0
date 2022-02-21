Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628094BEB02
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 20:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiBUSf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 13:35:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiBUSdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 13:33:09 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392BDE02B;
        Mon, 21 Feb 2022 10:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1645468257;
        bh=9oLAbbGjnkhE+O7ErHatMVYIIWAdsq3V+o20wSEQBt4=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=BexuOj74f2v4wZFnabLleOGv08UiYiSi3UxBXFLTCGa/L9+i3ieRmsP4lxCWkpEBx
         R5x72t5SFD+lNUehhYG2UhPUUgasDliAFLh7Omg/Q4IJNoU4iS+qkRzsrv4mh5ITMj
         p2WtHexqGEW7mMxNQEiiIXkYpjZ82iypNe4HLP+4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.58]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M7b6b-1nKoxQ2PiX-0080GI; Mon, 21
 Feb 2022 19:30:57 +0100
Message-ID: <9c27e785-df03-81bd-d6e2-59023d6dc002@gmx.de>
Date:   Mon, 21 Feb 2022 19:30:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:+rf/SCweiLbhPGKIfZhXYoPTfMzZLt/J9qzCn202x/iY0KdAQZ5
 OV9so7P21YjMj9AOl5qMnmAGerzTu8YoEtBUE0Pg15KgOhvIRvmb7gzZAQ+v8eeMvl3Ymwj
 8p6HrVS0EZR+n58kYsP8sQdq9dUeKL3M3dGPPpxFhRt7v9AcqSt0pWJkYyKRy2cVib2Lxlr
 a+qX0VRBwXnNWEubr6SFg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Croh49uymH0=:Xz4mwtSLnNKOcAa8uGVSe+
 MOFGfrIOu62qyAf9sgoU3+/8MIhQSeHPGxpQDBwnpKBq5ZxgxyOYcA7g7X/oylgds1ojkOYmO
 +h6EAcNxF1pU8E/dHZ/tr9ak9N1UAH6lQh2QMClYj6KPzbSawfIpDqKCJ1+ND6RgYp9sgir9R
 nJ94UIInRtaH5B/WR+N6dXpMRA40HvkqRsrPJifRxQOBzpsDgxVH9tB3DQWsV9dM30ms6BMnO
 rO8gCTcXuy2lynU92eXeNH39UgFXr+KsRm9IgTuk+SxKJVYLaEOgYvaXt/yR5A+9EFxq2P2VC
 FLtlLvf43uE+3geFuAL5ApYDGyR31U1s4D5XewcWwMfsLZyGH90YODUEQo4bDi7i0DqnVRIH7
 HOoDRtEETXFj/IMGDWSQBzR0DvCY4o42wx1g39YA66Dk4U03SiQR8bXszIfepvRjC9Zq1sT25
 RUshs8aM/sT0gQx0PHQ/6ccTIEuqzQ5Gbklyqk1LBqGTyNVvz9fK8/gzU7U3s5S8C0l33KXKv
 z5U99H0KdgD/kcK7n4+bXBkHxek+PTTuWU7OXlZUJ2kbOsWvHp60H2NGRBq0kTn55ZEDP2SZ2
 1WtUT0HnHaOyDWnVGVp4J69JLV2+WAGxC8lUSlprSV3lT9/626B3S64VxJfh78utxLCwwL7iH
 lJFQuPUPH/cD9GPafUZXa99XNpdOJBYBheIsHdGoe5yrITGfJpQeDhI3r84rwlCxvT7HaB/Z3
 VSfeWF2ZeXZcY6LyfQ6WjBzZin7nabVtW9tyJNFLvLPChVBuYRu+EfE2TU7kJ9vzegUZ4DyIu
 21B964rQinuxX623/WLz+umEHMrO+ZCTn+gwthbhzFma/HBY6nUpDWQXiyrDYn+k2Y3Hx7mgO
 IzXIz2m2phVzalR3Iti11OwsN7jwMyXWJeVRXMe8EioLwKfTOenK2dQwIe4RQkn5VOjGntBaj
 pcIhuc9Pv8tMlQKlhwnrzm6+OhExygCB+n4H47g1QQsRZO0Coo9Yjr2KnaOM8CppdiqL2TO1Y
 6fdcgR7RQouEFPlj/EWTQLQm7V1ULuj89E8xciKSK/PsTQZfMNrV0HXlN4uA0Mo9ZQrezUqIz
 cBEgc5A7aJdJDA=
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_A1,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.11-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
------------------------------------------------------------------------

regards
Ronald

