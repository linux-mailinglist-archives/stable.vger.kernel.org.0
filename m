Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A9F17A308
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 11:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgCEKXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 05:23:41 -0500
Received: from sonic313-13.consmr.mail.bf2.yahoo.com ([74.6.133.123]:33017
        "EHLO sonic313-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbgCEKXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 05:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1583403819; bh=TB/VZc/UhGoo0+B79UC9Tgtg0pigPTFcBcEvkMbFOow=; h=Date:From:Reply-To:Subject:References:From:Subject; b=V0O5bgFtLunsgDYyYvdGy4aFmxxCwydSpJRWaU5MyuOYVRngn5BYyFJ7YIlJ5xBluclylMb6FrwUTpR7qfw7XaJ10sEC0l/sxiFbMpI+1XirU/0X9tZTLpgNyreMrLcfM322QzFdInId97boWcb/VO0ANgC3/WNobCnV8hCtio4LuHcObD5ES7sAPy8QWjvZv4UnHkKebSkhrTaPSShFvjvw4Hy60cSRkTqNrlBcsLI6bWR/zzI2BLPWeLDRWpgwxfQIa988fFqjB1OkBoxDne8KNNb+P5M3MU03h+obk0lxSWZEW+wFdEJcfhWBt9tfkTX9pvl6rrFwGowZuR9+yg==
X-YMail-OSG: TEwNh3gVM1kBVyEGNbfA5.AJNaLhkBQeXNqrxrGAoyXcriW7jISJw7ZSEJiaKo7
 hY0L0Tqm8tpgEcJ4U.YO.LBPTbsSIex_U4QdeHr11IhIbtPhN6t5EUPOmTKtnCv1.HZy4JLtZbl6
 MFQeOFMZakohtUiFxx_5KsrAtR4UQfki03GLvStiq1hY4XTftE4cZsan1mHOEitoH73C2BJsMVvm
 PY34uuVyystmTy.tEp_pyESP9UujUpUyZ2Ul3Snnylg.IIUKdP2qzXAh0GXIK1vx61yKLOQHvj3M
 5X7hUbf2_HJazIPMTQbnGPEnKIEiSZozZOebL_ApXmJUKvkvTk2II_j.kcABJ2L_rqAQYHoH_aoE
 hzQaQB.UPjCpxs5lb1.Zt1PKfcu1DFoMh5GkilZgCDEOCyIVyQRHRKEBNaWjXXRF_emUGpO6zS6X
 xY9oLXMus4W.I2EttFvz8a4_0zVf1NG3Bp.Yt6ztaLPWau3TO_dBx09IsdB119t6cYe4TvPrK_Mq
 XRZEF5orYBRDAWZY0xP0WoMhSKyugo9wCsscOMbFQKXvX3A.KkUKpTedyVdrMacf32VmGxYiz6zN
 xgOXW2Rv9ceMNM6pzG0Smn05q9ZrP0pt1y4ocM1IZHApqyQXa8vXJKs3xBvUeY1khCvd1R0WcJQO
 _mZgcVBUzfND7bVeDLO9KxmqAx3LuGtRLpm7KRn913CC4GRdEhcBVSTgs1zd6Np82pErrXNpH495
 H88Eplqcfumwwf2h.UotXtR6uN4f__HjXP3wPsQIn2HQOAmA0IseQdw394KldNGyuVKEFXXF1n2Y
 XSERNvI4iiI_RYe3KL7RJYre4VBJNXJcXx8n97VdX_5VNishrqMUvZupQePjeBkhoSCtlo.8MPsq
 YdEtU7L.JMKU6fWQgXDx6RJB6uTNKUsvB1L4gKDBNFivaLAJuHmc4q2lpwu9aAEdXDmRYejhjMLS
 cxsU8WGxLcYM_Z4oD_yLrgYmTa49pTqGTiQs0uV6TIKGTBqk5HLhMEy28jA0TewHHsxd.PXizSoT
 .8OyLJD6PUZexU7_.tYSM2d5l4JKMClzsdYQpvuv5RLqVxOAkU__x2Asmtycjp92lICdCd5mXd5A
 EjGlXkzBID8_5Mzq3sXcIgOD7gY0iMhpdhbcOFSrS3gNgWUvgnAcrrR1kdz7WiV9W1uALx7kr6CA
 4qRIk0gW1NmqeIwPc.uJMhFgoteS3s6D4O5Rd89qHnNjxZH8qnOrfQDk0axfhovUTdOppeov2rcZ
 wAVvuOZh7wMcwW4sh9sKalN7O2zddcTczldLuluBg.5HvPNboPEUE4MBQT5tuD.qG9Lr80cb590y
 ClFzeLxwRI4EaETvFz5hzgV7mnk1n3xE-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Thu, 5 Mar 2020 10:23:39 +0000
Date:   Thu, 5 Mar 2020 10:23:34 +0000 (UTC)
From:   " MRS AMINA KADI." <gbob54644@gmail.com>
Reply-To: mrsamina.kadi33@gmail.com
Message-ID: <1541154064.127462.1583403814686@mail.yahoo.com>
Subject:  COMPLEMENT OF THE DAY TO YOU DEAR FRIEND.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1541154064.127462.1583403814686.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15342 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



COMPLEMENT OF THE DAY TO YOU DEAR FRIEND.

 I am MRS AMINA KADI. i want your assisstant to transfer the sum of 5.5USD into your account, I will give you more details when i hear positive responesd from you,

 Please contact me with your below information to proceed for more details awaitin your positive response.

1::Your full name::
2::Your home address::
3::Current occupation::
4::Age::
5::Your Country::
6::Your current telephone number/mobile phone

 contact me with this my private emails I.D (mrsamina.kadi33@gmail.com)

From

MRS AMINA KADI.
