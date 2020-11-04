Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56A52A5D5C
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 05:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgKDE3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 23:29:52 -0500
Received: from sonic317-16.consmr.mail.ne1.yahoo.com ([66.163.184.235]:42774
        "EHLO sonic317-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727385AbgKDE3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 23:29:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604464189; bh=NenO61agpJ8GjWgLE09biO1/EgCvBbxxddNwbDZctnU=; h=Date:From:Reply-To:Subject:References:From:Subject; b=iuZm/H9b/8P+Q2TGtFW225bfQ+5Pk9Gw0oWJuGquwDa1ygPWTrCrE6ayBAkSDNan1yGJJ0MIL8qyw3pdwROPR5bEiGGOQKknhyGP8YrjnCw3zRbT60uZfgCs/8yXhj3nTn0EUUFU449j5uoQhoOflU/hl3LyWJOm0jdLYlkXhz6Kg6j3ibDPJDMZxEA2ceC/83Doq/59/6jqqXOYzCwd6AnsuvTA35nmOw4arVZfC7LtJJOGXxNivhwgLnPnZU9Z9LCK4QveA5/YgO0Y2AEsw//eEmWLVrsUJ0uxm4emAZPSjSJomCB3ya8Rfz/ZVAdoNJsBo2menwenI5co66SvFw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1604464189; bh=YHfkD8ZUjBzB3NhIg5L6lpgmzWQKwlluqHn99VXNLpY=; h=Date:From:Subject; b=MOWepNdX8W4BcQn+xxBKkCZt69yORZOzGTpoi1oNOCjYczmBpUkRZKJsJ/YVG9RZHkUrzdNE2zPOA2yhtuMhROgSUJC5KEAShJw84U0XdfenG1hPUC9sgN0o/UWgPv38aX+9D6TAqb2+w5NF4yXKBFRWIJQ6SyaSytSOonAPwe8UI6L8+xGYEEhG5iF037kq3UJzS3iwCtHUHtE7VBri+52v253EQkyfOj1s1tVcI9DE7z9+5gYUBuK3zaOGuYGq16GEAANhqKPY2IY8KxoKs+59ASCY2RQSI7rwD1O2NcxNlMzoFYMQDsxbXunrym4rW19n09sFsMgUzs26H/5g6Q==
X-YMail-OSG: .h6_abIVM1mQ_8uBYSRIYBwv3mUlenN.zf0.OY3hlCT.X8jWMzAx85ZjPTGJYVh
 Q7UFWAj0v8m6a9PjiFbw3Hp4KwdgnWsA7_WXQt3VrLnbtiZHB7biZbgaNSRcqbXlttWb_eMt70IF
 GopZVa2V3lJWn3NO3HorzeDtrnt7db6Izv9Fp5FRSGeEbdyXg7AqbXkbegiW54RtCaTC7MCx7E.L
 q_NKtsBDwIlXWzLciVh4_ZF5BmrzJygSDVe22hAeHi7tLPv1Nx0biyYVbY2AN365SKUiHo8605Fu
 uHrjDHoL5xl7_aPCLMwOaxJbE8hObT8RsIVGipeNcJw.Junm.owDe2n445RpbrJWG3jg3ZK.1M3d
 TPS4tLuVfGM_WE264dPnOq9dUkMl.TU5DN.ZN9YLjVzN1FQczv4.swxeXyybmnWApd9jrY3OXTGw
 t8eYvc._fKKVLqz62YAGvjRAWJMwnVi5oXH6TnPCL5DI7P3R5DiMZNbHHfvJ.5I.OLXBYPW7B547
 LSxkcjsVUBPXeeC8eSrpQJ3uxK_cFey.FPXq79oR0G_PXdFdkG4GXFlvJfj4LHzyO7sp6at2P8GT
 fELwXQu2gQ2pkMjMPqwHdLxVBlMFxcKyAW7oAUntDuzvpDKoRn5I_Njdfa0MfbgDA2wKTlszdlK_
 KVurs2vzz7Av2N921SIj7DlbIn382DKRBTAHURufCHa3x6r.mFx9VZOfmT4ZEnB.09F8cDn_82kL
 r7rRqYehC69EAhfebiGYJtLWf38xa13W2IyQuFTHPETM4g6gtwoF1ZZRGyPKensSjW78ltosb2QD
 .fFid.K2MyqAhZdar_pCylLFElmQ8FETDD6sKeznske2f1n56WqI0g7YONW3KXl_3a9MZS3ke3Rj
 ZdIza9MROUT5x380PdkEJhazlHCqaGyi7w4dILnKty5oXJ19ok7MMN_nTHx.UN2mjjuOgOPyAzf3
 mHwXGxASFncQftv7SDwtSREwBVgcL.RdVaUrhgsvzJqMhtG.sWjXWwyFSXRFqahNNpH4b.Sy6Q.Q
 nyc31z_bjQtevxyvurrwTR870gCA7T0n4kno6UhjVQbIm7CIcDto3WSSXT6DfbiUJztnl8pBqutQ
 UcFYI9E6HLKjRHrxnMY4XjLqlFTRji.IpgT9KZ69n_6JFScaAheBp72nKIF15.9jSwfZ.CSVmun5
 u6.gpBVWCfNnpp4WAxHpFr2pjLdS17yquboVtaNJc7qtDCxveZYnBCkKBTf5wDuIBe8vd2DaBCam
 ywj1C0N5qziSgk6jpPcZ_Ez7J3vFpCWO0HvXk8QND3iRFIsmevhHniM.gWO74OZ3FP1OodE4xlHJ
 rV3oK3P2QlQfO7HfDcX19XLG92aayTeQtbOy_1pX.B0pBHFqZStg7cG5MLX.3_aQ4axqdBOy7SJP
 mMsAO_w6STH686UcYBBIThRrXHWkg475zidx1ca0Ulv2TKkzCXZlWEMD9.pAKsnQuxEijLOSig08
 niS3lSMgQPdcQW0FZC5diZ.gjK37KFsSkxBHXMqNbf6Usa7meyy2j3ryuclv5.UmAmPzzcgNUBfM
 whI2Gc3pGcIz8n4v_GOGBkV1.lcXr72nKLvbdLBXIrwgMWoWa.fz.EMQk4temdk.2MMhWQCBRbr0
 AVV.Ak11V6I9JNJbUvcouNmeycVeeptV3JWXRUSxXZoq37BdGDZVoV79GXtOVIrNgHWHWRe04NBG
 1DDc3OsEouH_HmBa1Q91lcCmhaqKdX0N3Y5p.Jaod.cJVDdpPa9fYCBF4Iry4.LXiRkhcyB1F_ev
 qmMsFbTd023K38FYJ_v7anpvFZx8ILXZgfMqUOekXb9yidQsYLbNo7hCEunpsVY.Zh2XPy0Qxcct
 8GtsiwTJeILDVLE1u.G2CW2d96gPkvbR8.FqZPeN8UaBIvuqQBJ_a2pT9Nz9_onhoqgd9osscHkp
 dhsdbyJk._WLPpdDCqK9ohYJTIMcEQB9BHqQdzpusB1WEGj1pjzl05dpcXfz1t8FYjkaT3SQYouP
 LIxMyvTgivZZ4w_WaqeD4Ef86Uku2Wug36_ePa8hlyUtnTGCAQQUDNaQvesOYRLjJTgg3gJnT_48
 rV5jIkBdc0awOVcKg9KobyXZkC7Y0nXUcyz1gr15JQzaiRE3zpIowEcMuAhEP583ZsVMncA1rjvb
 4iLnN382ndBAAkQTgfHbsLS5ClbT5kAZed4YMQG9FtkNDsqBMWKqBhJHfahAJkuTSCIPwpDLseFr
 x5fG.Li5aDrGUKngI8C.9qQOdhBBytEhp8z7MqObWy0KCy_LO7fImf8z_Db0AIvN15tocf_SRjYY
 xKWPXCgpRE8K6Qk9tp8PBhsaBETtcLm4EjG6y3HOvG9bvxBT7bx_M4Ozvylg5fZVCcJdE8HgyobF
 t_QqlgVUJ5zyIDsCqanQVOwkqpQiQ6TfK3PfcW.prgcNv9kMevWMH9WW79UmzmvnaHym47m2MoXk
 EeAtqjeKEOJ3mkVVkZ4_vgPboSr4DjIwCBdvjnrejvBeXqOwDvyIeLrj.IxwadlYVTJchGN9CF61
 W4lZTA6HwxWGk4aciO.dgELo4y751NewD3vxvxGXjwCFD7iUeok08943uBINwKpgc7Jhg5IhuIEV
 kC0UGjZA5498ClcEFCSUSOj18TRQaDOCC3I3hMEjNa2BdZ4Vw_UW9B8hy8qRBPdZ1YSeMHyrFKBV
 f8_UTz7xs23SuUR.KQGIG8n0bzZ7GjHce1RIAUqcZpxqc58WmoLMOA5KLc5VBU3IEVYXf.oud0Sq
 kbpjBhKuNWmNeljbj1XmAnB1hnly_W_5CUQfVBS9MWxv_HgOfcoX1QTfvStGqJLcb_WlNuZUDDUc
 .xTEiZg19gp1t1Vuyc3APBIYDOTSF6nZEufTjoe_dF3_JMhySIZDvpG3RujZeUIZ4p0_qj0Cd18k
 N7_La3flSnh9llSFm4g3gOiuycjRnVYLGNpd6mwBUdK8mca3gN1w138pHMrfXtvnV3qgnYgbTa7t
 Pw5x..nIdb0Ig7s7KZIRlVtCjEGxv6dQRnVF6i2BwDMctfbduADKZZ2_ivKiolUg8KOWCkTDsUan
 4zCWQFTIhbYliKIgohCRqIWc3AUdkecEdGkey9WnFSBwEduqbDZ83XDMkYwT1bQ6WuQk7I6Qtx1w
 tk9klUu7DY0LpVN.CEm09W7vrJOefqTxWDQB_yIKiHAlBxcKLn5wxw3DCfMA1KsM2SCGhgUIsJIg
 xcemCh.jb9Lg2ekWWnp_9yVOzC.t7VbnNQl10utJoa2VxtbuduMdJNi7zSCow9LBVCx8jMu1eLZu
 4Mw1i4cJQ3wrPXQN6KfEFS.JXLHuFFZricpQtpMMam_qoRoJUdJtNkiQlgUmKfHZQywXszRKE3rO
 rl9gauCfwuHFy4vMMkNASFMrlDhBuvRAGBKN5me98F3uZsJnZKPA0uGq6LI8cGefTqtVxIOr9QIA
 Nah8NuH.u90b71cIB06hsrpCk6mugwgalAsm494GrFP8KTFfWG12hE0CO9JgqBE.bOllTmszyAKp
 s1.QXicafCbxy.l3ROcSSY.0hl7HQeTc87ouqvVqzhjtLuYHeAQWZCbdK4jwVQ82h1NRZeF2wPtP
 9Ne9QjMnK.vvFnGkzMnJAg3WzsRFYyqZeIdCcC1JPoW8oJqhwL22zW45S5VpSAELVM0cZHPv.TVg
 8ppWbSzxjBIGqEU0DInukdmAWQ2H.i0OObtqYFv7_6VsOvoF_dGoi6KIfWu8J8UW65N_OMglMebn
 d6O.lPVtu3F9jpaDPJbS0RRPYTpzT7DlDJxEfoc88jPbu0WJzD1l_CXwaB79Um4dMlOHM5oJflVd
 gHiLpZn.maD0_t2Dd7YDbx89WI0E.zeT6iapwYLuIkQy2ggGIOAK9oaYL_T4MP7Z4VR05M846kLF
 d4X5IEjqwz1VhKHFVrgEJD1kJGOB87n.YTDrcHZcntimlsnePd4rSYkJGHFuyV3te.lI1gxHi6KB
 dAtqgfv3Tv46DDJvlPKr06kDAGVHKygA5GY3SIxOpgMDiPnwadSO7XS_EAyl7KbKwuhGp2xGtni0
 5nh2nhE_SJs7JlusuZVP0KLzZtA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Wed, 4 Nov 2020 04:29:49 +0000
Date:   Wed, 4 Nov 2020 04:27:48 +0000 (UTC)
From:   "Engr. Francisco Pinto." <webed4@gcgroup.org.in>
Reply-To: engr.frcopinto1@gmail.com
Message-ID: <1330001102.1455474.1604464068759@mail.yahoo.com>
Subject: Crude Oil Lifting Contract Offer.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1330001102.1455474.1604464068759.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16944 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:82.0) Gecko/20100101 Firefox/82.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Partner,
THIS IS A CONFIDENTIAL OFFER REGARDING CRUDE OIL LIFTING CONTRACT.
CRUDE OIL LIFTING LICENSE NO: ANP-C-STP/056432.
Reply Email: engr.frcopinto1@gmail.com

