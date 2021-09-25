Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F91C4184C2
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 23:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhIYVvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 17:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIYVvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 17:51:00 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A5AC061570;
        Sat, 25 Sep 2021 14:49:24 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so18456043otq.7;
        Sat, 25 Sep 2021 14:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jHO/1IiZ+PHhlsfqPDBlEYWBo0SzvhDwkGwjsRAOU50=;
        b=eISXXysp0m2bpjShVLy9ZuFbznULCeYZYiS2uar0D4JnlGw1+TdmU37DFJ4TCh0rmh
         spKiCU39F3+7/NUk9rXm6TUagfulEtctjwrYFroO38bf26QrSSxdZZRlLEMmcFCxk2v0
         3A7xQwWB1XIhv3me/5hdU0ALcBFGyRUwKK3Hlws40f5qvo582evz4yYkglxfx4PCkEPy
         pAUmAfIgFRFSmuygz1b+POid4Cc1TcFr9naqiWzrcCUmY385VKQdqtqt8kdztm9VduiC
         n+zwuxAKT4scTK2xBXu4g7PxCzu1pxrbscB5aOynWCDNDzrf9WKiHm+w0NlzSDnPOuma
         sZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jHO/1IiZ+PHhlsfqPDBlEYWBo0SzvhDwkGwjsRAOU50=;
        b=2VJEdYpPbHGIG8Z8HwIwPl80rI43kDxOIGiGl4zgeyPsgOrDy/q+Q2559S8ad4j4Y0
         sgkuBMbCKoG8LmRmx2OSYiPTxEwFnnU43PrvhKC48MbaV2+EWghLBImvkL7Ux9Ee23e/
         hDGy1s+JYPizuL3ttJaQEXR9+HtHIsfytEKJjPk/n41R59tPHjfaARn0Bpi7j0MsysdQ
         FLwuUSzVkN5uaBA1+e3yuaOIB/IVHs8OmaPnaAADpLQ1JmI4fNE5jCgEdozk9B2CNWp6
         qkjNFc68zeXfw0Bya3DdFbN4JJ7RrhzAgKB7pstDmQPhfDFJnc5F5i/ou2tX6z93XiLr
         66FA==
X-Gm-Message-State: AOAM532IJY1r67h9dL1nQLavlR6PPF9Dskog3bPs+Yinbhh4bH1ACg/1
        ctRvnIn3+VaAmHnvadshOrc=
X-Google-Smtp-Source: ABdhPJxgw36gIHDUb6J5o9jKObX1xmNKYOaxrvkdnho8DK4urY1F3TS1Ai3T+gonooaUro+pK4kCAg==
X-Received: by 2002:a05:6830:314d:: with SMTP id c13mr10249138ots.90.1632606564380;
        Sat, 25 Sep 2021 14:49:24 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v1sm3261306ots.46.2021.09.25.14.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 14:49:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 25 Sep 2021 14:49:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/33] 4.19.208-rc2 review
Message-ID: <20210925214922.GD563939@roeck-us.net>
References: <20210925120746.034087226@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925120746.034087226@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 25, 2021 at 02:13:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.208 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
