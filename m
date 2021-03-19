Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC763427A0
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 22:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhCSVXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 17:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhCSVXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 17:23:02 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D989C06175F;
        Fri, 19 Mar 2021 14:22:55 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso9863632otq.3;
        Fri, 19 Mar 2021 14:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nDpBB2jBamGoxoS0/MGUd1i7MLMWrKan2V8IVn3DLUs=;
        b=FS7ZYZcoK7MSkELknJxeq27r++WolJcjbXiKh96f9FdCvguwYqt6V66+oMuM+TJXfW
         vyEz4pKgF3BvWbHuqwXYNuApOkZdiF3ZWkkpetCvZYVxUR44uu1C16MED3Ppd94crOOr
         WodfJd0m1m1UJFwq3ZJkM6sB+DcpMcjvpvK6RGlnOJ2melmWT9mS3+yfSUKoDGvfTYEP
         j9tNS0HNd9VxWK6AtrfUOJBwFtnUcNqdKLwDNHLD8CuWSjJSUe/fGn4rpR5QCBZsH6ai
         Pr+VGmCR/TyGV7ktAATKpPyISgLfsEVYWBbWL513cndlY+EQ7HpOTc5f4BhqpaH1RHGP
         agBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=nDpBB2jBamGoxoS0/MGUd1i7MLMWrKan2V8IVn3DLUs=;
        b=Vh2QGKdzoc0Fqw2lb91hwmEZIQyJXgCzYJOSFFxqchAFRN3JhfCsNIg/RLJ5EfqVlf
         M0ukL/WecBLx5wRrXYQzFddtQB2LBzMCawNcfM0eY/RUQTfLNE6zfr+jNRH+DMuXAGLx
         monY1gUQWQNtEqtJ3T1lJbjhRTJXKQHSAuMVBzqOGvv0TCX2WJ1491+NCrB2M4mJDEJs
         v2DJybTc5uL5oELNphFCnWt22WAVugKunLDF2Itwujx3NtljX8eBPYw3ttvu9yjLk9Fg
         C1PXzBwvqTdgwaJi4kHC9sQALkvKe+TQ4PtKKjVV1g+rNveCK6c8fJU+3fusOLiXIoRv
         FCrw==
X-Gm-Message-State: AOAM532YwrDhVhPfFQ7OJ46NzwemqilZSm3bpO6vpYE/QrPhszT4US46
        xhQsMpmOQUDx5wHZ8SpTcLE=
X-Google-Smtp-Source: ABdhPJxH/U6oDAzSpEHPzRCcep5oEUrRcwzsjpqlr47J2SrDlxbqm7NfgRzfl3wfxl8aneqUzfxJkA==
X-Received: by 2002:a9d:24c7:: with SMTP id z65mr2655274ota.243.1616188974825;
        Fri, 19 Mar 2021 14:22:54 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j10sm1555275oos.27.2021.03.19.14.22.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Mar 2021 14:22:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 19 Mar 2021 14:22:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/13] 5.10.25-rc1 review
Message-ID: <20210319212252.GC23228@roeck-us.net>
References: <20210319121745.112612545@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319121745.112612545@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.25 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 432 pass: 432 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
