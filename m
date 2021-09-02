Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39173FF5ED
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347629AbhIBVwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347627AbhIBVwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 17:52:54 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A866C061575;
        Thu,  2 Sep 2021 14:51:54 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so4370795otf.6;
        Thu, 02 Sep 2021 14:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nHf7ewKIvjFAQY+SwKwD2ieS2KMakvsPBn5fagwH7HQ=;
        b=ESVePkKSYN8u9qONct2lqfK57LE4CkrKXSYXXvp/TzFNQLaO3arjTtP/hV07rxhf2g
         GIde1qjYmIBliWisN+qekq7MuvlYn1h49iVlcuMOMPGgyEaID7KH+M78RXPkuhZ7qGjy
         CciVAl/A8NRB5X+1T4Z/BKfrIMdsbCRWQ03tX1uCaVBHwhwCkZ3TY4BvBz6JHZwwpyJw
         d1HzCzX6O689DcFlmtQdjUHsUqr52zPH/aONcANMhw8hnTVohshmmDRDQ4dk8pk/rYXH
         M+FMHNrY5DGYZN7Lt9zpgpXaboF5NS1DRO26clH9FnJSTtEdeSUF/LYjYUfCiE4LNCCg
         TA5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nHf7ewKIvjFAQY+SwKwD2ieS2KMakvsPBn5fagwH7HQ=;
        b=TBPF1qc33PxyT/Ura3zw4q32CyHFlsBLUh0yUxKuQisW08ksofigdwLAweplGMi16K
         W2jAd7+fqPqTKXpctS2jpgWdAGqjxqJV1aPfSiv5H1CQkk5ehONiYJFoc22EgHt74u4G
         CtenoOsbboNSSawjAyaCD6sPeworNpsO9jicRu5DMRGD334fMhwS6rP7OO/RLYCfm/lR
         0t//kmQ/xPc3yPQ0iPstBa40jizxJ7vM7xvAApFhVRNQiAi24x/51T3Ho9eGvkJlfRdL
         fwpHWz7YhaNwnNLaXkY1WIexUnoCzExdlxuV1Kgspubqr6QFI8/GBOh9HCD/7IajgcPg
         ZLPw==
X-Gm-Message-State: AOAM531y/WwaeqGgunGQczXUqwyY6OAZOyJm5CGGbeF8yBBL1xskOd2I
        +Za6+m4H0TepzescEW5zQsk=
X-Google-Smtp-Source: ABdhPJy/OKiWcTmzVF5ASf5NtoFX/Spcx2LD92jNLiFc9BIwc58mCzMXGEc7AFLcRxHo+XsTeLvl6Q==
X-Received: by 2002:a05:6830:130f:: with SMTP id p15mr297608otq.109.1630619513986;
        Thu, 02 Sep 2021 14:51:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x8sm610339ooq.41.2021.09.02.14.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:51:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Sep 2021 14:51:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/11] 5.14.1-rc1 review
Message-ID: <20210902215152.GG4158230@roeck-us.net>
References: <20210901122249.520249736@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122249.520249736@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 02:29:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 479 pass: 479 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
