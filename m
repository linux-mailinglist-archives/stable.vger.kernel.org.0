Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88FF3A82BC
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 16:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhFOO17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 10:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhFOO1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 10:27:45 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E4AC06121D;
        Tue, 15 Jun 2021 07:19:23 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id z14-20020a4a984e0000b029024a8c622149so3038261ooi.10;
        Tue, 15 Jun 2021 07:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pm1I8k9SefU3DqP8kezFOcV0X3QL8Xa5A4NHOecAEkM=;
        b=QGntWahpOQCfREmfClvORHEVFd3E3Nj5LP2NN/3/9GVwm6O3NQqw98NyC5wLIRz2EQ
         4POpUQXe3e8uDZDqWt9eNF5ou2nuXQMRVxdyPMNCZeSkroOlirq6/yAgeH/namRChwKT
         wsXd5DkF7FPPCGNgBwn1BTNDKtXlTE7Qo0HliPn8zDoA98pcTVMqoySQAvxQQTqYDGxT
         ZwE9E6QMvxT2Eco4g9doTDE/Uh6jHp7oYiC5q+5w73UotyGK7B2exX4YE5+gdEWAhxB+
         VW1K3z14/TOg9cGtkbjlObNnoDlZR95DiobQdE5IliGEOd8JBdzgkUfbHWxFrbUZ0g6x
         B+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Pm1I8k9SefU3DqP8kezFOcV0X3QL8Xa5A4NHOecAEkM=;
        b=dTLmcyYfdD5w9yVQ/qA+wUzzZTcz/dlqSFzEDjgpBTV8/xGIGDgl+rBONGJTpDWOHR
         EPNZTLCHqA+QP7rHEzqk2fRw2+KUqEScEaD+fGmj3MIbYuOuks+bl7WlRCFjtw+0lDmv
         AkGkr1/+s4VhLICnFoOkrigXUbSw+RDBYY9YepTxOSHnrp42L69mPLalBTxeFpCCuZZa
         bxiB2lumRf1W9iKPXnVEvRZl9CBVq+X5INr9JQzvcpjhiFFLSMQN9y6uUKa+U/8RiZxM
         5N568X/QPjxCVwzvnzWGsPn06/pW2O3+GELZC82G377lrkXH5fc2f1B3nORuHvVEimgw
         7beA==
X-Gm-Message-State: AOAM531uhYBs1Q2tYz2FPNufoJSWk6QxunQs5s9+EVq0k8Hdlmh4IaC4
        FcQzQxN9ekxSemm78/0R0OI=
X-Google-Smtp-Source: ABdhPJyjyJWxe+U7mQzWXlw/d7Sf6vmwpXYZ9mKqGQBAbV2uzozoHMnOLOLkEkp7imqw4l2TD1MneA==
X-Received: by 2002:a4a:8802:: with SMTP id d2mr15872083ooi.28.1623766762796;
        Tue, 15 Jun 2021 07:19:22 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y66sm3799331ooa.48.2021.06.15.07.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:19:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Jun 2021 07:19:21 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/34] 4.4.273-rc1 review
Message-ID: <20210615141921.GA958005@roeck-us.net>
References: <20210614102641.582612289@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 12:26:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.273 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 326 pass: 326 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
