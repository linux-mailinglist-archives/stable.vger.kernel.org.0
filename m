Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0389C3B7ABD
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 01:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbhF2XpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 19:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbhF2Xo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 19:44:59 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14854C061760;
        Tue, 29 Jun 2021 16:42:31 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id o13-20020a9d404d0000b0290466630039caso674378oti.6;
        Tue, 29 Jun 2021 16:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H2clRbWtY3gLXXS069v0xLGV3qZ8FrOI0O151/krroE=;
        b=qJGxAHfDhtBJ08euBA240m4naufDhTOmca2EzSIN42aZ8m7gq6gEqR/UOg+G2hxVE/
         DfhbhLWfRLP8go7SJlhgkfNbnmkXPQbVKSOsNcd60ZhtF4yRStvBnDw4Q8dWt2F7DCub
         2Kjk4SMrNH5LYv5F5zvisuw25ex1p5HTrJBL9n+gnVs5vM+SNAEzJ8njL+LwxyWEOPKE
         YygfAY27JmtK4eMyNECI05ii2Fy5Co4oV+ntNbXDcKWjnOuHIiZwsDnjsEdrvH9danPS
         ZYh2zfiP+CkwiTbnDLjr+f9wm1zh0exDeIfNnaFjBkyaOmv91S1F4E0paPgnorNH4YU/
         76mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H2clRbWtY3gLXXS069v0xLGV3qZ8FrOI0O151/krroE=;
        b=L9NGJ+XLMc13uH4UvHaF5YKiDR9Pt4ow4e4iHjt2pLW82PnkWrhb90f/5zAU93qmhn
         QPbrP0EMWFdYcc2MBvu5VjDbkXav6RzwgTizfWFZmCpZ1yhtEaSnzAcdYDXNBXsZTIwi
         7COURVCf+Ck6H7nvs5/f0Ct+IASXRHShMh7xgXCgmYJOyLe/XZ4CfaL5oq4hGHY3l6iN
         sOUn6adABA0G1qL/YrEbx+eLB8e8sE+KJChL3WsDd106mN6yjpqysUTfQPc4ebc5SBRF
         vyms3MOHvv1P/XCbNQf1tS8SMB+l6JGBkkEIQRYgDJyeP060ksMYwRtYJNhoN2Hj2VfB
         Ol8A==
X-Gm-Message-State: AOAM530CxrSEapp0vFdPnPLQg1eLXyElA3BeIU5uYRtk6jPbNxGsEwnY
        APSPlfHAcG7OYuBQNrnNOn+f8Hys1C4=
X-Google-Smtp-Source: ABdhPJy4IYjT1pzqrGhJjDT8/AZ4TJ08JJPGOUAqkqFK78bWYxYkuRkKdLKbEe3PnxB8gWcnrY0tzw==
X-Received: by 2002:a05:6830:40b1:: with SMTP id x49mr6497774ott.64.1625010150444;
        Tue, 29 Jun 2021 16:42:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a76sm2166800oii.26.2021.06.29.16.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 16:42:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.4 00/57] 4.4.274-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
References: <20210628144256.34524-1-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <d9f7920c-912f-b3a4-c504-f79209ae006f@roeck-us.net>
Date:   Tue, 29 Jun 2021 16:42:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/28/21 7:41 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.4.274 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:42:54 PM UTC.
> Anything received after that time might be too late.
> 


For v4.4.273-56-gc1d107b:

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 326 pass: 326 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
