Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6904A2AD4
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 02:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351945AbiA2BEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 20:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351944AbiA2BEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 20:04:54 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF8DC061714;
        Fri, 28 Jan 2022 17:04:54 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id m9so15551410oia.12;
        Fri, 28 Jan 2022 17:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HowNelfI7xgsljN/Xg6WgCZeFid2j4X07eFbCkSuiSU=;
        b=RVg6mhENN0yMTgtTFA1cVFDc6KPz0OdxEtoWvFGOrQad2DrBphTy9o6w0ijhna/kKR
         qSV9rrR2IO7yuiwFOU8JAAwItC1zoXZHk9+Mkfim1Zx7jb7dostaAIRQcC92wr3pPW8X
         FA5Ji92t/UHhWwgDZPIyN+HFQ69P8SRqq1/RBMJKK6PUEKKYM7B2k8EgFsrlCssNF1Zj
         7sLF2of6h0nXBx77zgAsVVx+2O4RFcLqKixUz5VqeiaAZgQ44wA3kKr9huTZspWfw9M5
         rxVEaiODP1TgbGvEgII/cWoW8FC13HwfaL5W0ToxL4Cv40udzkFY+ur6BEnBf9qmHcF8
         Q0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HowNelfI7xgsljN/Xg6WgCZeFid2j4X07eFbCkSuiSU=;
        b=GjRbpuBqAJNpiUWMc98F/ous6IfAmcQWaMsXSR8gTt08scCN5Rck+AJjcnV8d5KO5f
         9E1dFQsD8s34BrNNZwMIHqYvN9BgROA8uOA/k52adQv7D5GHOYeZM6z72ZS81XDwSOTi
         z+mNIos1Z3ArJHFr/CSP59DidFodfRoFqCiyr1Tnt1//LykOdJNyVz5D8z13FRfQLCh/
         aJzAHDHgw4pmTDztLyaJzvo8xTnoslYnKSlHIoG8gIHnHtZsCuS9KOO/dF2HdW2dyZMh
         DyY/WH+Bxp01ib4Zr3yozMoq7rZeQB6EUfDZp6Oaz8PDNXkB0S2/6Iv/eyDrUGnZ/FwU
         jbmw==
X-Gm-Message-State: AOAM532wnyvHf3Iaj+mHtfPX4JcsOpYnmAsGiLqbXS4md5sTxPlUbbzc
        7B05zsz72vxdk9YBVcXR1QM=
X-Google-Smtp-Source: ABdhPJyjHeX/Tv59243KGrf6kBuCCLPcUqIatoQeVpCyxi6I2cVdSRE+1JkI2b/F03mFU5ugdy6stg==
X-Received: by 2002:a05:6808:3012:: with SMTP id ay18mr12987739oib.5.1643418294147;
        Fri, 28 Jan 2022 17:04:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k6sm6909229oop.28.2022.01.28.17.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 17:04:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Jan 2022 17:04:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 4.9 0/9] 4.9.299-rc1 review
Message-ID: <20220129010452.GB732042@roeck-us.net>
References: <20220127180257.225641300@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180257.225641300@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 07:08:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.299 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
