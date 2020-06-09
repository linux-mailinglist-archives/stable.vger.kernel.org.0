Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629E51F3A6A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 14:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgFIMJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 08:09:38 -0400
Received: from sonic303-21.consmr.mail.ne1.yahoo.com ([66.163.188.147]:44890
        "EHLO sonic303-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgFIMJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 08:09:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1591704576; bh=Uv9Il0GvVfNf8ySja/n2kkVJo04KZ3nX+ejOBNQOQ/8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=IA7dUbbzEMfqZx7qZXLT49rAhH9oW9YpJY5vd+KGW9GI6mAuQD7qrWH7CLj40dDh1b6KDAcz+gquJQawgAxZL3ntBAhlo24ncBIQvnlC/nNqAxedrihnmKWjyDX8t9hbrcUESOejW+XIAnT9fQPpV9IRF3igq1jj/HOxwQ2MXGdem2dVY5rqNOAYNf5wKT/ntMgXoWJecY2rmzGl0i3Mvr/hQH8W4Pa+6eDAHkOAHaK+4tGBD3+3/BAt4vsPhpZEJ7UFB3iWkjRUUKiq/lZN6mvTypGaJFzKGnc4zfDdAnc3JN22LarZVCe8ytjR1luGVBZ+NEgt9wChJmBqQ+ogqw==
X-YMail-OSG: rUP_DHsVM1nHe0nZR3nV4YDaEQ16va3aW31FF2abrtrOreMG4ICvBh.nifdCqkf
 uMqOX4wXwpzTtvw.XN.wOlL01Dq5rabBk6ySIxsruIFPJnTwEYfg.lZgNrQZ2_qthw_t.0cnSdqs
 HG5hm9s.txp1EekeeKO4BLyoRz.B1hYSrnMFdoF9Czi9rWEViSLXiwoSNpLAezZqPIa9O6x1zKG6
 zFHQTkSM31HNMHHgFfZOVeQkwcgxwBi6byZccq2ewJVSGKvqGNWW6usmPXJGpwD2VLQZCIF2vi4j
 D0lw9onfK2XK6KGRNIPMKu503HD.LRLFACN8lcTTeJO2G7TwLsM1k4tVgzccR53ZeBsxnwcuZnbH
 4slImO7.Jkz99LGV5V0jyEK9rc5_i6HHO9.TYY7FT8tnDxqYqG5Ub3VqYWCSXKVInCDubTAeMtWz
 kgmggrVh.MUSfDhVWoEhV3Db8BMiKeC4hYy60UREMltlvE18XUysbEnzf63rISpqtlggEYb8e8WB
 CUaEGg_202sRN4OXEhI.7NQfXJMc.4.GrefhfRz2frvLOyC3WvNe5CJRUQc7OvkJjkZxOiRWz87r
 yKtPk0o7aPI6k4bA7NKIcBd1X_.l.PUmDc7WgOnV9tpZEvaB16WnWZn9nYlzCQx5VxFkzU_HV5lL
 eHJbPmk3.MEeMFqIHxD9O0yUy8tyAdoLu7nVD2FkCd6nApfqnsnx4KyzSiO2ja7T.fcWLJBo4F_u
 EFsei5RpAD675sufxN6ynZSobftZaEEGFhZ8zyZKhEcmd9VPq3zifVpPgD1tbp4XXf1l2wd5kLnV
 vmB3mdrXZvSChYEyOz8US_F7S6XQikK8gsmLN5160jYQNEvwaG3C31DnfyFOGzS5KrY7CNnT44WN
 KMccwxD89LvidMmhTeKL._OjHzx3uiIBPQZGncoB2X1JInIJ9cHXQxY.7WHEH9b0zg_Qbx.DiEun
 Hgq_QvJPR93AfbWzqlOijyoV928UHBxoS8rDdEh.KEoIBMPa1rwu1KzOgP8rJT9.txdtnBBW8..G
 dDQBwWnNrlxXiiURHYYoPW7b3iU1xlRKcLwOri5H2CIqc_XU6EJn1s0iA3ZZ3ZfMx7Z0cSpoLFYj
 NlGfg_lf6uXTl25aC5mnE0aj02jvPsXllP6XzmQ0tLubeBEMO4z5L_XulQP3ihRDkqhdVFoJ1Eyf
 YDiWJX29twjZQI08M81TD0aUbWumOGjzbe0bNiQccgz.vUZTZTK7FzvSOqf5yFybrIHLVfJiRNQH
 DrD5mL9rSJ6XLbn3Tv_9BhSTGYqySX8m0mZRRrz6fQawDMDz1izLgLa_JBWEH16BYrXOxcHYXYDf
 F8pu_.BVhEbA_nBD5a.KcdRS_RDMpog--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Tue, 9 Jun 2020 12:09:36 +0000
Date:   Tue, 9 Jun 2020 12:09:32 +0000 (UTC)
From:   barkummar faso <barkummarfaso@gmail.com>
Reply-To: wu.paymentofic@fastservice.com
Message-ID: <568850690.1493095.1591704572390@mail.yahoo.com>
Subject: YOUR GIFT WESTERN UNION PAYMENT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <568850690.1493095.1591704572390.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16072 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:77.0) Gecko/20100101 Firefox/77.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



