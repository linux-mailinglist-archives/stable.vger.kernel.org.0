Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49EEC15CFDF
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 03:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgBNCVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 21:21:50 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44373 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbgBNCVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 21:21:50 -0500
Received: by mail-pl1-f195.google.com with SMTP id d9so3111925plo.11;
        Thu, 13 Feb 2020 18:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qDZU2XNj0nWziKXBpZXTUUjQziiDw/OI4yhhIpKmVpc=;
        b=Cu0W3mYCAoTmpJbeOAe9QxjaOVL1nSNb64XyHF+z1czRq68tb1IwCw3PV3obhTXdfO
         WZCx1i/nZuGtTv+xqgdlGgprKojor71cqvVzLToxW7L5Y37R2Xl8jp9NUM9q4jf37iqy
         bkjdVMqQzN/C1yZzPxLxJMZcQRvoiaid6ty0x6EygxHzYIKVmF8yoqW0eVqBYvtkcHiJ
         rUtRkld8iF0sEsYX0Dg3q+VOAwaf+0Rj8aKtRCkMi3o/7cdmmCnRQm8KsbTW1BdKBpdg
         6dh24aeDxVpGPhISRwL/0K4NRgYrG5zxKmqa6qvc7BN8QqmR+UJ37XV45JGPNIkfdq66
         UZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=qDZU2XNj0nWziKXBpZXTUUjQziiDw/OI4yhhIpKmVpc=;
        b=Jmbm5/HytW8AejxwecdWPN9irVt4TFWmrE8Eaqv87wopANGWfY0MMJBfcPhrJKNVWs
         SgDrXfL8glD9d/MJnr2Va0aitX502CmHhqb2TCUc3pzQeFO0c1C30bLL0t0Z6H1WcJfD
         Whgciry8CYHpd+ZwO/3Lc9sgiDZaKnYNLNAhzwUkpdmOemDIb+x3igMJIUAT2zt6A82e
         ayZ0lFi8ZJ+NlPb/Oe1EDFlFIsjEkjTvTtZFaLRpwxiA7XehVsllVyDcE4qXnZM5FHiD
         xq8sPeR0o3muuqCUvg971RCaO13pQnthjW7ViGoZKPW7xuMvZLl3i+IGITOgSYUt9JzJ
         /lHw==
X-Gm-Message-State: APjAAAUPLZp8Y1LplzxkOc9v2/ok33M+prJCarhr5urIOMahSrgRcLs2
        tymZs+qzQbl6fao+ZeGF1mE=
X-Google-Smtp-Source: APXvYqxZh1m48uhy5ka1FMZXHYluHVaKKMn0N9+ve6ERt2HB15abZ7gYG6KbL5WwcofpFmYU1lF0bw==
X-Received: by 2002:a17:90a:ab88:: with SMTP id n8mr265741pjq.0.1581646909413;
        Thu, 13 Feb 2020 18:21:49 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y18sm4730227pfe.19.2020.02.13.18.21.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Feb 2020 18:21:48 -0800 (PST)
Date:   Thu, 13 Feb 2020 18:21:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/173] 4.14.171-stable review
Message-ID: <20200214022146.GA4866@roeck-us.net>
References: <20200213151931.677980430@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 07:18:23AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.171 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
> 

Commit 833e09807c49 ("serial: uartps: Add a timeout to the tx empty wait")
breaks all xilinx boot tests, here and in v4.19.y. Reverting it fixes the
problem. that is maybe not entirely surprising, given that there were
some 40 other commits into the same file since v4.14.

FWIW, I still think that way too many patches are being backported.

Guenter

---
# bad: [2874fe09799571ffc1e2e075c38a1c128fc11cae] Linux 4.14.171-rc1
# good: [e0f8b8a65a473a8baa439cf865a694bbeb83fe90] Linux 4.14.170
git bisect start 'HEAD' 'v4.14.170'
# good: [31fbe06af2d73712ecc3e24a8bfd45ba9654d6f9] KVM: x86: Protect x86_decode_insn from Spectre-v1/L1TF attacks
git bisect good 31fbe06af2d73712ecc3e24a8bfd45ba9654d6f9
# good: [a7a7caf5064e71b5572e0e0615b253957faaab44] KVM: x86: Fix potential put_fpu() w/o load_fpu() on MPX platform
git bisect good a7a7caf5064e71b5572e0e0615b253957faaab44
# bad: [47819f61a70e6e82decb834f9619fceef3129c21] rtc: cmos: Stop using shared IRQ
git bisect bad 47819f61a70e6e82decb834f9619fceef3129c21
# good: [4e85572492f971378c791e3d2175622ff85f9e75] ASoC: pcm: update FE/BE trigger order based on the command
git bisect good 4e85572492f971378c791e3d2175622ff85f9e75
# good: [ba63da54934347cd4b208ac1e87d8b91c6c69379] PCI: Don't disable bridge BARs when assigning bus resources
git bisect good ba63da54934347cd4b208ac1e87d8b91c6c69379
# good: [dad1bc453beefd1d281e02d90243edd65e2b6d4b] NFSv4: try lease recovery on NFS4ERR_EXPIRED
git bisect good dad1bc453beefd1d281e02d90243edd65e2b6d4b
# bad: [e0fda976e9af9b5d26696c9e4d225d1c7757c22f] rtc: hym8563: Return -EINVAL if the time is known to be invalid
git bisect bad e0fda976e9af9b5d26696c9e4d225d1c7757c22f
# bad: [833e09807c499ee1449ddcd190a557d912f31e1b] serial: uartps: Add a timeout to the tx empty wait
git bisect bad 833e09807c499ee1449ddcd190a557d912f31e1b
# first bad commit: [833e09807c499ee1449ddcd190a557d912f31e1b] serial: uartps: Add a timeout to the tx empty wait
