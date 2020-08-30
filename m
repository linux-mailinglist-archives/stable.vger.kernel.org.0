Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060EE256EC5
	for <lists+stable@lfdr.de>; Sun, 30 Aug 2020 16:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgH3Oq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 10:46:56 -0400
Received: from sonic307-9.consmr.mail.ne1.yahoo.com ([66.163.190.32]:33174
        "EHLO sonic307-9.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgH3Oqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Aug 2020 10:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598798807; bh=Q/AmPmR0e9CXxQBYbB2SR9aRfA51ls0ZhJJ5ujjkgjM=; h=Date:From:Reply-To:Subject:References:From:Subject; b=YtM+9hSA7TXZeDZN7bCxDMRZw2TZH95Q/nRP9SvNR5QWl1/7tBWCoPaZ17Iu+k0Y5M+NNj1BE02oiuc72MggaGcLUj0bsdRh5h92rsO1248Ydp9lf/qhNc5wHB5ALtx1H48ebra8qgLUbL2yHl2LxXi0QcdmhX1+3zQZzV1S5eJieIaGSBy5KmlhB89xg/cVw9WfmEWzxh816dvvTpBXHsRjydPC7I3IDldQGgLTajYDjDN9eqwKUULJGvNOAAynO+pW6DGHAd8yL+AtA/6rz5EGgPTQ3xkmY5MPINB5S53QPfN+I+c4A9ZL8p1I1x2I2IgRNhgDCMugE5XtCf/X/g==
X-YMail-OSG: PBvGQGAVM1m56trfAiaiJYrfxCvl61nfIiZQh.Qmj7k_XQyJKqE8Vbg7AauoaZu
 2ogtY1ArfZLDwkLIRNirH6HivAQkt5FotFl0yvXfPvKp1HNNKWBTXvKruyQ0Dvb3WKPv.ISinpw4
 dmTxxIUaADri4b8vDdTmhzV7awS6dbYrtQ02SRQLJqASp_hKp7yKutjp8afv44JRg5yJpSE4s9lS
 AS5hDZupIHArq3jVAo8dnm9mU6KNwNMSoI5Zdclddh5Wr.ttVHdkdcHdZzUtdiuH7pStXG2BLSqA
 STs1iqqiKjie5rzqK_NmCv1k8FJmjiBefMI5FVKdu_NuYHKeoSvZJaLsxnj6z.o6fVvGgCDD6Zxr
 KFSQNzzJ4NQzyMy2UzUMGmiv.Ro4zqED7fu1NHZOidG12rikqJ_Zh1XO9hNnAr0Q6sifhsEeH_z2
 VLW5xqftjpJzsGKiOnwb3S.fLC262_evhmU7lWmYIGeoUjV1W8P_LH0grXVIQvDlga9U6kBTqJip
 3SfKat2liEGcbmyIHCAFN1HTf0cZ3AYwWYk4nL75eBNM1HUbqsV_uRDB7Rhha7xcMnHuzwOfF6de
 FA1ElU_eHCkWHC00Rc6PtnPam0m6ZFu8dkgem_pzo.MVBrrxg4oJCHip0rSjCtpT21eVeT8VMXvt
 qiBa.e1sEdBbEXT9hUPX_UqgZprYpScPCE3eL2JsW4OyU_V11_fOMyCOrTYZGKUGg2rFFpc3o7U5
 4Vy1Sq4YDsXE0h5FqhLizbitNoDdz5kVR6zqsdGiUSmuMEyAG.PS5Yc0P8F62oMu4HCpuFPkiLeP
 jepttwhoL_SOznYA6TNC_d3KsVJfz.CvzOuRXaR0Np8oralkNMCHQbj1uikziKV_c.dsXNVRamLV
 noDA6Qds9dztyEc_6V5B9woJBzjHXWpL7GTJFteYllYuBxMTigKSFkd4b10z0x0KdD.MC8_iSVcn
 DtMwzlWcwbygf6W50MZDUsPphprhpaC.mXDks0rVDnG3Z4z_f5jw6KxVMfXt6QoOj9rKk_gaumBV
 XzXutXjmFUu0sIS.Xc76qqWIuquOyZ95wZwNU_0GN2FKFVX0aIB0AuRTqz4NWMJZh9HGNirq08xc
 gPIauqX5stPWFwZgd3DIRTyq0tZaeCDybZqm_qoy.P8xFaEhTMQKUPL_WibeTms4k4RhKVN2C5o8
 HGOFBipyjSSTRZ30rRrp3OowdZlfF2BOzB3_xUEyAhV81cjHZbzVLIK2t44J_SIAc7i0cJQVzgRo
 g0h15BPGOJGf7ajg2JUMx_NRCacoUYr9zQngPg9iXdxPiegCPRu6tqhZgG7wqSgjGv_Le2H7pFeh
 r4wzi52lbTcvMRmIpnQQs5iATiqwrUf64PJmvYWj1NVoyLSy9RsTvqsoI.2QsjsoY6TzpnkIRU2z
 S.Z9NA1rTg3a9XCAai4.lp8WUNYMOoD9SqJFD3bIup4tonBqksnWCz30-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Sun, 30 Aug 2020 14:46:47 +0000
Date:   Sun, 30 Aug 2020 14:46:42 +0000 (UTC)
From:   Mrs Aisha Al-Qaddafi <mrsashaalqaddfi147@gmail.com>
Reply-To: mrsashaalqaddfi147@gmail.com
Message-ID: <1106110041.435339.1598798802967@mail.yahoo.com>
Subject: Dear I Need An Investment Partner
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1106110041.435339.1598798802967.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear I Need An Investment Partner

Assalamu Alaikum Wa Rahmatullahi Wa Barakatuh

Dear Friend,

I came across your e-mail contact prior to a private search while in need of your assistance. I am Aisha Al-Qaddafi, the only biological Daughter of Former President of Libya Col. Muammar Al-Qaddafi. Am a single Mother and a Widow with three Children.

I have investment funds worth Twenty Seven Million Five Hundred Thousand United State Dollar ($27.500.000.00 ) and i need a trusted investment Manager/Partner because of my current refugee status,
however, I am interested in you for investment project assistance in your country, may be from there, we can build business relationship in the nearest future. I am willing to negotiate an investment/business profit sharing ratio with you based on the future investment earning profits.

If you are willing to handle this project on my behalf kindly reply urgently to enable me to provide you more information about the investment funds. Your Urgent Reply Will Be Appreciated

Best Regards
Mrs Aisha Al-Qaddafi
