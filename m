Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395DF1C99A9
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 20:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgEGSsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 14:48:04 -0400
Received: from sonic313-20.consmr.mail.sg3.yahoo.com ([106.10.240.79]:45176
        "EHLO sonic313-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726598AbgEGSsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 14:48:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1588877278; bh=+X/e7zmFn4b7c28Xaqeh8O5rMGj3OdJTyFAsbLudSBU=; h=Date:From:Reply-To:Subject:References:From:Subject; b=TutSLLANXzJzR49FCpNRHFJ7A7WdgwcYHVDgb6ARN/H6tJJk7u2NWYFT0cG9A98iWIETfr5ieQKcxdvg0dQ+ulwSlibd9MEoNK+eMUf4poCd0m/KSz3G4T0nDZJEQRvvd+R0C+QNfiA/lJwYdZKH6yHQXcOi4RlGS+tVCx+POV7H2Y7s4OG373JdJ0LYKSI5wFiFa7ZeRNlQ9kS6rKX0smROuyBakwDZyRgI3OiIHYK/B9XPRSQZ4vlC0K4P/YU1wZN6dfi6rqj5QMxWEMfVxIUBgrSx9WqB4C+8CbzjyWeuASw51lYcwX+Ru5v9sm2IF2o58bOcom93UpgwTRs+cw==
X-YMail-OSG: 4F4ajjMVM1lB_6mJRyj1mVQjGQRWYyd84UjtdkubNpCjlQ0_YfbmiLrVe1yr2dk
 oTSEE864mq2wa74Z2LKCK_FTp.BmkEp4mnA.entJu6Xw_p2EhLXwUxCr.n2ogov2nmodhkYZN81Y
 KN.8lmB9oETyXSzj2995SIyUg4fVqKust2Ty8ZYtpXjhul35h6vLwEoAZUvEYVYOhKzwJD2UeS5.
 UCJ71jU2vryF37Vj6X8pbclq3mOA.hVCUuWDX4KutHxnvq1fV8YALlDpEq.JOSFYRscVd_Vvq4I8
 cuveuKnHEdbHhOgmX.y2F6_X4FDXcoTBmCottUDkfZIMeyNw0oc1HOEjX.2k05aso_z84GkNee.e
 vvzlL3oIwkl70O9gKiXOTazQ3nZHym846SH6iT_7L0Bux.pPXzHFVB6E7R.R6V.hjIRAFEK4y6Jh
 Uq_PsALnEL.VYJWeF1g43hybL0tZ1pIl_fvNSo5GaDOKpKOk_7lcBoUV7SLAImDRIqpeToo_eAxg
 dI5LpvFuvsGihRFFjuc9O7TKjjRGW.XfTlNdEudRd0wiIlZVC31htBzJBd7vJCYwnHQpsJ7695qt
 vYmSRkpnpUZQ7.rux.BxSEg9oxbrhNTi5WUAf2IFPyFgwgwpgy4ZY.2yYSW_wVm_fGkpsycgsyw8
 O1QByEBwGU_htkQYslGTeOgvpSZNLz7uiYxgH2zlMbLgn__UycUL8YYkHGTkH0QDzHpSjcZ0sO24
 qKWWdYbDQFDUONa6X7NDNlFHjqUaPiDHu2cCInt.nie5UxNh92VjTZ.R2Yd9jmWar1sz3yPaO6e9
 UI52VWfbhTwRt7xbjWqvVV3W0YkDV1IhPsAKFQK2lN66IwFLDTDdvdH2A933g__HmKlS47nSQ_tB
 kRJLWtZqS_xD9zzEwtOvVlT0XoLfVIkSfzYTfJp42pmkdF9eKQsyB64w_XawLfaPpfSVW.9Lcs8o
 LrlT7oJbO_xRaekHNXDoVSjdv6EHISjj4RVfL0lWLmfWb3Sn0So9EAOyTINbKNgjenwtLP.0ORNe
 fcx0kzHAzIfirrNPQ.pHffWe0R4j4NuAuTBe2n3bSvx3qedSM16quHuDmmx1PnaLVfaGtU.IbYHF
 x.cpCd2bdrZM8IKiQRaF84HKobk8YuR5MqXOovrRv7btPQOxDsp7WMdNMNMuBgDEA.JB1lb06zk.
 QzormQ3tMYcayzieEL32eWuIBABfoxfpgRCUa4FlMDr4vz0.J7N.MW4mn7V3mAVzzhHmI6Llwzus
 LJNYFy5DDtaFLU6V3aM_0CfZvYp3iRfIypb8oLxqxfrptE8Z9fnefjfszirSo4gELBIBLlXujrXg
 yBb72
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.sg3.yahoo.com with HTTP; Thu, 7 May 2020 18:47:58 +0000
Date:   Thu, 7 May 2020 18:47:55 +0000 (UTC)
From:   Nola Mary Zem <nolamarryzem@gmail.com>
Reply-To: nolamarryzem@gmail.com
Message-ID: <1044176337.1944292.1588877275072@mail.yahoo.com>
Subject: Dear Friend
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1044176337.1944292.1588877275072.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15756 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:75.0) Gecko/20100101 Firefox/75.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings

