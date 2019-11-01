Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEABEBF49
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 09:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfKAIjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 04:39:22 -0400
Received: from sonic315-15.consmr.mail.bf2.yahoo.com ([74.6.134.125]:33506
        "EHLO sonic315-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbfKAIjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 04:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1572597560; bh=yspjrTSmVCHOgCQdguSo3B1Yi7JBdS5yhkJ9zTaBtgk=; h=Date:From:Reply-To:Subject:From:Subject; b=U/St1/rcUFeGGmcUQ/H4FGxvHSWsh1Rgu+PuAoFMp9v4ju2N01kIZ//Hgf/CkrNWSxchG7KHl9bJuqi+DjwSnv4f5hCzeK+3DAzu54+sYYB/IPTRSbR4KUtRDXXduGN3OPPb/wivghewnhA4iCvraub2WX4TJs5SdJBI4ekKPmUH7kPepPqpuq19wf8EvDPW+zIuVyVflvqaA9jMUddoAfZOgQN1sPGTYj/5YOZmROFXh2C2xJQ5/gtKb5eVMWya5GWFUZz4VNdBcGfHS4nYQXy1mpb8CEgiFjmPH1h3SGJeNjstp7lCPrF0a6P1DcjWRrhRK7yGj4IOWJ7XlR0FWQ==
X-YMail-OSG: urm8xxUVM1mKux3yftcIixbOoQOyyZgAoYZZv4rL5X02zEv6ctAivQccxQDhZz.
 o.sC1iA42fMrerSmdTZwVJ.UidW4rW3LPi4hUyKRblb8c0p2HT82NOWrC2RGk6ZYMOqvCN8Loiu9
 JOJRF5hQp6Oq_2UMQcC1DGvA06XdlN.1BXhiGSlPA9RKAXANXlSRh9ZDGYbGfW2E_J0YzMmjCeaz
 UzUq3QTvl9sTuAaPQF8wDSML9UEkDCeJ8Mw_YtLFlYUfKqOv3v0dIIxJwt1saE7mF4STnjOvpw4w
 KHQLlEE98sfnxdKSeMtzCWTF_..46ggqLLPXDsfcCYR4lbu93F7ii2mvgubyXN4m3UQhXB1brMp8
 o9GqTAoS4w7a_FeHL7bgv6pOXijBrirJimbfxN.K75K.LmwSxdiR0lVND7QY6E96KFpI5ZLdclU0
 VKvnFDommfyz9x3o4VhoB91ALkViVUqPMqhtDi1zBpf5Ci9y58tvn9qx5q40PneaiYSpvZlnzOtr
 y54NEYIL7YKzW5G4BCtD.ks.bulcbfGObWt2HLkT9Y.sepIV1Y9y8diwtCDhcX_onLEJ59_6MyxK
 V899Q3GNWy3SH.K.DhhRU9QCLhtk98SN9_Z9DibuQtpiyZnTmb9jxXERBdILjOvY1sOH1BcsW2rv
 eaPTPaIy3Sd77qudSiInp_sYho6CtD5vC.xvLUekKkVjyMAUW1rIin361Lxr4zDrCzvCOIMxthe.
 WO.eepZH5N1s3BPAbgOhK9LI4MIj3LAj_Q1e5c_9mdUqbd8Mi88QpYUyxvYNTp6Z29Lhli1iPncV
 AnCn0xQ2LUMoT6gYovuMpurOqQny3.z_S3Y5Bp3e3d4bQFFYXXxGbHy41qu3SWeYjCJAMdEYG0ap
 jRy2QK4huKhiHq2v1xiHv9kCsyATanaW3jex8VneqBHNgkdfXW0grCf.zQYfCHyq0Tb.R3EexS2T
 5RruaXU18ajDhON6i2KDqmWF9VZPNYKGNnLezp6Q4aRt0w9Rk7hPw6Wj5npuNymKmfrAfj7L6qo.
 cANTNOA6Z9cEBE_myR13hR2lqBvsqF1jHN7oqF11PcyJb44TuwWMXjaaB.4rUu5ZtNC_GW4wToy7
 EX4wiiwsT.yIrMsKhOClmwQIi6Yc1xSEiogIWBky7UIylFOpfXiriZNPO0K4o66b1_k5Uy6N4abp
 WfX4mSLQ9a7RHdQxT0vCeLmsUHkN6iNTFeXbETdcgBuoB2B4HC3rTGeoHwW1xTE_XJ17U2UoJ8oA
 2qGbAsqYRjiMK5MexW3Ap00_KZeaDMM2iVS0KiX4cEtxIrhjlXoI4CetBOATCMjTko16H8b0qQ0I
 pRFqE_mM-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Fri, 1 Nov 2019 08:39:20 +0000
Date:   Fri, 1 Nov 2019 08:39:19 +0000 (UTC)
From:   Ruby Williams <rubywilliams266@gmail.com>
Reply-To: rubywilliams266@gmail.com
Message-ID: <1132432703.2712588.1572597559251@mail.yahoo.com>
Subject: Greetings My Dear,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=C2=A0Greetings=C2=A0My=C2=A0Dear,

=C2=A0=C2=A0=C2=A0=C2=A0I=C2=A0sent=C2=A0this=C2=A0mail=C2=A0praying=C2=A0i=
t=C2=A0will=C2=A0found=C2=A0you=C2=A0in=C2=A0a=C2=A0good=C2=A0condition=C2=
=A0of=C2=A0health,=C2=A0since=C2=A0I=C2=A0myself=C2=A0are=C2=A0in=C2=A0a=C2=
=A0very=C2=A0critical=C2=A0health=C2=A0condition=C2=A0in=C2=A0which=C2=A0I=
=C2=A0=C2=A0sleep=C2=A0every=C2=A0night=C2=A0without=C2=A0knowing=C2=A0if=
=C2=A0I=C2=A0may=C2=A0be=C2=A0alive=C2=A0to=C2=A0see=C2=A0the=C2=A0next=C2=
=A0day.=C2=A0I=C2=A0am=C2=A0Mrs.=C2=A0Ruby=C2=A0Williams=C2=A0=C2=A0Johnson=
=C2=A0a=C2=A0widow=C2=A0suffering=C2=A0from=C2=A0long=C2=A0time=C2=A0illnes=
s.=C2=A0I=C2=A0have=C2=A0some=C2=A0funds=C2=A0I=C2=A0inherited=C2=A0from=C2=
=A0my=C2=A0late=C2=A0husband,=C2=A0the=C2=A0sum=C2=A0of=C2=A0($=C2=A011,000=
,000.00,=C2=A0Eleven=C2=A0Million=C2=A0Dollars)=C2=A0my=C2=A0Doctor=C2=A0to=
ld=C2=A0me=C2=A0recently=C2=A0that=C2=A0I=C2=A0have=C2=A0serious=C2=A0sickn=
ess=C2=A0which=C2=A0is=C2=A0cancer=C2=A0problem.=C2=A0What=C2=A0disturbs=C2=
=A0me=C2=A0most=C2=A0is=C2=A0my=C2=A0stroke=C2=A0sickness.=C2=A0Having=C2=
=A0known=C2=A0my=C2=A0condition,=C2=A0I=C2=A0decided=C2=A0to=C2=A0donate=C2=
=A0this=C2=A0fund=C2=A0to=C2=A0a=C2=A0good=C2=A0person=C2=A0that=C2=A0will=
=C2=A0utilize=C2=A0it=C2=A0the=C2=A0way=C2=A0i=C2=A0am=C2=A0going=C2=A0to=
=C2=A0instruct=C2=A0herein.=C2=A0I=C2=A0need=C2=A0a=C2=A0very=C2=A0honest=
=C2=A0and=C2=A0God=C2=A0fearing=C2=A0person=C2=A0who=C2=A0can=C2=A0claim=C2=
=A0this=C2=A0money=C2=A0and=C2=A0use=C2=A0it=C2=A0for=C2=A0Charity=C2=A0wor=
ks,=C2=A0for=C2=A0orphanages,=C2=A0widows=C2=A0and=C2=A0also=C2=A0build=C2=
=A0schools=C2=A0for=C2=A0less=C2=A0privileges=C2=A0that=C2=A0will=C2=A0be=
=C2=A0named=C2=A0after=C2=A0my=C2=A0late=C2=A0husband=C2=A0if=C2=A0possible=
=C2=A0and=C2=A0to=C2=A0promote=C2=A0the=C2=A0word=C2=A0of=C2=A0God=C2=A0and=
=C2=A0the=C2=A0effort=C2=A0that=C2=A0the=C2=A0house=C2=A0of=C2=A0God=C2=A0i=
s=C2=A0maintained.

I=C2=A0do=C2=A0not=C2=A0want=C2=A0a=C2=A0situation=C2=A0where=C2=A0this=C2=
=A0money=C2=A0will=C2=A0be=C2=A0used=C2=A0in=C2=A0an=C2=A0ungodly=C2=A0mann=
er.=C2=A0That's=C2=A0why=C2=A0I'm=C2=A0taking=C2=A0this=C2=A0decision.=C2=
=A0I'm=C2=A0not=C2=A0afraid=C2=A0of=C2=A0death=C2=A0so=C2=A0I=C2=A0know=C2=
=A0where=C2=A0I'm=C2=A0going.=C2=A0I=C2=A0accept=C2=A0this=C2=A0decision=C2=
=A0because=C2=A0I=C2=A0do=C2=A0not=C2=A0have=C2=A0any=C2=A0child=C2=A0who=
=C2=A0will=C2=A0inherit=C2=A0this=C2=A0money=C2=A0after=C2=A0I=C2=A0die.=C2=
=A0Please=C2=A0I=C2=A0want=C2=A0your=C2=A0sincerely=C2=A0and=C2=A0urgent=C2=
=A0answer=C2=A0to=C2=A0know=C2=A0if=C2=A0you=C2=A0will=C2=A0be=C2=A0able=C2=
=A0to=C2=A0execute=C2=A0this=C2=A0project,=C2=A0and=C2=A0I=C2=A0will=C2=A0g=
ive=C2=A0you=C2=A0more=C2=A0information=C2=A0on=C2=A0how=C2=A0the=C2=A0fund=
=C2=A0will=C2=A0be=C2=A0transferred=C2=A0to=C2=A0your=C2=A0bank=C2=A0accoun=
t.=C2=A0I=C2=A0am=C2=A0waiting=C2=A0for=C2=A0your=C2=A0reply.

May=C2=A0God=C2=A0Bless=C2=A0you,
Mrs.=C2=A0Ruby=C2=A0Williams.
