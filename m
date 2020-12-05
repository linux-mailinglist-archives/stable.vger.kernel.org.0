Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F044B2CF986
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 06:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgLEFUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 00:20:51 -0500
Received: from sonic308-3.consmr.mail.bf2.yahoo.com ([74.6.130.42]:44885 "EHLO
        sonic308-3.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727093AbgLEFUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Dec 2020 00:20:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1607145584; bh=Rhd2J2SEPF/GyeQKjmzMtbg49c344gzPjWthoLVAB7c=; h=Date:From:Reply-To:Subject:References:From:Subject; b=o0NhJUTjlghSQh+v1BRQum9gS4rilYuQm5xSF/jXLcZ06KjVRoxEnBkjQ2chzCa/+nKy0H2uvXYe6wgC1Kys9ZUODRzHLLd3KXKsyrBPdbCOBsZhrXsjL218F1QZBG+0gO9RT2FFAhuQuQdODNhgQjyugCktA84jszE8wbkZkQuKFrbIL3gvOLeXjxY/u2KrkorTTIeESjXytuw99O8MPM58+4wOP4nOkBEvgcXHTpDCMNkDs0VLujQOAcWjC2uhPobV7swQGviT+cVtjE4BLjipWsJZoG95X4ona5MW32A5J7QubMTZwxaTYh1ACtrzew4vQt5e++JjK7Gfz19nJg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1607145584; bh=STFEGZNV2vgmUqRuGWOd0lyCgQJSRVqlQO3TIhxDPPv=; h=Date:From:Subject:From:Subject; b=QT2fx3F2rz1VEPFvkp2uwSvPRY0tiTByx08F/IM3k/TY35NW6mJvtBD3X1EVXAwmfNKKCkUfzRAhagXbsMkRRes5EB9O38DX7faU8YDlkf4+CJsLueukQCNOrfMiKD9Rga5p1smLvBqGFHdV8sQn1yl0zrtFW+hu96kU705hjdRn0mc2EOZEeruApSUdgxIkTUMtYeuJysGJWmNwzxljMpOH4WItw2AgexEBxSpDq53GKfbO+Y40L0seoEe7moo7n/BZsK12W2ut1t4g1lhmZbJ1TMb/BhfruIYtVxoOMuh5nfL9p3Wz4p/wMt++gYIoc/aYfVbuXr7sNLb9jn8X8A==
X-YMail-OSG: sStRWMQVM1mF34pfbuQpEAAjcK4lwm4tuNvD5sfGqIuLIy.vyViwBdSVKjEdvtb
 0DfRWAOBqESu.R5_4HTe_eAEJcjg4whEGsiT2S7MH.LB0xjzsDdLcd.crHTKNMde7awM95zeQjgK
 GSK9b4kLb7GeywHxuxZPbm60U6sKeXXgvq9TG73abVkbBG437VlOZ9WUDYpOJ_kPHRbjZbRXsuRt
 o6RkTiDQKIQcO3rkG6q.iWEqlC5ZB34_rQ6OJwu6CcQcCyaGJLSwuR71KCqfroK37_Khtp3xyJdM
 L6cHWiLAYpJCNZ5pTMO0zGuAQjGc9XJ9eyQWjoAvowz7oxlc7qOxw7loiC_4HLe8IKgScmC6i2BE
 tYaOUPW3lj6J6HkYeSiDO93BJ_1hKfvosA16JWmQZyMclKBEy2m0.wfABrpUAmnEsFeR6IOKQg_w
 VwQ7BoReflrvr6Z_jY4X2heuowArKqpzSSTddHt_8lYOK1dsKRzeOpNhuz9Vwi80_7aREmiDvqal
 upMcyaF7KP7yTuym3f.MMPjWV_ZayL_bdRREl9epm0QwzfE_9HQH1cRaavYUu_tbGl.93fNOgxMj
 RUwKwacqlxPzXAifI9E6EsqHoTo7Zs64x7bqCADcdeZ17YOgc12DaRHfAesvwB9imSKxo1ajDpIW
 kkQS4_Tjgy0KTgSegsOKoplZI6nRqLK.BLsPNsHAiXUv.iGTWeti0jY21eg0dmkLum_3Eg2JuT6M
 E4suC65nCvOFCBXkGo_sBWMrnoBl9w0OGzI2M.ob3Nvqe0mX1sFsPyPSYwAe2kz0RqYK2AwmDDk.
 JP3IFdHGct9LGk4gNKSK6qTLwYaOqK3UymHM8gfRZy_3xRS2uDmGPRZSzKr4coqKZ_bSsdxYBuZ6
 xb.9XhvpDwfiXixQ3rJAfYR_JOTCqMixPjaxtOzypMZRTXWNnFymJeH7amOv96zgxOagm9kergfx
 1OU94VnJPtDle.b1t6GayQVUY5JYIE99v6MSIWkMfhF9bMQyDitqMLnfldHR4mefpqHKgRu.aC9C
 NuU_gK0dF5woNDB3n0Ae_EMSCkGVwQUL3NXuNKA85Qe7WVItwT77pWZRx7yL9oXHWW7kLcXqQkK3
 GN.stA1fJT42mLUEcvipfiroQYVJCLPCj7lHDBrO35ySZx..SCK3aK4uXFL606MI1.o1VsBIoPD4
 aq0WG65M4CZ9PCv0tvEcZyc4MxGvivVArmxQ2xORdVd6a2Wr6Bm6lcJP_Qagz2sucCGPQuz8nu8M
 hyqiI4wDe8BvZwCFTgUTQ6AVbH_HO9DvacBsSe6ARhfjwjkdf2rlw9BuvHC4f.9U9JT5S9u7sFNr
 X7x_.2TwMmaGV4aXoiWbZRctQT3GFOkaJJBITEB8P2Zk4NHn6WWviaou7x6Zsnae_kAYSe679JuK
 QpduLkRQKLEfHIUhjb2_y1UeXpLcz1pxjClCHrYOgSSEuuNEH1CN_vW.WfWCOxZZ8Qm3emGpfozW
 rDQzjSMFAywomJyhV9YQb3qw5NbaW_a6xObyVgqp9_RSCy_kF6qI9mStoMABlvz98yoSETHsfXpc
 z1xY014NsBDu0.x66keD0PIHBZ_HTf3ekstwm6Bbh9KcraTGzrnubqVduBQmzZef_UK6lQGqCjqB
 uQcwtgmza7RWPISw5sSPPnG2gNx1zNk.4SOkGtZaBdUNnN1SSxSOkVeBDZMQk0QH4_RvyBVqglD_
 rnqSDvNsyPBs6pzC0FhoFzaEn3EsjVY0qDUmquvWqffUWflz3KQxSsmOyW2aWID7LJW22pBkqsT5
 MLg621Vx3_wGr1aDjE_yEcvxCz7cDbbo9hg7_NrevxbSfWOScLCCvyDVy_8T7AvPF3FkzZCpcDAu
 _jmQGn8BioOu8.d1IvW_we.xK8W3tWNwlI4fGGsT94f4SCJ2btv915LeJcVusKUbeR3qWm3rrUg2
 CVPlHVTB60ziQDXJjAK33xt_ypHgyFlmC.zNYqGKeLVUdr6Eo0b.A4JJxdXfXLML3BPNqT7xC9_r
 S4jGK0N7_7AG1nRrO9TaMl8.wO4IAmYVCJmvWWx2rTQUDkoP3SAwStanUyecgIaFGU5BbsS1VpId
 omH2wwjjUDrcFg_giW9PkPE3XvEIw.GMyqGRgCoXLx2KEkFW9g3e5r0ee.kCuY6SjPqe3RIKbDxU
 MkpFqrXqGlyT1.Fz7PrXS2KDZTBZMtzvRT0tEcZS3bm4hUmGYt18jMzAIwTe0OaTXtgRR_sRDp.l
 sgFE8xItkiyuyGSzDS4T3fBrzy7sjAKsO7cox_COmrKmUpGQPNfEy3hTjaIDtUH.tLLPFGGF1qNF
 KI_AVfWNYYyROe6oPZYKLKks3ujk3O5niWEU6aj4l7k5r5Wny1Oj2u_KuJ.S7SuIdN3YRDVJ39F6
 Ry2al9dOBEaojrxS8wF4xcFtHLJfu.yEvtxbOzWXX.p3dDyKUCK3ltBSMrQYIEI.wJttZmCiZIzZ
 2W.fejQizGBf2lS2Ou6HV4gzM3WqnvfHy9Do6p7VnuBa4Fn07I6Dsjcvi3Yn.ZONw.y4syghzADC
 jI8FloA775h0iQFdE5AfqJgQHgxM8K4xqF8Ssn_jesR8DJAzXJHSd8BhxtTnEV8lK5mbaDzMbim8
 1RcDTf.gHLiBjM79vKP5vpPVmlUs.8m6PHRYLSE7Flt1.5WrV0maojGVNCugPGbB5kIYsNAFsNDj
 r0mj2H9YjrZvHF6y5564.YV69K0P7Rye9WPAqbjtAMrXsFc_qEsr3zGdxu2CMRdRUHs_LsgUc3LY
 2rmbQUR4DvxHsbg8iAIDiTaZ6_0uoHZ6OmbFco3UJpV_AQtJ8K6SIl0ZiEOxaKNRrNijbcc2OojL
 rgPI.lUZTYQlpunM16Ub4phy1O8BKaDN142LRvFf9qSH9miJ_Rt0ZsHGm5tk6IoHUI5CM4K2fpxI
 pj8MW9AoOGJcou56rvOzuB8POCO_wugPYM5tGE_Lw2eOi0yrw3QCVWv87QSxL9ZeCF2X6k3f7MWg
 qdwWKnLHgW7UlYcF.TWM72z1sIlOkh2ClFp4G4bS8QwMcEq_eQ_kRYwf8QBnGt4hQr5kZ3mmAVsL
 QmPxqCLv4Wuej3NiCih.O2b93viAxTO49onq9CEjKhfg7X7rQu4B5hHBzDiOGlwGLmB9HGccUfRJ
 IGxYEYFOxf1mDsve84km.hsNvz8DbL6mMAzHS0RTLbul_ho17uev5SZIi6AM9Idx370cFnTfAFTw
 h5MiZ_4s9PdOEXrCmXR6mo_6Y6cD0FY31l_rpcyZCTtqh7QT6DkBACzV.I572whrQBxA5oNziN1_
 Tf7KjQfid3R1ljS4IV43IUpokz_0lfKmfqfWNHvMm5zCrNm81i83C8sMwvawKzf6iRP.ZBpxwJXL
 x.aJZ7GYhM9UyM5mpFNKk09SisQObaN1Pfc7dnnJdT0znBqvvuW8aaWjIMVk69JiQp8mWjVDYFSM
 tiKwucru_uw9BeZZTwBY6d6YK9pMH.suxH5gHQw6_9440UMEY28SKiOrmI2ztgYFr8fKV43sZIr1
 UHi1V2IIbXw6iH45SuZr518gFYcG.4ZQs7FWY4elFUxInxNsw312neY2IO02bBc95WuSBfQsz0lu
 KgCLQzN3EU_BV0IcgEe31Y8HH9gHQjuvQx5TzFmzMXQWPIXvOmstsuJAmdEa6gruYclN0VXoW23T
 DVJfZvhZP_D_6nUpYza5BPiF_ykGfmdS4DwJ.h4oIcMpzak9P8at_kOQwhLxbnpnpNeuRvOT8y5n
 Ug_HEG_wlakQfBJmrA2MpC.2BJgtRJv_E8QYkpsAFi7TrVF4.G6lmdIyMAlRehkizTCuKUkKUDo7
 oE2lp6Cji8b1b4EeEhwUJ9SuEIUSRdCOo6ofs0cZ1O8KgZQs9JjrkwxLijpMBThtDmfLRaEX3nQj
 LkPVUvWtJy1jncMYDoTg1VPsLDIzbgxxRKVbGoKRbywTY7WANAh_2kxtd9QrE4B3oFfNPqBeGgK2
 M.fMy7BE5JpImsM86EkBa7IIZCtPppWmcEE2MoLx_LRgXwzFYLT1LMI8wXQnbE8DRiz6_6ryLiJ_
 2c_bd5fZQVTPh2peXn4NF4xPmy9UgdRgdF.VnMHvmoGhVsLAnYesSE_GVKDjjX7jlPU3tB.Ym75n
 UZY_WiSlz9azh02c97lHN2itFB18NkMXKol5q937lGa7lncrGpJ68qqWsg49WvreH9viBmVRljcy
 1SKpOGYqrijRSBIfsES8Aqwh6KRF4AXwAPin1fuLlWSYD3nsAuv22aCOboFgt7EQs.IgWxrCG981
 1knZMLowyBiKO_bT8M9JGoiY354vzpdDGJe7emZN2eJ0lL5.pjDrc8cK5jponjvPHJCNFxpMuI5b
 FE7JKVPQbFExixidQfsMgOGi7wITqOzxDIGkWB5Rg0Jko72STMnOzMxvSu2ab076JxoB.WIle_qc
 ogv_cDVj5SXsZSzTXNqDibmCWgq9Q1sX8cFZaEKGs6JUCWTuxAn7X6m377x58t3qvCl2VddozYPl
 RshuLFeB6EDG1NKDZvSyyJbWxKoXzPg0ILruGcw4TvtoGYTyc.7PKonXBMmHNC4sGYE9CTWdansg
 K.EUHhClfYH5qAJ3yArPPy0OWZP.3M8mSTrp47qzouulQZpLHR1HH8eX3pVKDVkxrFXf.5yAk4z8
 G0pF3wLs3qI41hMlsM8Va0o1SBIxlxbGX2HAyapfQEiEOVCMREsTgmg_bOu.M5aMp2yvQdzzwaHF
 jn_ZMIWcIO8gOsP0IEdDjaDGZPWE1Q5amsyptUooGZBr5842iksKO7dsZjBoamBId0eIkc3oNPIv
 lpSCT2M9tp6tma8.uR6As2GkL4LxTM19xsbw1dZ7xq8BkoPWmlainaRsBYTljPaPJt8AwKJG0MdL
 wXJlLM6bVNrwrcI5a6AKFnG1Ss2m2SG0wS9GfNfLE4DgM9qjICNfER7BGxS6yd.dRpvn6MG4IY2r
 HzArSOt5XWI21wbTir8_GYaFGyHRTjUgxQEXsEG44pCIDQs6.ems5aU7winWWhBzNG4xBiZYK9_P
 bKHCvgxcKC5e3iVoQYkIvGhLaq7MExSCQ1u41AzFyZdifGoL4.0QKWufIylJkXDP1fR7YgFVT0Cz
 Mrb73lxFe2BxT55Q_rGT9Yfs28Cr_PXk0negUA16KA3F1pfETeoBms7dzRYDYlKOQweJq1gAyqbC
 OJeaqFjItJfvqrUMbFlEpcRN.C58bn29tnbnt0jMuk3rGAlKemadG.cHX0WRPMUQdR5S2nG247TB
 F1rkY139YNmGhKhNhiNXV
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.bf2.yahoo.com with HTTP; Sat, 5 Dec 2020 05:19:44 +0000
Date:   Sat, 5 Dec 2020 05:19:41 +0000 (UTC)
From:   Prince Rassaq Rasmane <princerassaq@aol.com>
Reply-To: princerassaqrasmane201@gmail.com
Message-ID: <506152735.2990098.1607145581376@mail.yahoo.com>
Subject: Antiquities
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <506152735.2990098.1607145581376.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.17111 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36
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
