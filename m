Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44E431A44A
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 19:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhBLSJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 13:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbhBLSJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 13:09:08 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9381C061786;
        Fri, 12 Feb 2021 10:08:27 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id 18so543374oiz.7;
        Fri, 12 Feb 2021 10:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b8rsPW6hx+IRc6VCaqA7AiZrA102auoLBiZQBE4YAJY=;
        b=fMDcpuMuzIZoP7n0BREk9eRGAAgpLbVi3Qr31WZogpid4vtzs57gOCBlhDUyOdsCaF
         lyxzIl6PpMcsCOT84iIvzVLLtA0DhbGXirElw77G3h9+0mBpz3mrwThz4/aVSfbdCwUw
         Ei14mQKHKvsVRDhsJRBfzLYmH2Mr0efN14Qq3K/x4DPzgxt7t3fC862gQ+qHXhwdeZSa
         lslmO44K1MfpL8i/KhGAtXKQzeZVTuFV+45EHGpimVHzzx9qbjLE2Ywlyf305ZcOdLLj
         PUhcheRO2ez43ejN0q5vcgd3aL2L2sYKLRS/EDlEF+q59tOFE9QVoW9YURQxA/w1YHvj
         BUuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=b8rsPW6hx+IRc6VCaqA7AiZrA102auoLBiZQBE4YAJY=;
        b=opq0DPJ3vpxmzHoF0gF/vM/lUmNN6ctiTheOCEYZaCy2TJyeJhspsDi2ECv6IaTD69
         be2aaaKQZ3txxYVuuNV8gTWVdhPQH6hnKHv3f2kkggH99yFmDsI74R2PG2c8UjHc+R0V
         MGkMM+/f9KAPLeUw/naOOshAuCMgZUrJ47Az9VqrEUv8pWbxxss4fXc/BKMyVt1psCK8
         gbSEswf6u84Eg3UHbzIYyiAwfL3Hqe4TNGsplOB8f3GF95Nj2Z4frfnYESAc+xejPJuA
         52Yuo9R4rzdolQC57gQ7z+R9bbnJA6QOb8WEhRVlexxEppjfundqtRr+vjvv2uE841C4
         0f/A==
X-Gm-Message-State: AOAM533hc2/4gnaQu5UhKC+ujPOK+D6BRjTQHn/8hFcQ/kdu2H3sMwHA
        WcPEvX+7+hgL2GFAjmV+b/Y=
X-Google-Smtp-Source: ABdhPJz4KJGAizZzEluHiHbCQxMsyVItBR28wcwBEtue1qG3UvrN/HPxyq4pMnMLyuFfhE5J5RN9hw==
X-Received: by 2002:a54:4697:: with SMTP id k23mr469902oic.17.1613153307087;
        Fri, 12 Feb 2021 10:08:27 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i16sm1814970oto.45.2021.02.12.10.08.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Feb 2021 10:08:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 12 Feb 2021 10:08:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
Message-ID: <20210212180825.GC243679@roeck-us.net>
References: <20210211150152.885701259@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 04:01:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.16 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
