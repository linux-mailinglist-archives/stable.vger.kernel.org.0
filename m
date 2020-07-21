Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9538C22807E
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 15:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgGUNCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 09:02:14 -0400
Received: from sonic306-21.consmr.mail.ne1.yahoo.com ([66.163.189.83]:33931
        "EHLO sonic306-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbgGUNCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 09:02:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1595336532; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=lgO7j86UUzMplSI2f0VcOy12WKkv0a/GG2wEN6iF1DguncLt9dpsJ8xhHQs1OGa/LLrDNXO8n+r69kTaPfIpo62JcirJmmQ/eP23U2+bOQhXBoK2fU79UAR8vDe+4S0kMH7cGFccl9ppEo8zNV3gHMSxA6+6Bf1fDdfo4tX9YiKictVHdFn2E/Fs56yDmTWRyMEYVP3MbvgWHigi0h2j2M1bwkBclRGrY1iB85XyxCRAed9IFONvNTqT6S2rmjxavqk1sHBKGj1kURBYWFEUB49F8Qq4WeEkNKfzU9w49hX85Jy+YDt+fOUQrjCQg1+YXPVVSeR/D4EKlhQ+iiMb8g==
X-YMail-OSG: 8x35GZcVM1k3CcHa1ltRL_xX4cbGTLyKBNO4WBcTuNDD2ymzBw15ucYmwQAHp4M
 7J7wsCa_f3He0HtRE4_gtbIft72vw3khWKqz8g95WRE3r3DeVh2YXB85SYvVNxrlwu4eBTmXbgIu
 i41wqxbXiJiOiGAv_oJLuc1bXJaY6GA1sV4yf_iEobnqHmwwZJsjX1IkJeoKclyqAAtSydUOoCoj
 Fg0XLS5asbhsKqNwUYy5SctWfoDKdiOciXVyXttSpZRK00.ysCTKGqre4LO2rzm8hJhfovNp5pFu
 ggxMfTudTZDbV.2eOHAjAlaDsCrsNBVDO8zxeG_7m8Y_l8_CEOGQ92953rRwVEjX1PQDrmqXgK3C
 H_rDRUcFYnlj6BDu2gwKAUH6qU26_Y6fk.GcQy_L2kgJCkA702fCnd_3cbX69XsdeNBUhmQIF9ZE
 gHOC9ZCfCxg9opUQePe2TOE4f1OrX.gGkamKN3iC4Y7PucglAVxe2_zfpwW5jKCLd1riQRzKTrPw
 XRjC7SHHuQm5NWFWfb1zGHMa8Ke6KMn7eWJ7QjVpDgO5U8Kh.fXHfhoGX39R1RXNr71gIViAdFvN
 qGQF49wVT0KMyToyNpuA2F..0kJy5ug3q2sKCsm10jCeh8aH1YP8m_KTrkJ6Y9DyFbNKqXlMAvu.
 9B4pgKmQ65xcut9ylHHDqsC7NX.JWAKpVlmXgRLiyi89pqUjnCzif1PeKZXxbk57vITasMRMBTOu
 EDr9tjoYo.8QndB0Fq39a0HYFSMlkV0xfAYaBfjo8F_sT_o7nukAbYCmmeQtXBNwd64U5rY039es
 fCw2PyBN5SDe5uf_nuaj8sDpeqLhJKYVq3jHjV3Zwc4ciBJYh7aqTOAKKCJNsCtrM8e2HmAWzQhC
 Oe.Q3nK83rPg4OFlaf96Duf4roprW1zREe1vkjgVQx7IVTNKY.62lehhcvKto9EgkUhiF3SDncB7
 _oo3Nzs449OLAdkr5Ykv51lYiyjkdn50.2X_B1e22xRYZ71K4DW7KTENCVwHxoxUDQzkQaWyCIgA
 Sh0JzcYou4Sc9lQGdj9Lmv9Klt3LcK_hpLsMlhZ9AFRtOuHNHou4AlJruyqIuQZsgUqRfHZCuDlf
 b2YAkxqyjkckgKMROfaAj4Yjekl9zqDIxT319Wn12kZDwuQYVj729dUEolVH_MTpa820swQmusW6
 fqKp01mu5IyR9SVjTMQMxz1tiYYfUaQ3uUBj7RPLLbMEG2vMytGFA7OKilq63VJMxAlHmNrZL8tn
 5XH3AjnLQP.MxtLH_l.H05HpiHK_d3mj731o0abDXabq9It6STpYH292VWPstl4AX0UIDXa_Ysg-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Tue, 21 Jul 2020 13:02:12 +0000
Date:   Tue, 21 Jul 2020 13:02:08 +0000 (UTC)
From:   "Mrs.A.Mina" <brunel.m@aol.com>
Reply-To: brunelmrsminaa@gmail.com
Message-ID: <1170937654.4837977.1595336528654@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1170937654.4837977.1595336528654.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101 Firefox/78.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



My Dear in the lord


My name is Mrs. Mina A. Brunel I am a Norway Citizen who is living in Burki=
na Faso, I am married to Mr. Brunel Patrice, a politicians who owns a small=
 gold company in Burkina Faso; He died of Leprosy and Radesyge, in year Feb=
ruary 2010, During his lifetime he deposited the sum of =E2=82=AC 8.5 Milli=
on Euro) Eight million, Five hundred thousand Euros in a bank in Ouagadougo=
u the capital city of of Burkina in West Africa. The money was from the sal=
e of his company and death benefits payment and entitlements of my deceased=
 husband by his company.

I am sending you this message with heavy tears in my eyes and great sorrow =
in my heart, and also praying that it will reach you in good health because=
 I am not in good health, I sleep every night without knowing if I may be a=
live to see the next day. I am suffering from long time cancer and presentl=
y I am partially suffering from Leprosy, which has become difficult for me =
to move around. I was married to my late husband for more than 6 years with=
out having a child and my doctor confided that I have less chance to live, =
having to know when the cup of death will come, I decided to contact you to=
 claim the fund since I don't have any relation I grew up from an orphanage=
 home.

I have decided to donate this money for the support of helping Motherless b=
abies/Less privileged/Widows and churches also to build the house of God be=
cause I am dying and diagnosed with cancer for about 3 years ago. I have de=
cided to donate from what I have inherited from my late husband to you for =
the good work of Almighty God; I will be going in for an operation surgery =
soon.

Now I want you to stand as my next of kin to claim the funds for charity pu=
rposes. Because of this money remains unclaimed after my death, the bank ex=
ecutives or the government will take the money as unclaimed fund and maybe =
use it for selfishness and worthless ventures, I need a very honest person =
who can claim this money and use it for Charity works, for orphanages, wido=
ws and also build schools and churches for less privilege that will be name=
d after my late husband and my name.

I need your urgent answer to know if you will be able to execute this proje=
ct, and I will give you more information on how the fund will be transferre=
d to your bank account or online banking.

Thanks
Mrs. Mina A. Brunel
