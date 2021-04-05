Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534D3354654
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhDER4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 13:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhDER4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 13:56:39 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D638C061756;
        Mon,  5 Apr 2021 10:56:31 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id i20-20020a4a8d940000b02901bc71746525so3048948ook.2;
        Mon, 05 Apr 2021 10:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TKrBbC33rTAg20tbUtTeyG0qCz7Kga/JcPNviUVOWes=;
        b=iBdbeUT7BxKPqLQlx7dSYV1n7PxlsI9RT7GKAy6nyM1iNTvw0/3m6Bfxv6PxPLLIhO
         sOeom9+hK/iapXrAvx9WI+9EXmSTagAZC7YhGwqUzG0SfPTdZHglGSGcX8W7jQ7OHbyY
         +QnyqNKuSTKyI8oAjxvqZoU+KDvDYoIO1skw1q5oygyb0Jfh0XlCJioKqS1xZiBdutbN
         WYMpHG7i25hLOYRp4SUUaMhY/xvNypdxyaKS9Ns7fsCBAOU/KgfwKdy1uNrK5JwKlddd
         S5oGs2TuuDCPNJsmoR9aEiusdyXEwxVd3DidYzh03PzQN6huB375z8uicvcEtm4yYRyh
         coOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=TKrBbC33rTAg20tbUtTeyG0qCz7Kga/JcPNviUVOWes=;
        b=lXy2E6LWi7734403EZxe+kDRCPwq6Arvx8uh1J/uubhrZ4eWK5E9RzZa8BrM2W1/UB
         U5KHgwHhx54kMrwZcRu2nT7QA/6TNuhncAaKa3VEe6KIzqSTWw+rkJb/iCIFjc1JZgFp
         9/m/XQy7i/PN8kfXx88Ie5rJDdO//bwQOA7GXGFqWxQsF31mT7q9r2zxszIW0lASsRc3
         pzPKJhUSt8/7vJk8qrcWbjNUH6L0YKKgf7PQJ51NGYjaCPcpiAIz7CwV3EIWFMihCKxR
         97MGn7itJ+2DBB9ofG0QVJO26pvPCzfb9eWsej5yYJailRo1VHLo4cHJzn6/uJPdadwH
         rSWQ==
X-Gm-Message-State: AOAM532xnql8+O7ShZINXu31Z/HjgRxUf7VO9Yu2mxmg+A1KqHj7Y+mw
        +ZtKzo+DSSlaKp3NHfUYCjo=
X-Google-Smtp-Source: ABdhPJyZL2lIR9h1oinIX35CNzaSda5DMdAFRNKy88RUkqf90niqT2JDb48ckdDfX7KxO7cFPI2ShA==
X-Received: by 2002:a4a:e8d1:: with SMTP id h17mr23048144ooe.20.1617645390947;
        Mon, 05 Apr 2021 10:56:30 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f192sm3205673oig.48.2021.04.05.10.56.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Apr 2021 10:56:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Apr 2021 10:56:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/35] 4.9.265-rc1 review
Message-ID: <20210405175629.GB93485@roeck-us.net>
References: <20210405085018.871387942@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 10:53:35AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.265 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 383 pass: 382 fail: 1
Failed tests:
	parisc:generic-32bit_defconfig:smp:net,pcnet:scsi[53C895A]:rootfs

In the failing test, the network interfcace instantiates but fails to get
an IP address. This is not a new problem but a new test. For some reason
it only happens with this specific network interface, this specific SCSI
controller, and with v4.9.y. No reason for concern; I'll try to track down
what is going on.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
