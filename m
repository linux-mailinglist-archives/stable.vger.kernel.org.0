Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2919A28A
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 00:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388173AbfHVWFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 18:05:34 -0400
Received: from mout.gmx.net ([212.227.17.20]:38615 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388121AbfHVWFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 18:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1566511529;
        bh=w0UuzSGDamxQSoXaUYDNsax/0O4yCaaFg/b8kvVkmoM=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=blEovGqpS5ZoZwpWKd+FF6QiN0dy9Awe/GGUpXqean95eEd0JjGvaP877GrJ/ziJ7
         eZMT/g56kgDmDbmqR7pp8HLbnGMst0hymVwhXfi9nl071ahHNGKmXUknRE6r2mjRrY
         mqSh1NGMTomU1swxjSXpXK0wkvp2YvyPNudS8UAU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mir ([217.249.121.199]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MQ2Tn-1hvgHi2C3v-005FAG; Fri, 23
 Aug 2019 00:05:29 +0200
Date:   Fri, 23 Aug 2019 00:05:27 +0200
From:   Stefan Lippers-Hollmann <s.l-h@gmx.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
Message-ID: <20190823000527.0ea91c6b@mir>
In-Reply-To: <20190822172619.GA22458@kroah.com>
References: <20190822170811.13303-1-sashal@kernel.org>
        <20190822172619.GA22458@kroah.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vbP6tOWT61OmaauBJbGMMet8Grc9UdD9EiwymFocq4mwM2kZ8Sh
 B867cbuHwl3L6ybGoIxQDVt/FW6tRDJSrl7+cR0IehSnx4tTKMDsyziCj5xXM0NxxiUY6jk
 cJxVT24DeNhCY+EYMSM1hfVnhprWsfe5cAy/QzLY4A4jx8TNMe7oDobwJQ1XnR89UYFK4gI
 ftq5rlYDNLNbs/MmketIA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tQyXeUKCrTA=:FfnU3LzxoXLcGaKtlBYTKY
 TjeVBXdMq+ltqj1rqpWFss57zKxK/xovnvGi7SHBG0imT7X6CJIyNEqKUb0EghWp0x8AvIF6v
 7qza8kWZeoBXNotik98B8pIrd2wki0oJmMTgX5Bc+zO/p5ZgjHXoCkm7pO4GzrpkTYwU8QI/b
 bNEiE8neoj0cNzYzvz39fmduW38bKz6Pqo/Z7FQAlX1xaquU50XLTtz5nkLdLIYYi5nfiKbbK
 2GOVJlxh7Mf5vUxeUZLNGsgc7BRyOxEJ0u7kddI3l5UNDXzCLeBy22INwh64fRZ+FGCAma+T1
 JUH1adjPZD9J2XtwixyW+rvoBi4Iz/0536F7QMP7Fr8bHOhDX5imnnsZwB+g3n2Dwv2zHZcAq
 e5+z2ZKfo4SLmtAvx9+5fz3wMX5rn2eNsIl6a/nNc/7yHuAmzAHozomAi0ftl0QvIK7GgybmB
 D2ZbUaHRC55X7tY+BjoANv3cvxMqZgp3iQL/zjhoW3Re46fIRPn6b28DwP+qJul5ngijxaIBW
 qkDoFs+pMef2BouNk7a6QcN3V9zuhU/SVY9ZniaSoTJR89cT4imUNvmn0XBETv2GGyCYIia0y
 sqlJLXYlmK/B9eagFxBEkt7Tbe6QDuUeBPE2fIN+zPtd1uVvgupdpXzjaTjFmMPkJvkhJ3d50
 G+38sEmE479qDqJSYrXCHiez4WVRFxeEA6Zf6eaOYVIsgebu6V+HwSBuX2hnKHzLM1s+LzH4D
 W0Zzzr3RQngFQJ6grD/mGrDbgZB0ONd3k980Zbw67jYwqJT6aiJkMBqTqQcRBoBKjRA7YiIrB
 XtCDJ8CcEg1iT+K4fNEne2S89wPcip+WJSzY0IJ3Rcl5j1LH6N6t8i364VdOf59M5PdGbXau2
 R+TFrGqzPbGarPrZI13gSEQtIoyBOcp7ooDVx1usy7iglb6FGShpqBH3pCZ9Y/0St/Iy8+HXb
 KVZVXGfF7Zl6Plau53tuKaYK39ivLFgu1RVUIez0TWowJn5ZRz9nbnGFF+2TuMtyt4Q5xJKuR
 o4DnvxIYrfmYQ4nkSItqMFXnkOTDek9HUlEOPH97kYZKs2IMCC6E4u6KCt2MUlrVJkdiU8aa3
 gDBl8Duv80nlBv5rHXYL95WW4cUtfB3fWGhcgA+JCOnZPP4uPMSzGQ0H30vQTgQuZuJnpYRVC
 ZVpJbHSVsQYbElUQm7cLiMVrI2JlXd9hK8PlZK9CKvoTNctA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 2019-08-22, Greg KH wrote:
> On Thu, Aug 22, 2019 at 01:05:56PM -0400, Sasha Levin wrote:
> >
> > This is the start of the stable review cycle for the 5.2.10 release.
[...]
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/pat=
ch-5.2.10-rc1.gz
                                                   ^v5.x
[...]
> If anyone notices anything that we messed up, please let us know.

It might be down to kernel.org mirroring, but the patch file doesn't
seem to be available yet (404), both in the wrong location listed
above - and the expected one under

	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-r=
c1.gz
or
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-r=
c1.xz

The v4.x based patches can be found just fine:

https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.190-r=
c1.gz
https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.190-r=
c1.gz
https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.140-=
rc1.gz
https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.68-r=
c1.gz

Regards
	Stefan Lippers-Hollmann