On=C2=A0behalf=C2=A0of=C2=A0Almighty=C2=A0Jehovah=C2=A0and=C2=A0Lord=C2=A0J=
esus=C2=A0Christ,=C2=A0who=C2=A0give=C2=A0all=C2=A0good=C2=A0things,=C2=A0w=
e=C2=A0greet=C2=A0Calvary.=C2=A0I=C2=A0know=C2=A0this=C2=A0letter=C2=A0will=
=C2=A0come=C2=A0as=C2=A0a=C2=A0big=C2=A0surprise=C2=A0to=C2=A0you,=C2=A0but=
=C2=A0I=C2=A0beg=C2=A0you=C2=A0to=C2=A0take=C2=A0the=C2=A0time=C2=A0to=C2=
=A0read=C2=A0it=C2=A0carefully=C2=A0as=C2=A0the=C2=A0decisions=C2=A0you=C2=
=A0make=C2=A0will=C2=A0go=C2=A0a=C2=A0long=C2=A0way=C2=A0in=C2=A0determinin=
g=C2=A0my=C2=A0future=C2=A0and=C2=A0my=C2=A0existence.

I'm=C2=A0Nola=C2=A0Mary=C2=A0Zem=C2=A0from=C2=A0New=C2=A0Zealand,=C2=A0a=C2=
=A058-year-old=C2=A0widow.=C2=A0I=C2=A0have=C2=A0no=C2=A0children=C2=A0and=
=C2=A0suffer=C2=A0from=C2=A0long-term=C2=A0cancer=C2=A0disease.=C2=A0I=C2=
=A0have=C2=A0a=C2=A0fund=C2=A0that=C2=A0I=C2=A0inherited=C2=A0from=C2=A0my=
=C2=A0husband=C2=A0late=C2=A0for=C2=A0$=C2=A09.7=C2=A0million,=C2=A0and=C2=
=A0I=C2=A0need=C2=A0a=C2=A0very=C2=A0honest=C2=A0and=C2=A0God-fearing=C2=A0=
person=C2=A0who=C2=A0can=C2=A0withdraw=C2=A0this=C2=A0money=C2=A0and=C2=A0u=
se=C2=A0it=C2=A0for=C2=A0charities.=C2=A0I=C2=A0would=C2=A0like=C2=A0to=C2=
=A0provide=C2=A0this=C2=A0fund=C2=A0for=C2=A0charity=C2=A0work.=C2=A0After=
=C2=A0praying=C2=A0to=C2=A0Jehovah,=C2=A0I=C2=A0saw=C2=A0your=C2=A0email=C2=
=A0through=C2=A0a=C2=A0personal=C2=A0internet=C2=A0search,=C2=A0and=C2=A0if=
=C2=A0you=C2=A0are=C2=A0willing=C2=A0to=C2=A0take=C2=A0care=C2=A0to=C2=A0ma=
nage=C2=A0this=C2=A0trust=C2=A0and=C2=A0funds=C2=A0to=C2=A0fulfill=C2=A0you=
r=C2=A0last=C2=A0wishes=C2=A0before=C2=A0you=C2=A0die,=C2=A0I=C2=A0decided=
=C2=A0to=C2=A0contact=C2=A0you.=C2=A0I've=C2=A0been=C2=A0trying=C2=A0to=C2=
=A0manage=C2=A0this=C2=A0project=C2=A0myself=C2=A0for=C2=A04=C2=A0years,=C2=
=A0but=C2=A0this=C2=A0is=C2=A0no=C2=A0longer=C2=A0possible.

The=C2=A0rest=C2=A0hopes=C2=A0to=C2=A0use=C2=A030%=C2=A0of=C2=A0the=C2=A0to=
tal=C2=A0amount=C2=A0to=C2=A0help=C2=A0you=C2=A0carry=C2=A0out=C2=A0the=C2=
=A0project=C2=A0while=C2=A0doing=C2=A0God's=C2=A0work.=C2=A0I=C2=A0desperat=
ely=C2=A0need=C2=A0your=C2=A0help=C2=A0and=C2=A0I=C2=A0have=C2=A0the=C2=A0c=
ourage=C2=A0to=C2=A0contact=C2=A0you=C2=A0about=C2=A0this.=C2=A0Don't=C2=A0=
let=C2=A0me=C2=A0down=C2=A0and=C2=A0millions=C2=A0of=C2=A0poor=C2=A0people=
=C2=A0in=C2=A0the=C2=A0world=C2=A0today.=C2=A0There=C2=A0are=C2=A0no=C2=A0r=
isks=C2=A0associated=C2=A0with=C2=A0stealing=C2=A0money=C2=A0or=C2=A0100%=
=C2=A0SAFE.=C2=A0If=C2=A0your=C2=A0funds=C2=A0are=C2=A0available=C2=A0to=C2=
=A0charities,=C2=A0let=C2=A0us=C2=A0know=C2=A0immediately.=C2=A0I=C2=A0don'=
t=C2=A0want=C2=A0anything=C2=A0that=C2=A0would=C2=A0jeopardize=C2=A0my=C2=
=A0last=C2=A0wish,=C2=A0so=C2=A0thanks=C2=A0for=C2=A0your=C2=A0utmost=C2=A0=
secrecy=C2=A0and=C2=A0trust=C2=A0in=C2=A0this=C2=A0matter=C2=A0to=C2=A0fulf=
ill=C2=A0my=C2=A0wish=C2=A0for=C2=A0my=C2=A0heart.

God=C2=A0bless=C2=A0you
Nola=C2=A0Mary=C2=A0Zem
