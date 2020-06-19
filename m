Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79675201EC6
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 01:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgFSXsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 19:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgFSXsc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 19:48:32 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA63C06174E;
        Fri, 19 Jun 2020 16:48:31 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x22so5158776pfn.3;
        Fri, 19 Jun 2020 16:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0iF24H+3/O+YZ4xcMByigSGzxf2WOFkxmlzJjh0PGVU=;
        b=G09rxDjnbaKFIkveGu8buLSARNszS7ajPIX+VDwuUKDt5rZrOKkh/UH8jWf99N5jLF
         CxgLAs+1xOBE8O2xe7MDA9OD/OV6ClWfKtqSdK1O51X6Obi3MHtOLdesJwWKngdl37Dn
         VrJiEfz/renKrYoiYhnVYYQ00cRYg9YVMTVlzV0dWENgjHww1x/wm+ko/EA5IBs5JaFz
         8FdHikT40mxj3Azqe1Wn848HZ5e9V29edVcJrC1QcG8yv50q/pDim0jjM/ZG5UFOYgJn
         19iHNid3ixN5KDmaM/Wp//s8YB5+zvvOCfIT5aaxQY89icZM7xmE3mvAe9XKIrmetZzu
         asGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0iF24H+3/O+YZ4xcMByigSGzxf2WOFkxmlzJjh0PGVU=;
        b=NdRxpb+dcL1gW5Y0a3YnHNFEOLBEH6K3x+6bNj/3Wjlnb39M6kqcRC/1Zh3L2VqZO2
         FQep/AuLRiksCjt9zzXnfj+FcUkegOvXQb+GbqtkquUoV1yqKDcC4YzAxzjdOJoF/zhv
         Cpk4h9Rq+X0csBV6iGkbZdP2m7WwyhNiKFK36IMZTim/EuEQBv7LfUpOew7FAJMqOvYg
         TVJHlDMCvkKsPXW3NvNjBEsHVzw3g6RhidOn7kLn0xA1djcH35VZc5yYtER6e/I/P0H9
         SiA22uExdv9aiil8mpDx3UKN1+tWTeXr9MQgfw1oem244BxdLtgiueQQc5ty/UYuPset
         fIeA==
X-Gm-Message-State: AOAM532c22PvJg83N3Wqf7hNLzFpq/nTWSjDLzB4+/V4jGuXgBLNRt3j
        tqLRvrRpB7sZmHxkThkrrcE=
X-Google-Smtp-Source: ABdhPJw25el3ax8Z/ogFDnf55Y7r8nyzG+mzccxsjj7dYbBLLtFWqKAqu+EalbswxK5IAytDIgmWxg==
X-Received: by 2002:aa7:9738:: with SMTP id k24mr9601447pfg.44.1592610510626;
        Fri, 19 Jun 2020 16:48:30 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id mw5sm7071175pjb.27.2020.06.19.16.48.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2020 16:48:30 -0700 (PDT)
Date:   Fri, 19 Jun 2020 16:48:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/267] 4.19.129-rc1 review
Message-ID: <20200619234829.GD153942@roeck-us.net>
References: <20200619141648.840376470@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 04:29:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.129 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 144 fail: 11
Failed builds:
	<most mips>
Qemu test results:
	total: 420 pass: 360 fail: 60
Failed tests:
	<all mips>

arch/mips/mm/dma-noncoherent.c: In function 'cpu_needs_post_dma_flush':
arch/mips/mm/dma-noncoherent.c:59:7: error: 'CPU_LOONGSON2EF' undeclared

Guenter
