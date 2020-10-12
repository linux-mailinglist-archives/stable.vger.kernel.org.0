Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EF628B4E9
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 14:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgJLMsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 08:48:21 -0400
Received: from sonic312-23.consmr.mail.ne1.yahoo.com ([66.163.191.204]:38794
        "EHLO sonic312-23.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726572AbgJLMsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Oct 2020 08:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602506900; bh=hiXlLyGGY/5HOf86zFXDcM9X09oJlDdR6nFUp9kOZr4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=SlB/ydcTAmsuIXdfUptOnavYLsRkq9Jvs0dCWkgg43bcI8TfVz3puj+FL5e/AdkTpgMO+nQonJsy/KPY0KWTU7qFXPUUUixSh3ZFIavwhZjgNYywg4RwfSl7Lp0vYWk0M16GnuHqvzjgOO527gSS3pl+zIRPTMy1awLB8P2hhsx+7sGz53FTTpWEDNM0P4P5oX9jdKa64ZhJiL6/J35LTf18la8D0fEJ0XXm8nceccESlyGt9V+qt82rVpkAHzE5FprQY5yb+qlcFbRVrw7CceFu4OpedMnpxMKMV3jYvbJBwcib5o8UBMznd7aDMIm3AMlTmSZuTnochvL8WyU4ZA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602506900; bh=fpi1ljfoT94zD4xsmck/F5vYdPb3wHs7ItcJBpB475+=; h=Date:From:Subject; b=T216aKscWVsEcK8eRjaroaEnk19fWZqVvtqazQkzaaktiLvBk0/lG2Ps2sGuxn/CG0w5CrvvSlKVrVkMX2j3xf0rrqx2fRSV8tsrztRkdy3SpabX8E+xqcJ3DD1esvE7X9GuZ7NAvhIi5CEqHToK16aKTIyvD9nvna+GwFz6LMYNG3qoG0+HYnMJH2zgaKhjRaTb7VDeD1eiLKqWRoXDgLoqGqOPMSL45WIlrktVa3WKWY7QIawKvvxC9jm71TkE8qyunmswzJPztFK1ATULZchSr7AgNJdEDmdgbiIRK8iay63ovH65BfoOe+C0YchSX20dfw+EHCl3R3j6ir8O2g==
X-YMail-OSG: mkM0zuUVM1l1e6iWsCZze7oWuzQce9QAMgxlPWf4fvT72R.PaRSZCuAzFr_VQQd
 AButZZhrfDmkdSRybwBBA48dDbtlhYU8auTXq9.ipkrtfV4HkR_1nSfvq.PGl2785TTzK4XGZwwB
 tC07zKgeL_O.kjRRB88lni1sH8qpVwIxAaOIlNJPKO93z.bEiVn9UkKU0LqvG93ZjQq5q1jMIT.5
 R1H0BEZ5zw1AG90D3JB0ihZql3YNv266Rs2gb20pMN_A_BkeCuCumDxdz.MDIobpCWpDpP8PF6OD
 mIehj_6PNv_w3c4_ZQOQJmqEeIgUxbP_7nxTWNs5Kj6KPKvjSKpDZU5kO77OFfC6SyBdWSE79_OY
 uE6iDRJ9HOD45FyES.7AXlXDwUiCC.vcID9emS57AINUlGCsSYOjWg16oWfVr3XOpc_2CmDKose9
 4KM5wQBZUjOr0ADxA_JpGy.D4Uo.1jRHjyBb4QBY1d_xA2ytaLNkcuvRY_U76c1bZHLM3Ch3gWYD
 wz7DgaSLj68MCbBw.Br_.8CNYSMqX_3OnccuSKJlHbHpjscbewKuIFU.eyBSJ3t_8WRaiTOTb0mU
 mUge739ejq28DXGgWlEZ8F86gHxiZznZQqjC4QSUTghCWXMZzvIknPsPjbg_gjxRA16BVHhCW.xE
 zQnxNE3fjDltIsSHsLpP8Tb8SJ0xWbHjV1GbDCgEBnEZLvvCV3ECANIx0y7rFGdm6hdG.VxEjtN.
 _AVQPcVbUmQhtdTuxeRuRhmwNYsrgAAxF8DnCb4gibfajGgfGe5r5oTbiuGWcoQFKitOXtHnsjlQ
 tvuVfLWn9SXHFTee7ok.xx8UOLN9Nm3IG7EVwjMyhBuyYMBUheI5Eqb4M60oCHqwPwp2FbsQ9bfe
 B4ITmyF9b2X3Kxrtir2e9KI74d6QpYA33NtINESwfaxaA9rs6KR2ldwVxoY6R.XOTcAVJebbC9V8
 Xlem67UcadUK.PWJM0hi3AqGgmqKmzYi0oEL63oy_1KEQ6GXwqm0Ie5RPEumuO7wgo05aKjPkVle
 L8BZCP1Hfd9klC67vVx85ygmKuavYLGgkl8o3aaSdZWfYrruUoU4.ukpViEZA.z20u5UM25.NIO4
 ii_NP3sMzve7xbWCbFXPNsonJ1A2kOeB0D9yRibsWho.27WdWtXQN79lkiv9_y6l5TtStDxOz.Rm
 FtoLbcliDwtKOQWEyGpzneTOs.jRqAotHqdEiJWE5X2_9h8jJmVGDvF6FgYjGktgcBTu7Buy3UBc
 Wce55memkHD3aFtv1_.w_p14ekByQcoUkqW_EvnyFaYaqIZ3FJG86PAi3TXgVMY2JkMIjmu.JQkY
 U6sF89kejBzBjfN.LhBfVvVNeh4hoZAbUqZMgh5TFEwl..LHTS98GyywSr4GCWHYi2q9TYd5SGYL
 ib57OV1ZPh9cO5N7N9IfXwgf53jDRmEHqp2DUqjnJCO_9
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Mon, 12 Oct 2020 12:48:20 +0000
Date:   Mon, 12 Oct 2020 12:48:16 +0000 (UTC)
From:   Ali Shareef Al-Emadi <alishareefalemadi465@gmail.com>
Reply-To: alishareefalemadi465@gmail.com
Message-ID: <831028875.515165.1602506896449@mail.yahoo.com>
Subject: QATAR PETROLEUM INVESTMENT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <831028875.515165.1602506896449.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16795 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings.

I am Mr. H.E. Ali Shareef Emadi, Finance and Account, Qatar Petroleum. I have $30m for Investment. Contact me if you are interested; I have all it will take to move the fund to any of your account designate as a Contract Fund to avoid every query by the authority in your Country.

I sent this message from my private Email; I will give you more details through my official
Email upon the receipt of your response to prove myself and office to
you.

Email Address: alishareefalemadi465@gmail.com

Regards.

Mr. H.E. Ali Shareef Emadi,
Minister Of Finance.
Qatar Petroleum