This is a confidential business offer from the oil rich Sao Tome and Princi=
pe. Please ensure that you reply this email strictly at : engr.frcopinto1@g=
mail.com

I make this introduction based on my regard for your credibility. My name i=
s Engr. Francisco Pinto. I work with the Sao Tome and Principe national pet=
roleum agency. To be precise, I oversee the issuance of oil allocation lice=
nse for our oil company. My position in the agency entitles me to recommend=
 oil allocation bidders and actualize oil lifting and exploration allocatio=
n licenses to my candidates based on my interest. I also oversee and approv=
e the issuance of the license for oil allocation in our company and also mo=
nitor the lifting procedures in our company.

In June 2007, I facilitated and actualized the license of a candidate. A bu=
siness man from Korea (Comprehensive details to be provided subsequently). =
The license was for 1 year at 24 million BBLS/12 months. Incidentally the c=
andidate was no more. The license has been valid till date (as I always ens=
ure that I keep to my side of the bargain), I have decided to begin using t=
he license from NOVEMBER. I am in need of a partner from your country whom =
I can trust. I will package this partner as the allocation license benefici=
ary and assign the license to this partner. Due to my position in the petro=
leum agency, I cannot handle this position. Your profile fits into the crit=
eria of a partner I need. This is why I am contacting you. With the trend o=
f events in Sao Tome and Principe, we shall be able to lift a minimum of 40=
0,000 barrels of BLCO per month. This will fetch us an average of US$28 mil=
lion per month. And we have from NOVEMBER 2020 up until NOVEMBER 2021 to li=
ft crude oil which will fetch us approximately (12) x (28) Million dollars.=
 This is approximately 336 Million dollars for the rest of the time of the =
