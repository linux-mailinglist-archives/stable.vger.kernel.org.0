Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8084D2B4BFD
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 18:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbgKPRB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 12:01:28 -0500
Received: from sonic303-21.consmr.mail.ne1.yahoo.com ([66.163.188.147]:36745
        "EHLO sonic303-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730396AbgKPRB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 12:01:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1605546085; bh=Rhd2J2SEPF/GyeQKjmzMtbg49c344gzPjWthoLVAB7c=; h=Date:From:Reply-To:Subject:References:From:Subject; b=DZyRAW9kmh9Rp3Z1fEk79UefARUaO7xCo63vtkMfIBIh47pht4JHf8avPSnGSSbaEYhWNceY8yKZi2V7a3dxbBIQwo148czDUbJhBXRpwwmu+yp1ctCsgKZAZ30NWwQgQjzphpOPLePMb+6cILaBdAngWlalncCVoF5O8EtIPOAp/TxNoKwcSt1DGT7VVNBUZ1ZC0czEJbC7hgEnsouv0P/KRM64NW11Mo/SaiN1ezyz3p/bw92/SFVbeVR1oWL0JocZ7t8VRrFc8yj//Q1Vag37oGYMT6sUBdtdMvq8kAvhlqbSPUNrU97KX5dZfFeC1fFiSeoO8VOX/E7jYe6obQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605546085; bh=/SMtC50TeYaGMX4yU8hOY9fnfDd+oNKaDLVXMLVAHsL=; h=Date:From:Subject:From:Subject; b=qm2grEM7yG7VLQF41MUXjwW13KFqCg7QgWHjG2qu3dthsd8laY7uBgaBDGx1kzMNXrYoJp76cvf3KYMdecREwFFqsOsz9K+Y8Q+cuoAenAzrwL0OjvFIT7FG9oQDe5TR5Doao7azkknsweg1aQeASfBmfrhj3Y3aqemTugKbx0ocHHJtGDFdm/NCnqDaF/u8XIkJC02+2dov8yrAAvKDOko4lo+MVOCmMHs6NXbE3d7dVASmg7ih9gWytW4MIpG8/mGVECzx7JSNJR4DF33A2BXU58pil/3Rt7+1pkxjNUX1O1mdV2VDxZPmX6uNcyw2xBNvkm+wbPzkfbhD3hdoIg==
X-YMail-OSG: 7kfiFxIVM1lptHjk.iw15YHrnO9I74pjOlRVYxU13fbljxbdpukm61Pnz1Q5TF1
 mL5qBCh2oQhZ7aNQ8FCAVmTp5peE.VaAzNc4w9KfAoRHUStv9i.6mDWqQDDdKdKfv5XBgHdDMsnW
 LiBeqnjvYqoowhWq.4yimNeAIWmL3S35PWwPF7Nk8iITnjGfYM_t.TQaGUqic7rhGU0TT7EuVII5
 MrHbsP_p7xH7O3gGLEgB8shy9ljoRrkEIK5LWV7YNlSDuqa8yfPKCAtAlF2mMGCpIiOoFidhL2gv
 n31XZ9eZ4nSwkZDz.cdAmdk9J5MVyftv9rbRyhudaeYZMiLeel4KyFxSpcsG_jdELRM2wOZz58CO
 hw6.FlwTJj5E.YonajirWYgNjRb80HlnIWf7Ck5qVN64Neuww2uUkFvvhc29D7NX3plZZe0owwf4
 .FpAMWxlyOpoJWccNhoEcKNtwUt2vvgtaKoqajjGHnO8n71TxyYJek03rEoTk8.8FIPpztEbyIUT
 MtUYtEwXWnGfmBd.DXPg91goQS_m3DMxAlaNbHwJkwb4UsoWPB2gWYC00SrZSVnms2tsdnO33s3f
 Zfqp7ngHkALJl5mQAMZK9SdPGUOklCtoNHjHIu_q4HZbMUon8QjrxDXTp27s0u.sdOvP2PLZgIGk
 NvykKCSLuGZTP09UGsZj36ZvjevsPm7Nul5Du.CUPqeAAqPldACJNzR3nyBdMAI9AWsIgaEyJ4_M
 eb0a.5VWaIiujCA7T9sYtdhJxteeJvhVODyJaByw7tmxySH4eIzkeY1zhmHhDLT4.R4YuFN5dVio
 1lF5lu6i5IW1ZBgAO0Q_Osq1pMdOH0xMlaHSdiwADwcjgP6zApXdFVHxG0Q3XEoveiOYiOI4xco8
 PG6CxsvdTfhW6CikixtEXp.tzFhTuTm1buwvbH4k1SOQmlTR.0te.b1MtmMtd7YT2xZ9kAiU4q0m
 213TGwm7PqUHJdlMF7yKopnLQkZa49XdLX.M_ACV_x.9SBnQ8G1.18BVvus_UHnG2jDemHhfAbOe
 gzPxwH8wXE31HxfhBMtTZlLfAYKHBd08IWFhfqHbwltCn7doQrDumPzUTzr7PA1BmJjZac5ThUeZ
 _MG3eXNoyE8TYJWr6x8nOhYKsYl3xO_fBRefLbsMOA_gFDIj_V6LTl9dkVjNByNjudcP9DVXF7mb
 oDUU2_5P8fgFS8fHsNu1TkB1n96w5LQ1HylXhP6gYz5zlIA0jhAcHjVNriV3JKz7UY8vDA5D4ek9
 bDxSW.qBfrjZiwqrHNMzt5ry_pRaPCKzhGLS_KKVRJZuNN2.zcP1Mrfhr4yx90b8K0dRqXlc8ORT
 _75sSN4PPmTjNkZMk_yoEPb.ubt5QjeLZQTJ4_FjUOWWPY7ZnzyG48E_BcawwQXenEboQ9PIgDFU
 GSlryDk10UKttIiu14YVF8_MlxyF_1IHjHnK4YzhG9TBCxEeTeHpzsPR539HTzs73o_4wFggpCN.
 5bQwomdOeKwVOl9smSODffmSGZ037N1cTCLveNQnVl.woDeCxuOWnCx2CaTayAKGex38FS4KV18k
 jxlUKj9mEpA3vRzgJjkrcDb4pXpvJHPr5aM8fiwoi31ZT4eAkDHCQBtIBlUMBSO_INT04uLf8mO3
 t8jyMLyMwnDqzCG29O_xozQcaFqpG7i78EljjFX1wxDTgdDCMXAZ6HiZgt6w5x5ry1tyS5kHgQSA
 Nkxw41Z0qTUz.QirSxmicI8OG0l6MkScR1iugElN6mswY4Z9NvNqucD2NgqYX_QXLtrVi9wHxkJJ
 J1mbnLw_5fksbbtb6KaYVpuvQFf4s2zCf6J7V.EEAlq0_Uvh2jN5nwe9jYfsH.I1stsI8fEijZFy
 3HBoH1pGcDpxWrjtb8ygnpU4_p79f2Xz7Ho5O7wUODPp_F44m2BkWaLgJpr97n2MEJT9Bo77aLOu
 YdJNv6xI1GHja4eLOUrjZedcS0QEzyhuzxN5nYEIOhDpKcjpEAXXP_s46MjSCHBvoLjhFeHVwfEt
 RMqp9dN5HPhjXZzY2nIqW048_roPW444.pQmBM9LY5WI4n9iQwDcQimbpQbwFExLiyComZjgDSbB
 r2zzwJ.EDMyzhp2ItV.pXmoI9UJbbVAbwKOJYXNx9tVARm912Tr4c.hmRZEDIPjZWBrjZlDxFrMt
 U1wQKH4feUQSpzMfKFGke54lKE4oqDoY20sMWL9Xdb8RnpKvpsQ1ZqOpPOOXBQIuqAq3Si7SPT16
 bYZk8sG3mTqfs_nf705q.L1p4R1gZok6af8ZTLL6pwnW1ooGE.lvpgLVUJJIlxmbk2dZHGijfC0l
 QBqdyWN_8ux5.7lhoNh9Xj5mMz07PQCJ5bAIvKrBFLDFhfHeZUxKtlVB1stMhkyuI02foXyr4bJS
 WpM3JY6fsDSfo7h7yCu12QpbL37g9R7ULk4dkxmcyyy1V2RVjGbmYxeuKTgJMLWPpBl4PH_DwgQ_
 gqlOpiFL4MRKcafYXmeN.V68tV5JMJitxqMrh6aYj5bs.lENaVDNPAdHdDA1gMOBfmRcQIWwwi6H
 N6DUGq7.70hIod_I6rjd.wmUmF6zhhSuv0XhcM5O7A890dz07NgsCX4a_l82YDC4TTcar888DsZt
 Uf02k_G_fRed0eP_n1fwjUD0DoHVorZ62YteYcGlYTulWTn2AegkwKgCh2KDoRGogqBDjrt3PPmL
 8y8zTFRAp3MhePP58XTsKqXWgVpQ90xf2fggluthHkZLVmCHBk7zMdssXG9Ps.gLsWXBUr_WgRxl
 jiP2aMld376ISkl57qDlqwXq2QTjdhsLDgupYrqZuD5CuHQjVaN1bf_d8dPHR9ydVMA5oHkAUu2R
 OwVBj02Hlyd8hO.K9qNKhEcMDCai.uzySTShSUzzh70wmdwo3ac77S7l5Vc5MZRSZw.BnwYMGjUp
 s.fqRcXayxP1wgya0niOMEYb3OpZ7bd96JOloQ.S2xNunIT5A9k3DA.PuXq_kFxY8JxjNuN3Jv0W
 DFtJzBP4367WN19FjqYKH1dbDonjtDV8Ev6KWY8fDlplaLbM6EuBVFIIKnDSPyE1cDHjAn_VVdWr
 ePScJMhesq2KWBlLLLEj6cKSaXfsae61uIQVLIfB6MGnSNhkU_FwlWK88jLadjxNKQmUcskULqUT
 sAViGebwUWTJUXfFfSdvF0Iy9gucxxl8shvWmoMqbWVretgmka_Ke29CrSCKNayO1DUkGP.wv2g6
 LPYZs6S1YU_b0_RbAjpee57h9pXJhTR4J_z5LGIjF5FH6Ydft_f6y1AOVVmN0SkH2Eb0JGMKBd19
 Bqx3lJePy9gGafdPn2XKI8NetLrq9AmchAM2UsBf4vAUTQnPBWCl1cu.J_3J1wR1RhOT60n2eH5k
 Vt.ibTf5wdSr8Edq9ErKKesoiwbmZXmwqf.rCCf3aA1vgxYFYz0TbO387SWen2l7TtYOlUIpDyLy
 .VBqYAtUow3j5B8Dm4yjyPyAIcqwlOd8pvg8pAwevDy0aF1NKoKzpzVTWS_HCmuncZtJG6bmAyso
 4RKu7.OEYR80Pfyp8ZlBJOP1lAN.7XDROky.F19ZXbz9oeFQE99MHqt7BqwgRX8a_rCNufiXhQn8
 nk7TswDPhSp5ZvEtnZEkAaYD6WUmAu0BaC9RnkkpDiNNBAK9NSf8xnpeiWNNTGooe6fC2vX0z3Tb
 QY_OeBsQiq1fZb44SDnLoD3G3wHi1Nj9SOmDcsLt9dI5BrjPvZ13BXRWM4JPdD6PeugOykWD_hrp
 sEyA80NBbB2VmsFaFMSkA_bqqA6PTC.k5.Wz.hQOrBJPoriy77hY4tVF.EYTBasOTP5vlSrxZuAb
 Ry.DrTPeZu7USrW54YwZBypkuL4rKV2rcBNHT3CtF8a5LksqLhmpD37QpQse9w5WHn5XsNpEC5gg
 CJ9VhPZ2nbZeebaLhoWYk0ojK.AteuBB0HJGE5fnmzFRgMpAhrFNRcnaHfCufYGOdMXfDIR3aMdh
 2kMaF5rfKCUYPEENwZ2COkgWe8rKK0eB5ci5LdP6XhTqMyAYaBfASFY1s9ottXFlQZHz2F69Yhcc
 r6g9rUvqSyF18YIdnYSDDC.GaFHS7Se9Sl6H5caWlOS3Onb8ryMXTkeWBXLrpW6VzE0ocIENK9Am
 Rp7FJ.3pKsj_n7.KKlmCQR71Z2yQuWERYCNqpt67AvVg1C57nybKg7m2dor1iHFhRVBjtsDjN_m5
 hqUrFdzv56iPzin_p9WlFjNeYaY8lBe07mdHBaNFLweBHWaHr3581Y.pR4AhNVKPOp1OOjwqWd4x
 kMAWZPhRUVcL9mjCUlICJ8VJX6iClY_AJ427n1EikbrR_jROnNnX44E16Y.FUhuzVzkd96wjjLtt
 wfDgyz2Krm2B.FN.tpqh2mXeFWd7.hKaIw7sI6.kT49l1vd91gsPylOoQb4yOLTCxT2GUo5ZogWv
 Bxc4xm1gfE3Ubu5Smvs6FahJbA09dQhRdwvLm_8QRa1B3Wn.rkzE5WDS4GLcdCfePNf7waID.dCF
 ogNcnWL49V.eaC6Em71TuFPxDOkf111HWW1jqC30zoPpCrKTwuQuuR.B2YVtr9Y4NP.zFa9mjBZu
 iHdq0Q8Xw4__vDI5yNLMrUlW8rpy2vptpxT536PzNstCQRsHNC1KuAHEtEbck8Rd8F5jWZrwn8O0
 yOTpl11r37ymQ5y1RaKhTAWwV1Kqw_AHwteRhhsLHbcSV3Rv617BMTJlafza4wytsdVt5RJFbmQU
 bXLX0GsL4n.0DO7GyaH8Dc_UvcVaXLQxcH71x05zexP9in8Am4QuYdLL9mrabjHtCObqNptTjywT
 2FOpYOim3oxg0LfEdi1Sf4d3wTF3vR.WjbF7c0k3tNbkYHv2VzW7LeyQk1yquJGWA.fnv5Dh.KSq
 VHGdlzfEI2C5LUlKW6OpIMJ46Km4czauv6g5RDPPly7xx0utm2I1EH2GOriz4UqDFPxccf63rZzl
 oZNEOklebDxD1SXS37rWuKGDCrdpPLhexfu5mLqvdlMYWSkbDRVwQmeda9ZzWk20nvMdChAu0GvG
 _NDDTfd3FdhtH6E4wVhgTA005638CyPh7zd6TizDJ.O0O8GC5N3XVRXxobPn5YH6sRUhPHacwiyf
 f63kKsY_iblc_aZdd836P2zRQS011gA9mZfiNN79Z4I8cbOq4i8JPRiqqywciMfYxtMMj241dmuK
 JNQdLDvfL.A9lPJ7l3KjxU_NprBZT_yt6K4TS9bLnRyGP3uNdMUnfw07B_2_l8A1ermiwQM2Tm80
 7cQ4YpLCpkZyV2jLEGHazSPqquHqw7ECdy7bUShAakhFTQiqo6nf99B5sm0RaafxXh6zTf6ghVK4
 s0K_yjn8iFSz5qQU5h1d1PIajAaRyn6aSRbOP7pfO59NRFxlzC_vvxmRbvBjd.gRoNTtZvuBaQIX
 z2MV42HnA8sTBma9MakAaR.3kiUyVy.X36Mow2STXmfT5E0wlj5uRkngAASH82NY4cm6lxC5tY8f
 19aoTCtjmvNwWXYXKHgCQ_gmpN10gjwV1mVbAtYaRwD2ZfVFwMUrlG6fkIcE.I4aEujZu3gxbfSA
 4JJrew8inRjSQXbPSm312bbRewbHn.Ya7te4RJBszUSf5gZK.xLDy9il8xWU.ocxQ06GjAbC5Xi0
 fGKnMpHvR4iEILzl6bAqVBMO9PrLQ1pJHlAsM8WOOk70fY0loyF3LQKS5OQB_5F22g7blHFbcQl0
 d5KFgVfxBGTdKunnIcc9GXeZc3oaumIDDQt3a7pc-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Mon, 16 Nov 2020 17:01:25 +0000
Date:   Mon, 16 Nov 2020 17:01:21 +0000 (UTC)
From:   Prince Rassaq Rasmane <princerassaq@aol.com>
Reply-To: princerassaqrasmane201@gmail.com
Message-ID: <61451627.6087456.1605546081288@mail.yahoo.com>
Subject: Antiquities
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <61451627.6087456.1605546081288.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16944 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings,

I am delighted to write you this mail. Nowadays internet has been highly ab=
used. But i can assure you my claims are real and genuine. I am Prince Rass=
aq Rasmane, a young African who is passionate about the living standards of=
 his people. I am contacting you on behalf of my father the king of my vill=
age by name HRH. king Abdoul Rasmane 11th of Obokoma village, Bittuh west A=
frica, located around the border of Ghana and the eastern part of Burkina F=
aso.

There is a British/American buyer who is a business man and a dealer in Afr=
ican antiquities who initially expressed interest through his agent who cam=
e to Africa in 2011 in buying some antiquities which are our village herita=
ge of 470 years old but only for the objection of the village head.

Now, the concerned people in the village, e.g. the notables, the elders and=
 the villagers have spoken to the village king and a willingness to dispose=
 the antiquities for sale has been expressed. This is to raise fund that wi=
ll be realized from the sales for community development and also to put in =
place some social amenities like good hospitals, good schools, bridges and =
good roads that will improve the living conditions of the people in the vil=
lage.

Our village contacted the British buyer and he expressed his readiness to m=
ake payment against these antiquities if it is shipped out of Africa. He fu=
rther briefed us that he does not want to come down to Africa for any reaso=
n at the moment because he is so tight down now with his businesses and als=
o considering the issue of Corona virus.

He equally denied disclosing his buying price to us so long as the antiquit=
ies are still in Africa. That if seller should get this antiques out of Afr=
ica through a representative or facilitator he will sign a business contrac=
t with him and buy from him, maybe visit his country to confirm objects and=
 pay. This is a 100% legal rare vintage Artifacts that is worth millions of=
 dollars in the international market but we only ask for a reduced sum.

Dear, if you are interested we will forward you the address of the British =
buyer and photographs of these antiquities so that you can contact the buye=
r on our behalf and negotiate the price with him as here in the village we =
don=E2=80=99t have the opportunity to be exposed to international market.

Once you have reached agreement with the buyer we shall begin arrangements =
to immediately ship the three status collection Antiques to you so that buy=
er may conclude the transaction with you. Once sold, you are to deduct your=
 20% commission and transfer rest fund to us so we can begin our community =
projects. We will take a lot of delight if you treat this business with ser=
iousness and give it an esteem position. We await your prompt response rega=
rding this issue.

Please contact me through this  email (princerassaqrasmane201@gmail.com)

Best regards,
Prince Rassaq Rasmane
