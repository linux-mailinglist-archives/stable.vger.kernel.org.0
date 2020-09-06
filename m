Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56ED225ED19
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 09:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgIFHGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Sep 2020 03:06:30 -0400
Received: from sonic312-25.consmr.mail.ne1.yahoo.com ([66.163.191.206]:41758
        "EHLO sonic312-25.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725283AbgIFHG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Sep 2020 03:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1599375989; bh=NajTNMrfMLb6UXcjRhYpYerQX8PtVBLz0oFgaMINSWY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=flXdnYb00D8cSk+KWEO+qlNIu5gZ7eiVEmo1c6Blqo7brP5BqH7f1TYcPcca0QGN6oKtwJmEd8XlNwt1Qhlz0Y/ZOWVQKft+ZRyAd7cHakwXfXZuT1d01AGegCZe1K26jK3lDrKWpjOc6dq44kipfyON/r6rmAoQQr6tBzyzdWYWrwsfMZugToB0/rjG/XGEdgxEydKzWNgTT5D+tD1r0zb0kQYhTsAVCeLDCkUKZbJnoIWTdAOvnCd+cTPCVIv9wuFtPl0Syz9mzVFgVFCKKP/gL4LLqpDf2YPVlADDKwRzDN0DCG63HcND5BjVsfjegxec0DZeneWL24fuM1O5vg==
X-YMail-OSG: GevDmNYVM1nq5hhegCc5F_Yf6VCJH0y.WHds1.2mC.75P3MQ9uj6no7pfycDfG0
 uElwIl76kmi.2ZTxKZNInV6IReL2jucrudLFULXvgx4eiMnqueBNSK0cf_Wm5z24DKnf2PrEmToe
 X5XMmgcQvfRyVDbfPZqyWfzEcRubnAocMwQwmd.LFNt6JFi5Q0bOOyVGcABwF5Dn.oWLEmAYv81Z
 tS9DJX2CQFVOoMWaGrMrdvtU77HRm6DZhn3HPfsdW2I6rpoKvmLVWK2gJlIwK6nKVSnyjFerpXYQ
 0G_D4.swbQNAM9l7UuxZ2JUdy8C7CttuRVO8ypNUJfCcOvN2olxQnfCFf_FIu5e8fMlNZ0Qo1Qje
 p.MJ7WgnvdMlHAZO6cFc1z7EJ6Tt.sLv9EzR6duAscrZav3nwVAdKxmb7hlb7Yy7jkKPfmI2RD6H
 .JUU44k_HIPQLbCJaSkSGOAnks08ri9TttY7WRB9wRGK0l3ZmLmi6PV4WSYIgb.HIBchdlp8k6f2
 ibE9oi_mQsg9LQGjf0fSdARnJWR801uGrHTeyQgO1y6NyqhADWm2nhB0ydI4OxYrL1lGn87OMhBS
 0RYCt_XdB3k0HyS84FlBATdSEvmjZ65dkrrAmc9Gvigwp_Yd3lxbg8wkYpuxBI8_wsA7K.3ujsnX
 UZNFeCTAFOaFkvMALmID1mFmnR2x_N7XqAd7.gbM7ewjbLyjH4IBYX4i22s_AkI.mfAMP5CRxATz
 O6rCwA_rHxdbswVQPqtqvZId1p3F6gXVGjvW1RSVsWtz8dpkrzAJTHkhpXFRr0jzItgjXnyg2tPw
 x5ROC62.VlMWLCwzsfD_MTwG2fIKtyX.dtAqNP7.JYq5IaLnJ1lcCJJVRVB5IuiKIr9WCZjVlSma
 6.NUL2u0cHX.gbQJmNQZ1OfsxHEGBE2D6fyiYKXkMT5CoX7dcA264mG9Kei1OrHthjGDGi9Qp8sz
 azLpT5IEVpiFoY9DQaZ_HYBkSD6ZZQexlD4t.NIU5hpYjieMDgqByLvrFIQXvBZ7VkkaSsvA5.Ah
 G_uuRWESg5K412qejtoQWYMmIte4gyijoIj9eg3Cqvf5nAn0iNSlLnsvDmgS7fAarWx6geSEm5xX
 lcfn1xR2_1nsrSak86fUL5GR739TyaxCfuithGKCs6A5hx2PBx6byKzYEK9ZhLOFjgQPxfjScItp
 qM4ZlQCPL6hNncaTghg9DIO2cQ2bguuTPKF3sIKwTZrzETCrp57xBEk3iOHYzyv_LyIiWP5yHtgr
 DwkKXEkdg5spLO__HNGWB2s5CwItCnXUD0TVizXJVUTaAprst1Rnda.IxtnFnxXhwvTEKzaxWHTO
 PefggaoaZNf.41V2Q1h7v8yApk68LGuw2vx8_MpirLqL1vSI9K5jkWxqKT4Tf.dc7yC.QEuU.D9p
 TrxJ7IZ3Gpev8prEDOtP4ISuB0isXzb6Zy22Bnk3TiRDVoNZ3kw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Sun, 6 Sep 2020 07:06:29 +0000
Date:   Sun, 6 Sep 2020 07:06:27 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh0000@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <710931879.3701670.1599375987963@mail.yahoo.com>
Subject: REPLY TO MY EMAIL FOR BUSINESS(Ms Lisa hugh).
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <710931879.3701670.1599375987963.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa hugh, work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me for success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa hugh.
