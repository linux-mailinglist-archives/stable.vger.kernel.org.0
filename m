Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7C9374D04
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 03:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhEFBr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 21:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhEFBr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 21:47:56 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DD7C061574;
        Wed,  5 May 2021 18:46:59 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id u25-20020a0568302319b02902ac3d54c25eso3562064ote.1;
        Wed, 05 May 2021 18:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z0kQbsf6JHtFPCC/U+X5ibHZaLwDuVRZ55PNlj5+UEU=;
        b=JcI+MCu0ucR7bNAqgqeYpJwKNE72iylf3tD+e9Ld2jWrb4lr0yKuyRSnuXqK1UeoAy
         LvpbSeZOaEu1/kmcRb69+azZMF+QMw9T/aYxhFq8SGldbTVm0+ZxplA0r9+0ueMUwm3Q
         DIbxap6pvooFdCe/5H7jR1X0hGFUfjcNYA1o2sAkdWpVJSgiHL2AuqLyT/rvXYT9Kp3g
         7p+1ByFAlkAaxvFhCp0AzW48TOJD72FYAzxug7YUjctWiyKE07eJHT/KIEgAIc9vCxAX
         IdZJOutFbtTKrRkGYEjr1JDfVhDKg9eXO3wBZumxS7jIFJTIbBPRXyIMryVRcSjUh/u/
         vMxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Z0kQbsf6JHtFPCC/U+X5ibHZaLwDuVRZ55PNlj5+UEU=;
        b=IoXjTRyQNg35WDYVFIgX+3xWtPKigyFGwxKh5VQX7iG2idhvIYVbluRfMQv/TaVX+r
         x2Yu0tBfTy3+mvJQvnvjPH4HgMgbjxkNrHPZjet0BuDGl2bVAsWKMEY6Zd0nDiV5vZZR
         STcwqbNArE+a7A7EV7PJYbGOzbDUh/Gt8N5UzFtNwF1wBS5+pX7AklOPX5H9zDgyYgGC
         umEoSnoPes9HL48D+EeOIiCOe5O8xR2fMaQMOo+wjT7VjGdWNyjgJZGMY2MuXP16FCtO
         yfOgqB2W7Aa+cX+Zmmmd9Tomb4KHybpLr97f1YX5mR5HqXRLSllDEdfySHkMhwG7ACce
         6Txw==
X-Gm-Message-State: AOAM530OPaP4XHR8lWKcM0Rd+cGYo5K+6l5gxJu3J04Ks8HOdzarFSnz
        oSP5/nmD6/vaDzOFgjdqdP5BjTS09Ls=
X-Google-Smtp-Source: ABdhPJzQh1WD2j46HJTcFdI3YAB0vgvbdGq4oDSb0xsCgq2qGn21kHRZYzNLgdCJT7JMQ0SCIxI/Ew==
X-Received: by 2002:a05:6830:1b61:: with SMTP id d1mr1310826ote.171.1620265618579;
        Wed, 05 May 2021 18:46:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i130sm186088oif.49.2021.05.05.18.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 18:46:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 May 2021 18:46:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/15] 4.19.190-rc1 review
Message-ID: <20210506014656.GA731872@roeck-us.net>
References: <20210505120503.781531508@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505120503.781531508@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 05, 2021 at 02:05:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.190 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 May 2021 12:04:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
