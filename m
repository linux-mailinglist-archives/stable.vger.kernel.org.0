Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E5C28A5FB
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 08:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgJKGaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 02:30:12 -0400
Received: from sonic304-2.consmr.mail.bf2.yahoo.com ([74.6.128.121]:32813 "EHLO
        sonic304-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727181AbgJKGaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 02:30:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602397810; bh=ErQnYVlC2pefuSTpOMCm9/XUNMjj9rhfSqCUwkKhF70=; h=Date:From:Reply-To:Subject:References:From:Subject; b=SICCVGG56RSEDf91WN30JmzK939IvAikAAxQn6LOpSaee4D/vJsu3aLodEb/iCxMPNL4rLgZN0cRys0hFo0jsuggRYDLBQGEhLBTWboLpqwTboUcISYUnWeDWRgCdLPILb78a6x/nPvg/qFvftFau4xNyDcbn0uQbSKqDUyIIq0AlWjePPRAkAP2QviOsE4IOfGMT96XyqUzWaYQ4pz+qSOH7Y8q0YjqKMROQWVyfHnRyWqrauqNFuJ6sJEGFbCMMo78T/Kjy4BnWMaLxTBy3cTB8ewbreeKQP3hPEf4HHKv26kP2ZVQuPEcpkIEl3+9+CltPhWaJpVmcYZ5fZLEIQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602397810; bh=zdWrSJ9pgUFkpJ3MVwuVuTLX0jwifU/rvtR0JGzLbZW=; h=Date:From:Subject; b=iNCrti8jLaO9ktoixS58pBMcjFRj/SspJV4a5ofwzozL1ZoXsslxwUYfSHjDvPK8X6k6/QsRdbhzeUJLPeYSjZjrgiMdPWDTSpon+TxEHbPmUPChSXQ49hEC9nflOALeIY7Dc5H29CVAT0Zcf5uKvr+EUENcn8wVfLjm75WBvf94p7gU4cxMgIP4ytWQPQC2wbh5KbYi63VsRtgvxBbFeVR1dzJLyZBtZKF1FZNAH4iLH8wN0M/dHLrq3NAxrE+1CQBmPKmfRc2a4CmE6lR3iWHhAo5s/W5DeBhOe9J7kfcbFthap56y13KOLu7mIKgS0+DtCzn4jGFXn4DVHWV1Bw==
X-YMail-OSG: KVnhx.wVM1lla6_X5ilR8i3SXLFb_KGWDJSIVUEV79PAL9FJEmVESIOw_5Fj1JT
 3JJ2oBicYQ6HTcE9P47BXWWxhCZFxqPU.FhxwzXA988l6XMRRtSxyf2px8ACWGPGs35J.74JoRnp
 _oF3iL4YZKru01gtqgHWvyTX56M7W2QNkFmwPIjR1niaOWnH0T_LFIhIr6uPWHIEtAOxBMK63RlS
 3dVMmBcyOnTrGy4ZsQA1_rHYoaO2GDnPEuJtETPeMGMeGpgnFIXPM7q2Eau1FivtRzX.eaqbTKEK
 6xlygdKPkI5c31PmOOEw.loMpwsCZ.7yXaJ611gFCj2md5MFcoLSLz6jaJBDqcfkesgeo247Xp3l
 VEYRCaQqXPLk4Jliv3NVAmmelIlzluEokOkkEUeXyMF6viMmPW5Ft1nSqFv4EXFSfn1EjPw8QXX_
 NtdXEWeTpK3GhO_lV0fhxu5q1QnBx2Zcgeg3pKoj0RlqW3KoKoucELHAOz9Vm0Z1_xTEN9bjwYac
 uNuIIhZGEyVn82LwPMyXddeHboQWNvs3qVmbcx1k9liWAHcSV758XMpMOk7ku8.p2EHVqtXQJnnu
 kx9S3b2ZH3JaG3AJAlL7NPe9n0tNJHABZbeFTrVtzIWWpyGvOxa.Il7uR3cqFN0nscMrxekRB3oN
 qQC6QCskQw57Zjz1eHtHdNuetbeKlFs64kEKScKIAmVEeg1VP6ElrpVBb5wTFPtxxlYNXoNfP_kx
 OSkJKcvheIgQEThsmotZqLG8TkT04XASF8.ki6jfIuwKOWZVqGSNmLvGbUDl..HuauRnO._bGrK5
 NIC8Wb1JmxhLNYvABYhcZ5OrDxm1BMwtGY_ZLWcPLAkKNnNmfJpStvVruAHYYt_6nf5FfsAZ6Zj5
 t4qWfGey7FlxZHGkLve8TtfWVzGr6Lny.S4IPrER9aQ.rHOxOZ8jVkkfJ7sPPCgE4FyUKVLD84vy
 MXb39azD84LpVmkbraA4OJVM8cUUetVz_txKRTJ_Mvl1aAtONlrdnoAz4ZTuMSz5yWkYS.Xsw9XO
 6nR0e26agmGYBcNj6oQaTlQpXGhoNFXOQchkbPURF5v1VORjXdW9Ub3ISl_iiE_l8Atln3vt2FGS
 bYVkMUxbtPSWT9pneWwqTBRiEhwtDCE.pUz_73xWzSbR8LQ10j5M.tp6EJfgAxuzBFMqhl493EBe
 .USryNtHyxFiVpOBQd0ARNil03hTcTre7lilNNJndAg9UNA4KXTh4LtNYOkyHDlkpPHlmGBo1Fqe
 ctHJgkHDKRlbdt0BoKfz7dOxbJHJVPri4TPgATRoNulMStRX1DT_A86pT9gegc7CTL8U7K1RxXZl
 f6Qqn8hKXq4kGZs2_0_7XyRnLLPFXE4yPbPhNMvPvMjagVdZD3vsnN77DgSwIp9gBseNjMj7GmzY
 rvqFrVO8f3vmpGLxzZJbKJDbH1_WN9GyraH9KQjAa8gN9B5Z7KposHjK1PtEc8yS3_3eI77fZJYu
 Cu2Jp1pDG
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Sun, 11 Oct 2020 06:30:10 +0000
Date:   Sun, 11 Oct 2020 06:28:10 +0000 (UTC)
From:   MRS ALI FATIMA <webbox23@yckot.in>
Reply-To: samanta123@bsnl.in
Message-ID: <1705347341.8164.1602397690442@mail.yahoo.com>
Subject: PLEASE DEAR CAN I TRUST YOU?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1705347341.8164.1602397690442.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16795 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



From Mrs. Ali Melissa Fatima
Membership in Turkish Parliament Association
Tele: +905356520176
My Dearest One,


Greetings to you,

Let me start by introducing myself, My name is Mrs. Ali Fatima. I have been=
 suffering from Breast cancer disease and the doctor says that I have just =
a short time to live. For the past Twelve years, I have being dealing on Co=
al exportation, before falling ill due to the Cancer of the breast.

My late husband, Dr. Ali Bernard, a Retired diplomat and one time minister =
of mines and Power in the republic of Turkey made a lot of money from the s=
ales of Gold and cotton while he was a minister, but we had only one Adopte=
d Son Name Ali Mustafa, he is only 12-years.

later, my Husband realized through a powerful Man, that it was evil course =
instituted by his brother in other to inherit his wealth, but before then i=
t was too late, I and my husband agreed that he should Remarry another wife=
 but our Religion did not permit it, Before, my Husband died as a Result of=
 COVID 19 at the age of 89, he died in the month of April 2020.

Please I know this may come to you by surprise, because you did not know me=
, I needed your assistance that was why I write you through divine directio=
n, it is my desire of going into relationship with you. Before his death we=
 were both Muslim. Now that I am very sick and according to the doctor, wil=
l not survive the sickness.The worst of it all is that I do not have any fa=
mily members, expect my little Boy but he is too small to handle This.I am =
writing this letter now through the help of the computer beside My sick bed=
. . When my late husband was alive we deposited the sum of USD$30.5M (Thirt=
y Million Five Hundred Thousand U.S.Dollars) with Finance/Bank Presently, I=
am willing to instruct my Bank to transfer the said fund to you as my forei=
gn Trustee. Having known my condition I decided to donate this fund to chur=
ch or better still a Christian individual Or a Muslim that will utilize thi=
s money the way I am going to instruct here in. I want a person or church t=
hat will use this fund to churches, orphanages, research centers and widows=
 propagating the work of Charity and to ensure that the house of Orphanage =
is maintained.

As soon as I receive your reply I shall give you the contact of the Finance=
/Bank. I am offering you 20% of the principal sum which amounts to US$6,100=
.000.00 (Six million One Hundred Thousand United States Dollars Only) and 5=
% will be for any expenses that both of us may Insure in this transaction. =
And another 5% will go for Motherless babes home. However, you have to assu=
re me and also be ready to go into agreement with me that you will not elop=
e with my fund. If you agree to my terms, reply (mrsalifatima67@gmail.com}

My Regards to your Family,
Yours Faithfully,
Mrs Ali Fatima
