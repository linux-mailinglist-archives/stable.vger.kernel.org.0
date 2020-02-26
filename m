Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10F5C170637
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 18:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgBZRhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 12:37:24 -0500
Received: from sonic311-24.consmr.mail.ne1.yahoo.com ([66.163.188.205]:39850
        "EHLO sonic311-24.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbgBZRhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 12:37:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1582738642; bh=KB5k1+sCGpSRd9pTKc0P9/4ZGPy9ZVtmix5g8Hf7Eac=; h=Date:From:Reply-To:Subject:References:From:Subject; b=O2Lg25JEvJRggFYXOA6KnBC8wWwHadbgJhh9ByvsLBd43gMVWvUnOPl34r97qlEmNhB9gYqVvJZJYRXr/Ryxx6z6RcBpujZei+QT0aNTwuxyQXR7N4Qs3HBuZpZ4hbqOrezde6mxjJtL5agJxwV6l25cI8cbx/kzjL3TIFxdWxjB5m+gk4AcXymOkRITaXA2+aGXhaYipSOTCzSOElLr0wr/8GptgmfiDTzds9ceCnX+ih2lsalEgQu/oYIl0g7EfoxOPLnQAAbYotWKs/CWBaQNXe84mzS6FCNsXIGx+ry1mFviVjD+FNaydyZUdC3kuACf62UlV1+G4B2FiDU0uw==
X-YMail-OSG: mUF7nUYVM1mjmK1TbNOsBr802542_LjbGC2iM7rf3Kc22hfP3zgJIMuCiF2JAVD
 pOB9CLzuEKQTfIxILpXsYXJwiCBNzVp6_LzC0.84fyQHfm0HEVD4NJ8x86YhkAozb0PtfpsWT1Zy
 3Ex2nXDorOYg5vNGhnwRnev7BDqdEKpmLd5TbPA2N.gkapIllcACp6pUjk22bYaONIc4c0vmVCnD
 HaLYIHsc72UfCvTqF44xD2uES6.uZovcEfDiGy.bxZ8yCdEpjc5r1MS0U1zykpG0EWHMnsIW68tW
 6doqr4jcs_vBRRNn5p1bpU7NU8xZRdDcpfZ160EE8sctvqGAJ0w9CLgQcdZ8GAvQrjY1J6ia1GGg
 EXCUPg1v1mUBAW7h_66wQ8qN2RDeST8yPexKkaKV0OOsCyIGa69UziGmfPoZ8G5x8C9_zVGZ9xg1
 u_uypvJ3SwgBY9JNhaXFBwA51lTEDI3jBUv2mu0E81LiBBccvU80bzfxtKKd346U8.pMst3xDjRJ
 B4UchGyd9qRSgzDnkxbcLQ6Uagb9Bs6JRzkQoDurOAmGZap_5TWso1zOEbGr68VPEEtVh86BPLKR
 Ot0FM73dapr4dNED5dvFW2GlWvlm_JgIRmBLe7FaVu.saekeWw3vnjqSbYzsy9ZL3UPV6wu.8fpj
 TguitzI3OhFCCW9fDSCM8NcQ068.QUzDXGejNHZ.DxBVcWiIgv2H2Qr_3BYXG2O6R5U_.OUCP8HC
 0y5Xy1Cey3eDuDPHA7O5g4pyWR_Z2_IwpIbochm1XKpj5ZsHhi8aug26XgR6o32b8dcp9AYNc7ZN
 AxcTLX.32JZo0TWVyRh9mQP1oZIiB7ewpuyaYMA8DvySItBHARpcbqx9KFKkPbuM..tmRkaG0T0C
 JxX8VgLWMVluCFkmToHTTpRDA7LvHgAWjM5L8yc6XBYkk8IDCQ6Tmcr2oG9verbWBCvLNxjG.sAI
 5Bt_yJ59SaeVenoWjAlCZdHnIT1_p3O5LQLJK947zOlbONtmBvYFBnyt7PKW49ph55H9p5hhO.1G
 wpd6JJFl_Dpt3aBTcqlYvDq5so5gDWQ3V8qedZ_1r32dCaJnO_C_GX9.rmVnmTNkjHPj6bZWP8fQ
 pBfEWz5siJxOMCbktq7qYuuIwfMwMRZUxcdN8sG3zOK31punYQK2uIogepdqzdh2DswM4iCz1v6w
 DWgZrGyiiSaIg32Rh7aI07iBByQZuFyzQ0yNFJ1mPaLQNK3uSioqpjgH.K6ROW9eOLQ9ve2gD1Nm
 4M5Cj40KP9k_zC7idyERhceObEHxMZ_9kaN0nA1MTfWA_38cJ.IlogwjcZzTE57HyVAPn5SA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Wed, 26 Feb 2020 17:37:22 +0000
Date:   Wed, 26 Feb 2020 17:37:17 +0000 (UTC)
From:   jerom Njitap <jeromenjitap10@aol.com>
Reply-To: jeromenjitap100@gmail.com
Message-ID: <2071638843.888167.1582738637500@mail.yahoo.com>
Subject: SESAME SEED SUPPLY BURKINA FASO
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <2071638843.888167.1582738637500.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15302 YMailNodin Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:73.0) Gecko/20100101 Firefox/73.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Sir,

This is to bring to your notice that we can supply your needs for
quality Sesame seeds and other products listed below :


Cashew nut
Raw cotton
Sesame seed
Copper cathode
Copper wire scraps
Mazut 100 oil,D6
Used rails
HMS 1/2


We offer the best quality at reasonable prices both on CIF and FOB,
depending on the nature of your offer. Our company has been in this
line of business for over a decade so you you can expect nothing but a
top-notch professional touch and guarantee when you deal or trade with
us.all communication should be through this email address for
confidencial purpose(jeromenjitap100@gmail.com)and your whatsaap number.

Look forward to your response.

Regards
Mr Jerome
