Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9035A4A501E
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 21:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378755AbiAaU3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 15:29:37 -0500
Received: from mout.gmx.net ([212.227.15.19]:57287 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378692AbiAaU3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Jan 2022 15:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1643660972;
        bh=MGGEDArEqiER/Usk8GGtn3L0idU4VpTIvEZhjGQnAO4=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=I+ngtPIYzzYdyRe2nvgAnch9L9i3T7itdXAjM2bJIkGMoOJmU+bPtMFP8Eq52oxK1
         cPAZjKXCR43iYSOgxcT5uFpo1A6d7qH97VWAOKkwPXNEX8afEXbAKSE6llKm1PhHEs
         atyFdunFovzuo8XXyMLeWAOpLvcTZWhc1o4mUnVE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.213]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MO9zH-1mqfTB26x7-00Ob0N; Mon, 31
 Jan 2022 21:29:32 +0100
Message-ID: <5d71bc1d-4165-dfdc-53ae-59ea180fe666@gmx.de>
Date:   Mon, 31 Jan 2022 21:29:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.16 000/200] 5.16.5-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Db0F0kxDRBeZiK4O9q7O9Z6ih4TOO2lAcRc9mfyaRridSgXyn/n
 ibp9xmRiJeHxUiozF24dzESEWhySbwO7AuCu1KkKZ4RZrJsG7nCoy4QV08AwEwQTHR99/6l
 n22m/6lxUgyUg86AiwU+M7yO+P/jZ1RyXHDtiOolvKxk44uaOImGP7CpJHr7akaVxN25DsE
 WDSRhzximSMEDt7H2wxag==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kNjfGHTrf30=:ESZW9+vEyOlgyQFKDhZI9W
 DjHv1wKAQ+SdsCA49v78rVnZcwzuTpy3pvr1MHHSKM+pttMWPItLsSDczogHkMGn8k/qOFOdY
 HC32TxkVob2AHT0avXDGwA3f2sCYV/VF8dSxJhni+ZTkqCdIbqFV57ILf+oWmCqXPjZ5FCdxM
 62dbSoNrUf6Xm9XK1f9i+AkjSZhuM8HWfrGRdfvcsJfZlrpWp3qhpxZvY0xczZC4yBMZh3vId
 vPPPOoMU9XwJqESKC1ipr6KTHU/KUW5RDs+mvHKCZPxoU0tK1090iwT6LIFsTkmNw4QlCjTkD
 OGfsS7Pn2cTsc+Bn7UHwqOHpXAWqVJjMj6YQ9HDyJtncEvMTR8P/S7itoJdelUa290L/qdaIZ
 hs8btqQSk2QpFHuGA0BcI1sOf00ktwRKVs+k/Pv9E5p9sb7KAVWmgh6sgp4+lCcbNf56LSFEZ
 KcNvNZ0Uh08pJknx9femGDfpRM/eXkAru/IQURQQwklEafaajEO1E9cV9XiQSH440mbZGQhiu
 ty0oGHXbcaa5lCn8QbOJoj61qI7ePcaLTqFLnCNJ2s9FIIw0mzw+xvU1LZioS16pd8Qu6vJ4o
 7UTaNRfYOIwjhKDH1nRy6x511tiegyTqtLRVxxbuWrX0xfBz8NlkfU96PsohTRzczLfniq0aL
 jUA23Z1FmZvOeX52aryoTvpQvz6KvyLjIxIvXcZJtYy5kBjokC8xBjeADU/FOxquknHAUbIuu
 As6zaI3Z6bHelUx0QZ6R21iGFB4rx3T3Scd4ydEZpwVzXkAnLJnU41TmqK2llG/fUPmlocMMe
 XlhOIGCS51xrJm4YDv9SlwC+dHo1V/FFoHDJtfEURL1sE49S78K4kxmOKgeEKNxfI10EEpvVN
 V1xl5N+jfCJFXits9t5wl55J0aZueZFByZc64zSOrihF4pDhCo2xkYhBT7nuTjiMntDxbY5Qn
 WMUGiryb9aWPVp7zyy4psFtVR5H/i0OW2tkBrfEghXxxTkvn36tgZdkqxgTAO5AkjjaLESRd3
 y2Vibi+F/0RH4M/usg2Y4touIHpvM7bb2ZCu8wqG5EjUJEQ4jzt13S6OLEWRpMLewtgPlvqxs
 cAqu+Ql8fZJL24=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.5-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

regards
Ronald


