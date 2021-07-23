Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DA13D420A
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 23:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhGWUhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 16:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbhGWUhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 16:37:07 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34261C061575;
        Fri, 23 Jul 2021 14:17:40 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id v8-20020a0568301bc8b02904d5b4e5ca3aso2522984ota.13;
        Fri, 23 Jul 2021 14:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wwRorxmkc6V5sKfZMzv/gTJDyc1IT9jcOqVGQJANDbQ=;
        b=GA+/lQXRhz7Bxb4SKK6UQ8V3OBmYNgrsa/60LEZJ/SYifMfoo+qdGLXi+obu5LKFjD
         i5siw7KuN5I7QJ6bJFG9b0cJb1PZNt5zXQyn/n93NU8X4NMkEiH8VPl5FMb0h1vuYAh3
         bo08qxXxYJDENGFsuDY/IeeM+UMoa3A264HQ9dlcyss8X66aDyiKFeNlpVK2G4WxUn9m
         De76mvpJY+VOhWKsXd8JfRPRp7QT8e8d0P97/RyGbDQIvlUjIqA2H6/lffinlUPwVLbp
         w3/u036trDY3mC7Q0hx6oH74Y0wO3MsiPLrHkq8+8ukL6V28CuZj7efRdZPKIoTJcHKp
         MVww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wwRorxmkc6V5sKfZMzv/gTJDyc1IT9jcOqVGQJANDbQ=;
        b=WvIj6agVU7tOyyH9nIx9ds/g5XNWuutyfMPcF+k8lxsyJfj4alNq16/Bsz4o5fkdak
         BLpI2Oj3edypDoQHWQ7BgQQTuiGbZFrl8RXXyCvh8rHWlanz3OY5wtcZUgWq5kZ9/RgK
         fwcGYHeR6AHmhsn2QCmGp4oqifakucwGInT+1pIMpFMp8+f4mHxco9f+F/95YYJ/MiCJ
         IxdsicD2Zz0+ogYypTBGlQfgvgLnXGE2HwL82EjeP7OdadDacg69diJVI7UbAzNLzxqB
         6d4GrxKxWfQsLUe/a2Va2gr3aCNi9nMCfcLbtxR8iLa912KnFiAK6dnl21Rxe3gaqXPw
         AMSA==
X-Gm-Message-State: AOAM532fht2PSW65YzhM0GERpNEpboG3oxjpMjuP7qUuidISv4p5T1MH
        g/khbi5m1gmNsKttg/A1+hc=
X-Google-Smtp-Source: ABdhPJye+EGm+9sIuVRVkVpWBqQpWElX3V94SbVnJczU1KVZALXfmVGnC96Hj222yCCOs6lRUQkuAQ==
X-Received: by 2002:a9d:7a44:: with SMTP id z4mr4308742otm.328.1627075059654;
        Fri, 23 Jul 2021 14:17:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o26sm5980373otk.77.2021.07.23.14.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 14:17:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 23 Jul 2021 14:17:37 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/156] 5.13.5-rc1 review
Message-ID: <20210723211737.GD3652778@roeck-us.net>
References: <20210722155628.371356843@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 06:29:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.5 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 153 fail: 1
Failed builds:
	riscv:allmodconfig
Qemu test results:
	total: 469 pass: 469 fail: 0

riscv:allmodconfig:

cc1: error: '9880' is not a valid offset in '-mstack-protector-guard-offset='

as usual.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
