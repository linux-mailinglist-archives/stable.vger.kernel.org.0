Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE99440FF04
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 20:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344179AbhIQSJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 14:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245224AbhIQSJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 14:09:19 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B81C061574;
        Fri, 17 Sep 2021 11:07:57 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id b5-20020a4ac285000000b0029038344c3dso3469841ooq.8;
        Fri, 17 Sep 2021 11:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v1TrtN+VEt9yFDA9ecCzlnFsvZMVzTwgDYp+aiXBr/E=;
        b=B6ZEi4wF8Hak8koNerrYNOA4VDOXJefJtpvnPLvJKhVlDoCWXvHq0MKIyu/Yyy//oV
         1GRmNKGrxkQ5SLoofxRvqxwe2IgYU0v+CRz2CQY5i4jaQnK4RgBNPIdAVRJ/lOop0I4L
         ZA8Q7SeQj1fQSSwkmHRY6luiCkLCKOnrUd+xtVo1+DVviKAc2+JD1kcNoJVNuPqP1omE
         /QE8lWaxrJe37wzZeFxezl5K3zVRf3l9fPRpEM9eOX5slhyPuF26qAVIpJJx34ilw5Ma
         hgBSzKZdBWqTvZ62U/ynBoX2iRY+CpkjXQYYLiMxAi9HgDkIA5dL+qlAjbYi6BIf/aXO
         9eeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=v1TrtN+VEt9yFDA9ecCzlnFsvZMVzTwgDYp+aiXBr/E=;
        b=Fl1SvsFWzr1F+/msqeyozSclSYMc9YRloklFhatnkv0kyf5qHbNkEQ3qTd83dTmwEJ
         g8CdBGwsHuCrtO52iKJHcllQCQcYWZUtIfUgB6ayYypch2vYGy22+kDhwf/4nOnwOk/9
         L+j73jnSdKAx1xn5v+gIW1SLJ7mFFc+Jno0Nuz+7Z+A7GW+eEXPYR05GLNt8ESoP+ZYy
         9xqqiTvOFSUDwyXfLzLFxDONo8xMH4h+WzTT7dX0moxlT2IkwGxq2+J5mkJNhQhLMnaA
         C/EmmtJFl7s6xOFo9L6xK4+tc426IAluc7J0tdlbllQnCLMZF3aVIlol5kWQdo3Hmsga
         /d3w==
X-Gm-Message-State: AOAM531gKXc9FB1EiKjWN4V9BQJcb4f837GizKeQQSKFTlXcvLsN9Pfd
        MIoQILNStazLtwDUpqjq9c0=
X-Google-Smtp-Source: ABdhPJwBUHz5ES5dTYBUVnrfDJgtt6nRDPWZcTMUx0VrLpsXphaT0iUPOkmj8zuDMSDZmK1BSDY1kQ==
X-Received: by 2002:a4a:a40c:: with SMTP id v12mr9896226ool.72.1631902077015;
        Fri, 17 Sep 2021 11:07:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u15sm1606136oor.34.2021.09.17.11.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 11:07:56 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 17 Sep 2021 11:07:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/380] 5.13.19-rc1 review
Message-ID: <20210917180755.GA4153060@roeck-us.net>
References: <20210916155803.966362085@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 05:55:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.19 release.
> There are 380 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
