Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B231C258B
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 15:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgEBNB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 09:01:58 -0400
Received: from sonic317-32.consmr.mail.ne1.yahoo.com ([66.163.184.43]:40083
        "EHLO sonic317-32.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727831AbgEBNB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 09:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1588424516; bh=56SkWJhpKOPCYDWtTYB/E6BxIRdQJLzvx3NlHQPGq74=; h=Date:From:Reply-To:Subject:References:From:Subject; b=ZsZmHZmEoIbhfj089hX9ckCGc+mjGFPE7PrODTxw4k7hQZGC9wQPkoQcnuC+SIlggWWi4A56aQN92jXQ1YgiCa0QfubyIzcmkmmPfJ2Cmulq1X8EoWZvAtoDG9VmHRN8Wpdy6UQ3a0p7E9vTdKLSPP7MzQXiUNNLPqdVi+ieJW36TVK7IOb/1Wi+N1mv5BoMUZAa8jOktw2c/bP+qolmB7iQQa0pujP6v7Tz2oDgKsGC1whH92tD4P5GMnGNcmJ/QXdVqx32Skv6F0E+2g6tR4OVsefqBLtM5sOq3mBfK2YWLHDtEm4ab/mQ3cVUDxl7ja0D2XKwCK+nUKDB30uYOg==
X-YMail-OSG: MQcN.14VM1mh12ex6QsSVEMumJgo9po79X4jLm5Aqa2W01elLgZl72i1XgH6wn7
 9Bb2mZqT4e20omiAx9bh62NYCFoOtl_YIIdHoqmSoZMRn8SDDNdeXfwPB5QA94DEtOOJ272r3YhO
 O8r_7uJkN.K.z2rcZWgpb76PMklQRPKphDOPdOb7aJ.EscrJEMUNE37ah2VmDC.zdIdXK6_zRHeu
 kFhIjGIr9VbilvhkOvKsnSAEwyDqIYpl1JJFV1XBeopl33h54ANbUDPxTh7FNNQbEFDRIYTkSLGn
 5yVoGRjIVcungWsqk9XxsTJnyen5k75h6a5XnHDs1lUajgdxLdqy0HwLm.SRukT.FmMam1env8nw
 tHcmFyZx6LQT9oIhNoSDILawiugmoB6tktf0U.qbdilC1JjRo.YhKHTsrs58vXnDeVS11wchFy6W
 IBQNzvU0pry0GcZu3Q_GZta98HuTVAXPM16DyUdHpmK7_cv.8swfpfyUsWUJM91XscBgZLfiip.0
 Ou1ShXHZyio_tadbV3mZHcSoiXoF9JRfUW_hZ2A44ddyQBPRwVhHiCvbmPapDtGe9rr2jRhHqTwz
 2ylamRoH7Ss8xWEO98KBKk.9wv0RUrAxmNB4BvJu4NPSmK85lMayGyM33EAE8AJ9o6aHGJhLuqrH
 aexs7eQDIy_QOuhTrsMzdqwnQPyxyOjwWOvC4cinMbgnQ1ZdFPzO0P.P97_NnMN5FMzCrvlipr1r
 gHlti_4R4yAufgpVYW9EAZhSqmHirdx7IhoF.1vJC2viqOR76rngHhGbFt7650Qh89xHMIzLajNR
 gnaNVqhhCl1XWzS7u4FHGbQTzJ6vL0Sw80.IgmCYf0lTOSb5sHbYC0ZBt5QaPRH6ucPzitfjlI6y
 vD1ZOU2PrNokaGOw3r1yWw_PU_WjCWPk_1P8RW6HDKk6iVFWOSZtGcoIxiIu8dWo8dlr_KVWlN_h
 u.E6xB4CM3MHCljEfDXxOn0IkLIn1hHh5jYGxMAY3gmz6DrglAn5r1tX1821gDUSlNP5qFCs7BqQ
 u3jHwpGCowpK27MpiM2YFiR01M87Wk67z1uBNrZj7NhTW8CqOz4mfl7DrF0ZKfTPkXEYyojT.sA5
 rxISBpnhnu4b1ibe2XhNkkM5pwel6tVLK3onRHh6QDqmx1OrZjb0lmu7pjsOvS.dgnOSg7G08Az5
 7QYfhYAwR8pUwR9oi33hbY.RDZCuhCJMgLz_dWTINKdzxvNa_X_.gm3QuIClBTEIM8NfZxkSLcB2
 h5rmV4uPMpHh31TP.4oCcF1QTiqaaM_B_HJheLyDKKAqanFKny3GdZ1zhtiajuWfQzGbsWccBng-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Sat, 2 May 2020 13:01:56 +0000
Date:   Sat, 2 May 2020 13:01:53 +0000 (UTC)
From:   Gerasim Melkumyan <okoyeikemefuan@gmail.com>
Reply-To: gerasimmelkumyanm@gmail.com
Message-ID: <1941265129.137285.1588424513118@mail.yahoo.com>
Subject: Greetings.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1941265129.137285.1588424513118.ref@mail.yahoo.com>
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
