Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D07C26B0
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 22:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfI3Ui5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 16:38:57 -0400
Received: from sonic317-32.consmr.mail.ne1.yahoo.com ([66.163.184.43]:38175
        "EHLO sonic317-32.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730183AbfI3Ui4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 16:38:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1569875934; bh=fOz5QQCpL6U5K407Bkt/I+DQVaJFnbfKvGDRJpSmvDM=; h=Date:From:Reply-To:Subject:From:Subject; b=joSeYv5LCcpVvBtnM5oI+zAdoMQULABKsu2d84JYCNdluFQy7HlHB0+trpaKxrUOJjFTezPklpu69SuMy/PXj8+XL87vJuYV97RNMpfiwWVoBy0witRZpw+xdReiXUtuzr3tOeW0DOsXXl4MKB2t6xQH4CM2LS+q98tz27EMvQSIDkRENkNqBcSMhQpUkdd/nqE6LL0GUD4zN/z3LrrNjz1DVcW+CKacIx/C7E/OyHZ8iKZFmsan9je+Me9l6SeZ5I5j+WKCf8UoEKBa2AuaRbgrPOYCPGiIigKvz09CgvrjXMv8rIf2HQIcgUzii4XU1Z2p+ovIceZxI5aMQeKyZQ==
X-YMail-OSG: YGIy2Y4VM1lSPqJjbbDcY9Ky12zJaXiTfPsnc7aKwug4zDJKYPfh9l6btGPci57
 _kT63JbIhZEVWQx4iyISGh87LLLC4vG5iolIqVXxiyQH4WXSLSAtRlvezqjedRnkOfM3aP1BNi_Z
 _7hZ9elAmXzUV.aZdI0o5PkQWVbc5hmgNfs2UJh5vY6Bad4SZKrgJ9cdI75V5MHgl8f_D.kM19c_
 5tkkSEY3V_4IPSUpYdeevDg2LFdSUyf9rM7yMm6dgAECG.b.JgNIFS89n0O3gaE6N20LRDrEZztd
 OdEcDGy5cblNSSleErLOAQneB4uFJCBHSjBFSrJUnqj_3d4EwKHnPk3mHKY4WhTNlzOjLyLJ_Jj_
 Ji_8gul0FyjkQ6JDJzUIS4qTaIFVSW3A8fJoF48F_52w3UsT3BpIkXng7Bo6EG.cO34OKK1_ZqFH
 s5lcah11gl5TIDBsNVBm3cNPtSIVRnJNcJr.BwNbERqOA2WAA7m0LhS8zXnW_oa2BThu84AAYt_I
 0OoeWGKrdcqolQ8C5d4N652kGI..Fdf_sQwVp8tctfvrf08Yn0IIgyrSOmGPbCJSnlYuPvKdtLis
 LlBPZ36vc02uV5sXUbMLDeyWwkoEIrvMb1wL51AT4OXFdW4vODDImP3Njk5Yw8wS0JV6kDVf9IMl
 J48UYjiJhVkJ6C0ctvb0NawAFwjjjnN6KY1wNTC3tNEn_4kVt.QfPZSUHD_OiVntuBbRzgmqfasQ
 rtwVL7_teDDh_oEeTuo2VXCNNzWYLXbrGOHl1Zp5XTgHdPTTj0pQCWX.ikKtuSf7dMbSS1Hn6nZD
 gviZ14.Rps9xKDDpoKaXkl9q3j3RxE9gZ7CqwgmKXgjHE7C3Ub9ZS4ibiMwPlPkfaoy3fFt.9UFM
 lK0xSM6bO2rCU_T_uGM8tRYFvew_PwikJbL.pXjHLRtJkS3JQhyk.E.WXCsTt4CRXaFSEK_9iUM3
 MB._7qBYzu4ZWVgdzradsoXerByjgleRaal4wuc_Fjc3HelzXZnKhVAx1xf5btCk2ztsLWt.YXY9
 hSrqxMaCl4CjAkuRAJUYGSpIt5D39qIsNi12Xd0dRXvvXVooE38EGI6Yk4dBU9aaysS.ImrorLlZ
 NaecFX5AM.hPwIqPLFXR_6DQEY7yYbpoe_eJS0t_vkvUWWyy0YU_U_42VmUTB_EjvTPBZY29Zc34
 qz2qGW9OMzddraOxNyp3pi91w4KRtvPtRaXTL6KPFrZGvi9A2gqvcOeEgkd7HKDcn3X1yA0PI__6
 g7apKjh2cuWJI9JNd67uWcah.V9cIAasIMxUCOA76o9Jc.o9ht_bM9lzMJdFjKg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Mon, 30 Sep 2019 20:38:54 +0000
Date:   Mon, 30 Sep 2019 20:08:46 +0000 (UTC)
From:   Amira Omran <ibrahimamira429@gmail.com>
Reply-To: amiraomran01@gmail.com
Message-ID: <1646906139.1627714.1569874126489@mail.yahoo.com>
Subject: Greetings
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My=C2=A0Dearest=C2=A0One,

Good=C2=A0day=C2=A0and=C2=A0how=C2=A0are=C2=A0you=C2=A0doing=C2=A0today.=C2=
=A0I'm=C2=A0really=C2=A0delighted=C2=A0to=C2=A0communicate=C2=A0with=C2=A0y=
ou=C2=A0and=C2=A0I=C2=A0believe=C2=A0we=C2=A0can=C2=A0achieve=C2=A0everythi=
ng=C2=A0together=C2=A0and=C2=A0create=C2=A0something=C2=A0great=C2=A0in=C2=
=A0nearest=C2=A0future.=C2=A0My=C2=A0name=C2=A0is=C2=A0Ms.=C2=A0Amira=C2=A0=
Omran=C2=A0Hussain=C2=A0Ibrahim=C2=A0=C2=A0and=C2=A0I'm=C2=A0a=C2=A0young=
=C2=A0girl=C2=A0of=C2=A024=C2=A0year=C2=A0old=C2=A0from=C2=A0Kobani=C2=A0a=
=C2=A0city=C2=A0in=C2=A0the=C2=A0Aleppo=C2=A0Governorate=C2=A0in=C2=A0North=
ern=C2=A0Syria=C2=A0and=C2=A0presently,=C2=A0I'm=C2=A0residing=C2=A0in=C2=
=A0the=C2=A0Republic=C2=A0of=C2=A0Burkina=C2=A0Faso=C2=A0as=C2=A0a=C2=A0ref=
ugee=C2=A0due=C2=A0to=C2=A0killing=C2=A0of=C2=A0my=C2=A0parents=C2=A0by=C2=
=A0the=C2=A0ISIS=C2=A0fighters=C2=A0on=C2=A0the=C2=A0year=C2=A02015=C2=A0po=
pularly=C2=A0know=C2=A0as=C2=A0"Kobani=C2=A0Massacre"=C2=A0that=C2=A0was=C2=
=A0carried=C2=A0out=C2=A0by=C2=A0the=C2=A0Daesh/ISIS=C2=A0fighters.=C2=A0Pl=
ease=C2=A0don't=C2=A0be=C2=A0discouraged=C2=A0for=C2=A0hearing=C2=A0this.=
=C2=A0I=C2=A0believe=C2=A0deep=C2=A0down=C2=A0inside=C2=A0me=C2=A0that=C2=
=A0you=C2=A0will=C2=A0never=C2=A0break=C2=A0my=C2=A0heart=C2=A0or=C2=A0let=
=C2=A0me=C2=A0down=C2=A0in=C2=A0anyway.

My=C2=A0beloved=C2=A0father(Mr.Omran=C2=A0Hussain=C2=A0Ibrahim=C2=A0)=C2=A0=
was=C2=A0the=C2=A0Mayor=C2=A0of=C2=A0the=C2=A0city=C2=A0of=C2=A0Kobani=C2=
=A0and=C2=A0also=C2=A0the=C2=A0Head=C2=A0of=C2=A0Aleppo=C2=A0Investment=C2=
=A0Authority.=C2=A0The=C2=A0brutal=C2=A0killing=C2=A0of=C2=A0my=C2=A0father=
=C2=A0took=C2=A0place=C2=A0one=C2=A0early=C2=A0morning=C2=A0by=C2=A0the=C2=
=A0Daesh/ISIS=C2=A0fighters=C2=A0as=C2=A0a=C2=A0result=C2=A0of=C2=A0the=C2=
=A0ongoing=C2=A0civil=C2=A0war=C2=A0in=C2=A0Syria.=C2=A0I=C2=A0was=C2=A0in=
=C2=A0my=C2=A0first=C2=A0year=C2=A0in=C2=A0the=C2=A0University=C2=A0of=C2=
=A0Aleppo=C2=A0studying=C2=A0Arts=C2=A0and=C2=A0Humanities=C2=A0before=C2=
=A0the=C2=A0sad=C2=A0incident=C2=A0and=C2=A0that=C2=A0led=C2=A0to=C2=A0the=
=C2=A0death=C2=A0of=C2=A0my=C2=A0beloved=C2=A0father.=C2=A0I=C2=A0know=C2=
=A0that=C2=A0it=C2=A0is=C2=A0too=C2=A0early=C2=A0to=C2=A0disclose=C2=A0my=
=C2=A0life=C2=A0story=C2=A0to=C2=A0you=C2=A0but=C2=A0please=C2=A0bear=C2=A0=
with=C2=A0me.=C2=A0My=C2=A0living=C2=A0condition=C2=A0is=C2=A0very=C2=A0cri=
tical,=C2=A0please=C2=A0I=C2=A0need=C2=A0your=C2=A0possible=C2=A0help=C2=A0=
to=C2=A0reclaim=C2=A0my=C2=A0inheritance=C2=A0and=C2=A0start=C2=A0a=C2=A0ne=
w=C2=A0life.=C2=A0My=C2=A0uncle=C2=A0have=C2=A0sought=C2=A0to=C2=A0kill=C2=
=A0me=C2=A0so=C2=A0that=C2=A0he=C2=A0will=C2=A0have=C2=A0full=C2=A0control=
=C2=A0of=C2=A0my=C2=A0father's=C2=A0estate=C2=A0but=C2=A0I=C2=A0am=C2=A0hap=
py=C2=A0that=C2=A0all=C2=A0his=C2=A0evil=C2=A0failed.

Meanwhile,=C2=A0I=C2=A0decided=C2=A0to=C2=A0travel=C2=A0abroad=C2=A0in=C2=
=A0order=C2=A0to=C2=A0secure=C2=A0my=C2=A0future=C2=A0but=C2=A0the=C2=A0pro=
blem=C2=A0is=C2=A0that=C2=A0since=C2=A0I=C2=A0don't=C2=A0have=C2=A0an=C2=A0=
international=C2=A0passport,=C2=A0I=C2=A0cannot=C2=A0be=C2=A0allowed=C2=A0t=
o=C2=A0enter=C2=A0any=C2=A0Country=C2=A0freely=C2=A0and=C2=A0legally.=C2=A0=
However,=C2=A0the=C2=A0only=C2=A0choice=C2=A0for=C2=A0me=C2=A0was=C2=A0to=
=C2=A0enter=C2=A0Turkey,=C2=A0because=C2=A0it=C2=A0is=C2=A0not=C2=A0far=C2=
=A0from=C2=A0Kobani=C2=A0and=C2=A0many=C2=A0people=C2=A0are=C2=A0crossing=
=C2=A0to=C2=A0Turkey=C2=A0so=C2=A0I=C2=A0joined=C2=A0them=C2=A0and=C2=A0cro=
ssed=C2=A0over=C2=A0to=C2=A0Turkey.=C2=A0It=C2=A0was=C2=A0in=C2=A0my=C2=A0p=
resence=C2=A0that=C2=A0the=C2=A0Turkish=C2=A0soldiers=C2=A0gunned=C2=A0down=
=C2=A0Kader=C2=A0Ortakaya=C2=A0a=C2=A0famous=C2=A0woman=C2=A0activist=C2=A0=
at=C2=A0the=C2=A0Turkey=C2=A0and=C2=A0Syria=C2=A0border.=C2=A0A=C2=A0lot=C2=
=A0happened=C2=A0during=C2=A0this=C2=A0conflict,=C2=A0it=C2=A0was=C2=A0awfu=
l,=C2=A0I=C2=A0only=C2=A0thank=C2=A0God=C2=A0that=C2=A0I'm=C2=A0alive=C2=A0=
today.

I=C2=A0arrived=C2=A0to=C2=A0Burkina=C2=A0Faso=C2=A0through=C2=A0the=C2=A0he=
lp=C2=A0of=C2=A0International=C2=A0Red=C2=A0Cross=C2=A0and=C2=A0Red=C2=A0Cr=
escent=C2=A0Movement,=C2=A0they=C2=A0were=C2=A0moving=C2=A0people=C2=A0away=
=C2=A0from=C2=A0the=C2=A0Turkish=C2=A0border=C2=A0because=C2=A0of=C2=A0the=
=C2=A0insecurity=C2=A0of=C2=A0the=C2=A0border,=C2=A0so=C2=A0they=C2=A0moved=
=C2=A0some=C2=A0people=C2=A0to=C2=A0Canada,=C2=A0some=C2=A0to=C2=A0Germany=
=C2=A0and=C2=A0Italy=C2=A0and=C2=A0few=C2=A0to=C2=A0Morocco=C2=A0and=C2=A0B=
urkina=C2=A0Faso.=C2=A0I=C2=A0decided=C2=A0to=C2=A0come=C2=A0to=C2=A0Burkin=
a=C2=A0Faso,=C2=A0because=C2=A0when=C2=A0my=C2=A0beloved=C2=A0father=C2=A0w=
as=C2=A0alive,=C2=A0he=C2=A0revealed=C2=A0to=C2=A0me=C2=A0about=C2=A0the=C2=
=A0sum=C2=A0of=C2=A0$27.5=C2=A0Million=C2=A0which=C2=A0he=C2=A0deposited=C2=
=A0in=C2=A0one=C2=A0of=C2=A0the=C2=A0Banks=C2=A0in=C2=A0Burkina=C2=A0Faso=
=C2=A0with=C2=A0my=C2=A0name=C2=A0as=C2=A0his=C2=A0next=C2=A0of=C2=A0kin.=
=C2=A0On=C2=A0my=C2=A0arrival=C2=A0to=C2=A0Ouagadougou,=C2=A0where=C2=A0the=
=C2=A0Bank=C2=A0is=C2=A0located,=C2=A0I=C2=A0contacted=C2=A0them=C2=A0to=C2=
=A0clear=C2=A0the=C2=A0money,=C2=A0but=C2=A0the=C2=A0Branch=C2=A0operation=
=C2=A0Manager=C2=A0who=C2=A0confirmed=C2=A0the=C2=A0deposited=C2=A0amount=
=C2=A0of=C2=A0money=C2=A0told=C2=A0me=C2=A0that=C2=A0my=C2=A0status=C2=A0as=
=C2=A0a=C2=A0refugee=C2=A0according=C2=A0to=C2=A0the=C2=A0Laws=C2=A0of=C2=
=A0Burkina=C2=A0Faso=C2=A0does=C2=A0not=C2=A0permit=C2=A0me=C2=A0to=C2=A0en=
gage=C2=A0in=C2=A0any=C2=A0Bank=C2=A0transaction.=C2=A0He=C2=A0advised=C2=
=A0me=C2=A0to=C2=A0nominate=C2=A0a=C2=A0trustee=C2=A0who=C2=A0will=C2=A0sta=
nd=C2=A0on=C2=A0my=C2=A0behalf=C2=A0and=C2=A0carry=C2=A0out=C2=A0the=C2=A0o=
peration.=C2=A0This=C2=A0has=C2=A0become=C2=A0necessary=C2=A0after=C2=A0I=
=C2=A0have=C2=A0been=C2=A0denied=C2=A0the=C2=A0right=C2=A0to=C2=A0own=C2=A0=
a=C2=A0Bank=C2=A0account=C2=A0or=C2=A0perform=C2=A0other=C2=A0forms=C2=A0of=
=C2=A0financial=C2=A0transaction=C2=A0here=C2=A0because=C2=A0I=C2=A0am=C2=
=A0a=C2=A0political=C2=A0asylum=C2=A0seeker.=C2=A0So,=C2=A0I=C2=A0decided=
=C2=A0to=C2=A0get=C2=A0in=C2=A0touch=C2=A0with=C2=A0you=C2=A0so=C2=A0that=
=C2=A0you=C2=A0will=C2=A0help=C2=A0me=C2=A0with=C2=A0the=C2=A0transfer=C2=
=A0of=C2=A0this=C2=A0money=C2=A0into=C2=A0your=C2=A0Bank=C2=A0account=C2=A0=
for=C2=A0investment=C2=A0in=C2=A0your=C2=A0Country.=C2=A0=C2=A0After=C2=A0y=
ou=C2=A0have=C2=A0received=C2=A0the=C2=A0money=C2=A0in=C2=A0your=C2=A0Bank=
=C2=A0account,=C2=A0=C2=A0you=C2=A0will=C2=A0send=C2=A0me=C2=A0some=C2=A0am=
ount=C2=A0of=C2=A0money=C2=A0to=C2=A0process=C2=A0my=C2=A0traveling=C2=A0pa=
pers=C2=A0because=C2=A0I=C2=A0want=C2=A0to=C2=A0relocate=C2=A0to=C2=A0your=
=C2=A0Country=C2=A0where=C2=A0I=C2=A0will=C2=A0start=C2=A0a=C2=A0new=C2=A0l=
ife=C2=A0with=C2=A0you.=C2=A0=C2=A0And=C2=A0I=C2=A0intend=C2=A0to=C2=A0comp=
lete=C2=A0my=C2=A0academic=C2=A0studies=C2=A0in=C2=A0your=C2=A0Country.=C2=
=A0=C2=A0I=C2=A0accept=C2=A0to=C2=A0share=C2=A0my=C2=A0life=C2=A0with=C2=A0=
you=C2=A0and=C2=A0give=C2=A0you=C2=A0all=C2=A0my=C2=A0attention=C2=A0from=
=C2=A0day=C2=A0one=C2=A0of=C2=A0the=C2=A0meetings.

Immediately=C2=A0you=C2=A0confirm=C2=A0your=C2=A0interest=C2=A0to=C2=A0help=
=C2=A0me,=C2=A0then=C2=A0I=C2=A0will=C2=A0give=C2=A0you=C2=A0more=C2=A0deta=
ils=C2=A0as=C2=A0to=C2=A0how=C2=A0we=C2=A0shall=C2=A0conclude=C2=A0this=C2=
=A0transaction.=C2=A0Please=C2=A0do=C2=A0let=C2=A0me=C2=A0know=C2=A0if=C2=
=A0you=C2=A0are=C2=A0interested=C2=A0in=C2=A0helping=C2=A0me=C2=A0with=C2=
=A0the=C2=A0transfer=C2=A0of=C2=A0the=C2=A0money=C2=A0into=C2=A0your=C2=A0b=
ank=C2=A0account=C2=A0for=C2=A0possible=C2=A0investment=C2=A0in=C2=A0your=
=C2=A0Country=C2=A0so=C2=A0that=C2=A0I=C2=A0will=C2=A0send=C2=A0you=C2=A0mo=
re=C2=A0details=C2=A0on=C2=A0how=C2=A0you=C2=A0will=C2=A0stand=C2=A0as=C2=
=A0my=C2=A0trustee=C2=A0and=C2=A0finalize=C2=A0the=C2=A0transaction=C2=A0wi=
th=C2=A0the=C2=A0Bank=C2=A0where=C2=A0my=C2=A0dad=C2=A0deposited=C2=A0the=
=C2=A0money.=C2=A0I=C2=A0beg=C2=A0you=C2=A0please=C2=A0to=C2=A0keep=C2=A0th=
is=C2=A0as=C2=A0a=C2=A0top=C2=A0secret=C2=A0between=C2=A0us=C2=A0for=C2=A0c=
onfidential=C2=A0reasons.=C2=A0At=C2=A0the=C2=A0moment=C2=A0I=C2=A0am=C2=A0=
living=C2=A0in=C2=A0the=C2=A0Mission=C2=A0House.=C2=A0Life=C2=A0in=C2=A0thi=
s=C2=A0place=C2=A0is=C2=A0very=C2=A0unbearable=C2=A0because=C2=A0we=C2=A0ar=
e=C2=A0not=C2=A0allowed=C2=A0to=C2=A0go=C2=A0out=C2=A0and=C2=A0we=C2=A0are=
=C2=A0monitored=C2=A0by=C2=A0the=C2=A0Church=C2=A0security=C2=A0guard.=C2=
=A0Please=C2=A0help=C2=A0me=C2=A0because=C2=A0I=C2=A0want=C2=A0to=C2=A0leav=
e=C2=A0this=C2=A0place=C2=A0quickly=C2=A0to=C2=A0live=C2=A0my=C2=A0normal=
=C2=A0with=C2=A0you.

I=C2=A0look=C2=A0forward=C2=A0to=C2=A0hearing=C2=A0from=C2=A0you=C2=A0soon.

Yours=C2=A0truly,
Ms.Amira=C2=A0Omran=C2=A0Hussain=C2=A0Ibrahim=C2=A0.
(amiraomran01@gmail.com)
