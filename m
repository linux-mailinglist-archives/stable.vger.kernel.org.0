Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5891208C9
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 15:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfLPOkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 09:40:52 -0500
Received: from sonic315-13.consmr.mail.bf2.yahoo.com ([74.6.134.123]:37358
        "EHLO sonic315-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728014AbfLPOkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 09:40:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1576507251; bh=KB5k1+sCGpSRd9pTKc0P9/4ZGPy9ZVtmix5g8Hf7Eac=; h=Date:From:Reply-To:Subject:From:Subject; b=Hl6e8IZ/bI9HEjM0JonD5p4PACI4nb2QeY93P3aHPsH+Nn4/jCA1HHYMnjr5rBMeIOZIbV7XsVsA3mPIdvkreKhYBhxt2P61RE6PWmeyENhtb5xhiPw3avDeE6IvXdvWNJI07CvkYBc3RnAe8zUeyecu9im4VBm5BX5m+PPMBR1RkDivmXqC4W35uhAF/QrlJzOokk5QGsJcOIavOZKNiC9nbve5xVBzD4XeFw5p4GxqJjmgGZidZOYO5YcpIF2wstgcXECBrttOjlyZoIFBwmPPL/z6fVbBqAKXqd45FQF33ixF1OgjIU6DMOZixr//NKei3fIPUnRwRpuYmX/1yw==
X-YMail-OSG: 2vhoRYoVM1mR_5k909pOxZS6TpgqAb_wfW2AjPyajDB3xwFa3Kj48LSeuJ1DJGk
 VNihiN3P_Ox8dGMz9hgnyJvHnoG6ggBav_daXws_SCP7JqQGhtd5jkzECVOvtlnf0VvKwVUEodqK
 9g87FY_SqQxo_k6ichhXcvaYwMdHInXrU3HqGJ6slyEVnhvSYjZ1j2XihN.zfwLktRS8Xb9Okzji
 1acnxyxfbMmfXpX1sMA.b.GAjvhVpGw8c_DVb1cbF4xiipliuNEAuz5sPAzMFDxCy.ds0034FdfM
 dpwK2AoIG3tBnArK1ak2_SA2CKiXr1OqKZedC5SShjvVQoeSjcQTNuOa8BhyH1Bamt337iPcSFQy
 xJBrHX.HGy0bsC_uvoDWn3c3xE83DbXLE2Wy2BQpLNlLraj7ojg_LmCAKRktN6j2zDfqRh9MFoAS
 pD.CL9zfhtTJks9LC7DrI8suzK1L30o6m8.Q9fi2SErMYOYfWkV9f31HLjwfZV3XN2AtpVhWeC0u
 Fae64MOQJVJOjLiCLpy1X6v93TAEW7Ca1E5pbiWw6ISs9Osi3ffS7O5FQOkg2KGHi93Dfm4uLkqB
 sPZWFNlaPZJcf8c1Ix.VpML83oYgAQ7Ngg6HNYmJeBizigE1XnrFiUV2fFwJlYmBo.OwpbjWRQl2
 XZ9AfJ9cZaDeBWf0a0dQE__Vf9PRdV8uA6aJ6R2ybjHlNcXzJL9Pq2VzRAefhzUHROXm7sNgvSuZ
 93PazRiY_x0yPUjjgEtFvib1ZYZX6LsPtPVo5LN56E4A41KLhprujLhdZXoEstThTzmIRxnrODQF
 rAxhCeq1H6jP3VH6wqzIPdRBbSBfCZQA8JLQStzyq4HA1Jt1aADo8Zq.Wfp1jYgdtQKzRXDp6DqL
 Q6g.rjAGN.phDmwBRLb_qgzVmlrYEV0QT9HPSuRzoScIN2KN5uTBwtfVvHK0CkwLdWeOdha8dQtc
 uJQslixf3xVVUjYgSbFu9F6u_htixxh9dXur_Sor_K.5pVDEwY.wGAXF9Xw6BOr5UHSvAOUo1rQu
 cLXeleXP3x2b3N78LTLYdXa5eJ29IeEXXhPcDomH8KfVq7YDdySjMFuwdZGTgHre4MoD7BrLNKk3
 2e3qiipN7zL6RaO8vs8n6ncP3Ds5wFNeICJB8fOsiQK51qJUHIMYLRlw0VXbV3M9ORB_lP9Kqk2t
 oPswpPkP8sfObu4r0SjrTV0geRbzjHLGxocUrOF3TVAU_u1jlx06.FydBxorcSLqyALiqzER_UxI
 1OPkR0jVXze0ipWBStc0zTYcCjrPMSRz1pKzaUmaAk8fxIW0EIcg6h9JjzBEDdDN6EELK0CZ5Ug-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Mon, 16 Dec 2019 14:40:51 +0000
Date:   Mon, 16 Dec 2019 14:40:48 +0000 (UTC)
From:   jerom Njitap <jeromenjitap10@aol.com>
Reply-To: jeromenjitap100@gmail.com
Message-ID: <71818101.9302004.1576507248635@mail.yahoo.com>
Subject: SESAME SEED SUPPLY BURKINA FASO
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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
