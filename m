Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED012824D5
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 16:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgJCOlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 10:41:22 -0400
Received: from sonic316-11.consmr.mail.bf2.yahoo.com ([74.6.130.121]:33964
        "EHLO sonic316-11.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgJCOlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 10:41:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601736081; bh=+5KgqKjCJG6yX494RS6bnUxSfHkVk5sWUVLr6Upex48=; h=Date:From:Reply-To:Subject:References:From:Subject; b=deHeh0B+FjVWGT6NRUYc1vanc3+Eif9AamPqaO9orV0c7Fz3IPIPSW/Cz267cle8kcod/qr+QPSs0Ae2idbf7BcCbHszeO5T2fsD6eGsCrlSSqt6DgaSkKbVrBqShTzMVK/qNhdkDQtMtlddVH8+f5b/L0en50uHhner66Kqrj1GlqQmDUqdt/17MnrmW8ticuoTig3/UT0LKb9v59KqcPuzYQ2TY2oRIuzYHkhW/lI9u53KWLSNytSYWJiqfF2iLXf0Jo3p1CLPPYA5NdR1y8zoSUq3CDyPkVzt2ZU5NuT7EBlxwnj7NdenjSNo814Hle5HrDgmDZlJh9qhNcx+FQ==
X-YMail-OSG: 8eMW0PQVM1md4_Y8OqodndPemO_3t0fhoNieCCjaWMgtHPbpbGeTe2cRqVCY7_m
 drPfZt1y3ZI7rddHXoKctlK.UOBgml9.42MYBLWAdo45chsjWJuPW6mczVWdZ3p8g4wMVxJrYypJ
 GOkM9x4ULDr3Jmwa51b8PsmXvcDKBqM.mX81pwYexDKlQNHjw9OQYiU237eZqqSUxVRhZQiKUNQw
 XRe2.LnAmbmoxXE2gbm5o1MFfqUb8V1wMsQDi0n0BpgTs0kWpcRzhla2c2f3VsLxxSvabBe8Ky_G
 kdrcGlRCeqA3iWV.j0I1mE5kFut8bhpV0MSOEVbnMdVfvkc0KxP19M3gLievMOM9espMVvrQ7EYz
 7ufUAqpTq.pzGXmRHwzI39jH58MpIy3SZWXhyWyKw4LsqaSJYwmUo9p4nJyfIrS1N1_SGs1wUjGn
 IvruZUba9vdTAyIPJKa0bV6bdR0JZ6.DmJ2LaR07kQVYcbdfqaMShFbBH1Q.eFDAzJ.UFQngqb7U
 UforahssSu_vAwX4baaYm4boWKBnYS0KaWF8DLRlgppjNzgRphKdcerJt64V2fXL14IjvwNzr.Bd
 FPlfAo0TMn7w5nByHcAx2mdNMQDVgBMfJPP8W.VROll30o6jzMy7QNp5MAmzTE1_lKbyVoTr13D8
 HK4qFePsmAEs3jdxcH79BB4qnhSnOmuy7cWRYf.huay6TMe_6XdxfXgBxHlk4Zl9pVHlUiBorQoM
 MiJpWtxi8iON2iNOUb0xJvKkar3k3KIqRlCkVO.26bsNBfeHgFUnsymbnpkky.12SE4ytIeSKmMB
 DxS2wI9RttCk2anNPGAGoXVEl8EQ_a_3Xw96o2k7uscNsU6edF5MLUt5Narlvc6AQBkS5ZDE9KC5
 PInvygFd9QC8MpE9b77y384UkvfTuFQSQxo3G2K9E0nIN7UqfCqPgSXxoZj2DNtGNaqKytPolyw7
 bbBIF9G_ATNPQU5slGNa8kqhfaUthSkRh3yL8KE0PU5_1vc6UXloJVjzdebtCGAeBErTrEu4szfX
 GrSSXR2BFx94_nnO46XTEFgHJciO4TZECtlyf6u1Xc4b01YXs2ILT8Ipzv61CyUc1HuWrvb5hENa
 9ELHQWy9ehS_IgVw.SIZ.Pu0tkpJ1kdifIwLxM2WtIt4Hlz8FTlVHgym7ZBJ3kJjq89q24.PD_dn
 xhZNbNntF3Od7NbjdxGDO7I1CDcybfzn_YHJbg2nu8SwOqZjXRs7Tm_cPtAZ8bPm0vNPmTO9H_hJ
 SiB0EzAbPZxpOnluldYNDZ7SFCW4Vlei4dLYxUei9EeSBQ21ykdHrm7FwWAbVL.Nc.wxJns2_XyK
 ppdaZpWi4HhdXIpVd_ngOF0wq4qOeE9nA0KdhC8sjhAQ7NeKcI8MwItxeXpkJ6EmstdogS55Jr77
 r1814VBHEOZlKEzpPE6RAI6_.C3xfbrwQNxsU6Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.bf2.yahoo.com with HTTP; Sat, 3 Oct 2020 14:41:21 +0000
Date:   Sat, 3 Oct 2020 14:41:16 +0000 (UTC)
From:   "Mr. Mohammed Emdad " <mohammedemdad587@gmail.com>
Reply-To: mohammedemdadmohammedemdad77@gmail.com
Message-ID: <1658243000.1408971.1601736076471@mail.yahoo.com>
Subject: URGENT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1658243000.1408971.1601736076471.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16718 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend,


My name is Mr.Mohammed Emdad, I am working with one of the prime bank in Bu=
rkina Faso. Here in this bank there is existed dormant account for many yea=
rs, which belong to one of our late foreign customer. The amount in this ac=
count stands at $13,500,000.00 (Thirteen Million FiveHundred Thousand USA D=
ollars).

I need a foreign account where the bank will transfer this fund. I know you=
 would be surprised to read this message, especially from someone relativel=
y unknown to you But do not worry yourself so much.This is a genuine, risk =
free and legal business transaction. I am aware of the unsafe nature of the=
 internet, and was compelled to use this medium due to the nature of this p=
roject.

There is no risk involved; the transaction will be executed under a legitim=
ate arrangement that will protect you from any breach of  law.  It is bette=
r that we claim the money, than allowing the bank directors to take it, the=
y are rich already. I am not a greedy person, Let me know  your mind on thi=
s and please do treat this information highly confidential. I will review  =
further  information=E2=80=99s / details to you as soon as i receive your p=
ositive reply.

If you are really sure of your integrity, trust worthy and confidentiality,=
  kindly get back to me urgently.

Note you might receive this message in your inbox or spam or junk folder, d=
epends on your web host or server network.

Best regards,

 I wait  for your positive response.

Mr. Mohammed Emdad
