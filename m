Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB2E2E0094
	for <lists+stable@lfdr.de>; Tue, 22 Oct 2019 11:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbfJVJWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Oct 2019 05:22:06 -0400
Received: from sonic303-1.consmr.mail.bf2.yahoo.com ([74.6.131.40]:44421 "EHLO
        sonic303-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730247AbfJVJWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Oct 2019 05:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1571736124; bh=6u3qDl6yXWBH9oVBF6VmNFaXPPfmaUEmS0LDo6+oXlw=; h=Date:From:Reply-To:Subject:From:Subject; b=A1dH3IoJnOXThGgWkjPtJ0noCO5UxlB/ZBAZpfFc3zjYQo4N5lXhe4EHI5N7kMJp7SPCOI1VMZ2ebSJBRDzgNVC/baXRFCaVYvD6S1Lk23EJgD3OIUwYu4UEI1fc8YiAkperAJJxgBgRASFb8x6HQNTKf0+LV0Dpnt77R2QTc+cXkhV7rtTjeqOmosMEGWskRj2RJIM4q0J62YCPctl++mvvUHy17hqZW2M48AEXJLu4GcGEDrs1QJPEKfY4ANlAX41jZH2vbRuXvS0+s59Dc74CATNdPVL/19Yo/xLusSY7RDP1Xa3pm7RBymvBw4qcjpWWzzmsVq5zalAwuS83GA==
X-YMail-OSG: hGa7m0AVM1k9Jk..4nd7BgddWRhqBkwoliZlOn24YNtQs3gMjeivEz4T_2DwzYh
 4GmrWseXDT8nO4RwzW6M94OGCj0pG4LhoI7iUYMedND_l_WDHZJYo9KZ0p50BE5XmnRe7.1_A13Z
 EkfBuB9TnAzSEvk6KNNQ0hjGnFe6.TRajQBX8GFdFDHTO2p6kDjBBM53km0wY0r7HAjLDeWrDUH8
 4jnBhvrf.nR41nJc9waiE_4bwg1LoORapwT4E69ywd9RbW_AgKtfFcJvD1DYnStdegVh4mTGb5gJ
 vo8LVFc3OyddB0LtdOsclrprexqAN9zV0cnFuFreUY3NEICL0orU9nI3iM1Qjf8vpqu2oTJ7FxD7
 ttv6X2NzT6TC4uhzIn3dF_tbRLceSRPhsjXh53tmvFXBkSL014CF4LTySeVUNPnKHqaUmeZ_m63t
 O0aMS38NNAx5uL9k5tY8tXGpHGrCNh3qHlFwjtUyhMVm_jeWgh8QvJQikTMzaAa5.QpCnGmCR26N
 zEYkW_U_JQSaO1J_Y4fj9FIp4xvhZHFMowOTMYDRe0pba_dwsib76Il24jvsfG1ax4Y0pwZ89_B5
 s8odv_1zM0Uvr4kDv7ckcLBPg2BWxnA6cBHlLnaAuFR5FDrSeDFkvDDwTU90lrWDH3Cq1DTyDHbT
 _e.zAMLQPUdR9yKCTq6QGVPiM99lA6xfiOya9WpeVYmJQoM_Fn4wbmoFSFVtdeBzkOXT6wrQE7.d
 Fv1yN7kZwYx9SUd6P55TaWRowf_s5f9QR6r6fb8jvcGpHh34SIsXxC4hdhExD.KaCWAmPwE6ku0a
 x1naT50mVGeJn.uUHtnFfWZOEz8B2x1Vun8k84D3quU56R1RyuZIivtTvLGqaetj.Wfw5cFu3kkU
 DK_e_aAR2CnTVlLcvAoHhedtHr41qIXajuaxCbLOI0nER9NQ8rkCf0wEvo3weBXjWMJe7FqLhClh
 FrLGRGFfPMFoFtq7fKbBoQ1TNIVYcLqqQtaaVSHA_9IXbL41DFWJSjrb3G1C6WZZbF6.WfsUaI.g
 YXbrh7Ub4WwW.XbJbj2XJaIKRxDkzUsfoUM08PpcXy.LZfnzJNDeRNLRXUTIhCWRQknT9XzYvn7z
 QfW3yAoBBE.87.NORHAMcP9QKAaAdHqPeYK7Yp7Khuqxg6xVTg.rU6JretwCAp8ZKCtUHoEsN0uh
 BF2igXvyr6UkCXEXHMzrwJnephr5vYxhIEc8y_V32rWPU61YRR5gXK.6S_lABfEIe1as1Ic5IiYZ
 fCe3RgJ0V3H_YqOb_rvCbbt0X6DbKMhCZN7q6vs_UNodwX25EmXINvuBnmKg3_BTO7BQcxtUGymY
 igQZ1nQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.bf2.yahoo.com with HTTP; Tue, 22 Oct 2019 09:22:04 +0000
Date:   Tue, 22 Oct 2019 09:22:02 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh222@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <693989834.3350900.1571736122360@mail.yahoo.com>
Subject: BUSINESS CO-OPERATION CLAIM.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa Hugh work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment and the amount is (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me after success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other .

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa Hugh
