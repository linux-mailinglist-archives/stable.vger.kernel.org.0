Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAEAA1208C8
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 15:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfLPOki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 09:40:38 -0500
Received: from sonic313-13.consmr.mail.bf2.yahoo.com ([74.6.133.123]:44158
        "EHLO sonic313-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728014AbfLPOkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 09:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1576507235; bh=zPC9p8T5S06DA73PD5F75wViZ/EpBpeYylTS7OqjCU4=; h=Date:From:Reply-To:Subject:From:Subject; b=efqWkVkMnX6DmuxyLw8VSaNu3PduHV20q2iI7Vb/pfkYsLPaNoWeMW+bcoYIzcGoD9l+dTIw1WlDpYdsF6qpsnSfAz2XgiA2d/L7n/ZbWxTYRbcvZpNAjmkn7HGm5Gv0JBw2ODUlJGTSXUACf2eqA8o9vHEfas1tnzxVG+65zdThg6839cQirONriLUGrstnr6yRkGIA5ogb4GqrLBb2KXG2WRTmP7tLKrwAbFwZBFJgEXSfEu3XxZzUENJ6m2KSBqUROb/ftkCx5s01GxXCdzl8V99Kmw6uo6tMCmqM2tlzrq1HKIMaWjTqT59liDG4qm5dEoJCKfM/kTJAsuIq5A==
X-YMail-OSG: tV7iO24VM1l.aqEQ904Wh.wu01wwCT9nsEqMqghYMGf5__wrw.4hhLL_iCoKGHd
 Nn7v9Tt0C.A7gqeDxn_yMYuSxZ4S5m61b8lIyMOskLdqBqMpEYNh3hT1GUFga6lC1FsLDqMnWANT
 9h.0PHSy.tROQCZKR14eDGxgE0szgMsS6bbCQbMF0ROS1.qpciccZrq3P_D2xEpLYDBR7ADXNZTR
 6hsvzaMJzOZsghcyn3QdwAUeOfuK68DOYNNtGKY9EUFSGXAv8RluilPLLH4dGN7cXQDCgu4cc4t2
 nzKKmcLE6zRncgHNSQXWbe.RKRrn5P5EGg2E8u0u6jnjPvW1yKwswL7.vyHM_DGcR1UJBiGvjMQY
 R5gWUg9HsRK.LRQ_FOX09c3Pr0y_EQR.yS4piNXM1ROgOzDYYWFpWEtaphusV0oGoduufDqVar9y
 Qr7SX1YVs_gm1I4YMNg6dTUECStckLM8iIc1iopPpDNYedQ3SOy4lpFbUYj66W.e6sxiyBNqavWA
 DAJ0vQqhvaBKVvTi1JB9ztE83n.d79CGYx0v7pzXAC2996I_xuND5UKoGa3tSFTF.9hWPIC2an1T
 bT5CyjNIwsJwDaxCXUNxH1dsDwYdEaeqygvRC3YghqEPK_J6UpcOBWTRSONmQoTzeGmHLllFAcJo
 zNUim_1udW88sYuwSQrB7kIRctvFkxfrdcuArMEWzVkM26IMR1n1T.LyjkJRBvR9290LU.UQeKE2
 5FRFCCQaDQZ650xGuK_Z6gE1R_e8TA5KcayA1fwwVY9Yne_LJIESTAyKQoeAuRarrd1jI6vZ580D
 CPrV1hF1FsYKhRn0318jzFfHmO4Oke5xYI8Owz1woZ17KilNaWlS3VM4sCFbieyw.pTj.1UofIjt
 2pZB_PpBNqgOEzueaeH2gwqJ5BQAdjH6yT8tpsUgaUIRLUcFL7fFi3pJhW68GF6E_SDk5RTiV_J3
 fyXdKuH6DMzMdXdSobpbx9oHXcWSPo5h_Vao.pPzG_T2X5rqjbS7OJvX1KELzufK65QSJqAEzOka
 iP0Z1TciUhOyz64ZvrXHA_eYaaPpp6CCwnJQY_o6gGddknxmRy6gpBYiKGLTADnxyhrk2D2whNWb
 ADekD64SJF_MQ9iE9DmEpHaOPkIrhq5E5mPhCXT5nq76dUzJesO0qxwH9AwCsnq3AfE4TysDvqtT
 Fx0La0yscOs.X7hMqQeNy2b2dccSCMlDfYBpjmnBhyDL.DN_cRDoeunyPQ5yX_aB8aHLJDULsrE.
 5d8pJx6gDZIlS74v26uo3vshqtYE6hr4iPqNWi_QPTV62KQgMAsOU.I_HCnIxpBUEKJ6cUq0sday
 CVSpm370-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Mon, 16 Dec 2019 14:40:35 +0000
Date:   Mon, 16 Dec 2019 14:40:31 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh222@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <1384645300.9292481.1576507231402@mail.yahoo.com>
Subject: I NEED YOUR HELP FOR THIS BUSINESS.
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

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me forsuccess.

Note/ 50% for you why 50% for me after success of the transfer to your bank
account.

Below information is what i need from you so will can be reaching each
other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa Hugh
