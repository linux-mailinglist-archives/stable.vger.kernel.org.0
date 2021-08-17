Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEE13EF2A2
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 21:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhHQT3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 15:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhHQT3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 15:29:12 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5DCC061764;
        Tue, 17 Aug 2021 12:28:38 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id o20so662513oiw.12;
        Tue, 17 Aug 2021 12:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tOwK4dq0zqDwvAzYUWQQN6opeKL125hWSKESXmqgBZU=;
        b=OPg+mOTSiFGej7pZAqUqyrCRbzACbBvcGNM/Mx55US6jGVUx02e1TPzdd6D4g1yf8+
         vZHz8mRibu9N5VGjvw56rQX1XhgKWLQTM4Udr0iqZwqJtcwN1bS0tJ/6ri7bCZW0OQBQ
         /Tt6nAIsM1NCK7sRLJ2KtS+oTdGNY6900jN+yujO1B0FGuKeIAnRG2URUArNRCJkS42S
         qd88LQA6bJBDSnPg2lvIBIGLqU3xJSIO66qC7QwHiCzjA7RtsZC+eKhvUNlJFKvz3VIn
         eQGuMvCY5n0UvuBV2WBkYRANqvdgfpUqNnqmB6f7Fq8oIocTbW7lq2Q6EIlCGbUfq3bc
         o6kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tOwK4dq0zqDwvAzYUWQQN6opeKL125hWSKESXmqgBZU=;
        b=DqnYr0hPNXHWtc9IJ9uj3JhLZytudLobs22+px/vnkVmDf6aJjKEuOLURyHzS9DWY8
         dGvK/p6aGyH6NeaKuRA3R910qUSBEYogyvudUZNXEeTjB6vXoVNbHglEIo2dHZ9FxnKu
         NelNmmv8AAb+0H1eeVrOybTpk/3s/VVoeBj4WMs0IbcsXc9PK97H+QPY1ivwc9GPMLgq
         fSuUVXsEsAj5sictsRf7CcocRNMoabABhQ8naPNLA4s8lri8/2wQ8EL7U4pmh/3gWFmH
         W5ow7gOzb9g3M1MBk3xk2aUG8A1iG6tgvNd9guNT3JaTeuwadw5uxsFSrYiygs9lBvtY
         TXMg==
X-Gm-Message-State: AOAM532eRJ4RRaMlnyoQ2mKlAZ8rFY/Aclf1pdZ76F96AKTN4t0DUBJb
        ZY/McLZZHmxFOfxoHXVHV9M=
X-Google-Smtp-Source: ABdhPJx0X77sHgO2JiWl6EWbDwkDMeNeVdjaszbQN5gl2SKF6nZKOtioWyBK0dCLvrs0A6RtRyWFnw==
X-Received: by 2002:a05:6808:54f:: with SMTP id i15mr3865787oig.121.1629228518126;
        Tue, 17 Aug 2021 12:28:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n42sm594366ooi.26.2021.08.17.12.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 12:28:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 Aug 2021 12:28:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/98] 5.10.60-rc2 review
Message-ID: <20210817192836.GB412158@roeck-us.net>
References: <20210816171400.936235973@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816171400.936235973@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 07:14:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.60 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 17:13:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
