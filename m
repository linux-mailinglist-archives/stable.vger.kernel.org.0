Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB2735D601
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 05:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241898AbhDMDgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 23:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241799AbhDMDgq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 23:36:46 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB7EC061574;
        Mon, 12 Apr 2021 20:36:27 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso12971540otb.13;
        Mon, 12 Apr 2021 20:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z9mIiocSxE1TePrUJcF1e7BUeeqknUgt8Nh4peEV8zc=;
        b=HrG4GzlTHuxu5ewkEMxKBatnbxRtlnQkHMxK2IbUUd3lq89tG6mQW8y+C2Ic28DmOw
         88q3+v0KaSQRgl8V3l9UwXf7pOWtbFbNJ6bSPsAvaapwOfWxWjFvU/CtxmFoW1pTxCtO
         pgsvI/gzunQm8aP0ah+NkSlniPN+VMTsI9/prBTMf0JIg+DQHOISl+i/K71bOeYT/8SN
         iAXde41QcDACguC5Fo4jh/2z2c35fJE4KGF2SPM0lIfURvUjltoq9YG1jMpZ/ajvblH3
         PMniHeZBBQ00m4Y/azoe9OsXCkb/F6SghfJcBaDbhu29S9+vNo1S1ur8XzekPrk9e0Q1
         IuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=z9mIiocSxE1TePrUJcF1e7BUeeqknUgt8Nh4peEV8zc=;
        b=JS8yu6dZJbWgE/KhxFi1A/RHant9RrgjWRSEXYiSzR/4x+HBV90TCrlNt1zrvcZWBj
         gU45r7TwQaiCoofI3KzTT3gqBY4s/BK82wylNCzihGYIWZkaBfTI1eN9n+EzJ0aNCLor
         lztKhasGyiKISfXulQQsyMZ2qZeA4qZcuWXNPrIoIGpy3i7NsuiPwAwtgWYABe+35/AI
         Ui18hi2Ic4cvXy4u4jWcacB7MUovY4Wrfn8n7ulk4EZScvJShWear06N5I8A+FdJLgAL
         6CnY2/MqTTDwMNvjWfEW2kborSMwAWgdzGf3ysZCg3er1/ZZw+L66QEiQEwFDnCYmsPa
         xITg==
X-Gm-Message-State: AOAM530qtNWld3LR9Ai3msU8nYN0V1+1ZIA5w97cAxsPbNS6cLri8O1J
        s6OtCN9kXQ0R+hRBQ1hO1nw=
X-Google-Smtp-Source: ABdhPJzsrVwJQAsiUxDbwDjYyqzO7n2OjB4zc84/c8f3z0AzmBkbR2drQP/Sc2PVUky3CcWKoHwxxQ==
X-Received: by 2002:a05:6830:17cf:: with SMTP id p15mr12733410ota.23.1618284986754;
        Mon, 12 Apr 2021 20:36:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w29sm825354ott.24.2021.04.12.20.36.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 12 Apr 2021 20:36:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 12 Apr 2021 20:36:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/188] 5.10.30-rc1 review
Message-ID: <20210413033624.GA235256@roeck-us.net>
References: <20210412084013.643370347@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 12, 2021 at 10:38:34AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.30 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 454 pass: 454 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
