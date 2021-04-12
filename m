Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6084135D2E2
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 00:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241414AbhDLWIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 18:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbhDLWIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 18:08:24 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DF2C061574;
        Mon, 12 Apr 2021 15:08:05 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id m13so14980480oiw.13;
        Mon, 12 Apr 2021 15:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Bs7oGhZYNIp+zEwmgr9ynjMvjH0MLJ1ZqnuYg4WmIJ8=;
        b=PARcm/azKGfkoj7p3NZu85qQ9muAq0T0xujJ3d+n2BVVyz9BsDNu6dQNv4wIOx1Bxn
         8ajZrQvcrnmpdLsgpHqyrqjP8inyFo/YXrU4P2Pn/PsUA2RVtX3rdEhObC8neLuMpakd
         ASmxIkUbCYdvoziipNRacPBRVKcPQt45OQN+Hrk/fq+y2OWarbnBXAxKXmR+f/Krx3oe
         V9GbTEIpZB865ope4sxdt3MUYqHL0wdNqbSDlZfFclsXZvbJOdMVkHFLR/Z+ySv1fjI5
         ACBeeNrNh5uKNCxNn3gRgmBHs6QRDUwEKxApuxlbWzW4DOsjD7DRfNOj/+NINyMJ6Wbx
         7KZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bs7oGhZYNIp+zEwmgr9ynjMvjH0MLJ1ZqnuYg4WmIJ8=;
        b=pXu3BunfxSlhgXODrVP/6rGcLHl3amq5C854Ls+xYf4SX/Rc1zpr/s9xkg80g5OJhG
         PQA+cpsETjASSXO/ije7grQE2oMEQadA9gu0tDutAKrh23DgEA2hcqZe9a3LScx7IXCT
         Wj6EqX0bgpF2vJanmUdL/Ggu4RDmtGjvxmOXx4eyDbnqT/O3YQ4q+2eOZsk3rgUQ72Mk
         grFRxCcMQyfeGMecs3yXGFyf89XcjLW6lqAZWDyHuTOgl9Uk+xbPF9jRv/5ZSgKuGyU0
         Akj4lYNAUCJ95cyWlwrX0e7FEPAAJFyqfhuFes2W9aXAAaG89a8tu2fk1cHgT7hfQGK1
         X6Ig==
X-Gm-Message-State: AOAM53117uQs8Ti4JRqcxsOorn9h4CdGuXnhnIGwd4grsZp+BiqbHgqT
        Z6UIjTy5QUXFbybtkDWsrgk=
X-Google-Smtp-Source: ABdhPJz7EOMv6wrNRhZ1ra0k5PDPHXms+H3OZFeZzaz7xwpm3RAD3Sa5vU6YclTWp7cINyqeyy5SHw==
X-Received: by 2002:aca:1e16:: with SMTP id m22mr983442oic.153.1618265285086;
        Mon, 12 Apr 2021 15:08:05 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x20sm2456652oiv.35.2021.04.12.15.08.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 12 Apr 2021 15:08:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Apr 2021 15:08:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/66] 4.19.187-rc1 review
Message-ID: <20210412220802.GA182151@roeck-us.net>
References: <20210412083958.129944265@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 10:40:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.187 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
