Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38722BC521
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 11:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgKVKki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 05:40:38 -0500
Received: from sonic315-22.consmr.mail.ne1.yahoo.com ([66.163.190.148]:46021
        "EHLO sonic315-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727306AbgKVKkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 05:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1606041634; bh=4ZfeLiPSBTHKyYvQQFgsEPvgbjF8lWi1YrhNpXeaPVI=; h=Date:From:Reply-To:Subject:References:From:Subject; b=J9QEUI6/mKediZMFRl90e6nm4iz8oOIKLV7QQ2HvMyIniVBDNyO6HBLS5OMDaNNt4cvfsfa9mWlo3HsOLrZbbW9yYD4cTpIMwNqnZtEV8KhW5aPrOodwEb2jQua1DT0WQ2kUKhaN6RrdHYPGUmjzb238sROmbB2aEBf3BHYXVSKdUO/5HTtk9axZB5vSZ+Nu86+H91LM9DRgAY9D3isPeZc4dLz2HKSwzBaNBGLVvAHOJ1+KQ3NPBeK5jog1yp55z0/VTpSKZ5w/9mChu4+4ORAiAuAYbrXmMGc/Y8z6A208eafQpEGGAnCufMSdyIQon4uVyBbNq9BoMRoje0EBgg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1606041634; bh=S9ekgnuuDhzxe4+wyzxbZP6764OqbZSI8A1MS09h5u6=; h=Date:From:Subject:From:Subject; b=uLt3PRZyH/4vzRLnO2r9uPExFbmLVAMU4kD+Ozgu5lnXlWEE7FureIigaI3DDxF/NC5SOY7B8tRee3Scy247h9advsBhxhAICmzveROHCCFDsIB/MkxNpbwOwDyqtXPgbQKClM2C4NoN2DoqXjvFUNn74iGH2mrD7KL+HvAQ3kNMHNLKlNjzS/C57Bz2FdSQKLVNOcBxHPUDs6zTrq6qSOWuFvdQ4qDyAQfgDaAnOL7AJHrxPfktvQk9fNhg7KQAuxnSJRDWqpHQ6TUOJfzG5FBz9Uc7JNB0lNDjyFgbixe6cK3Ik0pgHKYkkWhA9SCILBlJJ2CSBdAnodQEvj4/SQ==
X-YMail-OSG: FNEy89wVM1kjRD_q_pFuoqsVTqJWt2bu10F7AsPL3TVy9rY1RpjxAbL5NiZlnHR
 RXPMCvxWrOt7i9xh7D1QC.3LDrTMeInG6AkZJNyU1xExMubx6XJTlDsA8_8a5WdAt_IedfmQnYt4
 wuNOfTbpxsNk8pNEeeW08B9MXDwkMm44tMnUNDlgna1KlJOvBhw7PMMnlfsXAhBPeFXuczIg0bhe
 KRY2W3tmq6_EccKAPHsRybCknRhm7gQuDMjmvEoC2FXPXWKoDII4Q.5vSQ17HBdx0TWgnWmlMwJ.
 WHY4u7fiP4KUzWyezdiFwq4LMBy3nCidDAIHl84GOW9REunmqxOOZ.dscx1ZlLvzPf9WrSLF2Oo9
 z3_2Dahov93Wz_rYOzX.EWLiNNvHKzZo7sASsoCq6xZmBvX6m6Xew5fK0bd3w7DmmEfRtgPW2VxR
 dhvAm9L_bEGCdwsATc9KSjnRGUQCwwWFs4UtPiCHq.oum3Y889z3rJOp2.zDMKc.ED9vFIx2UF7y
 TqBM36SCDfK3WAz7Juapq60uTf3CPYi0ciyLPvPq4G4z_B_anBMEMWdqDafjVLkdPtWSGeFiaMKv
 7M8w2eJ0GylZJDU3qwsGHAztcYJCZ.Tdczt6rcDLc5SlvkQ2ubjpyEswSxjygy5TkdYJwFbY63Qo
 agAvpMGw_7GZRm5NcCcXrHxAKZMnrvGEI6D9rA7ggX0V7vFTQ6owg0_UorpMIUibr04t1V757m7x
 4zkiq4nes518WxIFEe19urRE8s36kZ5vnbQbhWgVN_M7ErJj2zNwDJcl_vzA2HqLWUDoZ5mZII6B
 LBz10sW9hhCdgt9saMbVOGMSzjD1kSdJ3ZWH1KFbJk5PWO.IIMCwko0A1gdON.gGxcSj0pgv.TK5
 abKX_rgku2b8HSAj3zd4bxwopDmNp87gA8kkayOJtytpRMcJJdnv5pCHimOC3UYJM.7BCPZw3fP9
 WO7GHcsj5Z0yMs.InmUZnyt4ySSOXlP3DtQrzb4cK_42ydpcMiou_Eyl512yhAHB5TpZgM4d4Hdh
 SV51sdCA2tWNi09V5ajTQUhuvKi6ebSu4drDt1aLdkZA4rJUrmP8yW0KMQtoHdZKpqe6FgJUYNqb
 Qth7T.AKddvKSUtsFUvFQw3BTmQA_vZCctr1MPxLvfQPhOhX1Xj1XGGSYpljPtBp46dsCvgIuPD1
 hLzBjsML6BWs4d2f0Mnpn._YsYgNtJAOMqA2UmjTB0JKNnhqGu8kHZPJvsPDEgyE2hT5p9aU2xwA
 a6dO2PxycAEeG9eUYDyvr.HfEBw4l1g8S1lXzpz4A6ZgvCITkIC2Gu47OHfRqOkG5MQmPEz4_P6o
 MWjEnTO8KvWRoXrK.aTwj4R_fZulykFG747pIHIMmN.JtDMMuivK2QQ6I4jKFHHe8w_T_2M.dVIN
 5cuLJ2DHN7mi4PogDjYnWieAj7LLJs9LDyniolBCFYangTLGjKglUlnFIjTazpEP.53rEDzuYImX
 lTOI_O6wpmJuuKq679ohshMJOgbdL557V.R9stxsLcSV8nNVtlBs_suAGa.bardF4NBJcw8.i.Ov
 4Wg7PadtAk6JF_CJBdCqBAETj0vEP3xc7eKQtWYIDBdoNrXLKsM4OYbqr4LhPe3.wHdBjWY.Bb55
 .lAsYbgev6ZVCMksCC4Gc5k3NEMbgIsMZaop5xCodmUXKF2WyRmjrHUdoYgqIRtkyiEax_b8C6en
 GA4AUPMG_8LYP_rT9hP1eacwZ0GzqxPd.EKBss9ZUPl1XUaKXnNPX3zctCE8EDlghFYs5qes.UIq
 LizE7FXgVmLY3sMa1mOAFBK3Jd4rentcW1SQwAzYplYv333rjGyhPoj9_1uII2DyyJtOAkmGulDx
 ZuCXEb1ouv_iF.HsT9YEDQwxq7h2yT8Y1o97pda_cO8v7G2t.RA49t4EY35YNC3wMuRxtUTYnoXw
 SEYw6Wa4vZ60frSZk._2oGmsMZwFSZAxljcnb0Mtpd9hzSpCtqtVZb1D_lCLIXIVlAXSJPXWu1rg
 pSAyL51yq2XzPern8SSe2UhhfiNBjgnEcsVMs0aTNA.qgVG39fPy9GMAve0vymfG0xlyzqlD.3VA
 VmoLVvUrtR3leKSDlwfVYgmEOHYvJa1ZeuG_yK6RzUxAcXUUMgmlDLZkMk903Leh2tjtrQmGHukS
 jN.OZ4To_CHIqCMgc8_5mz8Hhuotjx0Bas4lg2NYNIfQhQ59Skl8ggvsvkRTae6dzDzNq0eyxjTn
 mt2IA13GHeKTbNIy_ieMf2ZYSVSD7T9EVIrGTkgCIiEWzVGCeQhlinlLZrexMuzFKH1Qv3eqZ3Ou
 j4wq5K3tD4G411k.IEUYN1luH6TEfmbXwxjX2g3yT6BxLOFhTU2cpTq7outOUD.cIzvawAx2LwxR
 SPkbTrpE6XhlAoBFaDTxscvUfW0rp8uXqmJudaKH67sjedX0noKkmoBYFB4vTWVajqzfRZk31wKy
 u45lm0gopdswLu1eeVluqD83DB.Y2uFwe5WpG_ZJTk8htz5.xAZZ1n4hi8cuN6e3m_y9321FZHQ1
 oyCFn20_USEj657nLnNggcBYVboiS0dlT36S18aVNIVCu5Fov4aJeXRRctqg2wJEnoZp8lDhVPFN
 E4Tiqr94ll6kadHBwlezHj5XccqkS8bwOOCyIHKfLGGnbWnVc5U4DgeaKe1EWQfodLc0NuCjwdAB
 QDY47gmJGdt0TSz7sMdYNIXUzBoisx5_koJ2vNv8ae113SrnWOOssFr.scWJgn9pbke1p.owagJO
 wgPoi0n6m_5iKZpNzfruq4rYOjgeu9lNmszV9hiD9myUeAw93_L7czqLy0CuKquTIs1.2L_LIEgB
 lcZ.63OdvS47U5gLjn8Q73oMIvs9d6tNIGgyIfbS1N1naLBDHYEmfDGnCs1MpuZR_iOiGzoriyCL
 _DN_MTOThUaAedKXVUrtXSukyaUOuW8WSrk3te.E2xBpwgDX5DR0N2RR8dCry1DySL6BLZXymfIU
 K_CIm41HHTCnNdlSTw0MfWOo3jBaCh8x._ZlgbHcVJAi6Z33kDm0G9LXSWPIHS4vitSIzxii9Ss4
 DjBm3CkGCLJ5sIVLK28yVOkJ.YSplr2zIwRm_D6bIstZp4.8J2ZggyOqZmR5pV9FesnbWeLfkfT4
 hi4wD6JVBsaB3nxonYl5XP_cmKIAIn3bTSU6b_IfRylqXG2Rbk59AT8gjonTuAw5uYlijO3feGY0
 IZYZESJjUnNBByNYr14GmpM_Tu.uc774I3KHsK7w7FhwjeKGWafpVaHMfB0nNxymdmRmD8HVbK2Q
 vXmYhNutzVBBwIfh27bVijktZeGW.H03hDaI69xUS0vM9.guZ3S2Jsx_Ik3UrVCxoOuLL7X36kBl
 w14SfoQkfvHsYTvECgojyV1P8Xw0xraGVcNc56T4.g.R5Wcb0y5JfGCpMgVmgB8iLNWxYFI1_7o.
 tKmD3u19_lRkXmMlGMExJoWrRAIM81YE4ZoXkGHJgnxOgYoHXBOg83zKHYsYCbQ67BFg.FosfetQ
 HmpriY8Xyq9rBBErK9BiGfOz0kKW5qalj7Xu4YxysGdc7aD7oxpfEegLJTGNQyF.JvyFpVDw3gpV
 UBqzrz6F3rV6v_HLI3c0iMCF.ekif8KOfDm0M9dwmHxpRCDTJIlHB46QeeVffDkXCw4G4PI1ajuA
 W89bG9VnAagwwWYzJDhDJLU835KdgIvOuHoonxX_vqPfcf0X7H4gadsoOj0PJKyHoU0BhKEGo8Vv
 I4qcD.sJf3X3DdByye.MQiCwxUMERbRAptf014TwA7oOqo_acUIlRI0PpWD5NAZUe4ddH08zVaza
 KJUCLBN.28.g8I3r6F079DnbAljXBLQkxNpzRaHPMZYt.E0vqJdsatAblTzodWDkDS1jwAAw3X0u
 9vX5m2OxH5c1w6reKO_0H7nemLwONXZAGGOaGz4nRFRUyedheyrxi_Qt2QsJP3VKN0SyhK40ja0F
 tEeh3QcDdus6KsXAkn12maloillQsXL8m2zZVaTPl7cVKzcQsMLHHseQi9CMI3UN0ThGBT6fkx7K
 ifdClaZkgETZkXFDJfUBhpMslfuIUJivP.c9z7IuVpD2fbmIUxIz8LIaanAJ11RWLMNzf1MdvSjF
 iSlEl2GH8qBWXEyXAOjNPyOLG9cAjYtCO_rVIqEsKUa4GwF7sRs6eIoCUgdEJnAtK36S2x.P6tGD
 HlbAR1Lh1Xt_YO7_e0YIz8y86uw3mBopjn2oqSqPj404_DM_Ah7t0kpt33Uv3YR1xke2LjOkoxrZ
 tJMaSyxN9S5luAKgwlwKcO8e8Y8w9B__H9u3cWPyAaL8fr6yud5FXPaKUcFYf5Wlavu4U1FeGd.l
 N73C1sPRULP3OjH8xK3bBUC5ZX3G6G8YRcC7OWRMr5ecuU_bMYdvLJDf1W8KHsJJaDdb0eTBc10o
 WSuSNq4lfOROaJvMYrXPh57qG6.jClANoaBxXGe7P2qKQfo_QiS7g93JQv1Ip78KFiL6td2mqXOV
 tYHfX_CYv5iwAd.ZgW3MM9M_GHmqNBPOBUANpKxM7_bGDMcPOb8LaHedKXjqjPXAWoImuJYDucAj
 M4SkyvijSL7KS69s9BHU8nX42ndBKZTqpjlYI1rC38Sn79_6DvGZkCUL3CiN_mbagzJGoSIB42ET
 NMDpkOstGogIu37xCQBgSL8LEJebeUH4P.DpneQsGOgl47rx2wzWCPNfBIwZSMSuCq5XTxMwhi0x
 CG_PGqICmUYleGzSz8R2AwTxIHW2CLM7Z_lfCX1s9DdpM.Fna6HU.bXPMZOtu_eCBv3TS9rGdu7M
 bSQGSOJS0vy8hhlObIQSZLfI35e7B9eHOeOfWc2vw597UFiAvZENqOLs0_.s6_Uv5Gi.RzE1ifjt
 lbI33UZ9aoKtHvzwvTPvO7GcY72p6VgwbMSP2Io9bYYwFhPnKDoRnOF3z9umi5krmsKqIuu7WP3N
 SFVu9x2VMzbOYJDEWf6W67YIcYUPFtqEGBY.nkP2Ex9D8W244x4Lw833nxYAMS.YH4G4jq.ltYwF
 yAcS5R6hLn4XB.6hel6fvnEX5GprHe1LJH273n9uZDnf1DkBStB_f9qUFPr2AHOSuRLL1Pl3JqMO
 pEHXsw4noiF7DOJ7ia_QCp.V1_XrwhTQKsXh38nlN5xwNSRz9z97B4ztX_Z4WtIdMSRwbE_PS84r
 WZUKSWn3RL9fvebc7.LedehF8RnUqo_EFJdxy3J14CNP5
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Sun, 22 Nov 2020 10:40:34 +0000
Date:   Sun, 22 Nov 2020 10:40:30 +0000 (UTC)
From:   MS ESTHER HARRY <msestherharry8@gmail.com>
Reply-To: msestherharry8@gmail.com
Message-ID: <178663030.351714.1606041630403@mail.yahoo.com>
Subject: Greetings to you,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <178663030.351714.1606041630403.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.17111 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.193 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings to you,

My Name is Ms Esther Harry, 19 years old single girl, the only child and daughter of late Mr & Mrs Edward Harry. My father was a highly reputable business man who deals on (EXPORTATION OF COCOA & FARM MATERIALS) from Africa to Oversea Countries. He died of food poisoning after returning from one of his business trips from abroad on the 15th of June 2018. It is sad to say that his sudden death was linked with and masterminded by his elder brother out of enviousness. But God knows the truth! My mother died when I was just 6 years old, I am writing to you to ask for your assistance to help me transfer my inheritance money to a safety bank account of yours in your country.

I intend to invest the money in your country into a very lucrative business venture of which you are to advise me and execute under your management. I have decided that after the transfer I will offer you 15% of the total money for your assistant while you help me to invest 80% of my own under your proper management and care.

Looking forward to your response.please contact me through my private email ( msestherharry8@gmail.com )

Yours Faithfully,
Ms Esther Harry.
