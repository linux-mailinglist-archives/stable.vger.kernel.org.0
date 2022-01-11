Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3589C48ADBC
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 13:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239542AbiAKMjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 07:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239548AbiAKMjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 07:39:23 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60078C06173F;
        Tue, 11 Jan 2022 04:39:23 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id h10so22556160wrb.1;
        Tue, 11 Jan 2022 04:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7Hrhm7bAUxgue0b8cX7wTHTiwkPBIXA/e8ccgbg0Dw8=;
        b=bDWLB0Zhkj2AneVRgl6tB5bQ5Mo7kVC1W3ODKTD2An//sMJ4wo1A3bLmVzwOQD4H8L
         kFxtzoUuH8FMlnJl3+GuFZV5dtz9yOX9jZB1Db42sKDuJ4ZiX1P6cp3hJzOJona9KNIa
         eA6Kxm9SL64D6BZZntPFBTSJmeuoImKDzMEEUKNrKCb0VBA9QdmZ5XgNsKYkMbWGrcqH
         Q5PS/ED/jyQT+KEsTI3uqclu5KjM0pZRDbEa4sGFXJ7622BUQ8ADqNA8Tx85X1wUQZss
         17lKB+uXB5A3VBC0kjHdiog06F0v7Ocw9mvzQajpQETOTMuXC42S/PO0AtoABNFbZ/nU
         AlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Hrhm7bAUxgue0b8cX7wTHTiwkPBIXA/e8ccgbg0Dw8=;
        b=oFRJ301kMHwsCwqwefMm0XBUxtR+hUFGfKZj838ym1360/lj/BG/K5kyWDkNrjactc
         V7k1e115oAXQHM5SMEm3Dbp8M49IOkHrBKf/jqFtGe9DAyHuSWVS+rfhPEtcmDD7u3ty
         Ua8dFv1SdoZOn4j8D+JDAM2MLDVwPKOFXdMpEIiJ9OY0SUvgUfpZYGGDrtXZSZPfuaho
         p76oXQ6wlJKpREQ1zEL0NMbbgtb2JDPr5Dhr7fYTW/jlrAgp+6aBaQS6U4y3uDlbp1h1
         tqGwl8qB7AbM+p+mVvCQouBt4HItknjWSOtQqWpwVBfAwSAZSZb+EiLTq5S7a6JwMkHu
         QFXg==
X-Gm-Message-State: AOAM530ES1Sd5ygDJs3w+lC4izrYg9NEs/aOanxrD8LEHGaNB1vqV4Fi
        MFq1syp+Wf7g/F3HxibLocE=
X-Google-Smtp-Source: ABdhPJyjUhdhLpbBw5ZjJX+BV8NzyPCzziYyAYczHWuWxu6XApYItCICXKxUIAZlwCzUWi8rQzTT0A==
X-Received: by 2002:a5d:4047:: with SMTP id w7mr3617686wrp.519.1641904762032;
        Tue, 11 Jan 2022 04:39:22 -0800 (PST)
Received: from debian (host-2-98-43-34.as13285.net. [2.98.43.34])
        by smtp.gmail.com with ESMTPSA id q6sm9246124wrr.88.2022.01.11.04.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 04:39:21 -0800 (PST)
Date:   Tue, 11 Jan 2022 12:39:19 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/34] 5.4.171-rc1 review
Message-ID: <Yd16d3JpwsG+lWzy@debian>
References: <20220110071815.647309738@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jan 10, 2022 at 08:22:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.171 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220106): 65 configs -> no new failure
arm (gcc version 11.2.1 20220106): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220106): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220106): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/610


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

