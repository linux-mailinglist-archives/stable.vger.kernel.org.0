Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB66038B9BE
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhETWxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhETWxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:53:47 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED52C061574;
        Thu, 20 May 2021 15:52:25 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id u11so17935040oiv.1;
        Thu, 20 May 2021 15:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ITqZjSMiv64nVv4NKU1fnOxnOjYiU89JwcbnlO0Bt3M=;
        b=rNX0+gsPjqOo2vHVRNHCgskgDZYphg5MgQjW9z9UjqpBC0DID6AKkLzOLex28sS1HO
         U38xzmrYzLJAh7fJ/vR3bPBmhJZxs5ZJLe3cmsJnroOsp5VreSwLLhXu21aYC8o3zO+F
         wHFNl5+zzQAB0ex6VknC4hNAVXkp9eJI8S1TzPFsyu7wbin40BfjBMqoIZ1dgJjjakMo
         vm7h2t5GUbwCcEbOX84CNrLj+srbhXQZD+NEnKarfKCgA+Es+IoVurBWY6/EHQxXzA2m
         Clt5o58G/CT49EBlO0fJA/aIh1kUFnRpo36AttPE4G6ulM1sRnBrCK8TLshuuaF2D6wk
         XXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ITqZjSMiv64nVv4NKU1fnOxnOjYiU89JwcbnlO0Bt3M=;
        b=ICbb5XmT7l0DwNZKPyeTP3eKNFsehUWR0hqTv0oxjCyRuawTNA8ELpuDxKLp9EDXrs
         lcHXnKkkSuFmLL5W3UHBV5qLs57EA4tn1/F7ivupioifinbRC6ZNASPjhrQEGRERYyQ5
         3dptx1Nnc7177MfUlM4/+08/sJCBQppuix+QGWNjVfD1zQW3ISq+47l8efePqhWPBZkF
         bVfhKJOu+/PrlHMdhzR2QNETDhOxc4LoeIHkOvSlr0GoPFeIJ3xWvG6tAo5zMsUp2VOC
         RtP+tkrSif0jm1+spdqW5fNnl/1jf5jzBIaFQyjAICuRwoivi67kg2cgHYK0F64I1E+d
         su0A==
X-Gm-Message-State: AOAM531BqYmJ7onzpc59g1zEOPefYCJp1juiwxa39DXBYW5E98EX3bUP
        52KOnLEj2Z5hY5jm1YzN+Wg=
X-Google-Smtp-Source: ABdhPJyZlKcr0A0wKpZTgJSDwY/J/YB73dO+VvS14nPR6bdG0NkjC183gD0dQBTD5qzVZMpeK3Zaqw==
X-Received: by 2002:aca:ed41:: with SMTP id l62mr3738045oih.175.1621551144549;
        Thu, 20 May 2021 15:52:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n11sm463003otf.26.2021.05.20.15.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:52:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 20 May 2021 15:52:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/240] 4.9.269-rc1 review
Message-ID: <20210520225222.GA2968078@roeck-us.net>
References: <20210520092108.587553970@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 11:19:52AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.269 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
