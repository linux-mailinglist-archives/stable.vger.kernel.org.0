Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565271C02C4
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 18:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgD3Qlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 12:41:40 -0400
Received: from sonic313-13.consmr.mail.bf2.yahoo.com ([74.6.133.123]:43684
        "EHLO sonic313-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgD3Qlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 12:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1588264898; bh=I/YaSp7GxIx5LvsQNFGZSLRSPkVBBz+0MoHr+59nZ+M=; h=Date:From:Reply-To:Subject:References:From:Subject; b=r6DllMYAQ1LasM1/C1WuIIcUG6EKgi8Ir2M7DfWx07UI8ueRh5ptNoWRF+YU1hpfs4TbS7SH5hlK4L6HxRozAvZceBSg7wJhUJaQ1EAtzXmw7oJX+gKkbOTKdRwVJ9pxvWrDz2aItQVlw51QdGjRcR52AlPtrtxZCUfb8h8v/5FMDGFBNDDf2qpbiNKcYtiUZ6U6p/RM0r3X80BIvLsHry+9CP6gGolawyfdAJCcA58xPBU728uI7zwFaulUBOmmu02TiyDXKv45uakKasKD8NqN/2SLTDA6guXWVsB3ANwjj5HY31ZQrtSyTPS6l8ii9FgRQJxtPwRjQZmPuy9OOQ==
X-YMail-OSG: gcZyBfAVM1nkshMg957J.MqYkCGsNMOL_mY7KgfJtznm7Ndv1vD4lz6_gQIjJEG
 Dssg1rgpPJ4g2PTHvMi0u.pD.bIqT3YL33b2LWthgymXcrUD83yQpynZye_FzShKgdy0XPNNhaek
 bdx2IKjIWSpacrUGezfsee3XPG7i._iJXznNaeKfAxyom.VMzl1953c7.ZBKKct1tXlv8tzIgTTZ
 sQiqe4i9RozxiTspWzvJrKRpiBAM.LqB25zvuGKnzeABtNdbpWP1YgB_jQekIVK4GxWV0BAtj5_5
 t7ykEA7zX0OQMSC2phNo.rSI5qjJCPwSoV8esZoPGqdR8MRTJe04k0FA7XPoam3cE8KEtPcO_.Hv
 KMIQfKDauzeqbELQ5ssLFvowZW5SMPci.UKflodMp0MpqYk.WTcuoVIzJLPtt8H6cwVdjduvrXji
 5CDFaqklK1I965kS_vk2Cm1BM.BVS1JFaAleBBdqSXXMDyY28jaVUwtZFC.WQAd_Qlmr8qit_s8G
 TaQbCgLBDOFAUsfcP7voCVF6NPOCZl_A0jbHO88p.jiaqPwhrN5nr5JVb5oRJ0w9q.fiTB1JT162
 2P1n02DOJzJpOpHrNlpGswQegHQv6pShPikX1xdibiAiDojIwwEryVHR8sCvqmIEyUIYsPiPv4E.
 N3nh6q.gJlkZBrSfZTd9dIWh8Yei0HyNBVfl_p2oV50pT3Wea4HFHC6Z.MTrQog8yjxe3BHvd9Fg
 h.Frd0ZdYUAmbR_1BRhgcR3l.fqnieJS1xj0zlgHssf9ay6WaQpPBllzasyVKsi5I72fcu62QOrI
 B7Obl.WwUkFyPexaUsmt1WeH3miu0PQB2HuI7mfbdG6fAxhmerL_KCRNj8x5kkd8EgqPQ1l.K0Xv
 GAPW3noPvh4SxO.Xl_KY0xk_V3VunY.cHqSlGPuEd_8tbVSvO89XHRlFFJOo6jQoa5uTMzyql1q4
 yZxUDGEQ2D_oIVUk1xAYsiEkUAkbWMSEzc5gE0PkMrkmN4Ptz77mokstOuxkGSuZZX.eQDgSVmTw
 FDCT.eg7sw0nuQBhihAcS1rKYVCtSKdfDbbeFaeK76YLwlvXs.pt1NCWEkWErbZ8Eg3kB0bYBtwc
 a7L7K.eE9eBkam2BlajH3QpW9HyqXG4Fkkc_9vKCnSCbE1mY7kGiODSJMGhQB2A8kxXIgUbCK2vq
 E7U7ss0xcIStAUt8hmh6bGFgRU4Qba7teJFcD7qaQgAFwlnB_JLKeAJHzEHBbtwXnvxMUB7JSUoU
 KDsp8XUm4a1jjRpG.3KezXxoa5fC3GGIau68TL7mn5my_Jx8bsEj9lk32ZRr4dPxHFABG0nchDA-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Thu, 30 Apr 2020 16:41:38 +0000
Date:   Thu, 30 Apr 2020 16:41:35 +0000 (UTC)
From:   Gerasim Melkumyan <okoyeikemefuan@gmail.com>
Reply-To: gerasimmelkumyanm@gmail.com
Message-ID: <574293550.1948630.1588264895227@mail.yahoo.com>
Subject: Greetings.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <574293550.1948630.1588264895227.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15756 YMailNodin Mozilla/5.0 (Windows NT 6.1; ) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings.

My name is Gerasim Melkumyan from Yerevan, Republic of Armenia, but based i=
n Africa Burkina Faso for 12 years as a business man dealing with gold expo=
rtation, I am 53 years old widower. I have been diagnosed with esophageal c=
ancer. It has defiled all forms of medical treatment and according to medic=
al experts; I have few days to live without any family members and no child=
.

I have not particularly lived my life so well, as I never really cared for =
anyone (not even myself), but my business. I was never open handed, I was a=
lways hostile to people like they never had hopes of becoming as successful=
 as me. But now I regret all this as I now know that there is more to life =
than just wanting to be prosperous. I believe when God gives me a second ch=
ance to come to this world, I would live my life a different way from how I=
 have lived it but now that God have called me i want to give to the charit=
y as I want God to be merciful to me and accept my soul.

My mind is not at rest because i am writing this letter now through the hel=
p of the hospital attendant in the Intensive care unit. Hence I have decide=
d to give to charity organizations as I want this to be one of the last goo=
d deeds I did on earth, but now that my health has deteriorated so badly, I=
 cannot do this myself anymore.

I have fix deposit $4.5 million USD with the Compagnie Bancaire de l=E2=80=
=99Afrique Occidentale (CBAO) here in Burkina Faso and i have instructed th=
e bank management to transfer the fund to you as my business partner that w=
ill apply to the bank after i am gone, but you will assure me that you will=
 take 30% of the fund and give 70% to the orphanages home and few charity o=
rganizations in your country for my heart to rest. Please If you accept to =
proceed kindly send your details as listed below so that i will forward it =
to the bank for processing of the transfer.

Your complete name
Address (home/office)
Your mobile number
Your age
Occupation
A copy of your ID

Thank you for your time and devotion, I'll be awaiting your quick response.=
 God be with you.

Gerasim Melkumyan
