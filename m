Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE36308C53
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 19:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhA2SWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 13:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhA2SWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 13:22:30 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE421C06174A;
        Fri, 29 Jan 2021 10:21:49 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id k8so9496302otr.8;
        Fri, 29 Jan 2021 10:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lU0i8iebAoLa/58Dt6YhAKta8FcSScZscGsAOP8Mjos=;
        b=SY3Vz8n4pPuamo/X3OHNwzAJ/ehqr6FaR23Uj15O+wjyiieZvDGYkCgAgBKwjeZqQa
         jUvlpIU93ALQQDC6wUqpfdXTcxUOKKkN14DQ+JiAf/fQdU3FrSBL4Z1H2zD4O1104xMi
         BxfRFcHvCHOaQ+M1qsofHBZzYT9XRxnoxISuC1RwOEpj7I5s4fJ224xv3CxWUThK7Q3i
         YF7JOeCP0yxij1XIWDtGqZXsW9rsqbvN0ImE4QaY1kjF1RssSCbsMAZptYkNsyH0ELB9
         pWHGqG3qbK2fS+eq/NYL92B+1ksO35/thAK0d6QLvq48Z4hsdYeYot6YM6Mj+8sIlTPW
         Eh4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=lU0i8iebAoLa/58Dt6YhAKta8FcSScZscGsAOP8Mjos=;
        b=WCacuno0r/S8+F5yn8DdDRiwS8BYbLZr2R0C4yyxGMePse4p3RcE21qB+X1Gy19VzL
         OAKK7ww4zfHhviI1pTICPX+AXcKl8wJoDOyJLsyu9BD0t+am3GcTsZhQEW+KOzNL8up0
         zV9HYIUnIAbc/EXZABxNVSyAmPU8ahhH4tE8CWzMnpkMjS59snR2QREckLmwOiYDk3Vl
         5/7Jd6oEtw7kI2Oze5GjOAuSl6Y6f88yStB9dQiP14cwGF9F3Ynfanwf56GunzI3l+nw
         oQuIXJgc4+B+LK2K2pcouou+EDmik5d/PIoVXNdeevROZfJ/m4qEt/mnAfcI+kNHyvFU
         zt1A==
X-Gm-Message-State: AOAM532s0U7ZqZxtUH57bWMvcs3ose3b2HbTHg11u4KFNT4YnX40uMCT
        7CbDiK7k3qdT9Yd4lSbcljY=
X-Google-Smtp-Source: ABdhPJx/7Aat0cLJh3a4fae6MmoSXtVH/wBHxUdPEWIaLCYH+pVl+B4hkVql1fepeEmrMum3GWXuAg==
X-Received: by 2002:a9d:688:: with SMTP id 8mr3596942otx.22.1611944509175;
        Fri, 29 Jan 2021 10:21:49 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x31sm2256126otb.4.2021.01.29.10.21.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Jan 2021 10:21:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 29 Jan 2021 10:21:47 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/50] 4.14.218-rc1 review
Message-ID: <20210129182147.GB146143@roeck-us.net>
References: <20210129105913.476540890@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129105913.476540890@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 12:06:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.218 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 404 pass: 404 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
