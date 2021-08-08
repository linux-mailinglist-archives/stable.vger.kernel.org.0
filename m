Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F44F3E3CFB
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 00:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhHHWOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 18:14:45 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:57457 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhHHWOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 18:14:44 -0400
Received: from [192.168.10.241] ([80.152.235.138]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M5fQq-1mBC6609Oc-0079MQ; Mon, 09 Aug 2021 00:14:00 +0200
Subject: Re: regression [fixed]: SPI interface on systems with Mediatek CPU
 broken
To:     Guenter Roeck <linux@roeck-us.net>, regressions@lists.linux.dev
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Mark Brown <broonie@kernel.org>
References: <d865ef60-034e-32ab-3978-601b97d8904e@roeck-us.net>
From:   Peter Hess <peter.hess@ph-home.de>
Message-ID: <f17640a6-1521-3620-f775-d182ad412f3c@ph-home.de>
Date:   Mon, 9 Aug 2021 00:13:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <d865ef60-034e-32ab-3978-601b97d8904e@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:d+36i6A+R8XQZJfwdv6CUDupbGgZHBKR/5rs94Z+ccRdbKcKv70
 6seq7oW/3O9yas5geclN7JPjmxfT6zEFnk2guzccfyMPM9cteFNcQgDt1axSGQTy40Nc+db
 D83yp/gVU7StAIpRO99igW5nmWTUIAuV3EqtpoHiWV9uyHAXvhW7su5Nzofm+DxytGlw5+g
 TftFLQdfd5PpZ0MgyEKvg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zNuDvvJs00E=:YGt+yE2ayBZMk+R84M89Jo
 1aYm6p9hM2IM4Z6mL7+p5ko3ig/7OE5eGQJCzU3JXAqrQeANzR3o3QDW1deBGbe/qBfo1zGXs
 48tPOs57hjsTgUg5ss2faYgXO72tfm5WCmyU/3Ww6KVcFSY76ykEqqpcaa1hGVoVlbfwM/rMV
 EcSsBy8PMOxZUYWhQeptkwT4Z7G8nUXTlZZ+heaLYr9aBhBq/2wRh1NH/J/VYwWjJVKZ/1wA/
 inBzuPHMod6E6oEtV7qSDKj1q/WhbE9qTRE0P0LUoRGw7D8/AJMSUPLFhhuwS57g9FiFYlnm9
 WRtuDOcYVG4y5Y67Nl2MqOa713JGgzbtCt8hNN76PugkCxHdug51aq97vj6dCbV2mt2Kyd+k7
 QET0BuEkFeBrZGCqHFkhB2WNLwJ1MCcVQ/B8wL66KwhfcEM5F/Eh6o9p1ngDqfoA0mUYG6wxW
 k5s8jCK0pvz8ZhAjD6OgteX5+mUywSofwmy3GJHb08oKiFP4JNEeBOcojun+72iCbNhbDan+z
 UXFGGKvbjGNlOM0a0efYe2+PaSoJPsxNwUNE9Yna3jZ2sM7V8vKISy16sSn14cF+fT2P3iOfS
 k9zJrQ6soP7GgyXsj6hjjoEcileauYm3sUaNsCOwsx5zXpCTXQpfrhlSLtFk0d0Ir8tG3hskc
 hMJoIj4868oBmMLpFPNFSo/ExzYfjT8wTgvi32n1MaYEmVV9U1f8FlOW1noM3FnVLsc3CYdgp
 fB6extvp//EZP3eKRFSB0cnR7fdF7ae4lHKiPdUjNdsJFMX+4q2WQxiWSyhLqHOcorLHqee8G
 aZmJW/8GjOA+UQhVwPAGHIV7W3PmGtiB378eJT3IcwD4XtZQFt5mNKJKTAfkfH9C5NEVSYD
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello everyone,

I would like to apologize for the inconvenience caused by my submitted 
patch. I should have looked deeper into the driver, then this would not 
have happened with the RX path.  Unfortunately, the faulty patch still 
worked on my system and so I didn't realize the error. In the future I 
will pay more attention to the whole context in the hope that this will 
not happen again.

Peter


Am 07.08.2021 um 00:33 schrieb Guenter Roeck:
> [ submitted for reference. The problem has now been fixed in the 
> upstream kernel ]
>
> Affected upstream kernel releases: v5.14-rc3, v5.14-rc4
> Various stable releases with the problematic commit are also affected.
>
> The SPI interface on systems with various Mediatek CPUs is not 
> operational.
> The problem affects all Chromebooks with Mediatek CPU since those 
> Chromebooks
> use the SPI interface to connect to the Embedded Controller.
>
> Bisect suggests that commit 3a70dd2d050 ("spi: mediatek: fix fifo rx 
> mode")
> introduced the problem. The problem was fixed with upstream commit 
> 0d5c3954b35e
> ("spi: mediatek: Fix fifo transfer").
>
> Detailed problem description from commit 0d5c3954b35e:
>
>     Commit 3a70dd2d0503 ("spi: mediatek: fix fifo rx mode") claims that
>     fifo RX mode was never handled, and adds the presumably missing code
>     to the FIFO transfer function. However, the claim that receive data
>     was not handled is incorrect. It was handled as part of interrupt
>     handling after the transfer was complete. The code added with the 
> above
>     mentioned commit reads data from the receive FIFO before the transfer
>     is started, which is wrong. This results in an actual transfer error
>     on a Hayato Chromebook.
>
>     Remove the code trying to handle receive data before the transfer is
>     started to fix the problem.
>
> Guenter

