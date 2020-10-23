Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94260296B42
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 10:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460666AbgJWIfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 04:35:18 -0400
Received: from sonic306-20.consmr.mail.ne1.yahoo.com ([66.163.189.82]:41511
        "EHLO sonic306-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S460665AbgJWIfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Oct 2020 04:35:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603442116; bh=B9FynONTlj3nF0+gmds9WbWzodfi14FwitbyEyRJAf8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=YU75QcZKDB5XnHqts7ReWZgVIbUh4ImpT2TF+jx+Ddc5bKRDtWHA0x7qyh1IjSjuUyraukXehXbD8vkZJrLMbamcZ3pfCazAkGKvCi6kNwQpb9uVavjJg4PryxNvLfMo/fxtECKEbxOWFvPPBA/2k+S4b49YyrIhEa0trd2HkLW2hFfT19/TejQPcNbMFP+WHdUZEPOi/btYdr5MxJ9zrHnkq9wnJlrCMsBd3Fhv9GDCTMtbkGijtj3+dePDewnxQs3E2E4krq5f/HPG8UdWbsYr/zyuGTESx2TmSSaSG4lyHIzhe9V19bYQAIXJb1pua+r2tsK/5N3qDHZr4v6sPw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1603442116; bh=KHQI7tLDMUxgeV7qfF5NCPL8xi86IZIdP6lAiqCcRvW=; h=Date:From:Subject; b=j1jMwswwHB1cIGj5jFeZwNNCbhWqEmMHUsSyl+/GiIylIBnE3125EXGk4QvkMPUqEcwBjrkkZCj3bBs6/q24JUVG8mZ726mDKsFtdjAQlCIQNuxlH1l4O/MUB331EfZyIvVvcEWvjtsn11L2mPVIN4arjdIfJ/BPcAZK5yDkEohw1ClVhek9tiSCeu0Mc44zZL8K3vpAu/lBhlJwyLfpPDIc5L48780aC9m1fPVcgol77p1I8dbw7DhnBvfGTGuMzvspiKAnlrQxf+4TpYZoA/QOaIEgv0Fy1wJbH2aWWZuPHH+EW0zok5rBSgPbFbTZ2I7u/KNH6SpC8+ZJHqyFUA==
X-YMail-OSG: T6zVuM4VM1naX8zrJEF0vBwkOO48HghEe3OlBi0mCvkgNRxdWqRrlMSInQp1JaK
 .Z10DDO5GRQqsxwE_TmRQuObXJAY0FfWdB38oUoUjfJDLNw.rEBR3Jrl_pX0fd8Ti1CxWLVx5mO_
 UrunX1uT05M.Q4NRZVUdYwLRmkm.tpPipUbJrlVdVS6tbApOj5ww457dQVm2qhLZs95Y_KYvKBfN
 lroue8hhuWvSRSrc.r7xiLhphKGdvOeZA1JBQkgnSETRiWGPw4kj5OSj1niCTl0AJ7fNkub37Csx
 WaaVsnLO2bVhbP5Lweqb4x7xTD4oa6H81E8bl1CpbCdw5ez3msfc0GWtb9JtzNUuUD.kYeqkdmZU
 fTHCW4Yjav2SIoZtyVRD8MHkJ685GU3aJd9CVa7THQEFVnGm4FdQi1kq3Htll6K53ySpqWqIDcv1
 JZRXec87SneloL0MnfuOW8CjDQkWNsYyE6uV9RQmJl1o7X4w29qHgSiOL0YLQA56WkWOlBRo6Pqc
 FceUdHuaf5fTsZ_hb0XbBPSQe.pFblHS_zZxyGGnsBn2Iesjs6QH3Mg_ITReUGZHhtbhyOA_9hP_
 l8GfkcfXfED03Oyn2CvjR0G2_xYoyLmSF27Aqkz.Zx_eOYftHe5PZmzz9TmY0JSrljl6TWGW4d.2
 gtR2uY7Bqs3X6moMY4dxVbuFZfnWv7TrrhUd6_4xxAbx7HBmvj6WzZkPwNytQRomUCp4ICmMJoUu
 YEouF7ZvFSvCVwEj1QCcUGtgFiXhLU0vzpRG2TVADMN28.i5rwFSCDTmbULiN3ueWMdDP8LwYQC1
 UTILnQt_9t42rZk4CAMH7p1uAei4WOmI_klPiSGq.YUDe4lp.mtC.TGCpsHXTFPwwxGCUEXfMpbS
 vePUQ8AJH5dpM7x54VoU7rfChVbs0MdhyWxicAbqNZD0RueJFG7F03JrEnpOpvV31hvgl4xhtBXO
 a0g_b5V.pmPP58k1Rliu23jUTOju22n04PwYp7zpEVqCJSe54S_7C9Vd8SMLM2c7.fbvP1jb8fm3
 wq_OO.l_hK4.7fvjeNrvJBwKPLcWmKOiwYmonW9FO6_aDvx1GawFGORSAFw17xMuN5nXf4ZL15aG
 itsMhlci3LUXPKc.4vF4JfU1Bi3EKd2MxLF2G9MaAygiWCGnErk3RHeJflgPj_rOKGU1UO.qIcIv
 k9ffws1wD4RBjz_xfgbka69lh88vHHfjoj_n9vRQ5JhYH1E9rvW2Hji3B_PpA4gXGscjPFB5RNsW
 cloml4mg2RWxklPgOm3L3qa91tmWNUJ1fNbA8Myxq1YG1noybuFWJpfCPgJLZtcfK6TVNyWllWvf
 1YKI0Haag1tdvkq77L9y3Dpd_56z8Mmx8EP0tCHCVjM1qIgMXnbOiBBeIz1eLikgykbi.3ZldeLS
 .GQxh1yU334VhRRjNoo2esVLW03rfa.gLUKN3cKkA6MkxwSWWsatGGiQ4Hx8o4yaGWNtP.fJ.DHZ
 lpa8_ayg6B7QHMhoj40njSNsN3gqN9t3Z1Q.VwBFuAyKLP0nC3DUjkGlZhJZG7IVpoOuIjmlbWEr
 t8b9aagTP8xND0Da1nmAN_j8Ex_ZBAGwcUQgRL0PwwMmacO37LRbgRkxxDHyt.A1Xf6kNbRDoz5E
 O.Fwn49wFcpZo68TtV2zVngc.VoIMycDgKbY0ddwGEcA8c.ecfE8cb1TFggO48UL14mhjnKBkofq
 6VbnPfPIAOhqOtuaJ6bUc.BJgyLVii3nGTZoAAkQZ3jewwCjheWityc4._Y7lICZezaE9dh9gtmw
 Ezs_Ne668ibpzgTsp0lhjqDcIn6NMqwYugTYegCzjBTOUWEdA3TTRT1mzI506OkBAMsNH6.2jBW7
 FE_foNAIstCpMSayd_j2wROoHmqEzb163qrQS5t9ntqD9D3bJnsYL2twPvdUAUK4.KUfdc.jEdLv
 Qb0KkDAhq6Enjx3LhzbdzKvzVKKdu._VtlQWskIwSZJGt9CNAtLXVX6N7dILtFiOp1jvooQfT4vI
 VOU2sejeeSCPd4WGRz8jKjbEgGEkGTYMOs9Bi8Rz_Il4RKC2k2KHhJHZr2QBFs76v0q8e.c5Xyzm
 WUOVgzIF9zmSf4loekwecuN5z8gjAPbsyrkc1sAO6w4vESluhe.sJcYktX8HreKILQb0x192ZfSI
 cGTlAl5lPYzcYFOaijafYLFA1jxk3p02posVY7P1oH8LYOrfumyZeqh0ixm3F3XWy0CSrxJKOd_n
 4xijn7Ct4A1QgPjcAcirzGjXA2RmQ_Rf_yFAZzvPtIzYjcabm5lCYQKN5D15i4e0VQBbk5v_5Wwo
 qvqNjp_iB_wM3L7jc3OnG0sgWBbINSltMJl.jWK5Yjf0Aj4dHp6zCRTAw419mUjjbab.urnWjtOV
 oPieaafyiDnxiqazkA7iU1JaKxByQ_odDASRde_s10U8W2ZD_im6ecuzQE70Y9oeCWVb86u3lOjg
 W2VYyfcDrUabhjKxA0mN_.1hMXA2palyfGODwi7g3QnadAlPwIBB3RKe4.DA.2CqDVzeYbzM2oQz
 wzWN1YvLS8gskHH3k0PZfGolyjoJsv7.qdqGu_ZFRTmr6ZsgF7hNoACfeQQtfcqoLoEEnTuj2Ece
 4aoN8wiI2lCcpPWi98bREWCjV_gm8sn2tDoRYHrmbQnv2t6LJrWhRYnceAEbFzs6M7Fg7b4N3sQ3
 LY6aFUdXH612wpOPpyz8eQmEbAHG4qS4ZpjDfsFggUik2Um6vb9f4WPWzTruBIMPLf5_8q5Dnhaf
 eMWL8pNhx253tybK3gf5EPIEr46S8IddUntvfiq9UHfRVOv8xXO5voZO3156PG_.uFwL6sAP4UHb
 u7rC437AoNxM_u7kE9Ku7gFnVMWViV_foxBFD1BZCnrQVNPAS1qw_M0GboByRvET9AZLYBgkreSr
 oHx8Az.oCBI.XZkRJyHwdbefD1.5TX.3T1Iii19AThvZrecYfAzQB0uJ8NjQD7ZE.uV2JyhEOyDm
 aZcP1YlHuI1WGB0bXTwEAeMIplA6MKzXU8hVFRTB8_LyXgo_zyVEOmNQ7bbrFfO5vLqO0_WnIFYB
 TFi35N8RRMRCtEzELKWqTQblVjdIWUgumncKdBHU_rcRRUXmQPzH8xd4ZuwoS00UFPsgUXhimTj8
 X7csK6c.vmvvwGGiM2fT9ajcaUMnDUKLCBDYpBHdFuuDBZanV3FQo4H.bjXnPaVluODd7x3s6IWf
 iHRNcPICHBXOF5xgitYn5yVpPVJJnUbaF9i0pgjOZsOgxHFOHMKrcsJs0GzKzrN4.6lgENA4TXaF
 zPbH.zToAmOM5E7pzbLjKHWK4djbhBhen_8zwXh974qXaSvwIB83quzLrkdY8gb5uAzfX5hdCdwf
 4QKMZrBLcrRHQryg9FHIV6LKttQ7zsfeSEYLjlODIscpvt7FdjuV9wDUnZiV2zlOf67uJ8.mu6xN
 G1G8uHZhkHDulC6uNCiRQ_ycAGcVSCazJztio6gDojZeDc25jAwWOqTyxxgZm7MNfve.DPBXYLLX
 HqCFIFSH0eoT7qt9RZPXcUN3M42ocae8tnL4QG6Dllpurk_5itnU35qhWzuRfaApTmmB5.9VdsDq
 b6oc69PqfMIip7bwD_.hmPG3crv07BvEW_4bW0KzggccgXmiv9qCtQ7s8rXMkKTHMIPu0bWhoEgu
 tUxo88FulhmhxEBS5ztwgY.EeJg_WOkpN8C6MuFP0WnOngYBYjZYyGzpvh7A9gLEqSiB0MrkSLNj
 J7hqNR_yGrAQDlqOIzCjtZDElBFmjEjFAdwN4EKgI_IPjVfQiyE4AqCGQy7XheE0EeljBYbzfQlZ
 kBhU4tx3qZACiQSf.7UoL0Dg9QX_2ZKjFmtnu5r3.DZXv1Y1q6UMQTZKsxC_dk8e2BrPBlIOvnW9
 6qyZr24wKAQ8tKpP23XVW92Agpadk7ToCdf11IC38zmJtfVQjT3ZOnVcCl1ISjSs3LHOcqjASo5Y
 mjke8cWaUqtcSbvy74bLxsQtBfP62CN45g81PXMTnstLRfyfy_zZE20bpsH0QPs73AjcHN0uDXVI
 GtzT2Z20FFfuE65RqXkc0htGv8NLb2fUqpJDQeLPxh69kiha2J8ysfzcyb7kmQ1z8OTE4tSmxa4u
 1zzHNLkaXFAs0URg4SttXAu6PKGnFjw2nfoHTdxTAWpmZYY4ZvDcwJy0iXouaLuE8TwHLMpFXz9.
 ilZW2Kd05x_ZSZ5ncuZTQ0TgOAh9YLLVdqEyfSDOggzxEdR4NXRZEWJncVjnWnnnQioVaMeFO.QJ
 xc4RkY640g4Ntm.2sidWKq8w9UpoM1Tx7tgjNjA.JoDXYh2tBdVUc_sc4QoSQjYZpgvZQnOvU5KR
 NfNU_I5p7jMmgaz5_PR_KbHp6YNIDGPdFpHdoOksfYsII021AwT1167ogcGF1XSZr.63FTFT0.tm
 RDylJccViwMBkssl2SuQouu6FZsz6RHvPTHVVe9nWx5I.B6lG4FZ6LH3hisysWkisUq.w8tnVfID
 FqXALLsYWzyOhaKmFpCmbGQcE3iEVBkfDIe5jyCXjAEddnUDv5GT9.zkwv.iFFfawFbohDCBHzXo
 SF_B2qjHsVFeUS_1YARs9ZqEjCjEgRHi4k0udIIwxMNgzUrargOR9mvcWITe60cUMdDBiy81pufW
 FYEy3zDzpcOAEpYlNF8D_0qCdCFPOGlZBNYs6WVLhVZRcKzIpTU_xVO5ber3thMclEsL8je7YnN5
 Yb_B00ttWisowdLWodrcj1YMcIcreTIQo.YpNygEPT3lNkzZX51asJFKoUp1lVJVimIpnMe28u5j
 .sC2WNiwFVBlAhNAhDG90te0UdRfEpwvoO0zYYlno_ccaJzXyAt.1NBm.e_f4QlDczj7F.vsynV3
 L5LnZHUJo4IlngnNT0BlgxJ9KADETEMr11UAsRV9HTuL204vKCwvOZNCZSXk2JgFW8YqTvXRLh0B
 TUOFxGWdZUxR5oMKz3OxijTkABLMQEOsOM3k5h0bnt791p9EAUw1OHa9ZXuquBFpXq0rI4iyegRT
 Esm0EWm1UBpKz5tzK0iVEvKOnRGW9oRQEF3ZKfcuc5JN8tOsK5RG6Ew3vJjGpSZTQB8k6qck0cum
 t.F6TGATDJwMDHqX8SwDOywTqoQvD72XPeAHxZEzx2lWNFYkih4wVTytS.LhqaHewiyOA8pSqRDt
 Jksy3o2PUT4Pn7IiynGl6JS2kPZxCCWpV8sva0UrAYCTFItEiJfpx_fESDURVGOntbyDdovU_D9B
 88lzz0lkY3UlfpbrOek0RqWt56HABx2EuinQtNiL6hbq_nDdIgNWZK75LrTDqOJ5fA9NyMh7Ha4R
 iMv8M6NHKitgdhcWbwb9czKignBZ_KvXucY79Dqjpt8FHgEsH1dQfiIBRCqRCJNZJH5XAt_xoz5L
 fsqF9LafmMoJVVgiAnwmpiKZTc1Vp2nTLEIDZhvq.s88dilQPMfMz.JUsfT9bZXgFcZ_uMPc0yxi
 nNToOdTCTrJ.R03whbZ4fWpDqTwMuhk1lxUE08stRMRbGxTROvhFih07Uwpz_3IbZXcYJDn0GS5V
 nYRvuuxtjjvsGC4iYFAh.kDZdxBFMfz_R6r4EhqYugl7n4JaZthcJp5bBvWalPm0eEZpPFe4LyUe
 jh7uaSbV7HCO9NqYgEeLWFSr6KzaP9T3i5ta735n0AN5ifwYCMy783l.nn081V5I2yKYQ2M09eCf
 XJmZaAbMinQ2xPDuYWe21ilAwN6kj8LZrB6_eo4LKhU9RaIWfwGBesdDXbS.oSJwv2HM-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Fri, 23 Oct 2020 08:35:16 +0000
Date:   Fri, 23 Oct 2020 08:35:12 +0000 (UTC)
From:   "Mrs.Edith Rosanna Vega" <mrsedithrosannavega@gmail.com>
Reply-To: mrsedithrosannavega@gmail.com
Message-ID: <228935211.2593778.1603442112934@mail.yahoo.com>
Subject: Please help me to fulfill this my last wish,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <228935211.2593778.1603442112934.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16868 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:32.0) Gecko/20100101 Firefox/32.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello! Dear

