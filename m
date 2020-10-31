Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1992A18E8
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 18:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgJaRLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 13:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgJaRLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 13:11:45 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E75C0617A6
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 10:11:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id lt2so991048pjb.2
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 10:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=f++XT0bktABv7g1C5u6aG7U5oVmsTzK16JLOUjfHcLQ=;
        b=blFzmQ83C38im2bR36vRX2qK8XzHldcqCkGMyrfR/L6I98IiKSBXqxSscVWqpViFpD
         wCKIEhofYwk1EXGKTQD86WkCLLFQ2q66pPmEccT38CAox7RIr0H/rno2ZaRGJeeRAffE
         8xkFOUYcS+ac4in9hL/cATAWctQnzjrCZ1Oru82u9Y166aWU9JKptwH2SzB4/Dd8bUAr
         kwLlhQM3hdKdOu7AU3FHq4bMGBT0V9Ux8DMy1iUn50b2BIrECAKPJjwJgE/mEPZddtz9
         u4RNeMGzWzJtX1TSgb1yTjqeUfMltWBAYejgLwTUSvDcVMqySU2YClSv4yzLskZbz1di
         C5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=f++XT0bktABv7g1C5u6aG7U5oVmsTzK16JLOUjfHcLQ=;
        b=E28qs1ikncGjHMyaM+wlG+evevYiWw+eLuXR45HHZCw1Q8N0R7XA685wcErCmU7qXI
         pLUbH7LT5mgXHwuq4Mrh6aJkb+yOGo5MN+gc3M9kXhh5W3UbEdbF3eH2INlNpR0fqB54
         7knAoJnfTNrxFTu6m34/HM4JT4yNHgo/M6yEPPXAdiwDt8RnzNlpklFWPwqqkcwgDDAE
         oAxg4o9tG1f7lgQEUYu1yzgCyxdrMoT3irjHP0j9pjz5OvK0nZFPKzVFe8UwTkEjewCU
         OhUsEuPAlSEGUDydbqxAtRAolsS/AxWpLKs1xbm13JMRTMZi9gbRuuJ6gjro4cbgq4R/
         qCyQ==
X-Gm-Message-State: AOAM532RCSRHnwJmv5h982/H5LLosYAXX9a5PliHD0OC+PyyAy6VKK7T
        WUAQRyS+U5VbjGkxmuPQS3RiUw==
X-Google-Smtp-Source: ABdhPJyDY1dwIQwlf8y56cq19DGJULncIIV8NetBS226a5OVhciYDSCPwxMYJRgHdsNu9kf6xcqZ1w==
X-Received: by 2002:a17:90a:ed97:: with SMTP id k23mr9442630pjy.100.1604164304371;
        Sat, 31 Oct 2020 10:11:44 -0700 (PDT)
Received: from debian ([171.49.162.97])
        by smtp.gmail.com with ESMTPSA id 205sm9223691pfy.35.2020.10.31.10.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 10:11:43 -0700 (PDT)
Message-ID: <ca2501e512973270c6b7b7cc05c7f50791541a66.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.9 00/74] 5.9.3-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Sat, 31 Oct 2020 22:41:38 +0530
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
Content-Type: multipart/mixed; boundary="=-6W/pfINf4HduZ83u5LLn"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-6W/pfINf4HduZ83u5LLn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Sat, 2020-10-31 at 12:35 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.3 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Mon, 02 Nov 2020 11:34:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

hello,
i have build using ktest. but then i did the normal compile.
compiled and booted 5.9.3-rc1+ . dmesg -l err is clear.

some lines from dmesg output related  
----------x------------------x---------------------------x---
video: module verification failed: signature and/or required key
missing - tainting kernel
sdhci-pci 0000:00:1e.6: failed to setup card detect gpio
--------x-------------------------------x-----------------x---


Now something related to kernel build and install..
----------x---------------------x--------------------------x-------
WARNING: modpost: EXPORT symbol "copy_mc_fragile" [vmlinux] version
generation failed, symbol will not be versioned.
W: Possible missing firmware /lib/firmware/i915/rkl_dmc_ver2_01.bin for
module i915
-------------x-------------------x-------------------------x---------

Now one thing during boot..
-----------x------------x---- 
unable to start nftables
-x-----------------------x---

iam attaching a file....please see...

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


-- 
software engineer
rajagiri school of engineering and technology  - autonomous




--=-6W/pfINf4HduZ83u5LLn
Content-Disposition: attachment; filename="kcompile-warning-oct31-2020.txt"
Content-Type: text/plain; name="kcompile-warning-oct31-2020.txt"; charset="UTF-8"
Content-Transfer-Encoding: base64

bGQ6IGFyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9oZWFkXzY0Lm86IHdhcm5pbmc6IHJlbG9jYXRp
b24gaW4gcmVhZC1vbmx5IHNlY3Rpb24gYC5oZWFkLnRleHQnCiAgTEQgW01dICBkcml2ZXJzL25l
dC93aXJlbGVzcy9hdGgvYXRoOWsvYXRoOWtfaHcua28KbGQ6IHdhcm5pbmc6IGNyZWF0aW5nIERU
X1RFWFRSRUwgaW4gYSBQSUUK


--=-6W/pfINf4HduZ83u5LLn--

