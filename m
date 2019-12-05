Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE1B11489A
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 22:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfLEVVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 16:21:49 -0500
Received: from sonic313-14.consmr.mail.bf2.yahoo.com ([74.6.133.124]:43865
        "EHLO sonic313-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727236AbfLEVVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 16:21:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1575580907; bh=zPC9p8T5S06DA73PD5F75wViZ/EpBpeYylTS7OqjCU4=; h=Date:From:Reply-To:Subject:From:Subject; b=TYlyDv0zlYbLmHl2/0fWOr6ZUUyGiUf6nEf7oN6S6I5Qt3+y51E0qqUZaAvkX7kFPbTRc4akQgKlnNeMG2lNKbtECSzscA7qNt8X/JyRNpWqL58pJcH9+YDyxHYESJOU9r34UHIOMXIVD1FLZCyHMXoI0h8+MPfdT6O0zqw0KW6aDSmIL0tGYIpefKyYka9DZjHB58uqdku2TbKJcn4hLAIdDPnwNASzLr0GztozkvFOmPyIbx0LkKzI/b7s8xEOC3kd8YDLmec69KwFRIbMo0a6p0+o93cI7sG9b31eq+QRwAxlyiL4Nzh0Zw/9lD23HTjm5HSO/arBXPgDbfcfWw==
X-YMail-OSG: PwQgiSAVM1nQ0SaWCjySFSvcT8ILRoGsSbtIyvAk4vUqGdsM_gzn_n13muBKUJ6
 UMu7zeALyufMz4z6NKDZAtr7gXBX5X4DKn54daMF2aQ0k.c9oX0bGrQ.7ZFAptc8mBF9jAX4IkI_
 iYqgemCLRpipoRGsZZiVkyL7l6RBWf1zHu0LCY4hTtZeYscOYXelQ3rl8NcMsITmhSjh8bFbqG4e
 UnBYmJGkF_YapFe13siygpzuha3tu70mulB2lv5ghZD9scamgHkbi.Iakc0jeCfkKZEtTF38Boed
 4XcxMgz0GeH8p1a7rr1KhhUda_GQVE03FtWY7UfWA5nOqeJ9YrrjQWnVy7hV7baYQH5gpHRv2pr6
 9_8PG0NnX1Ae7vDYEJYeHp58ikOsqKBNZqiDiNSagVFtXSOoNXYWqhahGzirwdGq5hLNVb3oQERj
 8Rys_Vt6Octhf9TOXktZeW23AslSfcqH3h.c2nr6m9XDcSnjdakA0TfETHLA76bAaWHP2bhyLZqN
 hExD1h5yYZkU_0VaW73iF9kNdPgtoJ_AhIBSWtoFi5iub_Vxy2ha7oGKsZpUyBwUdZk68N_TVFhm
 ICGl_GZS0lG8StQUT7R966b6YFD4eccQ.w1L4XgPUmd49bOm5pljN6Sedb.YKbwcyBB.LiI.LCYU
 aZCOi7vadoquE6VPLxgM6.qZpzaDVyt.lagRZg7qZ6mU3SPVG2AskXBeTZ.4qNeBXb.16liczdYg
 Kp.8SDVktABUrp1.1_uEg93MD_Nhu5cP.gPfxcwqFRY5KfxAQsqeBEZ26uWhpLDCOJllehKoqyv5
 OfFi26279oGVh9wUin6f79zlj3r7mqCA63IWKKs4O4Pqg9MU2VTUEWgvGBQ2H90pNGTTqS1qRtwt
 oQliCEF_tRNEk6nFDZsRpYgMGH2uEfEM6y9UkaiyCXudzgMWe_NhRVxxl1WK43ngsOcvrCBxdTkQ
 xh9YIvGPxKMCrQi88cyk1v9.e9GEpzszzVc.77Z2Bc14KHLR3VZDNaHDsUgO7i4evLoz2hgZVn.1
 peD5c9YXHneEE_MED9Bxj0SKs4Mx7LcbO.7h_08.Opxh_cSj3VFXaGxTPP8lJhLFWLcb1kV2_Eqi
 Q8gzOpoJWVnZH0RnSVfhgfBYZAOkbJU_9aSvF.gqic888sFKf.mvDRYMgICc5OIt612Cgf.ZKyec
 LAiBEH3Iln01WBX0gsp0l5BobFs7uN0r2XAWM6kLb5d5goAOa_HurelU9rfYNNmmYxQ.fo5V1ygK
 aH9.N.kHTghrOZ5vlXgmYppiooaKnkMD5QnX9hFZGZo7ysAR02KoDqfRuLk6oDgQvXd8CapYLc8r
 KzVnE9iyCDg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Thu, 5 Dec 2019 21:21:47 +0000
Date:   Thu, 5 Dec 2019 21:21:43 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh222@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <525334177.6207554.1575580903090@mail.yahoo.com>
Subject: I NEED YOUR HELP FOR THIS TRANSFER.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa Hugh work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me forsuccess.

Note/ 50% for you why 50% for me after success of the transfer to your bank
account.

Below information is what i need from you so will can be reaching each
other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa Hugh
