Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A57297B27
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 09:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759515AbgJXHMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 03:12:31 -0400
Received: from sonic312-27.consmr.mail.ir2.yahoo.com ([77.238.178.98]:41981
        "EHLO sonic312-27.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759506AbgJXHMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 03:12:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603523547; bh=yKaVYPiFTbTCWqVtsBP4RcnJTwVCc8ARsZm7q5RKFT4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=aSnyotpHLZt+AGGRa3vAcP3i16+Gzcry2yHDeAgm6pVQ31znUNJ9WgJhzdLwd00X67Z68hOO6l0zPm3s7cxEZEQwPUiP9wpU3JSok+QUAxSudXYab9ey2nt28Uv/9FfFmOrFVwPN8fX2eEVPxU+rmYoBi5ffrYaIH57lIkX+lZrtSmle9gAf8tBX47r9DrSEztGWXCJSCskOHNfAmlKCO0XMSkSGwFRyh0lED8beBaqphUcBFMl9Iu/dgzfE5UOzfFUIxEcIo7CDOa2ZgUTuEC0t2RztMJ8fu2DMp00mDhJq4k0h2UFgBv30rWvC2fnmRod7vvmHywVDsw2op+MSmw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603523547; bh=8hQqkEAz6An0eOR/mrf4qIpIpf6oQJM3zcRnXgQoPSE=; h=Date:From:Subject; b=CggmVPC8vOxMNAOTNkE1hBFbFtbBQPg7g6wSOm4VG63D9GwiCQL4NoN1E+6qxzKu4mlI3jqfvU1MYfAvA7ZC+2lN8jKbRKUXznB5rAGFT1ZxUDWBH6WSDmELtwDEp1bGk/UBdy2toZNMPCBtkTbn6vaBxkS8+riXVDflAW+1PcK36MnxZ73nVsLrvMQ0g+5yKZ7p8iZx2I1hU8FLAlOOIHigV6tKj00LTvNg/K7Bf2CLPFiQ6uuNp2rT+/6EaRkiiBd1XfEoo4rZvS2W/BNcRVRR6HDfjz80ksmkjqcsE7TqSRMm4juErmRd81ojGH8run4znuEe2bPisZC377Ac4w==
X-YMail-OSG: FdNGBM4VM1niGQxbdPnc4z2UzUVzEiC2u9LSy8hf38KEa.zimvolKXReMWZRUrz
 JFvqQWiNypHkGagLdoPuH42VuWGyRLVZdMvFJTLq.WvUY7S_P3CgwzYsq43aJSD_TXpuiKLjs8jZ
 2uoSKK98rMuup58rX44ywa83KG6F1y2lhVW_7hDEPmaOHsHCXUB8oRf3juBmWfN2z4gq_0bl.y4l
 4OfRhm.Gi_fN8tj.Tqh625N_4ULsG8jehfeBbbdbFlZ6E3p4BM1JzR22hf_KqBcRtXu06VrMfdRr
 DKBLbzogul2noTxKFeom79BS6OXfrGu.eOMd3.g_Fbsf6l7Rc.woYHSLjXCVt07k1.12aQinW.67
 A0E0M_UTX310zVlu1u1PkqD6G3MYi3RhFDuzeP7DkceyFtdsFF6h.5ZFSGQ9xvY6BLfAXSKiremf
 IrW163d1GP9B_IyR6aotLj77mcnWlcFn1c9IiEktGG3YE9UGyCCHnyFLP2kF6M6i50sEc0wMBHEe
 VLgVg8BIHUx_BuOhOt08IIZJQlZiK8lX9H8gH8tcui763zMz6yZlW_zTYHtHHSKvKCT4HHWL2kR4
 349ZXgRxJ6hrjxOuiTTrI86nDEDO5AwwNcxim.HNqbM9IeyzSau7aTJ90A65M7Itni67KP3U.LVU
 CGhld9DWRWGsnR0EfCiVjXhiW5nfWG4raqP7mtZ3ievQdvcKcRdHLK0QWOmPRiWL9ynLmffz_mD1
 7W9Tmc_duS94ErhNfEXDSQEx11M7hK283xjGAzk6beav_W8gGnvVfq_KG6cIaxh1d5VUpQRbxPq1
 lh7pBdskCbBwjUOzhmF2qcCUvlPTHlWs4quKbIKBbgF0swNbTZBWhZHwVGrubpepELM_TDaGJPc3
 EANwvkH.8iwdjmAhGF2nM.i59e5uducjMStWv8MHktXKGcvf691DwzvY_TrXk6i7ENPL9sqv0jp0
 .nudcYe7vS4GOaBnNHvjgbTmeHXjN5g7b7B606gQIxH6LwYdKyLb6usdQjZk8FoHAjNFVbtwDoGw
 EU2zdnNGQzg1OljUOcZyJ_9quXB0OR5Lj8FW6fin0btWl2YeJXGluICqkFMyvE_e5HDGdHL1ym0v
 jLXqy8KnLpS1jIs1.b02kTIMtuPzSx53h4RJvaR_q5aYAyLR8tJyO.1foIkLMxV7nPQu.y8V.rui
 3NobDC8l1S7t9OG5WlatKltE11vVbpKz4Zmq3FP2Zzzx41ux7aMZxHlvjG0Jn3_9iJCJ61ClmlhE
 Y3QmecGUDbio0TUN83livo82Yw2mQ7ZCDGH4vgHwOHfDfEX2fbt4PS1UirklilB60eBxmKwc_zET
 HqvvXz_Ji4R0Vw2QNV5DIANG7fbO49Bi3zXR_5.x3J19iqSfyHsELcjiOv83_pgcBFQCapWQUtii
 WpyeaIC9ThPYFMIhIBK1PeznDDyQBBEvmrULw3p5YRo833AEpSa6f5u3EUKS9UxDy4_b8Q63sFDq
 U.wDBGGbNsXmcH6LxuGwHvfLruyneNmOomfs_kY.SCmyf4yGmvsEinuhLGW8JfYcoCY.Q5rdrIqx
 shcvnppB1D0kE437gRzZAFVGrwlmQ2JErt_oOkrmw1xhC.Blyu0kOxMkF4NSt0WHEX7yfKVqr6gD
 EoaJS_HGe9oYIa.Rtljx7o_pdB0Q8eOzPN8GFFA6wz8ZYbDjfpER145vNXFG0N6AvqxjxjNGzonq
 dYWGcGh8GoDUsCgaMHCTsYyzXJ2S.xivFVzRTuhTzZIPWpdpEZVx6F7tTBWZyKr0eieGuUG.FPaz
 mzVJwPbKJmwIaB6G8hTZZojg62xVRgJMCvslWUAU3Z.d6.81gSG1ALW7Qu769SxNV5IHV6LTQ4Ea
 qkfcQWV.NRIaW9McYH3wo3utB89P9WdUSNHhnbtQsYRYVcBam8rIMsCzyNr3FBxBkVIt00TQdK7n
 jsUaGIJ5OJGvTn1D9JeHsaR_P1WT6LMvwrmc9RpVRie_gkH0H5hK0m_yxQs2QZ4kFhyQbVRI_.xj
 US1OnKhWwIy2i90mb5syA3Cr9rtpg8ohCkUKPSaKExnjTiX9W05M0Rrl13xnQw0JWmjZmfcXegGf
 0f.BJDpNCa7nyEt2OkQPjZHsgwABMPTyNiZoQ6dKxxljm.IaoxKeN4DnsBLO1J4HMwAvgtIWLlMn
 F.VijAx6BjAckJSNIDTi5A03RsmxAU6aQ27TswiTVUXwJ_IKgXBmF1DJ0XnvngyCO_XKC2ywARFw
 _VAE17FcY5QakxEHlja.GYbs0VADQCXNOdW9s34MBK8CD4VRyUrDqYQxVvy6voLh5_XKQUpIc.rn
 pTAcdLQOWbhS0cTms_2xtzR61K4mqymtbF0kpzQyFCOLTXAU4JtCRmP0o25A2lcDCGe91gPi1EAV
 phUn42DYqpnlzCMcUv9rHGTdojTVRjuV8EjAqf0RGVwzsDBR9v9keQC5ev0wuxMxAPIuIKYKjyrg
 Wbpr8D.E5AgIDRigo4xMELh6lD_1Twf5WBOYeDoWPpC2r5LUkSlqoLT1WE_O4fCFRYUXxpV1zYPK
 t9Eu0MgkqVwPqdYOMI_k7Zve8QLhGq_nnOsnsgTI4uwWicgIGfIsZVAW.weWSaAkZ99Eu4V6u5Os
 mAPoWmHF8HvsMzG17Ch6h2uwfb6Q9SJUooKoDa_TFehEidzIaeFXmiLhk.u9lHoGm9REd_YzblXF
 sG.IrgvKKjK5FiRSMgijPDyk1HXj9q2C2P84QrANZ1PuaR7JKg_sS4QUZRh5Q8Fmwt.8v.NoJrNL
 4dji1JrEd70NC3flroTdeiyV4x_xHLyQ2QQ1e_ctiJ95Hq2I6fjIOGP8ec_4Xw4g2Zh.12E4X2tZ
 v8h8gtlDYequ6Lic3BlnAjt9xw_Fb394tgHKp1QyELEnWSXRBlZ6FkRA7kuhnZCHDZZ4Ax7xR4UL
 _jdHSChYRhKcMgROzM90YF_E46qSde.aCTjdl5rNIU3mMJmz4uqBcbMmo5H_lB8Z7FaaqFC1why7
 GRq9MC7qhlvKwzdr_3YGNkDcDBQKkqyCBiuZGTGXdrQTVf__sw9DMC6gR5IMB3w9qV4kWqc7qw4x
 8oXm2VdiN3vX810T_4DZnG9_Ya5x.7gckLKZSatqmGOwMVZ4Oc_i3enMnqTPPgRTxXDE9DmFU4jr
 CnK5me2MEejgzVU.1.YsLeMedLMstQpCgh60CMbOCZUa1cjOCxELAZ1h43dfpYkEKcoOtJVnuDi7
 4ftlhWnqpETLGvMpvqkA9xe1VupHcgzyZGOmoOigbgGuxQLWOWzmnQGRc3XF9dQMoIJG63nVXOh8
 oz3DdQ4oS4oB9prOh8LZjh8xxoL1W.nTI7j2IOwvakoKQajQScmyVuWh1v_hUCUW5xTK4D2rkBGA
 DAn6alEbkFDnT_VlsWh52hG8g9bmbhU1SRMm1XKGBfFYPD.HIbcYZ1767yVlSQDdEvYvFUaetr7d
 XWI3IRBhWAQq7OuYTvUmojCTRMSNvizIsVHGjB5m8KpmHtu4kyz08ZLOnRKUP_ETmBohftSMJTOn
 MTOgCijk8_fCkG7Z3rU2OlQmgkifAlDQ7SDjwb1f54RGSMrhLf.zZOv3AmwL4RMT8mJcWVqKynRk
 99x7znwUkseqzMpuk9bAioa3VA3p_1A2zy1udLaFMjvp05nkVLrgFwZwNovpW0act9.DunHxsxax
 IOdyAE3SObwp4tYRw6X22ve8IklyZPKkw4DRHmuen2JgfmK._JtunsE1Bc5bXAPl26be9.lga959
 IG3RLOZ4gL7I9_6m23FnRLhwg8jArfXNd4WMSVFdLoxwNUVwx39op3JnkgdirBmmDFladsfXrSOO
 IziByCfxP..d8YokupoiCDB56dkX3RT4hg1b_ZbrenHxLUFWvGZFfFTM9MuOZxio4Hy4w3rQO0kI
 eZvBq31.6q7lKSgpAafkX5f9HQ6Iim6Ms4R6qwUawcRbDWpywYo3jDDT6MpzK43jFEB5givp1VDx
 FFXaJhYuiBpj6cVhTkeRUNOmGDdefwe3Ghb3m9.J5AwQzxnfELWRSnPABWKq9di0k9XNJULLxi0A
 VFzRyShFeouFPsd4NuybD6jIEgQ1yv3OVGZgfCzQsIRH572qeuW8UvxIkT9C5xqhJRznkCRuV6G.
 uCr.t93xBcBioEYrgLnLozFrRhS5FmFnG1m0w_aYNdVb1jaINdKF0D2IqXpGUQ6taGQ.b1k352bf
 8sB0qXJYJpeLOYAtAbTqYvZmLLgt7xRvChl7Hr3Q7T_5lujTcHJic2aUjL3WhYgJSfx8L6kDkqEM
 wDTuR5lVtVIJYlI6nUkJR_jFJQ8rQJBTm03tkhG8R6eAYx_IQeV85Onf7db.BMBm4Ifbkw2CeBhD
 psrxCSvuohgwviNnDmQ7ogdfIpwMGUZYzY_iepStzPedqveQe5f26BEuz_quCrDQdref4HbhZz6k
 tdFAjtsUklx0F8jDB5jVD7A89VAqayCztek2UGm.URcZisZ5woTsiyYoO.Psb_FbhnK_A05lLbuZ
 PIJJqtlNOMiSarwqqhbwkFKcKbmfDRSwWUmWNelXPf1l.F1ggHC7eP4VjSOZHLpXHQnwA7xZf9.x
 SK83bdJ6rmRlVZVB0nySXfTnyehbjmZqGplFoumRKGQuvbyLVRteQ_j5coQ2GE7chr2AQUb9bq71
 GWcJyAuEgbwiQsM7KoC33qreNuPvDCWuvAApohRH44.SdDCohE92vUd4OdgybP67gsI3s3Y4h8g3
 tEG2EmHa7vY66K4s7iMcOe9Fz_JNSDyjXh5xw1kTReeZ0DlLmdHDME86I.EixyZSoMAffr_ENc3Q
 h591vYx0cmrxQTCrynkdVAwi6WlnQkh0LoGYWWvHLnYnpLVokgh_seDKKvhnKZ0CzqPJUFoDJIBM
 .PE1jSqsQ8uWPdHfg5Y4jRI0SFF4L176b3jfxGy8pNGsj9mWbAv96uabnIU7cmb0AR5CywuY2pKl
 nKri2NRO9vWnSnW3zXbeMXpGF.xnFFw4MRg48v5uoHe.jFwJgg8czScgQDQVolDeXT5a53v4AuRJ
 UlGSRZ0m31gKG4qpDHC1CQP.KUI1j.QLJiZ3ORyhLo3Ib.UVBb_Y5dm75qQuZ5yzeQvr7Y3fm3gr
 hpRimgOSCPRR86ypjzSkI3P2k6f96ZCBzi8CYDme0I9FpgIzyJMX4.vYWJiW4vmmZNAjpz6eSkEx
 bh0pR7ial9emux73AawYphy2gkaqsbfHrvCEMkYFp7_Qe9r81iPNtHQRXPQnmh2MAjVrSVQNAVkY
 1DENg3XJVY7DgiBMZgXNXd2uFtuZng.4c1vBUZSfb0OX_XEPsn9H7UQiLBxKCUaZ6OZcWJmxiIAP
 Soy_gOl7cnI4zUUUfmcciFyvX7ymb0adhWPWndnRXCx_OY4.Z1wSUh1SPDaPfDFT3kIuyCw7qgq8
 8B_GZQw_pPQl70kWvlQfznUdjvVlCeykx9C_aI.GrG9RenORE5VtnWW90c_AAfnYhTVsli63JhER
 iyp0kyeV1nNqzWx3VrigQd1wWsbJroX0zRQyStvnKQyQ5euK_vqedCvdIy9Ues3H2k6oTHF8L0Oh
 oSodpz5vcpOUiCjJwnOTSpj25MMFbdZ_Gzt1YTILpVL3cOXS.WYWgcEctMgRpkSyrvtzMmIlcFTA
 NHilC3AgzoL7Ya3f.ug--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ir2.yahoo.com with HTTP; Sat, 24 Oct 2020 07:12:27 +0000
Date:   Sat, 24 Oct 2020 07:12:25 +0000 (UTC)
From:   Aisha Gaddafi <aishmgaddafi@gmail.com>
Reply-To: aishmgaddafi@gmail.com
Message-ID: <306414152.109593.1603523545610@mail.yahoo.com>
Subject: Greetings dear friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <306414152.109593.1603523545610.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings dear friend,

I wish to make a reward donation to assist the poor and the less privileged through you as directed by GOD in your country. After searching for a trustworthy person that can handle this project I decided to contact you. I am making this donation after recovering part of my inherited funds from the Libya Government and considering the hardship brought by the present pandemic to mankind

 I wish to reward you with a token gift of US$1, 000, 000, 00 One million United State Dollars. Which I have given to Rev Dr John Walter Sinclair ,who was the Rev Father in charge of the refugee camp that we were in Burkina Faso during the crisis in my country Libya .

Please I would like you to contact the Rev Father immediately at drjohnwalter2009@gmail.com so that he can send you the international bank draft which is in your name and favor

Right now I am in Islamic republic of Iran with my new partner. I would like you to use part of the money to build an orphanage home which you will name after me .Please inform me as soon as you receive my humble donation ok.

Yours Aisha Gaddafi
