Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F2D27B144
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 17:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgI1P5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 11:57:18 -0400
Received: from sonic301-2.consmr.mail.bf2.yahoo.com ([74.6.129.41]:45043 "EHLO
        sonic301-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726460AbgI1P5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 11:57:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601308636; bh=QJ08hxYfTBT41oAXGKs4RuBuRPG8lVUycgZdUuqlOfQ=; h=Date:From:Reply-To:Subject:References:From:Subject; b=LVnh5sley0JmdKr//vaY0FhEDAQn/wGkL8kdcfOeHOXZiqTVl6SBdbQ0DXnttyO2Ao9KMG6CMQ79+ZSfI9SWY2/HxbE/0UC0xFqahblIz2li8ijvnuyh22UQkqxwt0/4fhhbQvBTGKPtW/kgYp1WhZ0iHIHfRDY47X6caq++eI3UbYW136L/M9aOCEL9E1xoW+Q00ROv41ZnnKHeasNF/uoxdAGEEfz+tSyqRUKz6qLo0JDjUgHHT0m2Xcbv0m1O3XKGYyj0uxxrnF/z/Qg32cL0iIZ5h7l/VGxOn+S5o2wriHAw25h/8m6AH8RWoQt6cAVyA/Pokw/kskUkMiNq5g==
X-YMail-OSG: ARKR8RQVM1kBlW_8mFhNu17o39azWG0QA2zwoXxEi3fMj78yeG9NqYwkBY9YYkf
 fg7T7YbOrc6MGyrQZaads0wGUzaIHlh4.M6OodYfad4DaIFpWs36kQTE.gTQ122fFqN1fjYq2lgw
 iCDT95xfSnhMvwUu2O1tG59dEqyGzt09VRmym__s29opLSsyQ_GcXFN.QggXqJ09j4AruzT0dtoP
 hwr2F5YMT24gSGTRMlUzkgp4IHSP2P5JtsP9AI0g1QHvst6XDPkNFVoZY.lRsTbD1sIfuffjWQI2
 mAqGOK7TjRG4koHsAie_9NvlH3t7G5IH3yG9Ii9KbozF0xHV7.ND4Hyp1frNOP5930LGJV5ONU8l
 G6Ebhgt2xOx92YjRl4h4PhBPmCdV5cweadKdex9ZVtlY9DoeR0dQ2pBa8bauTVRRyFzjJq5Bs04o
 PySi6sSq7zFoR3yRSGqV8vor3WRVEJIl3RUGQNPM.aAxerO.aM5rynIl6S449S9q_.p578G.7xXx
 tBurkEJZ.oFcwIKxSPJzcBtOeHuXXsYsntNHxHUMH9yEWtkXV3Yz4v2Z_3V.0NrXkxLGNvvMN0Sd
 E6545CUtVBPyGDjWQP3wV2gQLG0f92VcoBal1NqQdM2jwLWIOmjC0amS38KYrmJGu9IVmJgtz_62
 gkAbF_WMByATH3_8hHMesBANqz3It4R.7XAo6HyAwh2pFptja1wycLirKU84oYSP8BcnroMEcUQi
 dcyKIwXEJir0CNWzeX2dkcfSPXHc0we14LOchE60XNTDs0GrqqGst2r3zMkPrKezEvMSb.81N6Oz
 yvtmVXqRvBMV.vq8poTVStgnXIwWA0.nVhRRkDAiVEPpgQ2SBvA5tcV.obQ1wIjOf7AHBFPlTTxd
 pbn53y3Vs6bAA9ziiWQgbKRrxb5OZaE319zSwdwSHQRWwOeQHjQPzt6Z5ho6ek6Fabl4u4YlPL3O
 36781nQbuvr1ujSdqnPx7fwgUhF4d0_mix4rV.bmb06rEmOdbarOKHCZx2qyAUmYfH8..1SZs8OZ
 qoylrZeMMYHAQuuF6E4FUbaoEESWhUT5Ny80wz0D9nzD8mYxr3I6ZcEGG4JOdEy.CPUqnsaUxiKf
 dMfkQmB6Eor07apOgqZsXWEaCNXkoPFfsYTb0EpTKPqV8sHE0n_iAKEzNLF13woi.HXg91Tx2Vn0
 dr2kkG2j9GiTx8mbnPmApG53SJDlglb9MhbT95ULXkWi2LDKXAXVQRbpY05UM4151RuJqI7QGxdt
 5jbnqVuVvNYYwgKY_q1qOzWrShZ8WHkEDjSEE1oZSxByj5IDpZDpdyWwHknR7Az17e374oVEADwv
 KVR0ZPCGZ8yYYj4K7LrUcwX6Hrv1fn2S.X7Yzjeal6x1XZel9ze_.nUIZD4FotlOMcWtXJeB2LIe
 Q6PjdT_YSpT_o0Rf9mwDTTzf85aVwaF5pmFwfYgCi8Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Mon, 28 Sep 2020 15:57:16 +0000
Date:   Mon, 28 Sep 2020 15:57:16 +0000 (UTC)
From:   "Miss.Helena Hill" <helena.hill121@gmail.com>
Reply-To: helenahill13@aol.com
Message-ID: <73315806.1499242.1601308636256@mail.yahoo.com>
Subject: Hello Dear.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <73315806.1499242.1601308636256.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,

Greetings and thanks for your reply.

I am Helena Hill.Unfortunately. I 'm now an orphan,the only child and
Daughter of late Mr and Mrs Joseph Hill, from Ivory Coast  Abidjan.
I know it may havesounded very strange to you on why I contact you as
you are a complete stranger to me and I must tell you this,

It will be very difficult for me to get in touch with someone here
who knows me because of the ugly circumstance that surrounds
the demise of my lovely parents with whom my future ws looking
very bright from all looks.

My uncle conspired with my father's business rivals and poisoned my
parents during a business lunch hour and their motive for eliminating
them was to take over their businesses and inherit their wealth. In one of
their letter's that I stumbled into, they were asking my uncle to give
them their own part of the deal so While reading that letter,
I fainted and my uncle came in and caught me with the letter.
I'm afraid that they might decide to kill me or poison me as they did
to my parents in order to keep me silent for the evil they did to my
beloved late parents. For safety, I decided to run away from the house.
I'm now hiding in a neigbouring country called Burkina Faso.

My purpose of contacting you is because I need to come to your country
secretly so that my uncle will not know my where about. I got information
from my father before he died in the hospital about the secret fund
(36.5 Million US Dollars only) he kept in a Bank here in Burkina Faso and
I have verified this with them before contacting you. I shall require your help
in transfering this money to your country for investment purpose like buying of
company shares,Real Estate Investment Trust funds,Jewels or Diamond,
and to continue my studies from where I stopped as Immediately after the
transfer I will come to live in your country.

I will give you more information once I hear from you as I am in
sincere desire of your humble assistance in this regard. Your
suggestions and ideas will be highly welcomed and I am willing to
offer you 15% of the total fund once it is transferred to your account
.

Now permit me to ask these few questions

1. Can you honestly help me from your heart?
2. Can I completely trust you?


Thank you and God bless.
Yours affectionately
Miss. Helena Hill