license allocation. I have ready buyers who are waiting and would be ready =
to scramble for any number of barrels we lift. Also, I will oversee all lif=
ting procedures with the available mercenary around.

 THIS IS WHAT I PROPOSE.

{1} Your Company profile shall be used in place of the initial license Oper=
ator. This I shall handle with my capacity in the company.
{2} I will ensure that your company's profile is recognized as the current =
license operator and that we have a mandate for at least min of 400,000 bar=
rels per month, a maximum of 500,000 barrels per month. Starting from NOVEM=
BER.
{3}I will ensure that all lifting procedures are in place and buyers readil=
y available to purchase the product.
{4} You shall stand in as the license operator for all lifting and sales tr=
ansactions; we shall open an account for the receipt of the oil sale procee=
ds in which both of us shall be signatories to the account or you can provi=
de your personal or company bank account to receive the payments on our beh=
alf.
{5} We shall split the oil sale proceeds in the ratio of 60:40 equity share=
s. I shall be entitled to 60% share while your company shall be entitled to=
 40% share.

Please note: no third-party arrangement shall be allowed. I believe you are=
 a man of wisdom and intelligence. This offer I make to you is based on utm=
ost good faith. I could be Jeopardizing my position in the agency if a word=
 of this goes out. Therefore, without mincing words, I rely on you for utmo=
st confidentiality on every bit of detail relating to this transaction. I a=
m in London on official duties at the moment waiting for your response. Upo=
n your positive response, I will be willing to forward to you proof of my p=
roposition and my personal identity. Also, I shall fly back to Sao Tome and=
 Principe and from there we shall commence operations. I shall also provide=
 you details of the former license operator and a copy of the license issue=
d to him for the lifting of crude oil in our company which I personally app=
roved and endorsed. Also, procedures for license reassignment and actualizi=
ng the rest of the project shall be provided to you.

Please in response to this email: engr.frcopinto1@gmail.com, quote the refe=
rence number. CRUDE OIL LIFTING LICENSE NO: ANP-C-STP/056432.
I look forward to a prospective business relationship between us.
Thanks,
Engr. Francisco Pinto.
