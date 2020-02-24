Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932B416A615
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 13:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgBXMZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 07:25:16 -0500
Received: from sonic306-20.consmr.mail.ne1.yahoo.com ([66.163.189.82]:39964
        "EHLO sonic306-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727310AbgBXMZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Feb 2020 07:25:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1582547113; bh=vdONypa+pmkSCxMpJ481zxWsfmYXdIIKq3bhYsM38cE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=WPQxhjTnOoojIPd3pgtegA8KWUZqK72pnEUg2qkL6Z9D1EwOEAO9Arh+5PhgMqwfWiFH4GfdBZAu3sbne14QFuOCLa4zQidmVX7P0QEFib+X5WYjudgRxElaWlNP/Tgn+xvo73hK/Tf8I3AUD972YK6gUtdEEBsrihRkMJiXoQfQGWUiLPrmJ8n1zl8DkRdLA15FDcPckT0W0c5IVu/UcIfBDVnVp5gKlsp+4D0yKY4XKTvOGW3YXnQMigSBY4Xsw6bQYb4wMEBbBCC3uIkoqU1Ri22WRwQBCeRLt2CY68OiCYf7MVk+p16UsIJJWR0e7YfOKBspOJ8uvizqdiKFnA==
X-YMail-OSG: tPCaVn0VM1kJdscoSyzisBp.y7l4iL4x_0wBx5qvJOqDqsnF9zsgZkfhD9zGF6M
 kXcSW23Lxq50kjWaI.4h.mwDLTKPmyXPeKgGphlxWJAAnyFolI5_eTjNRanznlXLf3I67dxbwu1k
 8Rpy4FJc4bBVCKh0KpL6PS6K6EFDr2ZMx9cITZ0JypNQfWiQNEexlqWgLStO3yyiE5889iwsdEiB
 5.yQPDbTn3L1RL9pd9dqP8gib39p.BGD99kMNO0ADUvyMQkxNMtKtB85Xfz8tODJmJe4BI0gOAgE
 vw1PvZdbdKFfxBqDoW7DxB8U35EU0ZRfZ2gK80dz5fJyMiTBIYcucNk8bOqQt2WmkT8rwh3DkTEj
 lV476nO2kAjfMWVcs8jfJ5mijoItDSsgTIisTdqN7NnYq.njOlugyZm76XoAQo03Ag1MCearGG.B
 9oZUlorh3xqinChtxXMbPLe1K1GMTef9WTongaHTQ7I3r.da7JALwGXixsDRuY9okjUa.tYyr4eO
 RDD0d0D_xb5395LrnaABPMep5YPMqFmQgBq0EOJBloPlTTQ0UQHik8ki_hZoXDQwscFE5ZAqOKHx
 EvjR4kAy5tjl.JKLuKMvtHmRNNID7cHYkfOl6Oc0y6_ECqinzSJUTKrTuj89lycRZbUoC0GQuur7
 _fop0pFzD.uJw.Wb9x84r04f1w0Gy8fuX4SmN25AWStLnLpt7fKJBGl.lFN8tj7LMcY1UijcHFQN
 43DnhXeZYa7._3upxv.ftd3M.mZ8UwwfYIO2mu48fCu.yymgyDA8MP0yCYdrx.50172ORjYt3c.D
 .rKWUXaKh.G7LUi4szwxrYMJXHyNcdjcp3KPDArGmfnwvxE851..2AGCKuEj.XUfXCfy097w7N6.
 pF9TXQyuQ55RWM0ztHjV73Tj9PQ371XlXyhdphCIo7s.SMmfMlinIg1XgQXB57cFfV8am4nkfGNI
 lFXjVceXS2_VLx8sZ4tf.OrR3dIYtxJUoeDEVD2.En_sc9qgMSPMo8oAQ0CA6Md1we5n5J4CTrLF
 8.PSOmX18Hep5EntdDdsd0vNuIV9UQA.2QTcBJlf_03bNNmp.wc7mz3jEflUdcFduRLcL_hTWmsW
 AmpZeQM_rYuvcaVJ0WcdqrCtKs_l4UG2zpsGeT5JWthwCnNTBfY8rO0jemtt3rmeW6C3DNDiV6J5
 W01j_kbpGGEyZmQAEAFMY4Q5Tz0zqJiE4V8pZc7Gsr1mzkTkAKrC.jtml4_sz516AbbBq1QihYna
 w4wPjyvfLqSqDj_SOX1lcrvs.vOVmrBrHRUGljTBTmvnDUv1i6PN_vo_6rILfIGUDsLHnINmseXF
 ePVTOt8vYnMXn
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Mon, 24 Feb 2020 12:25:13 +0000
Date:   Mon, 24 Feb 2020 12:25:11 +0000 (UTC)
From:   Mrs Elodie Antoine <mrselodieantoine@gmail.com>
Reply-To: antoinm93@yahoo.com
Message-ID: <1311552627.7326768.1582547111731@mail.yahoo.com>
Subject: Greetings From Mrs Elodie,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1311552627.7326768.1582547111731.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15199 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:73.0) Gecko/20100101 Firefox/73.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings From Mrs Elodie,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS CHRIST the giver of every good thing. Good day,i know this letter will definitely come to you as a huge surprise, but I implore you to take the time to go through it carefully as the decision you make will go off a long way to determine my future and continued existence. I am Mrs Elodie Antoine
aging widow of 59 years old suffering from long time illness. I have some funds I inherited from my late husband,

The sum of (US$4.5 Million Dollars) and I needed a very honest and God fearing who can withdraw this money then use the funds for Charity works. I WISH TO GIVE THIS FUNDS TO YOU FOR CHARITY WORKS. I found your email address from the internet after honest prayers to the LORD to bring me a helper and i decided to contact you if you may be willing and interested to handle these trust funds in good faith before anything happens to me.
I accept this decision because I do not have any child who will inherit this money after I die. I want your urgent reply to me so that I will give you the deposit receipt which the COMPANY issued to me as next of kin for immediate transfer of the money to your account in your country, to start the good work of God, I want you to use the 15/percent of the total amount to help yourself in doing the project.


I am desperately in keen need of assistance and I have summoned up courage to contact you for this task, you must not fail me and the millions of the poor people in our todays WORLD. This is no stolen money and there are no dangers involved,100% RISK FREE with full legal proof. Please if you would be able to use the funds for the Charity works kindly let me know immediately.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish. I want you to take 15 percent of the total money for your personal use while 85% of the money will go to charity.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish.


kindly respond for further details.

Thanks and God bless you,

Mrs Elodie Antoine
