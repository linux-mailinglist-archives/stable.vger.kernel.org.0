Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91410453F38
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 05:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhKQEEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 23:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbhKQEEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 23:04:44 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90998C061570;
        Tue, 16 Nov 2021 20:01:46 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id 7so3335952oip.12;
        Tue, 16 Nov 2021 20:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w8mSj/cVyKUNlbk+O2aUSzjmhvdrjNAyoFryvRivSGE=;
        b=pS7KYnO3X8LbfXsdkCS5tfvu280bK6dECq2iptdzcl1aOGT9kOVDh10LzKqxTLBDIb
         rqFJirJgzKYW+7OU94S1bNe+armEGS7PHSFU8TVoz6gOd9gl/dmd+zbdPLLm+ADIrIdt
         fpoCA+LKuM9HQbuaeDBbB3777CaYXdMo7xn53P4/s9WkeTBEytlHp6YrsTNFQenWAJQO
         z8vSNnMM0lP5073jW2bmN6ff3Qu4zp+PP9c4Em0cut5rdD9VUH/VK/gWSqVuPdYfGlnC
         Vw6jkUWC4QHBjeJuH9MeFnnuaH1w8gLrR3pI+vALS5PdnEIXA/i+WzM1P7M5bVPjvF6t
         PPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=w8mSj/cVyKUNlbk+O2aUSzjmhvdrjNAyoFryvRivSGE=;
        b=U9bJNC5FcqSjBfxjz6x+RQd5ZuCPVdB9rKbg1oZo8QIRRWGOQpYGysWmKN9Wih8LvL
         fQ0a+I1YbvK4grHSmjh41cz7rkYltP/M6RKYL8hUKbxxpQ+CV9N4QlSIoc3ZDX6q025b
         vXhlW8wVMsBn6f8DwfqG1wOWfFAW3OtsBJ6OMQrhYisxtVMm56ieentFtsDgPjtU/wRZ
         5Fsolk7YSvArX+6mVETctscjn/qTi3w5E/sJifw248v52URPD8uJVmzx3IwK1P5H194Y
         y3emAvHy0xKYwrGRi3G/RiIr3QNtQQ3FaSlf7puPC4BJapQFcWTmR07Pa4JIlfBsFtqu
         5tMg==
X-Gm-Message-State: AOAM533GQVbmj4FC+YDuujO5jwhO2ez575AVQn9oDsKG7+e1zSeS5TZt
        8dxJZRmtFoOW1bCEa661He/2ItrxT6M=
X-Google-Smtp-Source: ABdhPJzRWlnw5FrBIV28nVgmuOmd25mNj9lmc2DSneyRziCyUbmEHTRiwbYSYs8lol24Fjxm/bctfA==
X-Received: by 2002:a05:6808:2111:: with SMTP id r17mr11528122oiw.118.1637121706034;
        Tue, 16 Nov 2021 20:01:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z7sm4382691oib.0.2021.11.16.20.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 20:01:45 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Nov 2021 20:01:44 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/857] 5.14.19-rc2 review
Message-ID: <20211117040144.GC212153@roeck-us.net>
References: <20211116142622.081299270@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116142622.081299270@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 04:01:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.19 release.
> There are 857 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
