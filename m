Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A02B42E107
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 20:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhJNSWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 14:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbhJNSWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Oct 2021 14:22:07 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6646C061570;
        Thu, 14 Oct 2021 11:20:02 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so7556208pjb.1;
        Thu, 14 Oct 2021 11:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=CSCiUxW8SmCR5wEDjrlsVc/mX29VHCSuZNIbm3dfXEs=;
        b=laN+WsFVwlEgb0Q1HmoD6ArUisaCyomol03RbjTV293p+4U+cSPLSLnLOFsDfk3wqp
         LKnAF0bRONjFNH06Xu2NtjZi3h4pTZoYr8HRs9M0Wq7GUv44OHWIcOThjVYJDc7luHb9
         QUIP0mZ8cB548kJWfZBjZhyjrOImakdOnf0sX+V7+MYDz/IBJj7RzNo/I50iAzd3V8Pn
         Tdp7sERg3LYG/c5ZKz4w2vjD6MiGaBJZgoSz6m007w34pDHgVzBmoUvjHNPh3X2tvy+B
         wgkxhGUy0IUzoz6uilDkA8L7srq/nGnLCl+Kb9SZh2QEUKFpIy8fU7l8XeF4eFI/bfGQ
         x17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=CSCiUxW8SmCR5wEDjrlsVc/mX29VHCSuZNIbm3dfXEs=;
        b=XRJ7W80srEjAm+rLrrL5z8poDR9E1MbxOQ5uHrhtDUeiO0QU85+/99aPRUsl5mF5oG
         Q/rt3oXBllAAdLrZlhYheJAEkcg+qELtVs5bOuLvfNFnsvcmvydN6E1ek4zWjvZNYVKq
         JjM0zXAX8BRDzs6DPncbzoB7v/zjneOg5DuFiGRS/dXUiZVasC/w9DnZQohjrC4moTtU
         bFhcM+lldri/oR6kl18vln8+2o0kmv0kwozNHeZ2QWrTiBaDOveFnG4QevJEjVMoIkZu
         ABtdUvTyggzHLEEEYB24vBxH8eYdARotgAq5JLsrXyfu4IwZTv//VmWErc7FN83fjxD8
         22Rw==
X-Gm-Message-State: AOAM533iyntZWv7aP5iy0h+LrAjDKc+wkI6vvWBvRcLnpxUquiVB6QJt
        w7t+kyykCeQvcsb+f6P31ILXtGiNJRIfsoePvoY=
X-Google-Smtp-Source: ABdhPJz223KP55wq6AH5vjfwFYeFyGGxqmVh8EctEfVjt7DgG5DSpxqTko6ONG8TfiWLZBWGTmOSJg==
X-Received: by 2002:a17:90b:4ac1:: with SMTP id mh1mr7766925pjb.144.1634235601844;
        Thu, 14 Oct 2021 11:20:01 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id k17sm3132973pfk.16.2021.10.14.11.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 11:20:01 -0700 (PDT)
Message-ID: <616874d1.1c69fb81.4185a.9bca@mx.google.com>
Date:   Thu, 14 Oct 2021 11:20:01 -0700 (PDT)
X-Google-Original-Date: Thu, 14 Oct 2021 18:19:59 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211014145207.979449962@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/22] 5.10.74-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Oct 2021 16:54:06 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.74 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.74-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.74-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