ATTN;BENEFICIARY:





You are welcome to Western UNION office Burkina Faso.



Am Barr Kummar Faso by name, The new director of Western Union Foreign Oper=
ation.


I resumed work today and your daily transfer file was submitted as pending =
payment in our Western union Bank and after my verification, I called the f=
ormal Accountant Officer in-charge of your payment to find out the reason w=
hy they are delaying your daily transfer and he explained that you was unab=
le to activate your daily installment account fully.


However, I don't know your financial capability at this moment and it was t=
he reason why I decided to help in this matter just to make it easy for you=
 to start receiving your daily transfer because I know that when you receiv=
e the total sum $900.000.00 usd that you will definitely compensate me.



I don't want you to lose this fund at this stage after all your efforts. Mo=
st wise people prefer to use this medium western union money transfer now a=
s the best and reliable means of transfer,Kindly take control of yourself a=
nd leave everything to God because I know that from now on, you will be the=
 one to say that our lord is good, so I will advice you to send me your dir=
ect phone number your address,country,Pass port because I will text you the=
 MTCN through SMS and attach other information and send to you through your=
 email box, Sender name Sender=E2=80=99s address with including all documen=
ts involve in the transaction.


For this moment I will be very glad for your quick response by sending sum =
of $25.00 so that I will quickly do the needful and finalize everything wit=
hin 1:43pm our local time here, I am giving you every assurance that as soo=
n as I receive the $25.00 that I will activate your daily installment accou=
nt and proceed with your first transfer of $7,000.00 before 1:43pm our loca=
l time because I will close once its 6:30pm.


Contact person Barr Faso Kummar
contact Email: wu.paymentofic@fastservice.com



Be aware that all verification's and arrangement involve in this transfer h=
as being made in your favour. So I need your maximum co-operation to ensure=
 that strictest confidence is maintained to avoid any further delay.


Send the $25.00 through Western Union Money Transfer to below following inf=
ormation and get back to me with copy of the Western Union slip OK?


Receiver's Name...
Country.... Burkina Faso
Text Question..........Good
Answer.............News
Amount .......$25 USD
MTCN............


I felt pains after going through your payment file and found the reason why=
 you have not start receiving your fund from this department and ready to d=
o my utmost to make sure you receive it all OK?


Be rest assured that I will activate your daily installment account and pos=
t your first $7,000 USD for you to pick-up today as soon as we receive the =
fee from you.


Please do not hesitate to contact us again should you require additional in=
formation or call +226 74 43 41 61 for further urgent attention, as we are =
here to serve you the best.


Regard's
Barrister Kummar Faso
New Director Western Union Foreign Operation
Our:Code of conduct:1000%
