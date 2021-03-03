Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9349832C836
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377022AbhCDAe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387971AbhCCUG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 15:06:29 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC7AC061756;
        Wed,  3 Mar 2021 12:05:47 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id u3so6643195otg.13;
        Wed, 03 Mar 2021 12:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bWNiIOrLrckPN7TRLZRMQPTLnZemI7fpr4pMOhC0Kjg=;
        b=brW4zcmsiDUnxnneQer9m88p72h28nBFcCgkK/A/1CV75f3Ha5T1FLqu4CgOYJP9Kc
         pNDCf9vsWJFawlgtvc8jJ07BioXV+0BjJ5Mn+JdeiuEcR4fWxtLUgUnuaaLqQY78g1lV
         hZVTlIlMOER9cS3SPowYogc7l/u9ZZGiOGXPrtz7OoWjDJ0mWK8dDQNlTXdaGXRoAGXP
         LAnCGKleCG+L4d8a7N3nJ1aJxHtjEqmdfo3ihJdV+drQvNeorW93llaK1qIucC/33Irf
         da6t17T7UkPYtW6K1f4l1FvjBnSN1yuRSD0uEiW4hcpZf12y+4F5FP/zDliwws7whQ+w
         1y6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=bWNiIOrLrckPN7TRLZRMQPTLnZemI7fpr4pMOhC0Kjg=;
        b=toeu+kGRV4X06HRqXB4WbPaB/6ByrPaAhXOnPWg5fDTTLCdmRgo0vJSxrPri6K5ft8
         gQeEe8QM9zSzbqnWJ3PPBJVN5CUoUTIHC6WSVe7zynUfKlpis2gJjjvQlg5cYFP5Bha+
         fPH27xdWa2B3x2OlZ0n4vXgVAqkV8i6GJzewRuTOz4iULdLutB7UxdHWmkv4WzCwUqLy
         fp0GvzHIoXwETC5STUqHhyvCsU7uk6Sx6mtiJZJgP6EbvGqnr6WLo38QxD0/MAkRMH8W
         /a74GOLJePGWA7T2V0NSBJnHcpyN8ImaQeG9A1hr6awotF+maBa9kaC++E6nKjBTKhDo
         SC9A==
X-Gm-Message-State: AOAM531WI/Ksj+vSkG2PBBBqfZbnmQt8gn/7K+EL+gap0BB/XebFw+Hq
        E/JfgTNFTbhE6ClTTT05b3M=
X-Google-Smtp-Source: ABdhPJw659+sCnJZj7AVZD8bOwCEU8PUXgtfU0xJeSdM2VvapjCA9IDiSeGzHuuGpr2C9jnVUW+qhQ==
X-Received: by 2002:a9d:5551:: with SMTP id h17mr624941oti.15.1614801946475;
        Wed, 03 Mar 2021 12:05:46 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w7sm4894677oie.7.2021.03.03.12.05.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Mar 2021 12:05:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Mar 2021 12:05:43 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/92] 4.4.259-rc2 review
Message-ID: <20210303200543.GA33580@roeck-us.net>
References: <20210302192525.276142994@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302192525.276142994@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 08:27:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.259 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 329 pass: 329 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
