Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCF148F7E9
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 17:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiAOQjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 11:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiAOQjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 11:39:11 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C49DC061574;
        Sat, 15 Jan 2022 08:39:11 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so14021102otu.10;
        Sat, 15 Jan 2022 08:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/QWsP54Y9fkrWbauwk4YTkhD1HrHaNWXSjSnf8iJWaQ=;
        b=Sb05Q3/FRDqyKcm5UM09vJS5EeiQd2bhOsjGuOTzNRRYganRHUbnnumGkORWZFkhWY
         0c8hlILdo4L33Px5vv447tk8jjWL4CP7Jj2m88TVXIiftquPqTq+NbI6CBmFTT6cXFdG
         6PjcMPKfo+QEcaZ92fk4sWlIR8hDEqmkzKMDohCcPva1JCb62PAgStqxbhB8rHVVWAB5
         Qd+KUWuOTtLb/Fyj2NzdqSAt+1jU9RKtAZ0iiWpOsPV3y7KHDzZikVmXrrLG7cHWKzCf
         uJjmq5ffXeRwZBbwKb5rAkgfEoKI+NcNjrIaAhSzylM+N9GAo5HXt+qGfE9UuI14wTJg
         IFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/QWsP54Y9fkrWbauwk4YTkhD1HrHaNWXSjSnf8iJWaQ=;
        b=RI7lFbqXpb+kze+HJpt2lXHFTTsE4BR0txSRlXSiriSi2pFPy7M+sDPnbWqgv/HZ9K
         pfacToWQyDsY6bOkaJWgG0Z9pMzrlAHi+ESBvwH5z2aVdpfWLeHD3SO/sEJ1Sp7ZNzMz
         MCrcprwFEkWB+THvEvq4YizsQnwMweDswDHRux7l+Y5o3GHjWgZHHGXvEfMcXhTfEGV0
         EcYEgm8gddKJRJRmCnH+XXuBhF1ksh3e3T4ZU9ehmdesf0gKGvJBsBZEwyiBEJ6YG5Pi
         NLOeYUZpqqgmOy6h5HA3tXOCV1epxbTs1ZkVPm7IvvLpu0N10oeng5k7oLyJnuHnXph5
         NtVA==
X-Gm-Message-State: AOAM533m3WpLb7N8Yh6V64jh126Uol9iWP+yl6j3YsVpIHthtbQYt8Mz
        XAcqQ8nEzh2qqv6psqGWXyo=
X-Google-Smtp-Source: ABdhPJzvI7dF8sICaB+Ge8/oZxxcrDNAbj2ocl/NoV3AivOr5wmT2Plf8j+BUKL6ZP7gAxgS+hOfOQ==
X-Received: by 2002:a05:6830:130f:: with SMTP id p15mr1487478otq.141.1642264733725;
        Sat, 15 Jan 2022 08:38:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l18sm1100886oou.20.2022.01.15.08.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Jan 2022 08:38:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 15 Jan 2022 08:38:51 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/18] 5.4.172-rc1 review
Message-ID: <20220115163851.GA1744836@roeck-us.net>
References: <20220114081541.465841464@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 14, 2022 at 09:16:07AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.172 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
