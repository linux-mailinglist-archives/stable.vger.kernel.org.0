Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F187B12A96B
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 01:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfLZAoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Dec 2019 19:44:20 -0500
Received: from sonic313-14.consmr.mail.bf2.yahoo.com ([74.6.133.124]:43782
        "EHLO sonic313-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726879AbfLZAoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Dec 2019 19:44:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1577321058; bh=il9mJQO4hXdAEQ+gp/h56Pg0sqwbWAJZYksFNpWWw70=; h=Date:From:Reply-To:Subject:References:From:Subject; b=fPxoYVIdxjMf+33FFPn8W/S52Cpfh2YMgslcnxQR818xtMhFrg7iDN2HTKFp4jJdX7Z6UZ/nASGIKKzmHFXceVWoqIrtTUQwdmWEpLHJhBvbC5jC0DDRDuRC338/rR5TrSLw2PBGnhoSPx43sQmmZGWkeGXbz3ccYMqClw3Hkx2RZeFjLTGTvsIt5bwCuj8AcbnqohLpa1Hl2GurHzG5y28suJ3r7oOawR64LTsjPxuGw1KaJQ4I7zF4U+wEgz+WIUMk22CB6rJxIuOTAI/5qtbMSL0u+CmGNO4N/Q6McdukfET6FUwKCGVeNpp+/S2qhVJa6CRvljlJ983dS5lcbQ==
X-YMail-OSG: CzH38aYVM1m65VpdUdvseTz7MXEFr89y8423ZbothNcnqoKFVhoIbaN539qLnIU
 afJWGcBZopm0dzlREyLSqbFLg40oEQA037TsogsNyV0.7WPdbl6bKGobXb7gU4o9Aa3yB3dE6sHA
 G2zuWqfNhD5KAIq2TxZB6_0D9FcAkgxPAowx13qQs6rzlJClZmIKx1JpiipUFAn4C4IjjwmFcZ2N
 DCp4Jhs7fclUYxCWExmO31qg0s_z83IYQnXa_TQyDTvBf_NhjYLP8r4TWgE99NzG5rS0mJXVKX9W
 groVWJHMGRttKlwjb83JtjVMaUFVO5f00QS5l0GGMbkCQVdvz9o0zplSF.jR6QCBeqKasJ7Zvh3O
 dt.CcrcvAxPD47Jz14wm1e2x1c3aqAMO0XvmFWGTeKQf.rJ8ACry_OJAHCZJoxV8hTqfvj232LoG
 MXTO3jMuR9_Mmg7MnMZ8MPVzboCwLZL2DXWLIpcjgpiZghOMkfnG_mahmnGiDlXhH8bHWedZU5KL
 wqQZfjxmLx0M04_Jn6cIUvUwVFOoPMXHGBj7zCM3W6BL629xXvZtEulDNuIgqQaCevtDa5DnO2Mn
 3zmcmGSH6s8Txla03wDSVfVlkvPhsYFErMANVawfTzlw9Zjqo1euqnbnB3.WAQf0x0rAZ2A4Z9l4
 a6djGuSTthkKvIv4YWNB.sLzz5GlwzZFPewCtui1GDI8cYL7EgNQnfAgM6TnzPV2H54B_xL6ROmK
 Dh5rBWgwoNnTZWIwPd3cSWi_KPkmLafsQSWDzZBMbxuthkEAazLBd_gsa6Qdi8p6r9ZqlOxGUxFa
 mN.oMOARUhkvDBYAYfA9KXs0fIePG4zH4Zglkx0Wo2zdB3hdcitVkuCpBFtJfwPId8tRZPltL_Om
 76oLN5KRzDXeKAlp9v0CHEeF_BK.7DmiEeIdLJ3_klUq3oQbpqAmQGoVjwltZ9bY9Mc6SWRKiJHb
 FMwfOnb8qwyte0esyBCtBx8K2hJbE3gm_F58chkRSzFqE.hhw3gqEuIHs_GTnMf.AxgA2CugML7H
 pqkix5Lx3sjP.8TIBFXRlN93joQG4y4LMm2iREqaP318EAfV9U0ihgbZ6MfOXt5cdnKnBdeNo_R2
 4SVis1uzAIx7CGaqc2aNRugQAmJgUOc7zBHptTWMPnp5sWPqtnusbyW4ZFDBq9WjPawJSgOBOLjO
 Vd4pN9N5FT.uqj5XUal0bT39POQVL9fiUgGgoptBlrPqFL5lcef37D6mzSlI7pD2_X2Xf8S4y98l
 zSyDbQyx0VkQseJBEFyIl2VQJ1FQs5Gb6x.nJOEQzZAOLNBYhjKACcB3RW9Ibye9o5YdfFXyEuBx
 ald4-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Thu, 26 Dec 2019 00:44:18 +0000
Date:   Thu, 26 Dec 2019 00:44:15 +0000 (UTC)
From:   "Mr. Abdul Samad" <abdulsama1120@gmail.com>
Reply-To: abdulsama1120@gmail.com
Message-ID: <735116218.2304286.1577321055201@mail.yahoo.com>
Subject: My Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <735116218.2304286.1577321055201.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Assalamualaikum My Dear Friend,

Before I introduce myself, I wish to inform you that this letter is
not a hoax mail and I urge you to treat it serious. This letter must
come to you as a big surprise, but I believe it is only a day that
people meet and become great friends and business partners. Must
apologize for barging this message into your mail box without any
formal introduction due to the urgency and confidentiality of this
business and I know that this message will come to you as a surprise.
Please this is not a joke and I will not like you to joke with it ok,
with due respect to your person and much sincerity of purpose, I make
this contact with you as I believe that you can be of great assistance
to me. My name is Mr. Abdul Samad, from Burkina Faso, West Africa.
I work iause it is top secret.

I am about to retire from active Banking service to start a new life
but I am skeptical to reveal this particular secret to a stranger. You
must assure me that everything will be handled confidentially because
we are not gon United Bank for Africa (UBA) as telex manager, please see
this as a confidential message and do not reveal it to another person
and let me know whether you can be of assistance regarding my proposal
below becing to suffer again in life. It has been 10 years now
that most of the greedy African Politicians used our bank to launder
money overseas through the help of their Political advisers. Most of
the funds which they transferred out of the shores of Africa were gold
and oil money that was supposed to have been used to develop the
continent. Their Political advisers always inflated the amounts before
transferring to foreign accounts, so I also used the opportunity to
divert part of the funds hence I am aware that there is no official
trace of how much was transferred as all the accounts used for such
transfers were being closed after transfer. I acted as the Bank
Officer to most of the politicians and when I discovered that they
were using
me to succeed in their greedy act; I also cleaned some of their
banking records from the Bank files and no one cared to ask me because
the money was too much for them to control. They laundered over
$5billion Dollars during the process.

Before I send this message to you, I have already diverted
($10.5million Dollars) to an escrow account belonging to no one in the
bank. The bank is anxious now to know who the beneficiary to the funds
is because they have made a lot of profits with the funds. It is more
than Eight years now and most of the politicians are no longer using
our bank to transfer funds overseas. The ($10.5million Dollars) has
been laying waste in our bank and I don=E2=80=99t want to retire from the b=
ank
without transferring the funds to a foreign account to enable me share
the proceeds with the receiver (a foreigner). The money will be shared
60% for me and 40% for you. There is no one coming to ask you about
the funds because I secured everything. I only want you to assist me
by providing a reliable bank account where the funds can be
transferred.

You are not to face any difficulties or legal implications as I am
going to handle the transfer personally. If you are capable of
receiving the funds, do let me know immediately to enable me give you
a detailed information on what to do. For me, I have not stolen the
money from anyone because the other people that took the whole money
did not face any problems. This is my chance to grab my own life
opportunity but you must keep the details of the funds secret to avoid
any leakages as no one in the bank knows about my plans. Please get
back to me if you are interested and capable to handle this project, I
shall intimate you on what to do when I hear from your confirmation
and acceptance. If you are capable of being my trusted associate, do
declare your consent to me I am looking forward to hear from you
immediately for further information.
Thanks with my best regards.
Mr. Abdul Samad,
Telex Manager
United Bank for Africa (UBA)
Burkina Faso
