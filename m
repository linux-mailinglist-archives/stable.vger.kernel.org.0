Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374536809DF
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 10:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbjA3JtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 04:49:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjA3JtL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 04:49:11 -0500
X-Greylist: delayed 512 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 01:49:07 PST
Received: from mail.gluegivebiz.com (mail.gluegivebiz.com [94.177.230.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66891D913
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 01:49:07 -0800 (PST)
Received: by mail.gluegivebiz.com (Postfix, from userid 1001)
        id C8B01826F8; Mon, 30 Jan 2023 09:40:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gluegivebiz.com;
        s=mail; t=1675071632;
        bh=5n0LayKpRHsZMclE7BidCW6LDGRdzRVHcrHQCq8kNN4=;
        h=Date:From:To:Subject:From;
        b=Gps7ypI+V1k9jwvK4jZIx/CJ03LdT+Wncy/7MyGOw4H2gNxrs76UNAMwl5I1R8PGv
         m4UcYBYclZukjDmqpHHa+ix62IWYAgYPJ0hBcAAQazhvtsn+ErTatwlWUHkyevMPuP
         DHjMtSeAhnGhhfgAoMCrS0+Q+AJfktbGbKs2PbT85FJ8lEAdLGrIIVF4F7VQOcncM7
         PY9QaoYq/RWKdPv2M+8We8vY1lHBuNdA87sEr0FhkTLo8Q1oMmDpR11C9eLr447etd
         CCM8/3ayOdHCUtVrNAZ2b8KUKgFTO7phzS+2ewJLmpODLXvif3kCP8i15ky4QIVuay
         4iq72ZadbTugw==
Received: by mail.gluegivebiz.com for <stable@vger.kernel.org>; Mon, 30 Jan 2023 09:40:07 GMT
Message-ID: <20230130084706-0.1.11.2qdg.0.gm2xduoqzj@gluegivebiz.com>
Date:   Mon, 30 Jan 2023 09:40:07 GMT
From:   =?UTF-8?Q? "Vil=C3=A9m_Du=C5=A1ek" ?= 
        <vilem.dusek@gluegivebiz.com>
To:     <stable@vger.kernel.org>
Subject: =?UTF-8?Q?Tepeln=C3=A9_obr=C3=A1b=C4=9Bn=C3=AD_=E2=80=93_objedn=C3=A1vka?=
X-Mailer: mail.gluegivebiz.com
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dobr=C3=BD den,

m=C3=A1te z=C3=A1jem o vyu=C5=BEit=C3=AD velmi kvalitn=C3=AD slu=C5=BEby =
tepeln=C3=A9ho obr=C3=A1b=C4=9Bn=C3=AD kov=C5=AF?

M=C5=AF=C5=BEeme v=C3=A1m nab=C3=ADdnout velmi v=C3=BDhodn=C3=A9 podm=C3=AD=
nky spolupr=C3=A1ce, technick=C3=A9 poradenstv=C3=AD, s=C3=A9riovou v=C3=BD=
robu a testov=C3=A1n=C3=AD prototyp=C5=AF.

Specializujeme se na tradi=C4=8Dn=C3=AD a vakuov=C3=A9 technologie: cemen=
tov=C3=A1n=C3=AD, nitrocementov=C3=A1n=C3=AD, kalen=C3=AD v plynu, zu=C5=A1=
lecht=C4=9Bn=C3=AD, =C5=BE=C3=ADh=C3=A1n=C3=AD, p=C3=A1jen=C3=AD, normali=
za=C4=8Dn=C3=AD =C5=BE=C3=ADh=C3=A1n=C3=AD (s p=C5=99ekrystalizac=C3=AD).

M=C3=A1me k dispozici rozs=C3=A1hl=C3=A9 strojn=C3=AD vybaven=C3=AD, velk=
=C3=BD t=C3=BDm odborn=C3=ADk=C5=AF, a proto jsme schopni se p=C5=99izp=C5=
=AFsobit va=C5=A1im po=C5=BEadavk=C5=AFm.

Pracujeme v souladu s na=C5=A1imi certifik=C3=A1ty v rozsahu norem platn=C3=
=BDch v oblasti automobilov=C3=A9ho pr=C5=AFmyslu (IATF 16949; CQI 9) a t=
ak=C3=A9 letectv=C3=AD (akreditace NADCAP).

Pokud m=C3=A1te po=C5=BEadavky v t=C3=A9to oblasti, r=C3=A1d v=C3=A1m p=C5=
=99edstav=C3=ADm na=C5=A1e mo=C5=BEnosti.

Mohl bych v=C3=A1m zatelefonovat?


Vil=C3=A9m Du=C5=A1ek
