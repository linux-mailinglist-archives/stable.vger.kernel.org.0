Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E5E19FA57
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 18:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgDFQkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 12:40:39 -0400
Received: from sonic306-21.consmr.mail.ne1.yahoo.com ([66.163.189.83]:45829
        "EHLO sonic306-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729485AbgDFQkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 12:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1586191238; bh=NrufYlxZPI2D7M17ffM2J1hn0BWNdr7g0rD57IYSt9I=; h=Date:From:Reply-To:Subject:References:From:Subject; b=X1jBiwpX9hbzlLof+xFksPdUU+C5ukAYGloFRJbtz1rFGkPxr801ohd+KDxLkwUUH57p4vDslMGZlJkJdBZ95Nv1ZH57CO+HqyBkJMXbD/uppa5l17PeAldjwvg9WZqcBetg+9k7Eg+cYxBohO76y+VZwlejEFVOsRAwL+t9J5wBd+x42HazDE7kA4AJvEs4XmJRyfTek5NL06cSrjPX/08MRg7hS26NIAIRThempkqTsKo4g5CH+ARbRIF+8eZ6HvBj9c8sWrhcuxhJnI8nC8IQM37FS+TPmm3/fGAaglCveLB5RzERraO6Ga51yc7u9xEQN9CuVSNQ+txN6wN9CA==
X-YMail-OSG: R3PyflcVM1mEpwqllV5Vos241ZPece3Vx9G8FkpAAXFpw14RHhpaC0CmYkCJorw
 IGH1SpUuffUeW7UesIV23iR0Pz3JoKIdJWFZH7_Np0PXjoYqPldHSUZdIUzA9S9IsIeWav4A3MXf
 c8N2ZVwUte6J_6e4SzjdRPn4xjjUZ66KpoXxdLeoUrNK_zUJGzdbEl3luzqKXPE06GVGOU8pUfRw
 QpV40WTazlggoj2yVsvLVNdqfF6UO8HC5SD85EKHBbKajqq9iDSAd0MpulT9V45L73wwafLksryq
 6xkIZK7ZwvetXVeqpB0ZN6PP46NbB.T7Oc.Fe3.qffKVb9akWnMsX.HABBwlmfxH_e_UN6ciDz6e
 fn_Z4pSvGxb_0Sd5ViUZHupQfTAEB6lZjf.k3rMJ.SYrM7qzYdyqlYb54D5yuTus.5Uf1EhAM_ky
 eze0aE1jNpgChm2.vhZgqrzT1sH0dKkoM2bOzRDJXwjcIpUUWryBwSioIfQVttIn3HYq91V5QawP
 xXGTnmYQA9hs3j4R0nW8KABYX8wPhLhN31t9cZGL30DxJJYvGsaw1HCPClKN4_wRjy2tofrNT5Nj
 H6hbxR2Qb.MRS0uo9mVU5spor_78_hfrVl7Vy4HTRWSIqvfsloJv021FzktL1ebn0_g6HjqIFaqV
 VKEUaMrdiP0e1LZa2AUSTVccc7P8y8VwvNy9na5FJzbwtouXNqiPh8KwlpunxhTSduvTVk_w6JHF
 Cn.KsHZ4nmMUFO1g5ZflSzGZaqJm8Dd9AOqqQrJ55gX7NRP91ya1a.sGcyL_RY9i33uHEXK6JFcf
 fknbV0cYgwJIw3H.F9ZCdvHdr.saLzkREasIQIF57v4idIqeq3BNfHjXjOB7xlhHvQjroZeXtBnO
 GK.hJX7_0sGMGpRfrbIz8A5p1XIG3gq10dy9jyZoFAhk6SUJtQPUBPY08G3MFn9XNfHmQyn4xBxt
 f2IeXqFww8JmPyOvpjM1CTDL7dua5ZQ43TNR3d2MusBpXgUGl1N2RZxpuLFZgivVQboRUwRG8eGa
 BuT2zlZ2rRpzxASHtalPNJ4BPTHZRTMw5XDqv537ePfRkB6sDQEnWBP7Si883bTOGNOSQoZjN66o
 dbXd1qHZBBJYvIMVYLV.BQFP9_9DQPOvz2iHSk76CO1s3YX9uMYz9XpKrfv_GxkKF8rppzTHqjHf
 J2pLFdW7y9HvQQlAj_fYxLORlbsxqjbBVLBuNkF9M5L_dmmGPZBh..xAnhJzNAiKWn6dSRmOHdUI
 7QnuwnFFZxxDNd1lHYneVe8hJoQtjPmkxr0PUzY6V.bkfs2CfD2L4Xvf_KdV1Kap7l9HuNO6pdoU
 1x_1goQlqyFqkM5AzU78JZ2DwpXQ-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Mon, 6 Apr 2020 16:40:38 +0000
Date:   Mon, 6 Apr 2020 16:40:32 +0000 (UTC)
From:   Ruhama Koenig <mrsruhamakoenig999@gmail.com>
Reply-To: madamruhamak@gmail.com
Message-ID: <1095189114.1295953.1586191232904@mail.yahoo.com>
Subject: Re: PLEASE I NEED YOUR URGENT HELP
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1095189114.1295953.1586191232904.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15620 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:74.0) Gecko/20100101 Firefox/74.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org




My Dearest,

Please forgive me for stressing you with my predicaments as I know that thi=
s letter may come to you as big surprise. Actually, I came across your E-ma=
il from my personal search afterward I decided to email you directly believ=
ing that you will be honest to fulfill my final wish before or after my dea=
th.

Meanwhile, I am Madam Ruhama Koenig, 73 years, am from USA, childless. I am=
 suffering from Adenocarcinoma Cancer of the lungs for the past 8 years and=
 from all indication my condition is really deteriorating as my doctors hav=
e confirmed and courageously advised me that I may not live beyond 3 weeks =
from now for the reason that my tumor has reached a critical stage which ha=
s defiled all forms of medical treatment.

Since my days are numbered, I=E2=80=99ve decided willingly to fulfill my lo=
ng-time vow to donate to the underprivileged the sum of ($18.5M) Eighteen M=
illion five Hundred Thousand Dollars I deposited in a different bank accoun=
t for a very longtime because I have tried to handle this project by myself=
 but I have seen that my health could not allow me to do so anymore. My pro=
mise for the poor includes building of well-equipped charity foundation hos=
pital and a technical school. I will explain to you why I wanted a total st=
ranger for this when I receive your positive reply.

If you will be honest, obedient, kind and willing to assist me handle this =
charity project as I=E2=80=99ve mentioned here and can avoid contact with a=
nybody for this fund until my fund reaches your hands, I will like you to p=
rovide me your personal data like:

(1) Your full name:
(2) Country:
(3) Phone number:
(4) Age:
(5) Gender:
(6) Your identity:

Contact me via my direct email:( madamruhamak@gmail.com )

My account officer warned me that anybody am sending to them as the benefic=
iary for this fund must keep secret until he or she receives my fund to avo=
id impersonation and wrong transfer.

Best Regards!

Mrs. Ruhama Koenig
