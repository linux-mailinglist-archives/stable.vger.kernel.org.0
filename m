Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5F24CC15D
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfJDRIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 13:08:18 -0400
Received: from sonic308-9.consmr.mail.ne1.yahoo.com ([66.163.187.32]:40025
        "EHLO sonic308-9.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726978AbfJDRIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 13:08:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1570208896; bh=NpCDJGFiPXgQJqlSph6AraCuJeCGLTgDpBTbzEMZcHQ=; h=Date:From:Reply-To:Subject:From:Subject; b=HsLJoN/urNBtpsGL4/GUP+PLT4QimwRMoWh2fnp8QljllBrJ0UPY/ZiS7Ha5V73gyXS1D+1vI6JV8cRCw+JVOBIyFFN41SAQKKOzliRwr6gajrvVXrV9DEoC1jFTLh2Jbp2PlnfaBPXwOLPtgrAlhI4A2GBMQEQjw7eRWo72NcdAV6RulJraNcK56sUJUHzSVbEFxNf0c2qZLobnc4613G+grU3nxQ1SuhtflZfz+7wuRAlXHzyIvlOfGrVfONiYk5W9PTBtT4qPYlca9iaiyuxeXyaK5plppZMSPtyP9gwHCPgw3ri8w/5krVTFrm4zuAd2JFJpZXQwtFz0LdwqQg==
X-YMail-OSG: ZBSwQm4VM1k8UQW844QRM1PvlV13Rd7JqP7srJn33eDkxMHAf6ajfw6vFkMOfYe
 8tV1yMUcqkuldSNl_CzGOsnph4mtksoltp5ZDQbmnAVFqx1HSVdIIduw2mNjBdROwWZqIDLT_VWT
 dyWCwil3d1cUKEeF50ccNFEJBVqdXu.G7yKN1shQU7MMC1.rWsGildt0.x8_gPiCiuIe04COy2NZ
 U5OzeXnemEPpdyxLeWdXWoQWpDHaXn9umZFa9T4cQwaoj5l6rJg9S37.0zoswa95gHrJharA3pyF
 qDD2NVxqSciHkpPHEkh8jayv9MrePLSB6DhIMt.4.waNdRRD7ybNYFqNg0DeP3O.VCknErNTeuzQ
 tN4SYTPHhrFoEiz.HWB3WeqcDt3Ly46uBHLaDn80ubxMRiROYuY5Js7sDpf4KAotpNjghxP3trRG
 SFiGdHIO.EwzkWQ345Jbcq71n3idulZP5QPZW_.KwwmMO2YOKmUYZKLj_MloYK8wpty2aeOjAMuo
 yLPX9Q6P5v_VxdlAT7TrqCstZioq7fSXtfRUH4r4rcD4DNQBoEOxx4zfKM.o.9TriZJ53WDmC.ch
 kfmrWQ7AoiRTangoFUEzJUIcJxbWfVHiISvlFnjdi3m.pusML_7nPxkWxn7ODYdjvy3iRJEq2RBn
 eW83utPMt0kYijtpA1_gdteUWRPs6s.s.hu21x8tKa3.8MggYHE8ufViPM8w40TIhgCfCbXpVPBt
 zhzSLE41xjGvZQgFhybkKrMIWdoZIrWkTbUefs.MSz4IgFRAAIQLJ3ayrAN9O_F.CntUtEDQrUYT
 GnQ734q0kjVqPvLra6BvVUYEXRCPxub_Crl53woXj98FdMzaLCvR5IUR.ycUjF6Dlq5zY.4PZgvz
 fJodWvfsu0TxB18ggVEfrQJD2M2zm3Aux6rGNa9mTQj3C0Dg3VUv1RLm.eM.j1Xe_SS8FsRtToZR
 NiVTpv8WJUHCef.f96sNFIY1kJEXYVlNtCcidI8.3eGCcu.qReejPs0cnJ4GkSlwmsieJm1eQtVp
 9bHASW4..z0ZNl.iAMYUFZcu7U_uzAZrIuHPMegm3oAt05.KrtSGQguxgoS.szNtiWq3fI_ZIgSN
 EV0PJpP2D_nZR7YgMpNkoyXVDvwseXhEtVXGUc3tc08Gs0aLWjN6p3qFHo0XnUIp2tg4SSOFVfLd
 gQZMI3ZpAHamfNlYhnQ51BPOZuHn.5N7D7MLAcKPwFskzWrlA6BAkD3uJ9hTzxG.p8ezPPELlU57
 TAirLQ7.KmRNyYu6Id_va4qPqnjmpT2u8Cm27I.yhQRCxnyp8
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Fri, 4 Oct 2019 17:08:16 +0000
Date:   Fri, 4 Oct 2019 17:08:15 +0000 (UTC)
From:   "Mr. Fola Oladipo Adebowale" <accdept68@gmail.com>
Reply-To: mr.folaoladipo@aol.com
Message-ID: <2116419410.3763524.1570208895405@mail.yahoo.com>
Subject: For Our Mutual Benefits
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Attention:

As=C2=A0the=C2=A0Director=C2=A0of=C2=A0Finance=C2=A0and=C2=A0Accounts=C2=A0=
with=C2=A0the=C2=A0Federal=C2=A0Ministry=C2=A0of=C2=A0Power=C2=A0&=C2=A0Hou=
sing.=C2=A0I=C2=A0am=C2=A0in=C2=A0a=C2=A0position=C2=A0to=C2=A0facilitate=
=C2=A0immediate=C2=A0transfer=C2=A0of=C2=A0(Twenty=C2=A0Eight=C2=A0Million=
=C2=A0United=C2=A0States=C2=A0Dollars)=C2=A0to=C2=A0any=C2=A0of=C2=A0your=
=C2=A0nominated=C2=A0bank=C2=A0account.

Source=C2=A0of=C2=A0funds:=C2=A0An=C2=A0over-invoiced=C2=A0payment=C2=A0fro=
m=C2=A0a=C2=A0past=C2=A0project=C2=A0executed=C2=A0in=C2=A0my=C2=A0departme=
nt.=C2=A0I=C2=A0cannot=C2=A0successfully=C2=A0achieve=C2=A0this=C2=A0transa=
ction=C2=A0without=C2=A0presenting=C2=A0you=C2=A0as=C2=A0foreign=C2=A0contr=
actor=C2=A0who=C2=A0will=C2=A0provide=C2=A0the=C2=A0bank=C2=A0account=C2=A0=
to=C2=A0receive=C2=A0the=C2=A0funds.=C2=A0Every=C2=A0documentation=C2=A0for=
=C2=A0the=C2=A0claim=C2=A0of=C2=A0the=C2=A0funds=C2=A0will=C2=A0be=C2=A0leg=
ally=C2=A0processed=C2=A0and=C2=A0documented,=C2=A0so=C2=A0I=C2=A0will=C2=
=A0need=C2=A0your=C2=A0full=C2=A0co-operation=C2=A0for=C2=A0our=C2=A0mutual=
=C2=A0benefits.

We=C2=A0will=C2=A0discuss=C2=A0details=C2=A0if=C2=A0you=C2=A0are=C2=A0inter=
ested=C2=A0to=C2=A0work=C2=A0with=C2=A0me=C2=A0to=C2=A0secure=C2=A0this=C2=
=A0funds,=C2=A0as=C2=A0I=C2=A0said=C2=A0for=C2=A0our=C2=A0mutual=C2=A0benef=
its.=C2=A0I=C2=A0will=C2=A0be=C2=A0looking=C2=A0forward=C2=A0to=C2=A0your=
=C2=A0prompt=C2=A0response.

BEST=C2=A0REGARDS
MR=C2=A0FOLA=C2=A0OLADIPO=C2=A0ADEBOWALE
(DIRECTOR=C2=A0FINANCE=C2=A0AND=C2=A0ACCOUNTS)
FEDERAL=C2=A0MINISTRY=C2=A0OF=C2=A0POWER,=C2=A0WORKS=C2=A0&=C2=A0HOUSING
