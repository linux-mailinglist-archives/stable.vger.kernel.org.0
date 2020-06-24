Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A1320746E
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 15:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390907AbgFXN0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 09:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388365AbgFXN0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 09:26:48 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FA0C061573;
        Wed, 24 Jun 2020 06:26:48 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d66so1167629pfd.6;
        Wed, 24 Jun 2020 06:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3QqyRUnOedHGVId+AW8cu9yICVAaeoUy3JEKTkyV2pY=;
        b=ELKXzinkEcorZ+IWkiqUi0oVSY+Hn/VMJDGq23u65Tfb8tGujbqyignb0PBl6M5XYT
         lxGF3Vfd3alJAgYsq/9CCpaGWkWjngKrpSbOaHE9lCpnbOkCtNKjpTXaUYads+E1uzjI
         DlYqSMyCf81qaOYJ4zFsIh7UWJX554cCnnH/QvESau2mZAxAQwQkVmuwx2nk02sFoKFr
         ejodypRkb9lUW3OvTa+hbRCL/FfD5qQ2hwdZu0tB6+juUUZQmnfd2TcniR2CZn62y5WZ
         4tR1mvPuJE0qmkw9wFSvxWzM52+qA5U8LO8sx/eMXH/0RjXjfMQ6EHRV+VXuQxZUwue1
         2ylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3QqyRUnOedHGVId+AW8cu9yICVAaeoUy3JEKTkyV2pY=;
        b=IGEfjGacRP6+VlJrzAROZIVRcLpGSHdF3t1ANNVXXubYoa7HKBmDWBC/+V7kOcU9FA
         9SR5sWI/7d3jvcFuxn94bIPv1FMqs5IrLbGaHzg8ggOa1KudrKoUsvBqMyNTmHU38aGX
         fxGi+URFIW4DbalAUgYdVLcZEXkIElt7arT4N8ond1ViPffnv8MphCi/q3Xh4tl2q6nM
         WwUlxCdRlRTtvG004zd4AwItPE6KiL4IfUDrhMhWn79B31jE05tdmJwMUzYFkpbRdAeG
         zK6a5A+gXaNihqSlJaXAj0hf4LJEUex0eilyZyRhdVXa/g4dy4WALFEvFAqmCKjOHG/d
         6UbA==
X-Gm-Message-State: AOAM530hSWWhIDdERrTCEGbxULBrJN272o3wb3Rwt94TGKeIOyaLEbND
        1X+2oBfCPRjVotyoniip/fphwAQ/
X-Google-Smtp-Source: ABdhPJxw43FZvIABglVq0YDaYBsTrD65Tmm+x0odlt5dNOLc2bEFsiQFoJeQnuIDDXMQpkvE4p0oCg==
X-Received: by 2002:a63:3d42:: with SMTP id k63mr21698323pga.330.1593005207934;
        Wed, 24 Jun 2020 06:26:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id hi19sm5335251pjb.49.2020.06.24.06.26.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 06:26:47 -0700 (PDT)
Subject: Re: [PATCH 4.14 000/136] 4.14.186-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200623195303.601828702@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <b882847b-9047-79ed-6701-a78a3fcb9dd1@roeck-us.net>
Date:   Wed, 24 Jun 2020 06:26:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/23/20 12:57 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.186 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jun 2020 19:52:30 +0000.
> Anything received after that time might be too late.
> 

For v4.14.185-136-g1c6114e25934:

arm:allmodconfig, arm64:allmodconfig, arm:pxa_defconfig:

drivers/mtd/nand/pxa3xx_nand.c: In function 'pxa3xx_nand_remove':
drivers/mtd/nand/pxa3xx_nand.c:1918:16: error: passing argument 1 of 'nand_release' from incompatible pointer type

arm:lpc32xx_defconfig:

drivers/mtd/nand/lpc32xx_slc.c: In function 'lpc32xx_nand_probe':
drivers/mtd/nand/lpc32xx_slc.c:938:15: error: passing argument 1 of 'nand_release' from incompatible pointer type

drivers/mtd/nand/lpc32xx_mlc.c: In function 'lpc32xx_nand_probe':
drivers/mtd/nand/lpc32xx_mlc.c:808:15: error: passing argument 1 of 'nand_release' from incompatible pointer type

Boot tests are not complete, so there may be more failures. Also, looking through
callers of nand_release(), there are more failures. Confirmed:

drivers/mtd/nand/jz4740_nand.c (mips:qi_lb60_defconfig)
drivers/mtd/nand/bf5xx_nand.c (blackfin:BF548-EZKIT_defconfig)

I don't know if I found all instances.

Guenter
