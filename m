Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F14128DB2
	for <lists+stable@lfdr.de>; Sun, 22 Dec 2019 12:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfLVLkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Dec 2019 06:40:37 -0500
Received: from sonic312-20.consmr.mail.bf2.yahoo.com ([74.6.128.82]:35778 "EHLO
        sonic312-20.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbfLVLkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Dec 2019 06:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1577014835; bh=il9mJQO4hXdAEQ+gp/h56Pg0sqwbWAJZYksFNpWWw70=; h=Date:From:Reply-To:Subject:References:From:Subject; b=IFntruEo4H20eY6tK54hiHCdNpHw2QKBFin7VbcrVfpu8nw7PV73U6a7u6LiHKSSQXIH5Z2XsCcR1P+GHH9XZr3amudyd44K3VBXgPeuVCE8Zd36nS/armqCMhA+IVRjpXM+NwUKJNu/y8EwENd4kFYVFNig8MkeMBOjZjPcav6xJJuf4HTCn9cCxKGybA8uGNDBxnI+iB0xY5dbs9Z8hTqEXTwsFVKa6QbFTt3X1tqaOJuHrqL4v8FctQxCsG7vNY7Kt0uOoWdClmtVSW5O8DnhaCntJt6bpyXMRtiDCsHpDBO+jay2Ba/S5Q8fSjvGo1BP+9u1KIrGxRLHa8UHqw==
X-YMail-OSG: DGlK_u8VM1nGiuQBh0jmQsQhL40iIFF5KDlThjVC2ge8Mh.nrMyW7KiZHrpcwNy
 BhwJvsWC18W0HeTI0uQt5JtZd3y0D8m73rk6DGYlELC53mNQ9F4.ScTfyntHr5EN4_Q3_3FKKFZc
 fceGl0Rl9kB0YUlggfDji0hmUkL0oJEAD44U.RxAVrllRJDG8hFI5Aj3X5Ul7zlUV0wYwfrgLUXs
 FS3Bh76PHabUy.SHmp2PeBHR3YsZ27k.ErFFUMs3IPo0omRYiUTe9h8qV6HjmqNExK_us6TQWPUr
 j8jr8KbWw1ac0MkBhdRLkxV9dDC7fOmy8lSF.HY1cN6q2AMMvfxL.reEyWZuHHtu.T4WyQZSR4kl
 XLVEmF4Bk2nMgPbeWAVEcUHYr0Qws6HNU2IRfflYM.sNrozdyeYbUoBsRUU_boYecs0HPODYMSp3
 CFMLuLb4tkx87kwszVnvO6VzM387GbAKby_ngPu_4TvgLtKgr.jYSLcGM_tzO19ZOtTguX3asVV4
 uamTCWZrMj7Qnc9WaKusKMdxTnEE8Tj4dKH5zIqtYBRTv.vy75zisXlaHDvGaGD39ahn41AmOVCJ
 uZ_PreDqChUyO7Ca5CbJwjiFQ78ZRgFV_vNMrxz._rH.9hriCeNplDJlNjoEoRf573w9kPmkZOzi
 XzlowR4DvICZgYBG.Qyx3wmwEeTzn3mN01w_AjwEavRejoa9Yt5KCcCmeSoekt6tP4ytBGX8wR0E
 eYeXvVN8KGObaCcZ.CnGy5Er6lrEJEaAeCO7Dtx4uzDOIL.TbSbk1YeqFISIoDUIP_QHQcRbm7Vk
 VAk.55ZhTQlBOySO4n4HTkJCoXseJAUdXxMfjlXcNy4htOwJzBKAwn0HZtysux0I7ch3JskAHpkb
 Y416U9G6itM3ZZM9T37VaYRK.NWbFWHGk44Uv_XR8pco_InrzxFWrprE1kBOtgeWVd7R0CPKSMpV
 XuX4_tfh8jXadNkkJQ9DnXYxjDXmBg8SebZb3b4.N_PyY1vPHMwmJDDnOPUfkj3QB1OgUjZlQOth
 Rdgy.j6yzt306qirzvCtcGjm1lx6W3y68bBBJ8O.qOv_03TSZ6MXdPWoUx5pJ2VHC7uQBP_E8T6T
 vQwwbePFKGAmAf6OiD33miEhOMJcyXhpe6TSYwarZyuOxlCnZucy9z5FzQs539yx3nWYK_4_Lemw
 OBH4RouizqGqA3Ok0ziwl_bDRywnfvv6fm.8lVyo6yH_kbEYSNBjwr6A9Rh2rdUlRsO3PCUiZMW8
 bZ_aiRmP5FtPZ8IP.JUQ1oV8n4KNFE7Tp19GDTR8LwpUY5HkfYEs5G1bQAcHke55DM8mRVJxynK1
 r
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.bf2.yahoo.com with HTTP; Sun, 22 Dec 2019 11:40:35 +0000
Date:   Sun, 22 Dec 2019 11:40:34 +0000 (UTC)
From:   "Mr. Abdul Samad" <abdulsama1120@gmail.com>
Reply-To: abdulsama1120@gmail.com
Message-ID: <240141395.1579109.1577014834016@mail.yahoo.com>
Subject: My Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <240141395.1579109.1577014834016.ref@mail.yahoo.com>
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
