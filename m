Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4184210913
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 12:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgGAKQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 06:16:56 -0400
Received: from sonic310-13.consmr.mail.bf2.yahoo.com ([74.6.135.123]:41827
        "EHLO sonic310-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729226AbgGAKQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 06:16:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1593598614; bh=mRTN+SHzx1/Z7q/L4FjxRkoTzanYhcRodtuQ5iWox24=; h=Date:From:Reply-To:Subject:References:From:Subject; b=hJ4s6XQc6m9K2MqX1q2iAIfDZcGOdBU6Ng/MZn47G++RndTAs+6yqM8AtJxFpgtCUVVuXeBNd+g15lIG91EFDYsgGhbEbVlsKnyv3yPqHXr9FInBoo9+Q9HKkFNgNzWpeiy1Rp7foEupa2+YmviCE5oIOSPI/TWxnFL1BDU6RgmxB6qWT8Q6y8YxRI3QzlgiXod5XUG8vDdas2Rr887oKVWLE0PRvezFeQQkZSkoNYESfjf0tFCnaYL4HikglWSn+whJjR/AAYje0cKLeOPeyIrfKd7LID4rIgwauGI194PQmQFrsaNhjgYeSOcKdOTswNMzLqp4sO07J5H433VFCw==
X-YMail-OSG: 6UWr7dIVM1lFkUMDsXtewwb8jeV97XxWQriCGaaWqPwxa51nD0mqAOTEHB8.xIK
 4k3y7Iy4VAgWkLXreeXCo5m1QUiz8_IASaNZA8Epd_WHyevJA2I.95ZaTdoH7MT2S7pZ9iYd3LbB
 6teyteGwsHS5.Jjd3AhbdFtt3D1nncKC3Vd9duj6.uo8IxD7UqKi1fxjeXN9P.rerF83lgSvCU.G
 4roT8RUZ249ERkz8RwDHuLPhncjUBJHUiHvnsR3fHsMmMqaoNhSjyAnzgEyzuEoxghvxA93lt_Ij
 oQL32.O0h355Mj1N3woLIxZWTm5zVt4ItuY9UP6bWDAUCoJlXpIhV.SFfs4C_etEg4vtHblvq7uT
 cugZS5uSc6HVHBB_6aE3QzzCGPljYy7LLkbnNdkBHKCmjk1J3uIJe0ncahiYDtw.eiCDgRs9LzvO
 EGdX2dVmVQQyOE38F0P5cTevITbwijDvgcS89Kr6BIB6i3aFGH8FHwkA67jNXO7ZbPs1T5VJzqfi
 Tl2zho5PFsdUrJADPIFWcBYXc5e014SNpfgrnbXlFJIPuna.55XFu8Os8aAXpNWFNsPlepde7J4D
 PZngLk_vJY6ZT4XvctKnGbU58MfQDyDk01hlgUqM7dM8KnlHVxK7ZN9TW5BvYtEZtN8sg7sA9sPN
 v3e2k1h1LCTmZzejjD3yC32jbyC5mHio9yhPttXkx1V8AH1rGNvNGWEYK3RUqpL_3oMUWCuV5V3n
 jj8fCzG6Wc.c6Z6zQnp8dZ1LUmj4dGNNI19SEhgskhNylykQubB5By0j5CmbTBIUA96q0TxCQ13C
 0GPSTCiUqwOBcQvTJQe_7A4gdj7yjTAp4KusO1c3JMWsUXT66KMJI.kQ9ShVw.P8Zr4NEHJ_x7JN
 LzeDsFNFZnpLynqQBQDaLAGhtdNpS2Q1fvb7QKN62mFusW3qpYFOnP.0V_SIqbf9GihNg2eZl22Y
 KCgc6DnZo7qx_DL7Rk67Xq_l7vYa27E.zRiUVbZlH06113zeLWkJbECxq3nC8DcJBbnaBLVFy.mV
 UzWnng7B80.76OwN4Eif1MenhbKAMSv.QK.IP22j7cd.qXriRlCAJX.UyU1KM8tWtzw5LX.ZJ9yU
 LaZr4PeHBDEQspiEClV1qwDDbeHSy9hjLr90z.1Hsh74rSLh7zT1khKHshz4KUsUWF1GyigQnB73
 earXR62QNdKpHF940bqn4VtQ4qTZ.cWQ0bT2Iz21_Jen_dCoD2m7KIb3fLJrEi51mx6Y4HJaxIQH
 Z1q8p2NGrsZpZRWBquLseso.ZaHvqzrP1vGsjyU0oIYM_uUWX2O53F2.l4Rt4DqV1F0uB6E3TG75
 8ezjU
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.bf2.yahoo.com with HTTP; Wed, 1 Jul 2020 10:16:54 +0000
Date:   Wed, 1 Jul 2020 10:16:50 +0000 (UTC)
From:   "Mr. Jean Marie Kojo." <azkitty55@frontiernet.net>
Reply-To: jeanmariekojo@gmail.com
Message-ID: <1610214194.566344.1593598610160@mail.yahoo.com>
Subject: Waiting your reply to give you more details,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1610214194.566344.1593598610160.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16197 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.81 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings,

How you are doing? Hope you are alright, I sent you message earlier but no response from you, did you read my proposal message? Please, I await your feedback.

Regards,

Mr. Jean Marie Kojo
