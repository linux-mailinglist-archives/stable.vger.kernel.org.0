Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D142B311F54
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 19:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhBFS26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 13:28:58 -0500
Received: from smtp-pro1.mana.pf ([202.3.225.198]:42270 "EHLO
        smtp-pro1.mana.pf" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhBFS26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 13:28:58 -0500
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Feb 2021 13:28:57 EST
Received: from tiare.sysnux.pf (103-4-75-17-dynamic.viti.pf [103.4.75.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: courrier@sysnux.pf)
        by smtp-pro1.mana.pf (Postfix) with ESMTPSA id 2D3BB5420C;
        Sat,  6 Feb 2021 08:22:20 -1000 (-10)
Received: from tiare.sysnux.pf (tiare.sysnux.pf [192.168.10.1])
        by tiare.sysnux.pf (Postfix) with ESMTP id 65766215A1B0;
        Sat,  6 Feb 2021 08:22:14 -1000 (-10)
DKIM-Filter: OpenDKIM Filter v2.11.0 tiare.sysnux.pf 65766215A1B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysnux.pf; s=202012;
        t=1612635734; bh=CfHpfCwmSCFyBojycpbdn38/EVGdPuo1DTgmTyMIDGU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=XJ6TMbEea+TsK6idd3ZZAFSXdTIpnvUApyzmkHQBPExXVfLlSnNHRaEG8H2VQSEjR
         t9RMA+CBwAik6YS7lLohUkmZKCgkGqsvlGRJYvHldj2iuMcIQ9MFlkjRUTwbBxPNe3
         faUaOLs8hGISJ3jzhgZOJ2d2OgCPEiB3veurS6JQ=
Subject: Re: [PATCH 5.10 00/57] 5.10.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Newsgroups: gmane.linux.kernel.stable,gmane.linux.kernel
References: <20210205140655.982616732@linuxfoundation.org>
From:   Jean-Denis Girard <jd.girard@sysnux.pf>
Message-ID: <80b8b4af-1061-18b6-8f38-79d298323a07@sysnux.pf>
Date:   Sat, 6 Feb 2021 08:22:13 -1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Le 05/02/2021 à 04:06, Greg Kroah-Hartman a écrit :
> This is the start of the stable review cycle for the 5.10.14 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know

Compiled and booted on my machine(x86_64) without any dmesg regression.

Tested-by: Jean-Denis Girard <jd.girard@sysnux.pf>


Thanks,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527
