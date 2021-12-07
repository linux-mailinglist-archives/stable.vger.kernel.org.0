Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30E746C4C5
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 21:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241172AbhLGUoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 15:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbhLGUoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 15:44:12 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67FAC061574;
        Tue,  7 Dec 2021 12:40:41 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so427359otl.8;
        Tue, 07 Dec 2021 12:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aOxtKoNMyoR3bGqtkztJYt33nhph+eNqDBV8BycLPtg=;
        b=hr12Xc9D8hT2Ssx1Tx2ZRDhZzTlxUG9As9ewBbcwCotVhnjEKBVqykpxHoo2iN6yAw
         ULEIXpskzsM2lC0NEK5IM9JbCnO+L+6k7/W764XkztO8peLa6/4l1aVQv/zE4S4lotZy
         6z4twrSZzPPthEU3UsljAYvvIx20Whm0PfC1ZOWzVVC38xnr0q1M2q0foHoTgpDdV1ck
         5Pvazoz7LABnZSZh8zzvgbAIryhStmdWAAGNn9YRufW5v7aGvzExd1kT49T47pOQgRZd
         /q0CqKVlz2fkCcuAWfleTrQXMd66zMFh7BiLGEO5uKJCsUvKcd9miLCXBLTRHIYOqFu8
         XZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=aOxtKoNMyoR3bGqtkztJYt33nhph+eNqDBV8BycLPtg=;
        b=UseDRbrwEtMwKfctzvlbdoH2IFCCgnO2ET5cAc3DK/FTSSQWq2cBKdjyBVuAdPCTj9
         jJ+wkzVm2P8vf/U8n1vbuZ3F/lvXBQ+HYVMz/CNfUArgsRNCy3AxxcyYC0lNJsHWbMYJ
         qfoTgiIAZKolmt3enwJ/Cu2g8d+Nrx0CVkw6QT6RPenNaldJmITtstYqq7PArbslPEK8
         WJQNPMtabgxNyJzScEbCoczcO4npzPtWSjMyxBB0dcQaKOqNpgGgRaeRPMBnk2I6nO7f
         dRyqG+cntMCzKODyqd17YdmVFsejRwDaatQv/XRqBFQyMG/yljkWDIWK/BJ8iA3ZDnWk
         QgCw==
X-Gm-Message-State: AOAM532bFt2r+eK4OfVcVJfQR9SiSGvvp8H/B4xJ5pzH6gtF8JQT8VMg
        JzIK9ZFLYEsehcMQ3noHuCQ=
X-Google-Smtp-Source: ABdhPJx1r2kpwB1Z1I5cLGJfbDd+JfYCK0Dt04TRAEFJgdEdKdIfjF6VY/o2p6Qv3fyrkChnFVeC3w==
X-Received: by 2002:a9d:6058:: with SMTP id v24mr37137494otj.296.1638909641317;
        Tue, 07 Dec 2021 12:40:41 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c4sm147809ook.16.2021.12.07.12.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 12:40:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Dec 2021 12:40:39 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/106] 4.14.257-rc1 review
Message-ID: <20211207204039.GC2091648@roeck-us.net>
References: <20211206145555.386095297@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 03:55:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.257 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
