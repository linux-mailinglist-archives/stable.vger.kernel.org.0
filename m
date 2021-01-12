Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA312F2C90
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 11:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404886AbhALKUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 05:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730219AbhALKUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 05:20:43 -0500
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C71FC061575;
        Tue, 12 Jan 2021 02:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JRgndvSvrLF6HtVtfHoAE+XZbWVAHtqr+c8ygOv5xaI=; b=wNPwyoykBiUNX5bHwUUfPFXd9e
        5xAoEQUQ4vgSHr0DyoKJER9NFiUnsmmC9Z4Fcj0WyFDqvBbgMcA9fSoR6eE9NhQR8O870GlhCslrD
        HtSsCMq1F0/BKx464G7MntXGBiOESHHBsvGKMzPEKBGI3NygEi6F0rgIGjAFPlSEOamLLYh+VMcgq
        wt8R3qY4/g6tUyBkznBTxABSfl1hz2emcMgVrkvOnffQAU9wWGo9VytnnbQQcOKTFBByRclUSpqu6
        HI8aUC3Nq2v7c7IdVTPWdhfNKo3Ex3pLK5MDI0ID29C6RpzK8KmdhONVcO1bVRPFQNpzEZGbzpSYb
        eAHU4t0A==;
Received: from dsl-hkibng22-54f986-236.dhcp.inet.fi ([84.249.134.236] helo=[192.168.1.10])
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <cyndis@kapsi.fi>)
        id 1kzGmN-0006ii-5N; Tue, 12 Jan 2021 12:19:59 +0200
Subject: Re: [PATCH v2] i2c: tegra-bpmp: ignore DMA safe buffer flag
To:     Wolfram Sang <wsa@kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        thierry.reding@gmail.com, jonathanh@nvidia.com, talho@nvidia.com,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Muhammed Fazal <mfazale@nvidia.com>,
        stable@vger.kernel.org
References: <20210111155816.3656820-1-mperttunen@nvidia.com>
 <20210111214221.GF17475@kunai>
From:   Mikko Perttunen <cyndis@kapsi.fi>
Message-ID: <92fb3f30-a08c-eb42-0741-affc3ceae0c0@kapsi.fi>
Date:   Tue, 12 Jan 2021 12:19:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210111214221.GF17475@kunai>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 84.249.134.236
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/21 11:42 PM, Wolfram Sang wrote:
> On Mon, Jan 11, 2021 at 05:58:16PM +0200, Mikko Perttunen wrote:
>> From: Muhammed Fazal <mfazale@nvidia.com>
>>
>> Ignore I2C_M_DMA_SAFE flag as it does not make a difference
>> for bpmp-i2c, but causes -EINVAL to be returned for valid
>> transactions.
> 
> I wonder if bailing out on an unknown flag shouldn't be revisited in
> general? I mean this will happen again when a new I2C_M_* flag is
> introduced.
> 

If it's guaranteed that any new flags are optional to handle by the 
driver, than that is certainly better. I'll post a v3 with that approach.

thanks,
Mikko
