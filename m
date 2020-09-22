Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D367274740
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 19:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgIVRId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 13:08:33 -0400
Received: from sonic304-9.consmr.mail.bf2.yahoo.com ([74.6.128.32]:36866 "EHLO
        sonic304-9.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726558AbgIVRId (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 13:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1600794505; bh=d56+Hnfb/DINXPulDOanNa8pe1PVf9OLzJqRR/9Ggtc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=njve2UB99k7BmKVQPgfdgyvTE7pzXt3R2cj9B1FUasv/OVkrwaqvhUjnkUjkrpSyNR6y8ffWsuD67a7Y5QaYMmmveylUwTRFpXcmaIndDOEVP4XIYMrjKDDXrxzv4noZIp+sVYI57HIX+gbszOppJJIp1gsBvXc3gSMYfTYUjg8JxbKDQ4SKyW3lGZBz/d0LslsaoZBIZE4Pzpax4kwc4CZ+eJOlJzzF+xhmqEnUWDx5ytJBZ41ghj0OWcy8ynCJMXyM9NQW4NcUOo5C21cbQdBn/zDu4HkBeORYm0l3F/ZhOaMbUgkD9+JJiSNHV0ehYE6Sr0fgVe+UhZJRExDWRg==
X-YMail-OSG: 6HWeeSoVM1lCRWIoygMvAsfXTWIq2AvuMGbQwd64Yu5mZ69nHCVHiJJJkoX6T.N
 OM5zgmNRwnLrEVEyiN2_5H3uc19X1daHzzQ1xYSwmbn7.UiuHbn1N1oI3tKSwTs52ia6WvUYH0DB
 ehqVVOLAV6sh8oPdqdQYLav2yBMAiMBuQe.NeDL5ybCLEdKbTz8klxyUgjtVuBqygMQ5nMptX79Z
 QuZk3jXJkB2Fj48HBXAe5e.rQ.u7bi.ZJOHwFbWbO49Ytjq9xAiZ9O7gSVEjX5aSZk5KfEKJViuU
 lVjmyB7O2xjvxXHkYTON0FdKHTduI5Mu50rkVMtrWvFiFwqY.sEGNmy3NVp9zIJwiM2XoQ0svpFP
 VuKeEZpZgp.1Vfl.KYIIgekpe4OyVv756rnD5mfyG0tHGSkEGNmOPrlvowS76PlP29Z36Cpp44Qo
 aStZ3N5wJilsCCxMjXQ0YjDOA574rtiQLhea1oaod1iaRivRoUBAydxj3oWTu8p9.90yFxxakepF
 ezFh62vxf7huN1xIOWNcT_8yDeT5n0AiQshVmXaf_FW.AfGWp50v8BpIBPp1DB7mLZXMfSHi55Ob
 TRtqzsD5wnIm2JWVnp_i6yrWAADLybSPVLNUsNMai6QBMfW0O1jNHn2udWP68kYv_Sd3YAEsVHZe
 Ut7ph1BdZqQhjfP5L1Krh8FE0LwSIJ5qtsG2i4dopDUvoPtwvZgs8Zce3RXyy.s_4T1ekLUpr2LO
 lTYZRmGory2mAOhaoxCZIubh6QLkfARXxDUSKfOPbKe4Ss6SQKRQ7KMWC10gGb5UKdvnCP9UoiXr
 3e69U_NaoeOVbC7mcP3smvhbiHcp9ZaCX2qYo6dyQTy991U4PGoGxOZBF8OHkHBUK7Rxdt2Ufvae
 gBLSvSCk56wctiUjXzjVWyjn9YK3QkCjhh8ZVpM8QaXJT1bGk6s.ObVnxOBrwnA44NRmPN3d5c5S
 hP5Z6Ho0.MYKQfnSw4wEaDUx0LGd3Lvvl8z2k70oSSpqHsgiFxdrUGuX0LTECq523V_2BD16Osj3
 NJDsdUvIYP0utRMIipb8PazP_GDGkTvMA63UhSeCRgs6W6iRpa9FB.c7v313NxDrWYce6.S_9CJY
 ml1dL6sgMDhOK0UAKPDnZSbyDuECim22yVV8SLLyqgIadXaSEl23SJiNR4Fx8ty3kr8horbzYqUP
 Iw854v3AO6GitPEWpNVEJjRdXAYTU8mM1e_.LsqdgdtDN5pzyQ71OOvaOUDgSfgWsKhOu9SyfqVc
 OLWXMKUAqur6dzTaVQrZNAorvNU8IWy56KXgasr8.fGSryLmNZwhDLs0LULdWDgwakGT8iqc4uNb
 ITd9I2rompruLRGnCNEvpe1BQG8ZKZonpYBwOSeuOefIy.p3H2bvdKIAMpLwYJEOxa7dK3py.XHf
 Xo.a24JuGxuhnT5aCTaYwTG9IaTmqCn7rqqoenuPvUVzknu_4oKV9M3PONhliJMU-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Tue, 22 Sep 2020 17:08:25 +0000
Date:   Tue, 22 Sep 2020 17:07:58 +0000 (UTC)
From:   Mrs Sopheal Jonathan <sophealjonathan20000@gmail.com>
Reply-To: mrs.sophealjonathan@hotmail.com
Message-ID: <1800147740.4839337.1600794478353@mail.yahoo.com>
Subject: Hello Dear
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1800147740.4839337.1600794478353.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:47.0) Gecko/20100101 Firefox/47.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear

Am a dying woman here in the hospital, i was diagnose as a cancer

patient 2 years ago. I am A business woman


dealing with Gold Exportation. I have a charitable and unfufilment

project that am about to handover to you, if you are interested please

Reply

hope to hear from you.

Regard
Mrs. Sopheia jonathan
