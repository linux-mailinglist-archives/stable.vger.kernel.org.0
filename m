Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBF438B9C0
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbhETWyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbhETWyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:54:13 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBB1C061574;
        Thu, 20 May 2021 15:52:50 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id j75so17895342oih.10;
        Thu, 20 May 2021 15:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nQQJxE5pyG/Gx9Bcp8GCpgcaurbBPz7jbF3U+OPkZFU=;
        b=pBZLLSLVANY8vFzHQOdfRQKtjUwQz1O/1VgqWgTaae7Qkk5e1d3E1i+ysjPLC1dmPa
         wtQtkrEDf85je5khRGLNYh3SPYxsK4d4P3+t7fVbJNrEYOGowQO7gV/jMdsN1Gowgzsd
         XIGyMmjW2AQYd6Zb6fpnkM1Yas2Gv/a6nr7YdaYpX5BrIyZMFIfYN5V/9shH5XFqKEv/
         jEOIO7s0rPG9dexOmDJeO/4Rhmez3XJIR1Yv+SEA/m6/aTvEg0gk/ZTusxP0oDwHzpJQ
         QoY+62oHYIkll49733OE+XdjFy5J67U+bExkgSF95FywsAxucseunB8xCvp0JNtQ1uqR
         KJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=nQQJxE5pyG/Gx9Bcp8GCpgcaurbBPz7jbF3U+OPkZFU=;
        b=SEbHhb4MhSQFif5X+rn3ReJJ7VH76Jk3Ucm5l1YuHU2+hPp2mhkiTpxMxjrQ7lXllX
         p4XPqqZMuC/wX8j/klWkkS7tTnEkm2GF7m7mzXSqW18aEeNnWQr3U8IDTg2UIR6YSOc4
         RZ5ewmDiprb6mmlifoMrgj2W/3EjTPqCTVz+UmyciNkKkbVO3rLJbmkST8jcfNVkMYFe
         LTIhoe67wqSBOdTYS7XU0GUjNrmbC6MbS6fDlY4Mkhs1WK5gaAFUCburbMP9cFjOLDzL
         wDUkWpAOdnlOrVHVNrzgQyg2HDTcPDYjhkcCVlvMjJoiHWnU7C2vlmxA7+X02H3G1EHt
         t3Uw==
X-Gm-Message-State: AOAM531AbD5jETAgnAa0sbSJ6Qu09cD7Vu3YvDMOOk5LUWJvOJMWqUZm
        +oOowMflqiuAdtjMFwLhSu0=
X-Google-Smtp-Source: ABdhPJx++SHzCNNWJUV1CnX7Sn/fuLbdk2cQT8AE8xAmwhiQunmvmcRwEvT6V39xw1Tqjk1mMJvQ5g==
X-Received: by 2002:a54:4d98:: with SMTP id y24mr4971350oix.18.1621551169735;
        Thu, 20 May 2021 15:52:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a23sm904429otf.47.2021.05.20.15.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:52:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 20 May 2021 15:52:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/323] 4.14.233-rc1 review
Message-ID: <20210520225247.GB2968078@roeck-us.net>
References: <20210520092120.115153432@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 11:18:12AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.233 release.
> There are 323 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
