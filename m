Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22669484C17
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 02:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbiAEB2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 20:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiAEB2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 20:28:41 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D518C061761;
        Tue,  4 Jan 2022 17:28:41 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id j124so62184313oih.12;
        Tue, 04 Jan 2022 17:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FZBquu4GVvZ8VvgoDVmsgYXt5g7M/PTnZWNdIotIUA4=;
        b=W+fVh0iMcM7dsm5B21Vzg7UMspLcsKCQIKmJtdJBFmDvQiY/1hkPji22d50rI+MwC8
         33nlaMSJ2P62X0HeAYxEcn2p+b70pr/7K3lRl1P0ht7L2Qt99Ag0EKEYFKMI0tL1qHHZ
         dwzoUmm4mC5B2zt6qWQT8HJCczhZSnOpkc7H7/cSsonwHUjOulnc6MZpw2ouINdWB39I
         UyfdSrvC0hhx6V/Ryq6qap1ckfe6/BzyEVLT8lzSkHczyZMCo8LMDhhrhbXg8nGpeC6e
         vUcLoG8/+bj6EhokuzVhz89Zyw/uJXepLAzyY9qp1Tl+MxD4vESoYSYvRE4R25zKg2I8
         WpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=FZBquu4GVvZ8VvgoDVmsgYXt5g7M/PTnZWNdIotIUA4=;
        b=ibxTe0o77iVQiM6zByPygh9EogEBl0maQrzL3dhN80tasyuzVHuxXMPW3ZulE2Pxv4
         yNPJPFOjGDBMllirbT+GShwq7z4hLM6s84HjliLTVon/56oQSbK0bdQSxZh/S5zW++MC
         YTcos8iwzh13NtrQmwFuKNr7vzQ2UddZm/V6+M8YZ1BSDvrmS5SzcNBiFABGg5X+o/qo
         F8rOd0d4cLV83bEh4MEZ6dGLbChARQ+mtHrnT4CGv9uXHDEOIJKrE9nUWzpjrKXWM26d
         EPQkIT0jHEdoQ53hQzGZ1FNl3duXHUq2xq8KhLfxkYIojiwMvmqMjL1a6VI1xU73/zHt
         AYDQ==
X-Gm-Message-State: AOAM532sr/ZsOnGIJ22nmeq4hVtlvEqq4mRpokkzO/uxYz2tmtnE1/p5
        MoxP3T9zumScODeV8H3U1bo=
X-Google-Smtp-Source: ABdhPJwwumgWw5+irB9UkVR0thilyfpITWMZRRsODjkvbizE0L5k/fEB/yBP1N1UzFZWkz6kXXG6nw==
X-Received: by 2002:a05:6808:682:: with SMTP id k2mr840392oig.63.1641346120281;
        Tue, 04 Jan 2022 17:28:40 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o11sm10042228oiv.10.2022.01.04.17.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 17:28:39 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 4 Jan 2022 17:28:38 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/36] 5.4.170-rc2 review
Message-ID: <20220105012838.GA2729171@roeck-us.net>
References: <20220104073839.317902293@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104073839.317902293@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 04, 2022 at 08:40:58AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.170 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 444 pass: 444 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
