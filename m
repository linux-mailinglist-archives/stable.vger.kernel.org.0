Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB5449D4FD
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 23:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiAZWIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 17:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiAZWIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 17:08:48 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99A5C06161C;
        Wed, 26 Jan 2022 14:08:47 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id s127so2372381oig.2;
        Wed, 26 Jan 2022 14:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xumldFik6lK467rgXLXP3gTJKxVwIW2Yul3Wy7uS6Pg=;
        b=CMXejQuo7d/UY5Q3hU/zN3tVn/TNj2nwmMi4OQnDdPNUIejThqT4ALcLtQwVbyEruV
         HRdh/Kda7Znbe/n7ir2ku/4zZ7mEgvz4WqIq+jcX5ImxoV9SUrijYt4Tmfu6vvbhqlgo
         olopVNLJbpH7MJSGpswKk5F9WPyOyl+fhXDqKUaNSgrG6bqSqek5vAxM7iNNcsqBpcq1
         lq9R1FypbobbnucZQpj4iSlG8LTSIz+BPCy3G14LKOaWVR+01D96e18hgJQaH4mdjM9w
         Z6R/0e0tmlSqxRW0amr9NLmx0iUWQjv+Wr9O7PACAM9aDAkYarl61YUakoHyf9/qlPYK
         pVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xumldFik6lK467rgXLXP3gTJKxVwIW2Yul3Wy7uS6Pg=;
        b=NqTbwRrnX4m0OWIvaSAiCcj7ys8Qq2yFuCS20yE6XoHxVCJvPAuaal6ThMnof/CXUq
         /f/4r7ViDKEZ/7RgDDtzv1YSSKhvC71ESM9yD+vX0m5wt8Ro1BEbPAGl6upgw0D3pcw+
         sQZaRjgEYegGnFXIURj7ydfqZ4ZnnALOZtVLUtGyDtiuMOJG8YpMWBCnZyZbSq3T8aqg
         QcMmNBrwJkzcjH04PjdcoDrI69mHtkpRgayBU0STyX9+PMZuUZX8hVLUTGcB+cBU3Q0t
         /cYyc4xIaSNxjr9wDeH8hbKBLt758NbnAZpQHfnlCF8Jc5ypBKqStBNozFtzFoM5+tLK
         TzqA==
X-Gm-Message-State: AOAM530LlIafZ2Hpr2WX0NwDAcshrqTc0kewJl0AyUSILIShBMtdqKMN
        MJOOPeAbA/0vYlIZtugbJx8=
X-Google-Smtp-Source: ABdhPJzkmQoLhE50GHRjX2obxYd19PprL5+VHlPmAjzBAyi9eWO1h6UTaMa9zgnKe/JXpvANUD/bQg==
X-Received: by 2002:a05:6808:211f:: with SMTP id r31mr503662oiw.194.1643234927126;
        Wed, 26 Jan 2022 14:08:47 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q18sm1557388otf.54.2022.01.26.14.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:08:46 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 26 Jan 2022 14:08:45 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/239] 4.19.226-rc1 review
Message-ID: <20220126220845.GD3650318@roeck-us.net>
References: <20220124183943.102762895@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 07:40:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.226 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
