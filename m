Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB0C49459E
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 02:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358052AbiATBsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 20:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbiATBsa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 20:48:30 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FFCC061574;
        Wed, 19 Jan 2022 17:48:29 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id l64-20020a9d1b46000000b005983a0a8aaaso5745723otl.3;
        Wed, 19 Jan 2022 17:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=74BtsnIM1Do25h2pr2aLjfS1D1bQFN2QCAj85PkHcLY=;
        b=jYwP8I98dCQc3Hy7BY86CiJtgViUfob9Mo83VzbMTUlHoCn90o9woIahLEvs1LSRk/
         98dXSUUPptIJBuXGfwqy301bAFTTZMNzCKZ1ggG0V+291lGMOjSjLdXyxMbM2l4fZ9IQ
         NM+i6Oh6Q4ykJSIl+7mhWpB/PXPJvGCHThL3tE9utpytBQSass3SuJ1sIpX4sBpCGZNd
         AbdqCRsZykw5UzDuaAictBvGh2rJdYfQh6cSw2nhc/rtE3KGmZqeKO4fRbSHMMNS2a+p
         X/mqVacmBH/tqiTPxEYNhYA4pQTBAexAUKTcdJDDwXL4H7IXBsZ0lm2Tr39K6PmqSMiD
         Zvlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=74BtsnIM1Do25h2pr2aLjfS1D1bQFN2QCAj85PkHcLY=;
        b=BXAIAeMVQgKJCtgAdGcqiW5FM1xe+/8FI1/bLP6khTPJLpu4Y83wNHS1Im7H+WaWjR
         o2r0khnfT1Ka4Od7OcNqCbp/MccIWHp+lOQCUTvxWBeis4RNmth57IecfTkKKcVtIKp+
         dwOfBOwq3erV7iWRqfPn+6JLZibV0BA1pH+2EUL0l/LQzpBCy3xrsDtzXxmZfd4DuXI/
         bu9TZAyFnxGTzeY7a3Sh70NVRxFxmG9wiA830hJEfXYX+bxlGKtE3L0UELLxkFtld/IK
         KAaAaMqhK7GnqDtO+6Y161GBalNzXwfE5ny3BiBLgx7QfzfM81RXkhe94KkutP5QliqF
         zEtw==
X-Gm-Message-State: AOAM533gl7Ndsy2RBRT4xk1ilkAWjbRyWXEdvUZIW7wCQbu8FRvQVIEC
        pxvqRHwvO3kQK0p84OlJu33SFaGjEkI=
X-Google-Smtp-Source: ABdhPJzBOHTPjdJOReTPvrB6BaQEX4vRputs7UOtOtZ4L6lalloVBABvkOU9HpXjIWGnPvdwXM12KQ==
X-Received: by 2002:a9d:483:: with SMTP id 3mr26836530otm.214.1642643308799;
        Wed, 19 Jan 2022 17:48:28 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w14sm651954ooq.37.2022.01.19.17.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 17:48:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 19 Jan 2022 17:48:26 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/28] 5.15.16-rc1 review
Message-ID: <20220120014826.GA3476209@roeck-us.net>
References: <20220118160451.879092022@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 05:05:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
