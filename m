Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97FB20F109
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 10:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731666AbgF3I7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 04:59:04 -0400
Received: from sonic307-56.consmr.mail.ne1.yahoo.com ([66.163.190.31]:34182
        "EHLO sonic307-56.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731823AbgF3I7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 04:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1593507543; bh=ICTpPk6OHBtkNJL3JRqaYJle6OYp/MrdTJJRTueaLNk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=NbKIj4LfNtVK1KDTBUVzqdRCdUsdMwPnrpKRG8J/d9X4BjGh0fDynlf5Bu5yVORSYkeLr8jhA2jS/5KB+h5GVeJ3tRVWGnyrU6OMjgSaEoiLcvw2KXQzPlBYNYH5bi0aZIHSUFKN3SJFQGNfsB+yQDpF9sA/NyEjH3jKVXrb+5s+Z8hw5pGjLbmdy5V0y4mBWLmyaMr0mTlf0lQ+gQM/HiYvrvbvAmrL7debGZuxTe5tYmx/pHIopBIE55er9RN20od75X27SlmEdgaI8Rzbmk+TcthcbpdWF7X7ADJmLyp6ob6xtpA84TG0F0VhNkn0jiSoQc4oT5lRGnoDIR8A+g==
X-YMail-OSG: IzuJh3oVM1lwnjjcMldfefczGb2jhSl8JSf1VIbDKlOM1rqw04BdfWKQt2Q9aeU
 lFeUjWyymxoRcN8YnKNkuRV9NfMpla4rHMB0DgVkur8mW_gDCuQQiDWpsYE7I3npyuVOmHW8WbMz
 e0_UjP3JY0u0vRwgCDrDeuZhLjIMo20a6T4iXzNrPDFseu5XnmuGEm96D8VDA9nM0W4fPdwKkC9U
 LR1_zIYOSmXZn6zIg9WRwSxA2OWnWgdAYB5R5BuaIunxYzoHM4MMyzSmSbpcC8JItdTgvJikueC0
 L04X43ORudmzYhfbHaVV8v42PnqtbHMYK.fIjCor3wNwnJR4zMtCG5wIrG3Iu4q0yFX0N9lfhdhE
 lJb2LDojYqDT6QJXemiRETQPHNHA5BC9BsSyWfR0EGkLK7DMKI9nOvWGY3Vh4SnNsfWLXnZTen4p
 FJtRtDIVninooXleci6ciP80AENNvfxXBiqejpKCvjDW8N0HHjcAKVPo2W_4SLGzFjWpTbxOZeM8
 luJozVbvnD_9vucgSZitIqjG2.EgtTmwFU6w0qL2tLiKZJgIq0q3oF0o54BgcHcp_OD1RLgwTeuc
 Sd_iSo.On1hFQY0i5jJ4Eo.Ml7r6EWfa3D5TUn54oyj1UosHUPSLKEMKKLCJdCQQOQIzuFtIKsLx
 v.MkZg4X5LhvUNF1NeeEy0AmYv9OqpossPvVumO000R7ByPb6icmOuGvDuTOKSwgg4wYP.3_Mdxq
 LHtts_BA.0xB30i2p2T14_25eLKfJU9VGuLHLwRW0Z4y0SwTjMaxkVKYu6nq.mEfNUv3KodDZrHK
 nLhmtRpm_H8KZHvAnSEdw75dc5ecyD64R8xXPQTz40D7s.T2lSGS1zgni_WzuX0IzOjq2xAID0tb
 Q6IaRKJ_R5uP.qSRb1F2iSQpVRS2LBzyPdXhzSTBVggpFvSFrQW7fQyrCXtFisx0Tp92vTeSFcVp
 vHuQSxTR08POOLmuvno.Apevu01N28IHLEh6CN_pbkTCJFHudM_1mspoJ9MlZtwKBEbN_P_7_8D6
 avkYiquTxuKd.OLvL8ebDFagXtQMzBR1zC97pZoYfSljZgUAmnAvmG4s9Vx2AzgmVUDiJfasSPh9
 ex3aZCcildHCnPimfsHz2tgISvjNiyVrwZH2fslQ360cseOQYzjtUOA.JiF21hwJP7Nyn8_vbT9Q
 KYp2FD.9bJ7rY0hySMh82aGBNI242mwb8lV8q90EVKomr3EV3EsxRO5KC7E0Q10MNUTbDKujuk1I
 PsNNkhcy_v5946Fme1xyO4b7GfG8jTU_LBFK8fxvxqAYzfoMfBYUm6oEvQpp.vvA9Jkeus8_L
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Tue, 30 Jun 2020 08:59:03 +0000
Date:   Tue, 30 Jun 2020 08:58:58 +0000 (UTC)
From:   FRANK <frank_nack_2020@aol.com>
Reply-To: frank_nack_2020@yahoo.com
Message-ID: <1316942128.170821.1593507538180@mail.yahoo.com>
Subject: APPROVAL RELEASED ORDERS OF TRANSFER
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1316942128.170821.1593507538180.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16197 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:52.0) Gecko/20100101 Firefox/52.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

How are you today with your family, Hope fine? Please, it=E2=80=99s my grea=
t pleasure to contact you today. I am Mr. Frank Nack a banker by profession=
 from Burkina Faso. Please, I want our bank management to transfer an aband=
oned sum of US $7.5M United States Dollars (US$7.5M) into your bank account=
. This business is 100% risk free.

Your share will be 40% while 60% for me. More details will be forwarded to =
you with copy of my bank working ID card, photos and direct phone number im=
mediately I receive your urgent response indicating your interest to handle=
 the business transaction with me.

1) Your Full Name.......................
2) Your Private Telephone Number........
3) Your Receiving Country............

Do reply me urgent with this email address (frank_nack_2020@yahoo.com), (OR=
 +226 51 81 51 94,) for quick spend

Yours Sincerely,
Best Regard.
Mr. Frank Nack
Tell; +226 51 81 51 94,
