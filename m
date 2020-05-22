Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A9C1DED68
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 18:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbgEVQiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 12:38:20 -0400
Received: from sonic310-14.consmr.mail.bf2.yahoo.com ([74.6.135.124]:37036
        "EHLO sonic310-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730526AbgEVQiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 12:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1590165498; bh=/jVDohodGAPbdEuu5RjPi6D9HBdYFTcV1NMg+NrdvTk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Htv73JCTCEU5twt4nKB0iyPa9dTO5BpK3rH2mWqKBNHYpl9Ije1MzALGE88+Do4Wg7n1PeuMZF1HOU6NohxbwZEja6hm3lBTLN6lo1rBOubzY/HSW2czYvcfE8SgsWGLI+fEYZ+IZ/gJe5A3iHNOKiWt+IgMqTwNCBLXpglJBHgIpIg5FhbEbIF7gzOJNjv7Cx3uYdqZnuQIsQOX3vevC4IwVAtpgQbN2bHHcRQTuqbwpTC2by3w4RPmubtO6UuHSY92enJh9b5XSlFlMyjKX+joCyBHWq1osQQ8kB/Ixd/xQY+bOt/YiSuKjWsZc/sMl3yJc9CDMwlMQuEwz60ifA==
X-YMail-OSG: Tl6Weq0VM1nrt7r93Q_dji9tpteZMx44WsiqVwKOTS4pmJRIoVtmJ197px.Ewkp
 wN_pzdh21SCKBQlWGM5yCy5buQzqL4dMX74BazV2j0yjVSWIImC5aKJyjRX_MhwtJO.HTf3YzTk4
 KJTrP9cGNi09Nou4k03rk_kXGNJXqlNtmPypVW_F2.X1xvD6xAUvPQzW.1l3Xe_cL.rfylb2Imz8
 8sNaGOVjgYq_cVNb6LmIRSM_7vHy7rGoBs3RyX80ybjKJS1AL6QyV9k11Yzazd4S9fR6gDqPtbt4
 zUahgO5OZBuM3gZoE6htdEDusXzjftiwezVo5T1RgYTCCliso8yudMjf8hhnvqm59LODbMimEBlO
 qJq1v4n0mKsKNtuq3uwAt4g6X8kczXFjHiqfUXuFW0f9vY0vJPRd60ipYDLIUkLQSALDWgvarMyk
 9YkZ5sRrxfvBda.4Md5PShcYt8AnQFWrgQgk2x4j5XPxCVgduY9nPjC3Jciq17JFS8ClKOFWTz9Q
 pGK6SYk4zshgX8u1yBqApaTD2uMgRUlzKAvu.kvtyaF0OIxGLJv5WErr8BtWAeGLYMsoduXQJAam
 mBXxmB7VekUxS.rTp6ZiLymVFbVwoY_.okKtHntWZsu947ocx14L4diLpnR0hKDHE4ctrDp5zWb5
 VAXfau43JQ7JUtwWUMvQIIg6Msfk13LvdSarplcbVfHo24XgOUNwPUY89b1Zqf6TOQ4m4y2t72t5
 A_3_qKJW7j3Na8Tgz5CkXwEsg6a7cTRAE0Z2JTlSwh2nmtmEJHWN612PC9BFCG0rvthJ8hnKz788
 XHrzL64MYXwYV9WiwjNCPcxhnn7yslXRH9mW_6UNVSKgCrtgZqCmWY39qvJ.HvavPu8HLOtVzDCo
 8Su7z1wwyWrtusoI4gdA16OxNjv9EAr1SzKr.cwJowvBSxDuG6toSaWqnVFif.B9Y85IVx8WKNjF
 W1R8u_JWmURNTlAJVGEjkgYwmrDQEGk6KQS8q.InSlec0f7.mjH649f2sMlt6RMBfhU0MdoBUU._
 E8wiWyWk.leE70mbhkF.90fI9RkOirf2M5369RezqqaoYcEaiLFqMtJdh4YMf7sPAP1ByWO.p60N
 MTRJDi60jTnQebo2reyGHzPkpa9_dK3kHnWvYEzrtY.fw.waLWKr.pWM4A11k9Ma7JACTehGl2I7
 kQIo1ok7OXQzMTW6Y8EdtS52GElxQnywkXvcQqe9fGZxI5AnU00W.dqLl3FDes7KYKtmFEjG0N.Z
 R2AoDarjwmSCN6Q4uhr.FFN1s5RFYd9sn4l.tuFNlEp699B0ivgz3X.q5lXnLc_t_2DwXjdZLfMy
 UytyiL0MLnxvYNZD_SQ_XVpW8IGnhO6L443J0iT.8D7zO6n7prWdsX0n54motwJezhOaSOQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Fri, 22 May 2020 16:38:18 +0000
Date:   Fri, 22 May 2020 16:38:17 +0000 (UTC)
From:   Amina Mahbuba Laboso <amina.laboso347@gmail.com>
Reply-To: amina.laboso19@gmail.com
Message-ID: <148810672.737848.1590165497453@mail.yahoo.com>
Subject: Good day and God bless you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <148810672.737848.1590165497453.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15960 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4127.0 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Good day and God bless you as you read this massage, I am by name
Amina Mahbuba Laboso am 27 years old girl from Kenya, yes my Mother was Lat=
e
Mrs. Lorna Laboso the former Kenyan Assistant Minister of Home and
affairs who was among the plan that crash on board in the remote area
of Kalong=E2=80=99s westernKenya Read more about the crash with the below w=
eb
sitea

http://edition.cnn.com/2008/WORLD/africa/06/10/kenya.crash/index.html
I am constrained to contact you because of the maltreatment I am
receiving from my step mother. She planned to take away all my late
mothers treasury and properties from me since the unexpected death of
my beloved mother. One day I opened my mother brave case and secretly
found out that my mother deposited the sum of $ 27.5 million in BOA
bank Burkina Faso with my name as the next of kin, then I visited
Burkina Faso to withdraw the money and take care of myself and start a
new life, on my arrival the Bank Director whom I meet in person Mr.
Batish Zongo told me that my mother left an instruction to the bank,
that the money should be release to me only when I am married or I
present a trustee who will help me and invest the money overseas.

That is the reason why I am in search of a honest and reliable person
who will help me and stand as my trustee for the Bank to transfer the
money to his account for me to come over and join you. It will be my
great pleasure to compensate you with 30% of the money for your help
and the balance shall be my capital with your kind idea for me to
invest under your control over there in your country.

As soon as I receive your positive response showing your interest I
will send you my picture's in my next mail and death certificate of my
Mon and how you will receive the money in your account.


Yours Sincerely
Amina Mahbuba Laboso=20
