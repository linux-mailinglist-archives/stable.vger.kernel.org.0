Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA4913FC6B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 23:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgAPWvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 17:51:22 -0500
Received: from sonic306-22.consmr.mail.ne1.yahoo.com ([66.163.189.84]:35602
        "EHLO sonic306-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729261AbgAPWvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 17:51:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1579215081; bh=v8OBhJ6sz0n1EcNKYhxESkE/3M6bkVKDGAqY/Oav55I=; h=Date:From:Reply-To:Subject:References:From:Subject; b=cKekDq2bp/wxYYKfs5ZhrZxOzt/nz+p+Q+pNnujyWhDIAqepxJK8YAC8JGtPeyt8vOc5b4JIwjuL6u9S9blKIYxhjnksEI0wuS+kGyXrAPnI00vqCLmInk7ajA1dpLb2QJSctpsp698of/3egrWvKnGngiOmRF3u9CtGMcUtRNgYQReFWJoVHd2esCcO7ki1jG79oo1E9d7cOZV4zC3Qwh9VsMpuefQKJRpWRZk00U3XgDqnDRzoplcNoRlcqxHToimGPs+AM5bxqcidBtL7jf7ptlYGNJ7C49OroIInkodhVcLwLFwgTH39lhqZd3HxGXlV2KUfjCMt5lna3HOzgw==
X-YMail-OSG: P51M8B0VM1kGFEtHpi51tA5LzZqoVyEWp8CKfwpoy1zrXDUzJi12igUoBQdRRxw
 X6chCYBv8RahOm8EzMcopLtyYB1o.RWqYE42MNEkm9Hdc1q2y87Epuw6JFm6fj3qIxeSsrbBnIXx
 0IHzsAXmSpgRg1MSGf5Pd.ts2FnghJlju_kz19wI_V06w6wAZ8l7gIHwPyzCybd2mETcArUcVUHz
 QEcl2stXF2f_j_UmwheEZcTLfKsnuJJbkSz.o9.Eq2STmDYkJkO1K4IOHrmQvK8koqgw_pAZgkbt
 FvE3K6vBSW3EB7yuRc3o3KHqm2NUdzPIdzRRFyVbHk_PzSbA0Zq032I8dPPatf.uRTEfhYLaIRfO
 qan05h4tn_UWUv4Tm4UO6jZ_3Cp29.s35aQ1IlkW8lNQ4DaJm5K0Ze65Y6Q4ijXfPEsiB58a9mEI
 RU0P12ZLrgdiMmx15rb1o6QOV5q0lkmvbWWz5e_9P1Ops27VyPOjDUc8XD1O38g1u5lfbN5mjpBe
 KKhOwtzfnNsiylmMR1PYBxpBqhTyASMBqZmxgxupdirYZQRfkaDXVylxH0vpj.rsO8KOA15_TF15
 OHwaPt2tJ8oXtLPhJXsH6jzEtEDbPQc.zpYcPDbE45RZrzPGjXom7HtXkiBNQfI6NmBPVF4pnm3T
 N0mHgeLNFBTbstktluSnbTLrwYaR8KQnBjto2ogXh_LTDbCWiTB1u415Ve9aiRD7pl751ZnGeJiL
 mDnnXBh8k6kjZZDtR5ODbg9PYjKHqr_H39h7v3.WdO7fK9la1wLMb3akM8HnvE5Qu3RRnjGOLCGC
 mA1eyPQgdQhhybD3ZIKvRP0QRaoh3WB0yx773wWezHZhqbrUmXwm.yGOHCXDw_U5L4T2NV2Wwclh
 HB15WbdDPJq1b3nHdNNxkxLzc6PaM7r4f.9d6WI6QY8OEWeTYK_2pcF.TJpJsB0aLcp8vdKdhxq9
 tSIjkmgxxF.3Nes3YJGRJvpivbs77.EeOgCU8vNaUy.GOTaMJ6ilge.k0DktBJMDOhHf8ZxgLIGY
 POOEez_mU2.6tQB0pGAwYpvBFNuzil0wlgJuf5SVe8XhN1XXdvsHV8HNe9FAxBu6vb7VzLJqj9W5
 C7WXUw3cu5sJdhLW4aK4SEq2oT4LT7RaUfKAuTy0.ibMUTx1z791_0Kgq49EpGKHUzauHkLOM3VA
 dGdEHV4gRJiYb7GnqGBBHL8Tps7cmRUl6r3VjjwJZ9_8J2RCe6jeO0oRADGnX0eji2fGBCWwCNm4
 T4o3cYltAr30b0lr9U3xgAiRXPBb39WiaAvJNkZWN6nfph26KIGkAxZRDxmCUJJ3R_f0Vg9ydLb3
 qPpE-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Thu, 16 Jan 2020 22:51:21 +0000
Date:   Thu, 16 Jan 2020 22:51:19 +0000 (UTC)
From:   Brian Gilvary <1brian.gilvary@gmail.com>
Reply-To: gilvarybrian@aol.com
Message-ID: <1885347646.140281.1579215079881@mail.yahoo.com>
Subject: Happy New Year For Our Mutual Benefits
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1885347646.140281.1579215079881.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



As the Chief Financial Officer, British Petroleum Company Plc (BP), I am in=
 a position to facilitate immediate transfer of =C2=A348,000,000.00 (Forty =
Eight Million British Pounds Sterling), to any of your nominated bank accou=
nt in any part of the world.

Source of Funds: An over-invoiced payment from a past project executed in m=
y department. I cannot successfully achieve this transaction without presen=
ting you as foreign contractor who will provide the bank account to receive=
 the funds. Every documentation for the claim of the funds will be legally =
processed and documented, so I will need your full co-operation for our mut=
ual benefits.

We will discuss details if you are interested to work with me to secure thi=
s funds, as I said for our mutual benefits. I will be looking forward to yo=
ur prompt response.

Best regards
Brian Gilvary
Chief financial officer
BP, Plc.
Private Mobile & WhatsAPP Number: +44-753-718-0583

 Sent From Falcon Supernova iPhone 6 Pink Diamond
