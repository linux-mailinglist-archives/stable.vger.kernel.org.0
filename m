Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379F6B983C
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 22:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfITUE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 16:04:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34645 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfITUE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 16:04:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id b128so5250168pfa.1;
        Fri, 20 Sep 2019 13:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nWjJD5KR0MSVyCazxJbiyX2RTVXiNRqzLf26++eMD2c=;
        b=OFebuG5bwyi/4eHkn6YzU/5u+XRRNnNoeDAqoye/6y7u4ysfDKtPv8fdbAtwnatl4N
         s3fi0sTCpunpsO1e81byyiPvMWVu7guZpHGHDEBK6Osas0W5G6pkPFQkn23n2VxDey7r
         Dgu3dRpPXJ8pbjOQEFTSMLRp5oYqW8kdz0zXfgfoachxyKxz88Y6hoG/bVeo7fCeV8iy
         VWvyT1dS6fuKWZxR7epbI8QeIO4Z24XtglswpuDuX9xvnYIP+MkKyU2c8Z0e48UZT4/p
         92/vnyHIBr/sHaSrfDTw+7LVDE8bPXJxPfRE+mV5QTYvBLvt1F+QzfTzHZTHi6tkos+b
         uzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=nWjJD5KR0MSVyCazxJbiyX2RTVXiNRqzLf26++eMD2c=;
        b=MohRXkY0PwFXHEz66aNvQ1TzwioBRxUF8hitA1dHNFAGkDF2WHMy8nJ5nsyx/zHThz
         D5ca3qEceDYZsN/3TYLlTUr2LB9YkXQ4ZyqJomZ1GO4sSy5OZMIBrPdlor1N/A7MNQ6t
         RcmPrOt5dnFQzuHvEalG5HJkptlOsMhKXu3T1Qz0+aztaeNcxrQECtwEFKCufoxuKxMR
         4+JV/FTDF4yAlS/PMNQ0lxR2LwtnxFwP/G6OSSEFLFRM8r9LMf3brqNViwDM7swDTteC
         uderHWbzhsl/XVaoM6idw8MjSNIs7eBeczOWftPDxrGDm4htoHEwBbakovtTD5ALlOEE
         fFOw==
X-Gm-Message-State: APjAAAU7fgW+/czkik2jISd4Ur0AbEG3jljSBJoDrRxsEGtyzWffjWrR
        BikuJCCG5JRvNUkODu6xSF0=
X-Google-Smtp-Source: APXvYqyf/tsjTji8wgR6w/dglYdkgNvF3milP8N0U3O7Mak1pDuO0xdKRT2DsqN+7rriAapeHuV4gw==
X-Received: by 2002:a62:14cb:: with SMTP id 194mr20393524pfu.192.1569009866397;
        Fri, 20 Sep 2019 13:04:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q30sm3333841pja.18.2019.09.20.13.04.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Sep 2019 13:04:25 -0700 (PDT)
Date:   Fri, 20 Sep 2019 13:04:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 000/132] 3.16.74-rc1 review
Message-ID: <20190920200423.GA26056@roeck-us.net>
References: <lsq.1568989414.954567518@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 20, 2019 at 03:23:34PM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.74 release.
> There are 132 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Sep 23 20:00:00 UTC 2019.
> Anything received after that time might be too late.
> 

Build results:
	total: 136 pass: 135 fail: 1
Failed builds:
	arm:allmodconfig
Qemu test results:
	total: 229 pass: 229 fail: 0

Build errors in arm:allmodconfig are along the line of

In file included from include/linux/printk.h:5,
                 from include/linux/kernel.h:13,
                 from include/linux/clk.h:16,
                 from drivers/gpu/drm/tilcdc/tilcdc_drv.h:21,
                 from drivers/gpu/drm/tilcdc/tilcdc_drv.c:20:
include/linux/init.h:343:7: error: 'cleanup_module'
	specifies less restrictive attribute than its target 'tilcdc_drm_fini': 'cold'

In addition to a few errors like that, there are literally thousands
of similar warnings.

Guenter
