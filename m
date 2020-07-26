Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E40722DDDB
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 12:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgGZKC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 06:02:28 -0400
Received: from sonic310-56.consmr.mail.ne1.yahoo.com ([66.163.186.237]:35027
        "EHLO sonic310-56.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725810AbgGZKC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 06:02:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595757747; bh=wQR2TNpnSC5+pl+9xCwBDdU8shZ+1jYIhLI8TGcKGS0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=MKU63lJqcl+/Fo0KnjFAgry9xWUPW4J26WRoowK3IAgvLOUfA+2Gvt30ZBahP+pgy0XwcfR+M9wqEBfgm7YFwsZVQAM7PHwSgJ3v/hR+UofBTrjM4eyaTx4LfTDjWapSkKlcJtRu35zBe9BdCqlouJ8vhfHzBNppcvElCgXgq/Pea9icg2vCb3NEKYlUMjtz5AlK8qweFUO0NWCdO8PxXEGgbtBQm/LrwhggD3qq8hD+6Rn8gGi2KddtUA7Zmi/H7N2VbmdzEseuWGY49xwYnRuoG3uH3QHccfanxl2zrtux2lAkYetNJHFhXpnPKHkb2nVQCR/M/bbKr49g/BYRTA==
X-YMail-OSG: 5ViQnRoVM1kf64JB3S7aBe4I1k8m6Ch2tVhSH.1HWRQEPbBgr9n5_1fYweBzdbr
 v4mCS3o2oVsmOYeosqSkJR3raCD0_MGps6v42JrgiHuJcoN90pCp4yc5D88iPHbepTMlofe7veho
 6LVQtttAkr7mBdj2bXeY4bZ8wS7apwXdrrnEeJAv_ug04QqzM0Sv2ScaBgGmWHHRCJCUL1jTGuv3
 ovZuENjiUOR74o1SA9hLietbPq4PtkFMCHYCNlMS2m8VfQFVf2UBni0GCkrvth4BwhXw81.EJgeg
 AdaeFNZSMv6wncq1OHj7Q1d_WcHRZg6uQps84h5_7hG4q2cLcTx8WMRX4JSJZDsIXDKIMmDKKRRV
 80KkW7qj8kVpcHXwhyGQpx1BiLY9CS3iVI_HnxSPb3lY0O9SlBbCneB_e3lWXkQ8DSJFCIYjFd_G
 2Q4tuEyhb7qm2Fu0WJdMrfhW9v3GhvT4Rd3cHctQ.HO1xysd2Odbdayzhs8mjHQr5KKiq9a3LjAn
 SMgfwmQOoDAajiQPxMLJ30u05BtZ7vCwDWdzT4kzaKIymbkrBPAU54sB6tzn0p7yfp0HTs0IJ21T
 vT3oB18CBA_ECgS83quCv6roxQ_7pGCOJpNMXQrGhLTkqLN8Wn1.jczQ3RVIG8lLkIoSV4Dkjz3G
 BeawD88JB7EgyXgtqMTnR3.LWHv7v0c06rOCb79CXMa5KdXMzK5lb7Nn.xZXffntt060vurdKcWl
 xfrYJZN.ZCjzPA9RoHb19o2gybPOyGo16Wip1niB.ZL7Rycn9vj8hnCGdTIpkz5qJLuUguDFNo7t
 iS2ttXyW_0S6yERXl9Z4chn2BtterY69JS.5mmqE_Qd1iSFgHqNX0K8HD66DHUs22_deyd1njcO3
 _UuSbEe_bDHff56h9Kki.qMPVf_Li080RELMeBEKpY8A4x3qgQc.8W9UR4fQ7.48sG26tEX_5_fx
 bGEaGDaI_ro03T18CBm4eicnobmpwTFvQsNYoJPlxPvzSehuHndDd7IRMXzb1fk7TxGRjOjSjswL
 6jOWiCrgaHoVdId8QK.ylq18.OcWriuZ0ZhWx9VHYI7V_XYViYl4VoaociVGmcp7rGBTkJkk2f74
 qYbM.d.y3uqD4im913tmFTJIRTf7FXgAovbM_DdqA7xX8kvyxeO8hj6QF8E0LTcNPueZqozLyyVX
 OwBDLlmKBXYZ7rtabQhvYe9x6UT625EHiz3UeTWpe28HazD4aLOOLay1vTtUNCndScspL1VzvYVP
 XVsoXcKgOhgrcHEHwYdnXPTI9iB7bSduvPboJ8.lR73ywhneu8lQuFCIwVMc7ngIh07BKSaFoghX
 tBXxQLsLFBZgiX.VUXwLwW4Tg
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Sun, 26 Jul 2020 10:02:27 +0000
Date:   Sun, 26 Jul 2020 10:00:26 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau66@nuedsend.online>
Reply-To: maurhinck2@gmail.com
Message-ID: <1011851225.7262118.1595757626199@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1011851225.7262118.1595757626199.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck2@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
