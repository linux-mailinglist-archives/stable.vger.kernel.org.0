Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE4613294A
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 15:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgAGOt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 09:49:28 -0500
Received: from sonic303-2.consmr.mail.bf2.yahoo.com ([74.6.131.41]:44705 "EHLO
        sonic303-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727944AbgAGOt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 09:49:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1578408567; bh=mvJLZk1ixOYoDkz9UebJEERv8fQuudNV0x81teH6uN8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=fO75RL86uyTQPBk/2QWpaKd39fdpf93oHwO2fjSzW43K7HuMCxGz0Gu7yHRxn4r1WHS7f0rzlTbOmpDFSryfNqVYmHB0mNPlrxl8Cgc2ah0GsDsjZBXLFgSP4M76PBg9qSX5Yf2d1Fl3+8feUzKaZLZ4QS3fz9NUMk/G/oLLPq7x7ryeDeNIFDNceszPjV6uvqvVVHIaWz0z8Gg63Jn5cKZCUmWnmzRJ79cHegF0KGMHPWsSC1RxKzYFIXejIzp3l0iOISwY4qZK7HBv+4CaJ1X5PdDGWgXWsCP0kxdbGigJq7rv+CQQc2QhhQg8sZNmF5VGTG2ypH8ouN2dwBuFKg==
X-YMail-OSG: _iwTQKAVM1kBZ8WYAh0msl2BeY415.e3dB6Ax_WUytc47SDb9DJkUsC3AKgVis2
 rx4iQvRr1ciGgjSQpkI9MtcVbmSt.4JV06XccS4Zrb00p.Jewc_ZVt98DWoD4EqF3QO6BBCKZPdw
 D.jgzm6B0mVbKZWUtIPmVfPiQTZTQ1t2wL7unMrto82Tyl8_iJI0JCRKAAHeqX9c2wy69tYiNS94
 d40ueoF9aYVrkrkf0VFxQ.d2z2iL9qIitBGGw6fNQB_egytkLpXyG1ibQvq8JbTONwsY7G1QVwWS
 W2XHeiUP3UWLvyMm1F6o4ASpm0WW7Fq4qmZomOHq5xTkdSHypprLrDnbwqpFRaGyoLZewLPNGxrx
 vn2i6ucRh3YLThqgw.eRZ3R.tgCiKX7ruACLADv1wENnAkJsWpp1S0exRCpVkVbBcneAmTDKg9JE
 DiS71elqmBUxVPb1KHAcyn7bLUu1V8vk4qJwURhw6TgamM8tIJc32HjrIkkVvBQPc3oJ7rww_tt5
 _hT8Gsd9PiiT7yyWZOB02fjFNfk7.zeL._qvvKVZGZph_KXZMlCmWBdjH0KYO2DOJleS8_hXFp.9
 skRTQJBzTOfywEO8cyp37xl84_SMD6z1xJpV3.orLQAIhOUZHoSJeXcydGqGVdzOpKCAvl983lJx
 pOm6Afl5FeXNQ3AGMgxJ0ZuQno6SulzIBY1uFDydwcVX8CXejA7hJzjRYoNSTRsE.ey7f5zVEQG4
 gdAQ404_b1e_bFx09mfoubiJKZqLdyE9pgEKO6PHwNf3nGeYEJbiFSIC5QvMntDvD08BI0uoIRbz
 uXyFJlwkdeG7iSvt0Z5kVRVvI0En0MvOF3YDxUbNQ6JqwHMB8Ef2ygop36ECK1hBQJ4ykW.SmBtZ
 S5OtmVUMBp04O9H_FAtns2OdRU.BrcWwTCqAg0XxuwB0nf_I3x.40Wmpr2BztV5iAS73J2oiqDRT
 IjwMuIc8icSRYmaJK6aUCSXbayvR.ysIc0kcziASgBDiPxNpzb.zWzwrTU2GEbKjaxuLg8Qb_Ajv
 n_znqso5ezwzVQQG8URIrNZq2MM1hXtKefeyr.Pin961zG1TwKKoUloNV72KaboDpdh9eTwv.x9H
 HKijC_HfYtuQ_d4NEXz4VkMk5f6x5Q94poeM4sjDGS8YPG8elE7SxS1_sWcfImww1uE6_BAd1Q9U
 zO313FXp_KSavKh_XjkatzdTy4rH0jfD.ps4qe.SYe6JX_9FP_M5bryY0zX0QOe9r1Ejw.fCu3ku
 4mXzxFmxkhbzOQmmbISvRKVJmR1S7Op3l.5K2W0GLDfjCXnfl4s32tXRdcW7JoLl8u6rbLW.XMQA
 k9jtYwiqpt.G5wlPF5nZtQzI-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Tue, 7 Jan 2020 14:49:27 +0000
Date:   Tue, 7 Jan 2020 14:49:26 +0000 (UTC)
From:   Mr Yaro <yyaro750@gmail.com>
Reply-To: yyaro750@gmail.com
Message-ID: <1925243769.5169090.1578408566999@mail.yahoo.com>
Subject: Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1925243769.5169090.1578408566999.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend,

I am Mr. YaroYaro, I need your urgent assistance in transferring
the sum of 11.3 million dollars, to your account for investment in your
country if you are ready get back to me i will give you full details

1.) Your full name..............................
2.) Country.....................................
3.) Your private number.........................
4.).Your age:...................................
5)Your Photo....................................
6)Your profession...............................

As soonthe bank ,Do not be angry that I request all that information from
you, I do not want to fall Victim as this is the only hope I have in
life to make it.E-mail: yyaro750@gmail.com
as I receive it from you I will send you information on how to
contact
Best Regards
Mr. YaroYaro
