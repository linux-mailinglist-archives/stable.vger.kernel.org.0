Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFC8261EE7
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgIHT47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:56:59 -0400
Received: from sonic315-20.consmr.mail.ne1.yahoo.com ([66.163.190.146]:44191
        "EHLO sonic315-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730429AbgIHPgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:36:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1599579362; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=EKp+CQ3zQWfqGZVUnnCaeDn0wDmXHGVetzVvKss5io36j+WF4jUgL5V0w1HzJsYsiiJiqDJZe6Tw/Ez27V7NDM9py01C55dCIAfLGSD50YzshDPBONVRUxA0WN9T0FZpblvbsXV64zI0XNJMeMUJiNgG5wBtRWXqcK9kVUL0WpxGpKBqJcFRF/akfkWinR1MXco7bnBXeEIrq5ZV+W1pojfmBsraPf/A1Jtm3XEjyxdddepmbyZ7O/hGYLpQPy0y45oGj0uZBf8hXJT8pnBNYDU833Kb9jl7Jmv33P5eAI8rUXhe9V+8gm0rWvoprjtYgxQugr9bUKsV+aOhBvqj6g==
X-YMail-OSG: rBrRa.8VM1mdmCSKiBDTLQTtVqZk7Jka1DhhoJf.eq9fkvIrtHPhyFYtMH6H88u
 qe6774ZtFyV1Bzf3sIxZv7Nsg.T7_qTKGJK.4SVT9clpD2TUdcq0B_dkZHhgD2G3_GSRal0pGMaP
 7Zp77.3VmiEF6XSvUtevXrxOAq_n6hPLXYaF9FkIj2Dnq0SwilH6ol_yszTphjRXuxTa7hRZlRIv
 vQ_r2YQvbsTgQOd8Mla_O9bV3_BPUiKqD7KjZnwlG6Yy8iecutxEOYTRUyLJsV8YyM62_UxrzMOW
 5bwEnhqjdXBmKRdp7ZljQuKpMY82qLiCy7hWVBmKvBa_neApiXOwR6_B4ho7uib22vq4khlQJlKL
 3Q4X1n2FbQxp1LLh0Wz7X_1MXel1UiRaIQNFmLUVkE9JLjgCMGTBp2k4IC3n6GdDiPTXfzM9ZAdF
 60MUG99vWhoHk1YrHIHVTM2h2E4_cJ7pFRt_cl0SBueoZt6yIVMJt0zSuVPTWufS__3ZYigiu73y
 yWykA54.uH_PNfcL5rrHUZrEuwHtNDehU.QoBfl.Bb1C2_Wx_RwCNZY8FI_v0.vw58lsqdAlDiiM
 CWl96tLAnmHK2UDCnK1cjW3Z7TGRqT00OXjtekZWWXpMweiwx_UT.1HgV0.QdVz424WFLw37UJRJ
 wOqqJCHLKgyeLmAF0PcAnuaxzVvuVSqZIxioPWUzjMTon9QAulNagh_QUPrtDjp.rpPhe7K8DLAv
 4Ql3t4ZgE2n5ij3F1qve0qq0fQSrfLOrK6oHw85IiHiFtPrjTdvSlX0euPXFmPedJq85qerqnEZP
 eLB71LIrO3FndfCqBMgHbvNRC7BPbAsDDP4p0G7BFxT7UiRsbf.48JIOdk4TIGpmQQx5Nwb.KnlY
 f5I1eBZzuTvmtCcWEt6k1tg1lybKhvJ8jBe1B8w4NDHIRKYq1znvee8XyvimbWeCMcl5kg7PRwWl
 4W_uSjU1aBXUhrf.iZ2fgu561oSDCsj7hyxUiavkhc_mtovIxgVQAM7rylWTmAVDnD5zaSDGUPbH
 qYL_JXT4uaJ52pIss4ZG5glkIYiJul2ZmOXDN77KAiFZSRygflXdbk4JVyHU7Eyi_h.A.rpjkF1R
 XUD843RAxSZTqFXmhwP0znun2jejnX2.gzo2meyxBFoeNJUn_9ObAn9a.FXR448inUyrYE0TK.VL
 suKU267hmzr12ggfdmeVhjLdrb1oeYUwWKRro7u4CqMiaOHxp.urQjbrialDRqziAboxkX09yjgt
 p4Kt5jxHdiBowGuPkZ4YjhwbsoSmE5Y7svwJn__WwqgXtZs3TIkMp.cdDlmv2tgoha66HH75Nl.1
 4OX3H07ecLxJZm4teJ3Mlqw_sjPIAOl1iFnaSBQo8GKstHFad139IyNXBPLIIbV7EAWzpgDg6I4T
 JE_G8OxeqAMSrmQp6heyUaNqC1uu2D04p2U0lig.nciYurrb.eg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Tue, 8 Sep 2020 15:36:02 +0000
Date:   Tue, 8 Sep 2020 15:24:58 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrsminaaaliyahbrunel@gmail.com>
Reply-To: mrsminaabrunel@myself.com
Message-ID: <379109045.4372814.1599578698765@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <379109045.4372814.1599578698765.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:80.0) Gecko/20100101 Firefox/80.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



My Dear in the lord


My name is Mrs. Mina A. Brunel I am a Norway Citizen who is living in Burki=
na Faso, I am married to Mr. Brunel Patrice, a politician who owns a small =
gold company in Burkina Faso; He died of Leprosy and Radesyge, in the year =
February 2010, During his lifetime he deposited the sum of =E2=82=AC 8.5 Mi=
llion Euro) Eight million, Five hundred thousand Euros in a bank in Ouagado=
ugou the capital city of Burkina Faso in West Africa. The money was from th=
e sale of his company and death benefits payment and entitlements of my dec=
eased husband by his company.

I am sending you this message with heavy tears in my eyes and great sorrow =
in my heart, and also praying that it will reach you in good health because=
 I am not in good health, I sleep every night without knowing if I may be a=
live to see the next day. I am suffering from long time cancer and presentl=
y I am partially suffering from Leprosy, which has become difficult for me =
to move around. I was married to my late husband for more than 6 years with=
out having a child and my doctor confided that I have less chance to live, =
having to know when the cup of death will come, I decided to contact you to=
 claim the fund since I don't have any relation I grew up from an orphanage=
 home.

I have decided to donate this money for the support of helping Motherless b=
abies/Less privileged/Widows and churches also to build the house of God be=
cause I am dying and diagnosed with cancer for about 3 years ago. I have de=
cided to donate from what I have inherited from my late husband to you for =
the good work of Almighty God; I will be going in for an operation surgery =
soon.

Now I want you to stand as my next of kin to claim the funds for charity pu=
rposes. Because of this money remains unclaimed after my death, the bank ex=
ecutives or the government will take the money as unclaimed fund and maybe =
use it for selfishness and worthless ventures, I need a very honest person =
who can claim this money and use it for Charity works, for orphanages, wido=
ws and also build schools and churches for less privilege that will be name=
d after my late husband and my name.

I need your urgent answer to know if you will be able to execute this proje=
ct, and I will give you more information on how the fund will be transferre=
d to your bank account or online banking.

Thanks
Mrs. Mina A. Brunel
