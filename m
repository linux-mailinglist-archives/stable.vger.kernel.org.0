Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F754364F63
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 02:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhDTAS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 20:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbhDTASz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 20:18:55 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529FBC06174A;
        Mon, 19 Apr 2021 17:18:24 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id o13-20020a9d404d0000b029028e0a0ae6b4so15268786oti.10;
        Mon, 19 Apr 2021 17:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fP3aa6c5tIgwFmEx8ak6noxZ6ifeoBFJ+haYU+phzpY=;
        b=sniyFxZ8Eru1SuAp0l95bQxJLZtphlBLnYCJyiLXe6WXSuqhABFfP/b5atSWIhmeSg
         /KgXUd5VYh3oyAPry9dGoN0FfeFH0gae5MIq4hVADNbkSaJNYCV/QXKASJpTd1RMco4Q
         mgYpZiLkGUATmqrB0YMTgybowDfBSEEM08q422I2nMJL+iQ57UnGd7vWoZ7RyuCmrZdz
         MBYnpw8X1Uq24GCEDHx1I9v4ppbXU0MYXxcN+avV0kttGUrKyB2EnG4Dwk5trecVMzfS
         +gW22i9SLvmhieFVI1v+519SyOQp2AdAro4YFYcb58Le57TQmy0fDNO6xoP770/E9smE
         e5fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=fP3aa6c5tIgwFmEx8ak6noxZ6ifeoBFJ+haYU+phzpY=;
        b=ln6jKbvYhQNnUndYQdY6Ci//pzl8nVgTU3xpp2iRy9+OXW1vbCBOnJTQ+KlmxOgPyk
         cSm92veXCLj2v6ZbpMhU581XasMCvDHvarI/vkHsKRhmG0B3dQZ6snfQUUDrhHpmPCtH
         QsySyUDuU/mTLfA9hHhUqFBZsCNGwORlQJrMo2nxnqiOslbm3vLSGaj24AqJXGvkJ/zV
         hb2aIxY9/GI47hJRVG79M6QeD1l8XG2FiiSCtscnYOgOQKiuLDgzsn1cnwYYWFI/8RCR
         /7Gf39EDVqyoJzqaKulQhRArsV40yzAmONw9pzIAEoyoaftgwNrf4rL2rUIzLWOvVCAu
         i/vQ==
X-Gm-Message-State: AOAM531m0McuYZ28UL3BEj7k/TB8PwyxVG0MlEhYv6TyEMO5hT7PzG5Y
        jf8tA499REp6YmHXxbjCsYM=
X-Google-Smtp-Source: ABdhPJzcaTvUVzz7bcFmkqGlJUjab5PcSkC45gei+2yAE+Q7UoBlkEZk2Bchua+mviGmTZ36eH8xlA==
X-Received: by 2002:a05:6830:1e3a:: with SMTP id t26mr3729606otr.134.1618877903823;
        Mon, 19 Apr 2021 17:18:23 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c7sm3203784oot.42.2021.04.19.17.18.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Apr 2021 17:18:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 19 Apr 2021 17:18:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/122] 5.11.16-rc1 review
Message-ID: <20210420001822.GB218430@roeck-us.net>
References: <20210419130530.166331793@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 03:04:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.16 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 461 pass: 461 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