May the peace and love of the Almighty God be with you and your family!

Greeting in the name of the almighty God i wish you and your family happy m=
oments of life now and forever more amen, .my name is Mrs. Edith Rosanna Ve=
ga, 69 yers old from United State, I know that this will sound so strange t=
o you, as we did not know or seen each other before,  but sometimes underst=
anding and trust matters, been related or known does not grant any assuranc=
e of trust, even someone unknowing may create act of trust even than someon=
e we know very well, therefore never you have such thoughts in your mind, e=
ven if I don=E2=80=99t know you or we never seen or know each other before,=
 but God knows us and he has a reason and a great purpose of directing this=
 message to you, Please because of my present predicament and circumstances=
 i wish to contact  you. i have been suffering from cancer and have a short=
 life to leave. i have made up my mind to donate this my inheritance =E2=82=
=AC15.5Million Euro to the less privileged, Orphanage home, those effected =
by Corona virus for their medical support and treatment, Therefore for your=
 support and efforts to fulfill this mission, 40% of this fund will be for =
you, this means that upon your receipt of this fund you withdraw this 40% i=
mmediately for your own personal use and compensation of your efforts. The =
rest 60% you use it to support the above mentioned organizations as our agr=
eement.

Please help me to fulfill this my last wish,

I wait to hear from you again for further information if possible

Thanks
Mrs. Edith Rosanna Vega
