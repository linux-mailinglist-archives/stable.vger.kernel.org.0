Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5218527D93B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 22:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgI2Ush (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 16:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbgI2Ush (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 16:48:37 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C234C061755;
        Tue, 29 Sep 2020 13:48:37 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id m25so1647189oou.0;
        Tue, 29 Sep 2020 13:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6+H0ELsNtkKUqCdLMhCUZCLTr14QBm5aCtYZLFDOAdI=;
        b=BGLlfzG/f2+kak9xtFG7UcDbAFcFiutBILBPAfSGgICbzGDcg4MNbfJgwlATYKzQsb
         YlNabe/bG6B1m250mQEZVxynhMON01G/Q3YahAJ7oevSdyFeN741dMsU21fEsCsUXKrS
         EBCIhB6zwcy4T9rfVUtSrCm1NG88Ux5/51q7jBRgPOZxFPk+mKYCgV5LVytKOXiV0RwD
         jM0V29SP/WNa0lP2EWVDTJxa3QUxITfNMjtmGctLSHADGnmqSaM5tAY/wyy3PtS5ZRmk
         WTiiZ8HcGZuiZNiWyFK39meG3ctPo/smAJMb/LLgSLAcUbidoW1yCuXlDT6R+IG/kkAZ
         PMYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=6+H0ELsNtkKUqCdLMhCUZCLTr14QBm5aCtYZLFDOAdI=;
        b=OteOYnbHVy0uLmb3O2wF/YFEAPeqLQ44Ffsnoe9vMCkTTA0An/rjSkUb7eQUV+fSW7
         EabApsmaaQzQm4aqkqUOWjfByrt5Jgs0SQeYdBrNrAVW1oIkKhOuIM+hDwAuQX0LqOJd
         5dNuvjJ6p1fdnlcpy29vObgzphb81pM1hm44gPgNnVI6zQddjdg/8XYCFBzkeWnkSH6K
         2myJFxtBW9gtzorO5apmdoeteg/flgm9o/d0xRszV5ksnFtKBkgptCTbmMQHgGOdlFpW
         bW2qi35kt2AHYGUOlgLWzz6jQbOkcynefF2H/4jTz3ZoUas0w8SAOLqQM6S5iuKgzOUP
         lBIQ==
X-Gm-Message-State: AOAM533iZbhlaU6NIW31glprONHCjbZJ4i6wX4xponGml+4crDFc4SzK
        q7wxHksKU0Zbo2EwqRWgwjM=
X-Google-Smtp-Source: ABdhPJwFFZgtDJSA0xYQlG6VEwO2G8bVEZdxREXYTOgM3lWVTX3Qs+xIPRN2axg0A1a8PzSjEvwLEA==
X-Received: by 2002:a4a:e544:: with SMTP id s4mr5977981oot.74.1601412516918;
        Tue, 29 Sep 2020 13:48:36 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y23sm3186219ooj.34.2020.09.29.13.48.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Sep 2020 13:48:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Sep 2020 13:48:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/121] 4.9.238-rc1 review
Message-ID: <20200929204835.GB152716@roeck-us.net>
References: <20200929105930.172747117@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 12:59:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.238 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 386 pass: 377 fail: 9
Failed tests:
	arm:xilinx-zynq-a9:multi_v7_defconfig:mem128:zynq-zc702:initrd
	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zc702:rootfs
	arm:xilinx-zynq-a9:multi_v7_defconfig:sd:mem128:zynq-zc706:rootfs
	arm64:xlnx-zcu102:defconfig:smp:mem2G:initrd:xilinx/zynqmp-ep108
	arm64:xlnx-zcu102:defconfig:smp:mem2G:sata:rootfs:xilinx/zynqmp-ep108
	arm64:xlnx-zcu102:defconfig:nosmp:mem2G:initrd:xilinx/zynqmp-ep108
	arm64be:xlnx-zcu102:defconfig:smp:mem2G:initrd:xilinx/zynqmp-ep108
	arm64be:xlnx-zcu102:defconfig:smp:mem2G:sata:rootfs:xilinx/zynqmp-ep108
	arm64be:xlnx-zcu102:defconfig:nosmp:mem2G:initrd:xilinx/zynqmp-ep108

The Xilinx problems appears to be due to the following two commits.

1156dd2483fd serial: uartps: Wait for tx_empty in console setup
9a13572bf02b serial: uartps: Add a timeout to the tx empty wait

I didn't try all tests, but reverting those two patches fixes the problem
at least for arm64:xlnx-zcu102.

I don't see this problem in any other stable releases.

Guenter
