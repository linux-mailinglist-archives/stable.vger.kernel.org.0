Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47374480BCE
	for <lists+stable@lfdr.de>; Tue, 28 Dec 2021 18:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhL1RGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 12:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbhL1RGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 12:06:22 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7218CC061574;
        Tue, 28 Dec 2021 09:06:22 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id be32so30866249oib.11;
        Tue, 28 Dec 2021 09:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j636oQg+6NKdMGjOAXxnMBHZV8V9q0zppPnA2gXL92Q=;
        b=ELysWVyXec8T+lvANSFAc68/LUOyWQP9A6rbsJQ9cCE8krJq2p+ZAWnR5xVmJnsSfz
         qVZ6vfzsFHpOipAPJORUBZmMFUVIbhAD4IdB49zk39JP3Or3msRVjahIdHZKQrECURwY
         VCo7zrOyZDo5GyBNhYbA6cpzFCykhZjaUayXXA1gPns+0ZwZxWWyBQPWss+eLy5hADpI
         kNQr2ZaOYtl0rFOhfh5c4Dlk1cUPViuoRIatz0kfczVxXEDhhnLjoRf+UKKwl18Lr6GT
         M36ezymaYtrh1Q9bY/JjGd3Kbi8w4A2dWXEKWMXprK6XytdEAfcj6fb0tBtguemKqGny
         5AbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=j636oQg+6NKdMGjOAXxnMBHZV8V9q0zppPnA2gXL92Q=;
        b=wbxkbnXzdXd2ul4eL+7UOrpXaJtm0ZhUVTmHGPA5TDFNsS51xm/ABJFZkcH43iAtZf
         0Yu6QDGULqqeU8iG5Br/5SqgAq7+CpZKW3UjYJu+FrWUPVpQ9Abq14NwrzMoWSibNKxB
         +IBwYwvo6iRkjXV/izu73pcaX7ONt0Wcjy7EZJc/LykU18DIWWMQzxWCUX5byxlwHXMH
         xCVsrDlg7YrrG6qOM97hwr6ifH2sdeWTmOh1Alwv0hS9cr9mg87xWB/a6xl6Ri/cN1F3
         lF+TQPZIL0trvHAzBMi2o+UzcFdDFTiqASgQqKdom5Y25K0x79HyIrCCz6Au7b3HzpvI
         iP9A==
X-Gm-Message-State: AOAM533AQ4aGJA1nJUxWJR1pPFAxhEgWbYzhT1HofvpUsiHwgkaEXAAp
        vEblseX2gXgUY3lBcqZ5pV8=
X-Google-Smtp-Source: ABdhPJwbPdtoqLw2HIwELdHow4TH3LXWPZSoPhXU5QHXtq7uRcB8mzyppJSge6hAi3R4b8y86QT+Rg==
X-Received: by 2002:a05:6808:1408:: with SMTP id w8mr17339985oiv.54.1640711181917;
        Tue, 28 Dec 2021 09:06:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o2sm4068465oik.11.2021.12.28.09.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 09:06:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 28 Dec 2021 09:06:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/38] 4.19.223-rc1 review
Message-ID: <20211228170620.GD1225572@roeck-us.net>
References: <20211227151319.379265346@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 04:30:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.223 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Dec 2021 15:13:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
