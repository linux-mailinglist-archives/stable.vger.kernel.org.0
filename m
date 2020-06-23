Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF1E204DF8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 11:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbgFWJan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 05:30:43 -0400
Received: from sonic309-20.consmr.mail.ne1.yahoo.com ([66.163.184.146]:34048
        "EHLO sonic309-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731968AbgFWJam (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 05:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592904641; bh=8uXuLyXrvwFLTF7nJAnTzjY1iQF+Irk2qJ9oEwp+KRA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=qXxUePoOY5Vtm0n3qNJFxuhr/mXmXiOWUIw2AEFr9hn9hyrjRi109tpfPCRFuVT0eazbA9KB4WhWfbh1R1MMjLikv13+T68dg6v+NEMMRFskvrSba8AMab22zPdeBL0hWvFilG7gVG+g6PwAdsPRzCo0K7E1e5OiLHkUX9Ha/HXBAlCu6u89yAcpLYN914cp6T/ZA7JUSjrsaNDyBrCcGFdVE6akj9SkpnaHHpgnQ0C5CF5zEhX5xKAMDNeCP1Lmapcq2ymBJLXfxowa9alSJRcZZxl5GrpwkxDmAv/pT2RBZ0o9D3DSyHdlnCoG31ZGFtS462NzgMp+w1NrCT3fnw==
X-YMail-OSG: h_DPZEIVM1nko3R65wPJ.TcHztAr.jNcYmSUNtRI5p2K4WyfZnLtugnzlqbq_2I
 4u0BRAhtE1.iE50g.2Mt79WzFGXjd_ZfPOJhjPStSE21mn0hTBZKlKMPNPD.p9Y25UCqvZSWWXhs
 ZDDfA2mtDjZ8ZvGD4dt7gq.a1czcruaN2Z4ou8nL1RF3oTKKFBAEjWI1I2rNDu_cURRRIJ5BOjh0
 3wnbtqjNm2RzzLrsUgpwQpn_KO_FBd6gq5lVOS8Hx0Tqke.IBH6Z34VNzxCBRiaxNKT9ywlOkTnt
 Irp0kWHWxWxzavh_CVWeqQUt9aKIH_zGgz1ag75PqMOYjQyqLOXgN4rAa88YjbVJH9VawiRegxtk
 ywsqcDvp3rFp_rqnm.QAn9wE3CUST_Bix752plr9pPIGX3kCshGuJn5yy06K0pEU6_h7qOhM3oSC
 .Sx5GEI8cJNNI9xHXUUm00U5Uyui6gwGQfvzECRrEkA1MH.TqMPeldwggHAj8bEHU5X8JlwEc31T
 mxQwrG1_d_5tPaUzAOK6yeaI7oPpLxJQq3yASc4nTnfmSkCdx0_ngT.ypgf2cb7nwyAhmbL6YzkA
 9u8rCt82dAwxewushOhDFFkXi6_6vvI.0CaNd.5.NcI_VDOu3j_f.4K.53Xg47_.9GdTUAypuHWn
 NLvl9B2mjFENxlY28r19h6ynBPmow2fbnRlWQZ26NzEB655eb3vHpZwCWsXJ8GG.1_8tJc5d3YEp
 b8KYefbyGO3FvVTwKLEIN8wypUN325PfnWbI.MLYMo2Wd2tjaT0mKea7zC_Dh0KQ1vXE3FYRR9lW
 VpPI0CKd9CKkZv7HNlpq7mGPzKK5UTq4LJ8hGi0MlSQDotLEthv_Zw8CpNI0aqpNlmCSBaQceBdk
 eo1bLW_rDk3abrfiAPpii0gP.wYhl9CBPrgwsoIaU2mBkkp_ocyoZvsSpkbFM5a0jyz0LShxxpl_
 RUkq7EUkttU9EOygpRU2eKO7Fim2BgKS0ifFpbnQ0EpeHdtgAtJB6UflAAVOQzfa5mpjgHbEQ1wC
 JarMZFPjcu2.aMkE4WMYh1eFyEFIABFI0xLpJTz.0mYo9XxrOb0DSOHStrKTp4q6QHHGHdm9UQaR
 HB92f..tIHMCR2UKcsATzcL1rCXg7adERExVGaSQAbYprXTkNdgDJlRU1akEniaSi9gdfrOjONmV
 ZXLNpP9UAM7Y7hTVnRjY4xDnOP_dWbT18nP5pnaqmJ.AjXdxIQ06JScRygUnk0bz9CxKlJLW25qg
 tIGw9z9QJSVNHsHNR5Xe6lu2LoPOS1vDz8o1zxHxV1F02svXlNXKdQgiVPjoTiYbo8lHkDkbM
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Tue, 23 Jun 2020 09:30:41 +0000
Date:   Tue, 23 Jun 2020 09:30:38 +0000 (UTC)
From:   Siaka Philippe <phisiaka01@gmail.com>
Reply-To: phisiaka1@gmail.com
Message-ID: <808023475.2296976.1592904638477@mail.yahoo.com>
Subject: From Dr. Philippe,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <808023475.2296976.1592904638477.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16138 YMailNodin Mozilla/5.0 (Windows NT 10.0; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Attention: Friend,

How are you, I am Dr. Philippe Don Siaka, a medical doctor working with Gab=
riel Toure Hospital Bamako Mali, please don't be upset by the way i am send=
ing this message to you without knowing you before, i  only trying to rende=
r help that is needed from me by someone who is no more with us in this wor=
ld,

A woman who had an accident with her car was brought to our Hospital some w=
eeks ago and i was her doctor for some hours before she died, well may her =
soul rest in peace Amen, her names are Ms. Young-shin Kim, From South Korea=
 Nationality,

Now why i need you is because of her last words to me before she dies, she =
told me about a deposit she made with Islamic Development Bank of Turkey, T=
he sum of (=E2=82=AC2,500,000) Two Million Five Hundred Thousand Euros, acc=
ording to her she deposited the money without any next of kin because she d=
on't have any child or relatives,

according to her she was an orphan, All this was a top secret from her and =
she asked me to look for someone from Asia Nationality if possible or anywh=
ere out of Africa continent who will contact the Islamic Development Bank o=
f Turkey so that the fund can be transfer to the person, she gave me some v=
ital information about the bank and the money which i will give to you when=
 i get your update. her words about the fund according to her she wants the=
 money to be used for charity purposes to help some less privileged in our =
society 70% of the money will be for charity work and 30% will be for the p=
erson who will do the work. I am waiting for your update on this matter, Ma=
y her soul rest in peace Amen.=20

Thanks & Best Regards,
Dr. Philippe Don Siaka,    =09
