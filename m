Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FA51EE928
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 19:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgFDRJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 13:09:49 -0400
Received: from mout.web.de ([212.227.17.11]:39795 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729994AbgFDRJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jun 2020 13:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1591290568;
        bh=TAu6AnQdJCXobcFRn5FXllOYi3fYYBifAG7ZFmLonoU=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=Ix4aY2En/e1BkJ8nRFAlGEGJ+uvjYgFHvL8XV4N53/v6aRP9C8OT/Wk7rf0clD0mp
         0c96AvUQrlG9085hTCogJB89ITNyr0eoXPo8q5KKtwhb1KlWpThL0NB389efZxxJRr
         0Gc+Czw7LfGHoZOKouSh4mlya/JzHp3zVy1Jcxuc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.94.220]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MOArg-1jdc7Q2apw-005YSS; Thu, 04
 Jun 2020 19:09:28 +0200
Cc:     kernel-team@android.com, linux-kernel@vger.kernel.org,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Jessica Yu <jeyu@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH] Coccinelle: Add dummy report mode to add_namespace.cocci
To:     =?UTF-8?Q?Matthias_M=c3=a4nnich?= <maennich@google.com>,
        Coccinelle <cocci@systeme.lip6.fr>, stable@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a7359014-7932-c001-d995-920e6eab39e6@web.de>
Date:   Thu, 4 Jun 2020 19:09:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MH5+fAfiFqX2Nhk2jXFWYEWvscnGJRl7ZP6YWBUMDkmLs30pZME
 wBGC/4kpKmEndPWIIPc+aipPQwUu5hFI6urTrGZ56F0xWRdQ5K9oGV6DcWkLSv+XTzMcYph
 0PS9q+rN9A2jPWHrkg6AYa2CzxNddJoyzS5dbEc+2EAq0FCwkIih5pnuzG1LwrIXJIa7Qln
 baRjXcZAfLDyI9KJPpq8g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZN2de3a9t8E=:R+DmM2Y5/+ig7AGYu5Lk+L
 sdxjtweB2S9BnQ1APxi6SRV+a26LK1U4nUFfFNczqNfeOSl+l1aZixWsoKw3o2nemcq1iKRzy
 g4H0eOniHwato0vBJ4Z5DdO9YjrwvO0lm2ahre0RCfXGQtjPZ9AizyfYTI/9rn/mmGExIh0LW
 h4eBzkB6xQ+/cyvkfVIgyXk5aNdLWbUvWGWrgRjZSMACrOgDFuxZYvca74I7T75Ahz60FJiMz
 ZC3C8JtDVutF4byZ3oIuWM7DrdiWDIWF6r1B6QiCNH7rbLiiGr+Mfi4lNUaTxeken4BiQIdyC
 Kwzgo6Q/Xn8hLY1km+GRbrcjlnAirZe6okUqXoavqAr7Tqc1+2q5Jkpeuug8UuTpVxtuymen8
 NBEuQF35oKfJXFU6WoO7Q2ezdVgdAhxjCsDcQIgPIfDiOPENSJ9u5YyaPsLu8WEV/ErkyjqSJ
 9h997pRCX+dvWbpXYtyITg6wXTro2YLIyBNF52RXYlsf1J+Cm09x5SkAmDEmB8K8ZajL2hp7C
 b0Isf4B+1buhyQUvrWECIVog2HJ8f/M7aJKHcsBDrRf4xO6J7kUfZbzblaB5QsKZDVzYpMryp
 rFQhr2YWfIGLDE508Pp6iIpwgTAjwFih7B49qd0nXVf+yUET52ssWzF4x/3K3AIVdKPkUF/X2
 GTSQA7N9IKh8RD8kF3Oos5ApCWta1qGpa2E1P+9Gt7CsldAEDkSKtDL6gjOWWOKv1j4Nt5Gpu
 lh7y9uajPlxsoj/5gythrcrgZMQ8kYMXwo84TZUtiHvW71mzGwWx5AjPkpeSEHZ5HZ89AOc0P
 SRprGrOKICdW5K0WbhzArRl9BmGBB/M4diqbhVT/qKCrOQTa1GQ5LkPUYuDreJ2Y4+pl33+Bw
 rPolaMyeh9enzc80Wllfraa99g/kdNgTRFCA/qhfLYRqjh2AEsXVq/S59u4mQQznH6CzUjJMx
 tJpLf0hjUBsflI/WYS7Bi2zsnj51XYNuM5jFCIXhbAnFpLCX+meZ+WmYKrah1AOoGCJcMCJ/2
 UYy6lA1Cmi8F5DmQy9gc6+erFS5tDDKbTmSb+O0qJl+uFZ9Rc86cfE8AHZ/3wfIUxHC8ayxm9
 PW7sAMesyBBhkhLsnyczkO2Dx+UaadVWkK3nFlbMdXrr+og2cYDP2NGKdPw4A/LKGZE+PSXKc
 fJd2ZUg/x2og2HO9QAy1xyqNP2pEnxQN5q0+ejx2csQKGtRW/VqE5iLGD2nR5AFbakioiSVeu
 965a6KsyyIKVmxAyT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> =E2=80=A6 when run trough

I hope that a typo will be avoided for the final change description.

Regards,
Markus
