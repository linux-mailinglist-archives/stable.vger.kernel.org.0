Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F9D47C985
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 00:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhLUXMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 18:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234684AbhLUXMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 18:12:07 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA0AC061574;
        Tue, 21 Dec 2021 15:12:07 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id v22-20020a9d4e96000000b005799790cf0bso437811otk.5;
        Tue, 21 Dec 2021 15:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=coYrJea5ZwdZvQ1ADJgzRaDy/prrYZ2/USFGOsX/kPE=;
        b=fOjrwqap5XHB4jWrJ72ghiOu036pk/+CcBzk5jH+sW/XTiF9Gk7oEaTQgRiFOR1dVg
         zFgoff2Z8/5g4DsBWyJOdVsgUA990NZpT2oo6spIj6WGDFvS1wKeUnpg14ckmS08deAe
         jKr1xVZuozrITGN5ovSmCNUkkaorLrdcslMsaE/QnfvHCniJ9Y9u+wuf/CP3/JwwsdsK
         STE7k8AHKNu4oFmo66f/VH5+3SMUxJucPCy09Ld84AzNDI2keTS0qGfY1o5dnphP3bfC
         Yc1UlxKyDbqn9a1BIOrzuqj2uWaIMsfZTMsv1rvd4FvEfTIxYZp0WvMT7fwhrL8dNQbv
         krnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=coYrJea5ZwdZvQ1ADJgzRaDy/prrYZ2/USFGOsX/kPE=;
        b=UXVc0SXfEqValPRm302JGfOHxnyjXUmnTWj8oWmL1xVZ8l3B2BvMjlRbbrGD9Mz2jP
         IwQqp++0HLF6/Vr+cliFFuQDbd16IP6pB+Bk9hDORxRx0Nz0jmmpq+hnls/yp20Mji0l
         Hlzp6ufAbIS6K0ungIbLLoW7Ntgb7QMj5pbGGRkoVGkNZGcyM5eTTmZzVGNly9TmjGdQ
         afAXefTZEkYavFDIVy797g4qiOI5/ruf4kntgK1yz7mbwpfLH1SD760qEadKK2oYtBjL
         IlPiM0OH7BL9LKWdas+qblgzGjQiqbsCqPyoOzB2jUNL+xaf0SZXp3n4MsUVD1Tr2Kb4
         SRcQ==
X-Gm-Message-State: AOAM5300wEgYriIQSEzm6i64LjmeryeRSVHoIlcuo6gcJLkc36Zeh0dp
        mAbNBkP55XXeUI3sTEsOCSA=
X-Google-Smtp-Source: ABdhPJyisKdSmV0kpWMLRQj/rcJV8mJSp7Ex1v/o0Ku4BQSGOyi2LEM+0CbQndMqH/n8yLTBV98MtA==
X-Received: by 2002:a05:6830:1da:: with SMTP id r26mr366945ota.73.1640128326943;
        Tue, 21 Dec 2021 15:12:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g7sm76131oon.27.2021.12.21.15.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 15:12:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 21 Dec 2021 15:12:05 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/31] 4.9.294-rc1 review
Message-ID: <20211221231205.GB2536230@roeck-us.net>
References: <20211220143019.974513085@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 03:34:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.294 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Dec 2021 14:30:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
