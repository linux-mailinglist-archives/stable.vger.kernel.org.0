Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F321E910E
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 14:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgE3MGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 08:06:35 -0400
Received: from mout.web.de ([217.72.192.78]:34127 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgE3MGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 30 May 2020 08:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590840377;
        bh=O54HY8u6kNk5jzvThHN0FKrxm2RMGAbqXT/OzMCH9To=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=QRVfqUHgCSK4CjB0+eLJWIIMYp5yPiB9/aW3G4Xtn6zeIykR+HkdECe/HA/jPAFqc
         8fpf9BB9V95LslWLm9ANZYkFKHVzEHnfL1IvQHAjQzN1MrXPw4LQWJFxbl0VSHMccK
         rihrdc40rdiKQ2+YiPzVIqMGn+rVSZbO98ihldkQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.53.180]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MrOhx-1jBDbC1ewJ-00oYQ8; Sat, 30
 May 2020 14:06:17 +0200
Subject: Re: [PATCH v2] tty: xilinx_uartps: Fix missing id assignment to the
 console
To:     Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, monstr@monstr.eu, git@xilinx.com,
        stable@vger.kernel.org
Cc:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
References: <ed3111533ef5bd342ee5ec504812240b870f0853.1588602446.git.michal.simek@xilinx.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <170a896f-42d3-345b-7b93-c964d33fe71c@web.de>
Date:   Sat, 30 May 2020 14:06:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ed3111533ef5bd342ee5ec504812240b870f0853.1588602446.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:U0QUvgsTl6Chv5EeNmrI3y6j41DKwUycjVjsajxQR0cn6vZ4VYV
 O3Bus/0oG4R1KPBaXO6E4gRYlQwQOvmNeD22qSmMzgzBPSQeU7vIPG13jiXr9P8QwFbFyIU
 BlgLZgEAxiz7tOauz1ergidaOxeQd0R1ZUS7OsnefA8JJ5FE9HoPvB+Kwlou6ZB/PIpqbfa
 QOFtw0PfWB4Fv/LT77byg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Cu+g8gK14Wo=:4ISwZaVZBBFaMu8VHtE91z
 W1LQfA40u27nUxFQRbbUnhk/yY6iBby3ZKIpN9nY7A0lu+8V6c4xMjH18WTNwdafKVvGWVNaw
 aT8zpqdGhLTQl/cTDcFrRdMVf1NNGQsq8voK6LlsWYexcDEf//3EZZsvyMn+s/sUSEUtqNodF
 3QrbeJ3IbYzh1x7jqSwsbwOnP6HMLQ+mflgGsuDSNen7Hu0/14uL/tG0nwy2D3UpWR6xSVWCT
 EX9Z13Vsaz/T0kGxXo2F889TY7nFaRhxgSigJsXCmKbHaYirv28vCrOKyQ4K9vWduz+FEDKJi
 4AgrYb01h2DlmatngI7fjzmRvAsX05Fpy3kYwQvosiUW351w1JCJCkqKAEgLUbrAsqXjsQHKF
 AYkY8v2anHN098SoSSoZheis+EVNlzUFKu4zZFBpgRisjsfEeMMqgNSVNU9+HfwZYJIgSSFZs
 hH4yID0CygT3vmEZlDC3WD32y62rhfJcgZVfEjmr0uUEglFiSEJ+aCNTm2OtqC1hLGavLRyyE
 T/mK9WirExSrMrGDTUJ7bVgQ8c1oT8SNMF3tupCFnb9nCs/5+puI6ii6lCZ86I4oU5mjH4jXZ
 HFzMsjTVgPAN095ch1qsKgBC+wGvIkyxyrNsuRj2AcC9Ohp8apbW1DoYsEtpADnW5yuMemL8k
 A2Z8DmtirZ10ppCWuolQcuGqh1v+673bT1+5NHO2dFKBkpCEXOv6blI0X/8OfP3UedrnSkwDp
 smp93XTmIKiia3AyCAGE0v2IVq2y810L3BRrdaAuIQx4scqW9nrZCyhqpppJddlwIrLT7XwjZ
 bp4SIeAYvFdX2E10WeFvHKRn1KRAKqUNJSrmPJCWWlLN0TGg8zGOIODOfsMDaIrrai0KfvFsv
 ptA84RdbKalg8bdR+JXYCx6Ad6jVZ5oZW080Zv2LQVQIdarE0yeIW5s+NpOhK/PDIpDumifcH
 pScf9A9ZBnvd1GlqnbLqn5ylEXJdtqqI9NHEyJ7e8EfvwygkWxMs06G+N7mpd9argkQ2egEqZ
 aHF4gYJOSdAJjLOASkCQyfLdCCl5yIllkSzjtICG6In0P/eGHkmSKwCBUFhkey+BotY86tAlC
 9tk4veAB9ueUq/4bCskS/wNPG0kZE+7X9kc52aWKFwBOLCGGp4iBrLcG5RHQPgUSY+5K76J2i
 e26uH5Z+BQBjNpkiCb93lv+AetYLCCCyBG2eVoY6xgzsn3wUW8KpJKxW3jBx12chXFsI3JJRP
 GkEa9dcG7tzJtm33z
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.05.20 16:27, Michal Simek wrote:
> From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
>
> When serial console has been assigned to ttyPS1 (which is serial1 alias)
> console index is not updated property and pointing to index -1 (statical=
ly
> initialized) which ends up in situation where nothing has been printed o=
n
> the port.
>
> The commit 18cc7ac8a28e ("Revert "serial: uartps: Register own uart cons=
ole
> and driver structures"") didn't contain this line which was removed by
> accident.
>
> Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>
> Changes in v2:
> - Do better commit description
> - Origin subject was "tty: xilinx_uartps: Add the id to the console"
>
> Greg: Would be good if you can take this patch to 5.7 and also to stable
> trees.
>
> ---
>  drivers/tty/serial/xilinx_uartps.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xil=
inx_uartps.c
> index 672cfa075e28..b9d672af8b65 100644
> --- a/drivers/tty/serial/xilinx_uartps.c
> +++ b/drivers/tty/serial/xilinx_uartps.c
> @@ -1465,6 +1465,7 @@ static int cdns_uart_probe(struct platform_device =
*pdev)
>  		cdns_uart_uart_driver.nr =3D CDNS_UART_NR_PORTS;
>  #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
>  		cdns_uart_uart_driver.cons =3D &cdns_uart_console;
> +		cdns_uart_console.index =3D id;
>  #endif
>
>  		rc =3D uart_register_driver(&cdns_uart_uart_driver);
>

This breaks the ultra96-rev1 which uses uart1 as serial0 (and
stdout-path =3D "serial0:115200n8"). Reverting this commit gives

[    0.024344] Serial: AMBA PL011 UART driver
[    0.028010] ff000000.serial: ttyPS1 at MMIO 0xff000000 (irq =3D 19, bas=
e_baud =3D 6250000) is a xuartps
[    0.028172] serial serial0: tty port ttyPS1 registered
[    0.028579] ff010000.serial: ttyPS0 at MMIO 0xff010000 (irq =3D 20, bas=
e_baud =3D 6250000) is a xuartps
[    0.557477] printk: console [ttyPS0] enabled

again. Affects stable as well (seen first in 5.4).

Jan
