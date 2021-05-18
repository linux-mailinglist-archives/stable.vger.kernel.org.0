Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E33E388205
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 23:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352461AbhERVUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 17:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352450AbhERVUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 17:20:46 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38042C061573;
        Tue, 18 May 2021 14:19:28 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id i67so10788871qkc.4;
        Tue, 18 May 2021 14:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0R5SjlYotc4Ev8QR4+EtHHsmNndPhfUYBJe0q+UU24U=;
        b=O2mJ2alKdd20CA1j34ZDCY1rYHnEWJwvPk6THNvcdJ1xBtRO9GhU7a9+sfpJSvenG1
         qtCTdbHj0vzN0kyLsp9PvxplQroP6E5vLZRrAG3O/E8RzSt8SDlHYxaktp7G1k419cdD
         qy0UHc1zTkjWF1Uvnh60uvZPTWSsjOoTWflix1Wl4U+Bwvz2JBvQ3cDONu9axG5He158
         s7Te26QohQHRAI2aFb4VkXBroxFw0KJN6P3CaNeQUF2u/U19ZoRut8DJ5Kil+AYN2QUS
         U+SnMFKQLomsP6wuFQwme3HmWN+S0tlRwc7lDWRKesIHyupbl63bI/Xwd5f5IufcaQpH
         N7Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0R5SjlYotc4Ev8QR4+EtHHsmNndPhfUYBJe0q+UU24U=;
        b=B+Us1Rd6Lyv/uQ5Cg2vr6D1HCCiPXlLV2UgUFINpBCScFUb746SJguV/SkFWB1JI/0
         vosuxNMpsRuzVE/JRnmYj2zty+TuTzmechMycbQw12rtZDohYszmOk4QhER5IfaUJLW6
         bgZSh4uH6UV8VEMEbMS3IFlMeeCJwBT4qx43FoLyxWn4v59r8H7D/hIcAZflG0kL+43N
         cIPOGPQgljcDCdN7y56Rrq1EvaCjafA+GZ51cuERxsAvxHN5D8YcAyZXq6NYKKZ9jYjL
         E2TJWxJZy32RtdGLkPJq6K8E0JmyxvChldTUZ+/4ch0Wooa7bhQ5FfRQLNB+4Mjgr0LM
         8M8Q==
X-Gm-Message-State: AOAM53109tDwQb9ySBclKCJgTVgLnwDYqJqw4MOosqYp32oJFGYllFGW
        tYqLu+63TOj10zLLr5fVC9Y=
X-Google-Smtp-Source: ABdhPJz2Z30lYxJ8I9vG9g+MU/DCX3ixrza5Ze0tn1wADWIo8APmR2X5HOhod7SADH1q09cWXL7e5A==
X-Received: by 2002:a05:620a:2ec:: with SMTP id a12mr7358049qko.92.1621372767518;
        Tue, 18 May 2021 14:19:27 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h14sm4696220qto.58.2021.05.18.14.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 14:19:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 18 May 2021 14:19:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/289] 5.10.38-rc1 review
Message-ID: <20210518211925.GB3533378@roeck-us.net>
References: <20210517140305.140529752@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 03:58:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.38 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
