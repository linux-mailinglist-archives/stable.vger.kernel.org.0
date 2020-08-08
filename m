Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1055B23F837
	for <lists+stable@lfdr.de>; Sat,  8 Aug 2020 18:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgHHQUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 12:20:22 -0400
Received: from sonic311-24.consmr.mail.ne1.yahoo.com ([66.163.188.205]:46338
        "EHLO sonic311-24.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbgHHQUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Aug 2020 12:20:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1596903621; bh=2U/duAfung+nfY4beAWeITcIRIG9TDRczr9+/HUsCy8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=IU8S1kPZaKVzHCyN+Mdcworv/uvOl39jm17Tfz4p0g09PJIg5Da7+UNvFf+PkNi3HcTg23MKfDRZcBivlwK9yshgr9BJgXP1PUngVKd/Owi7uqwADPEiRes+En6nyGoXqqhyz+O2ZlMFA3vXXYC/Qi/KV1G8cMYVCDCWakL2W/q73gVC4Ywg0/6wTawjMdzCM9KEbH4/y/0SnXjSrCHjhemcVKFXBJJogRGQ7dI2hyI0ZMSVvRU73f3i3W3/f4dQhXCEiXeSw/KeLKXsT6cBWEAHmf6ejG9rQ4EtTvz1Q7dasIrCiuEvhHayqdKdcQ5C5tyeVKqys0IYv9dIx9f40w==
X-YMail-OSG: bde2pR0VM1lbOKzw30HxhlrBP_mP7cd0fjJv3CGKiUZ34vqax3Z9VXBTEJXIwwf
 Y1gx54KUYeo0qnvTSlqdBHM3a8R0jHfPh9E74Jb.rsXcDJYXWh7pnAd9QG70nD6ca9atXxyEEhxz
 rTA3vpTQt2HtFijPHuqDnHeGtO7LiDYV0Vm6st248wA1MxU1m9M3b.5.AkZMGQ2FpOiLV8pW1Itx
 3G0dAKORgKxQUndXVgaCJNHk_gFS4jpzjuHLTYUs3fb4uzdahCqlMrkbrDM6EI4r0pw9YETcEqbq
 .Wa9Gu7.OCsEA9Gq1ehlsHXC0.WferhePY8mIZNipPTHPkWeMuNyki3.pktXRQeUzDDbZ3N_Le0J
 4gaS9iJYLW7b6vKrpEvv1iP7_3H.gzYIoaVMa_xwO8CsdNQx.kfiBhBmpJSx44QSP48KlUoZyBHl
 cL1nqrrC.agSuivJg0Kr8mOK88YTgKp1D5FQURMsEJdw54TO6diVOgshTrwBK.TOtM4qT.JFoo96
 9sg5jwKn9FNjd2VwpYDZKrvtCcXoqbD5BhBLnH2lQxVswUTIy0OL2p5QgZwyuaKpHXDyFdxxtfaf
 AuJmKuPmgcxZoQnhFXENNF8vwnJnTdpHCelhcFJrsgSZ2BD7L2KZvq91DcIM7en393eFjWsXnbbq
 61DTMa5HaewDShKaDa.wXYNn9gjrQ51aeb6YpckfaOvCDrR9yAQ1xqraM5KO3vlmM8vg86wC1Lju
 fkeAgOFtpUbFxLz4hNR9W18wHRliQJujokpeXcnM7Hua1GPrniBO56KhVWsGvi5Z_dPQRgZWtwD4
 D0I3_51lNniYa0CjZt1i1FJ1_BV.ll2AYcMUy4GR_0SpcH96KULUXYhP2bHdeoA.bOQGWdGuBAgZ
 E3aU9Il1U8rywBOwsRLGyIue67os7YVxg3oek9O83e4lMyXmgajWcDBQ9IqB5E8iYTOY.95vbMNZ
 Uo9T8EFQ7.8ZqTztU__Kep4TSPhraUk9xQFW7dSpV3TyGNEe0R80ai4IAEcBc9XX0zXtdED5h1Le
 Mil1RzOjEdISgn5mxHPQ9pjwDyWgOIWu97zcGiLTBy5BUB8kcKR0sjsNpOaI24HQkcjGQqzkqQ2r
 l9c0nMKY_bn05xKFVocagsEcK9Rp8i56eNP6PlXosbY3ySGvBUSmJUAPBQ5rwb8KW7sDyG_.ydPS
 Wj4xmeA2OVMdNIpqLdc1tSaxGThkDeR_lZ18dXFgixEnJKofJ3hpmz.J_uy2HRQPJjMvni9vwX2j
 DeKsSyOc_BGxTiyOs6fsBGED7hHxZRpupM1KLlUR.r94gOgwqA68SaiONFQbX6q_yQ8WzAxM4AEi
 IIB2dB6fz1FzYKbqtM.2mzIK.Io.7HDwk2bQvUUxik2c6xLquIt_3_Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Sat, 8 Aug 2020 16:20:21 +0000
Date:   Sat, 8 Aug 2020 16:20:20 +0000 (UTC)
From:   "Dr. Aisha Gaddafi" <aishagaddaf0dr@gmail.com>
Reply-To: aishagaddafi2dr@gmail.com
Message-ID: <1055801941.1887427.1596903620165@mail.yahoo.com>
Subject: I WANT TO INVEST IN YOUR COUNTRY
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1055801941.1887427.1596903620165.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16436 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:52.0) Gecko/20100101 Firefox/52.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I WANT TO INVEST IN YOUR COUNTRY 

Dear Friend (Assalamu Alaikum),

Please after reading this mail try and make sure you reply and contact me with this my private email address: {aaisihagaddafi@gmail.com} 

I came across your e-mail contact prior a private search while in need of your assistance. My name is Aisha Al-Qaddafi a single Mother and a Widow with three Children. I am the only biological Daughter of late Libyan President (Late Colonel Muammar Gaddafi).

I have investment funds worth Twenty Seven Million Five Hundred Thousand United State Dollar ($27.500.000.00 ) and i need a trusted investment Manager/Partner because of my current refugee status, however, I am interested in you for investment project assistance in your country, may be from there, we can build business relationship in the nearest future.

I am willing to negotiate investment/business profit sharing ratio with you base on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgent to enable me provide you more information about the investment funds.

Please after reading this mail try and make sure you reply and contact me with this my private email address: {aaisihagaddafi@gmail.com} 
 
so that I will see your mail and reply you without delaying, please note once again that it is necessary that you reply me through this my private email address: { aaisihagaddafi@gmail.com }   if you really want me to see your respond and interest concerning this transaction 


Best Regards
Mrs Aisha Al-Qaddafi

