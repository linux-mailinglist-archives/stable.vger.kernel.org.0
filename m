Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCD338B9C8
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 00:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhETWyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 18:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbhETWyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 18:54:41 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91852C061763;
        Thu, 20 May 2021 15:53:18 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id y76so8667146oia.6;
        Thu, 20 May 2021 15:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9hsQiZTnGTi/TkwQ+IIuiQjk/9ymLgSm2E6EJ9n8Ki4=;
        b=Mnj2pi/+92JwbElJx1jijwLCbivR4OQA2tRQl3KRwr5ezffgXBqggzhdpV7YRghlbK
         L+UteRgKTuhPEX2Vw3IVE30S9dN6IzHd0BpLSAwpkR8+GiIfBjVUzaNefVFdmPQX6fzO
         bVMwptw7ccK+Mtb+RurE5Cnp/GgQCihwf2xOjmyNuPwr5kFTVMiSK94k9p/9lQ5hTwg9
         G+dkohBzMtQBepGfQV72b6ehGxfFOtiiptH2xAUkabMPKiICFqIxptfaIDK3w7u7U/mt
         mI24+eUGK0u5GhAb+hNQ/+Arp8BGANHjK+IvJNtKxU4ygrve/lU97LREy1hX1MekBGiY
         Tuxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9hsQiZTnGTi/TkwQ+IIuiQjk/9ymLgSm2E6EJ9n8Ki4=;
        b=dNQ0tt9Yj77e5n8+WP8csTuIOqyMCDGGS9CksSqrTKKW/bnrVULuMphZ9FDyBZO8hn
         AUkS0eQNez++vfUgM1AwxgHyxwdVT+YqN57dQpHOThlD4g6+gGSsZVxbeQtQ5qV83Hve
         x1wZKZ+maS3pJ4FQvomACaN67MDyaGxvVzYj4zeXhcc99Ji7Pd7dlHV3sO3+qSI88UIf
         7FujVGYuCRb61YH1pwC8cfMFFgvEhQ633Mh9Vc7nRLAi/G8zDNtzXoAQNF+DU7Z8hBEb
         JjuII1nIoqzPBrk3yawMqshW86Z5EvFt8jdt558sU8CzgfVvLCOyJPKspPCgkUzueQ3p
         VvYg==
X-Gm-Message-State: AOAM533cikB7Sjr1g3DEQS9l4b5BMvvOvGwq55ke2NKm/Tpff1VDQrLG
        BvrZ6qIm/ZtIcMJTJ2wj664=
X-Google-Smtp-Source: ABdhPJxKvuVl7YrNfaqanFZjRO55mKZ455lA9vtf39Bbuk+JN1ANSvSk8GyzXgXDykxnB6sEgcVOig==
X-Received: by 2002:aca:b784:: with SMTP id h126mr4878669oif.53.1621551197943;
        Thu, 20 May 2021 15:53:17 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o1sm958451otj.39.2021.05.20.15.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:53:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 20 May 2021 15:53:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/425] 4.19.191-rc1 review
Message-ID: <20210520225316.GC2968078@roeck-us.net>
References: <20210520092131.308959589@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 11:16:09AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.191 release.
> There are 425 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
