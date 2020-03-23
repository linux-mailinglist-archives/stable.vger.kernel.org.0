Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7C618F55E
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 14:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgCWNLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 09:11:40 -0400
Received: from sonic303-21.consmr.mail.ne1.yahoo.com ([66.163.188.147]:45964
        "EHLO sonic303-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728349AbgCWNLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 09:11:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1584969097; bh=/GcFFbn2btZiSKYiGCo/BleXlnSRHZPoMjv/YxR5ftE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=HdTGBhc6soFgdlSFLXaMx21XWkHtCucMP0S2tTNTn/DGNC+Vbrt+zNmat6Wk3/XMq9b3//JNh/huYfNN1l/lvaS5g85Y3pdCPWmZxGnwGYKq2by4OER71Sd83Rk0Jfns6caFP/ANzTNzA0R/LdP8QD3n1A9dMOiU9J3PTmHrXO9A4s5jw88xOAZv/A7nAxnrtAZnfVgJJCq5mHTlDCcnkp+LFFpTcH+FWyGKbylwWZNp0WHwj8sF/GLOZKQMYnhRPrqLBaBZonFPgp7o6ICSuK3GChSw2joVg6VhUIXvrdhsV2UiBUnppo7TOCrn+ygLW8eHq5wVayv7xZxHXpA1fg==
X-YMail-OSG: oJi0htMVM1nsuNAbPYMAzD79SQhBSUuI2k2.fQdnhMhBZdFObL3dWqipw9zSQSy
 UGoNFy8nIzml5JNUmfjVHCIJ2GWKgN_7Mpt1hzn6qJGfVZpY6cwGl.8_KI14rzTrtgS0lbYmnmht
 c91xi8PlKcFIMCogj.qWPAbzreMBj0JMlYCP3.DEVEsPmh3fWnjPYMdOqCYxgHYR0uoRYiWjENz0
 kIX8FNQfrITJxO4hjUWN8RjMf4Zn35bw__xGSyIReDzS5QjbZ_dZC36ODtisBd7KCPbOF69xzebL
 IEm2OpnecLrdFmQdqWLHxL5M92ln.n4zAne5ocZleHFI1fm8HZDxq4OUTKbfteZw_0ub9AyLTd4v
 qMgIpZnyr3sjF4M_GGmxkS3KOWXuX0Xo0niStyE4y8Rv5qhAFY7hzzSV1fEUS4beM_DAyTrGv8oL
 oqJFFKRcCNS7m4gWpEJAsaM2DiyeD4AYwSRS.7KD0aDxFtyPSx9XY3aUkc9HBDB_XBmhFdSAYYC8
 Pss7aNfLGkHVAVLIQcVKXajg6_30iP1p2gRP871pr2OWp0SXSxdDPljmtbETUOKw1CmRw9vnJ7Nu
 F.RopaUOObTqvvba1Sag8yq9m9097k0EsdhTBLMJCVT0iCsZ0__4.um05pA46ok7CAR_vC.AgS.a
 9BgK91scXGTD1375Wb0GRdeahNp_W1sqCSdV8.MZb8sFE32oCKG945xh9RgRepa52ZOSqsr1iUsO
 NE3.MfBqKTla8hiYkfLQwlRS58Ww6Ksd7Phy384pyq0J7ioOyHDKpHP6QdtE8A9rhwx.rL4VLoWg
 FACcD7ABYCGSBNrpEbrI2H924tx0eRp.vqyk845D_A9VVN7fKY7i8pxBZEu.5oyqXB01Ae8N4vJ0
 aHPcclMljFcCGbQ5ZGY0w93Lsud04WdB9HRTDmE91imQfA5blq5fLsnxOCZDU0gLnCaXwsQOSZM3
 O1X7B.cKzAHpVl.hHVFrB9lzm4bg1khjjf_J6PjdTVYzrHLlOSwP0qnxKlfxCogtA5exVPYFErZ5
 .UDB41Yp12fVyvXQsaWW9HhxZT8gSk3GmmCfI6GiLru.Tp2DINcPDjsMc8En8NVN5ejKOtZfF4Xm
 XnlLmTztOQNt49x0fB331.EtfisnW1fHywsbiuu6n_WjgWw1R2NiA7HZ8HXA8x6fkjgvKtwvmA1S
 JyNS9PDLSR5W6mnBwsrz_NA5tCphmIYeoxZDEIhr5G5Y6rJjFgNOCyHPrlwFjra3RCZHG_8SUrQw
 onEPmqDC1Md9ddjx5ItLP8SXZR_HJVkhg.hDpXP.DMqEX.tdXBlJntBMq2A_5pmyPvNOGbuo-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Mon, 23 Mar 2020 13:11:37 +0000
Date:   Mon, 23 Mar 2020 13:11:37 +0000 (UTC)
From:   Jak Abdullah mishail <mjakabdullah@gmail.com>
Reply-To: mishailjakabdullah@gmail.com
Message-ID: <1797000958.548419.1584969097096@mail.yahoo.com>
Subject: GREETING,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1797000958.548419.1584969097096.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15518 YMailNodin Mozilla/5.0 (Windows NT 6.3; WOW64; rv:47.0) Gecko/20100101 Firefox/47.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greeting,

My Name is Mr.Jak Abdullah mishail from Damascus Syria, and I am now resign=
ed from the government. I am a member of an opposition party goverment in S=
yria and a business man also,

I need a foreign partner to enable me transport my investment capital and t=
hen Relocate with my family, honestly I wish I will discuss more and get al=
ong I need a partner because my investment capital is in my international a=
ccount. Am interested in buying Properties, houses, building real estates a=
nd some tourist places, my capital for investment is ($16.5 million USD) Me=
anwhile if there is any profitable investment that you have so much experie=
nce on it then we can join together as partners since I=E2=80=99m a foreign=
er.

I came across your e-mail contact through private search while in need of y=
our assistance and I decided to contact you directly to ask you if you know=
 any Lucrative Business Investment in your Country I can invest my Money si=
nce my Country Syria Security and Economic Independent has lost to the Grea=
test Lower level, and our Culture has lost forever including our happiness =
has been taken away from us. Our Country has been on fire for many years no=
w.

If you are capable of handling this business Contact me for more details i =
will appreciate it if you can contact me immediately.
You may as well tell me little more about yourself. Contact me urgently to =
enable us proceed with the business.

I will be waiting for your respond.

Sincerely Yours,

Jak Abdullah mishail
