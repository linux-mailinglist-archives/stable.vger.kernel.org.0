Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784203BBCCF
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 14:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhGEMZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 08:25:04 -0400
Received: from meesny.iki.fi ([195.140.195.201]:35216 "EHLO meesny.iki.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhGEMZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 08:25:04 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jul 2021 08:25:03 EDT
Received: from [172.16.36.173] (73-55.dynamonet.fi [85.134.55.73])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: tmb)
        by meesny.iki.fi (Postfix) with ESMTPSA id AD77E20005;
        Mon,  5 Jul 2021 15:13:58 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1625487238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EMTlrR1pWMcGh4MxxvisxjlTz5qhudkx/zly5ijqBkI=;
        b=TmoGfO8YAY7bEFKA/kAbflpqA9nG/LkvA8BNkptksoJXtNJwauYJVM8GcsFijnmaBmRx0D
        MwcWY7hzYDaGroVwjfdC9VYp69lQN2lC9x7i1Nq3XZ41xtLqLswsk2ijNz4eEgcCwpv+r+
        18WVuFollB87ZTRXtsaYMoc4Q6ko9rk=
Subject: Re: [PATCH 5.13 0/2] 5.13.1-rc1 review
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
References: <20210705105656.1512997-1-sashal@kernel.org>
From:   Thomas Backlund <tmb@iki.fi>
Message-ID: <4c383f24-5423-e076-12fc-7c6511e34a96@iki.fi>
Date:   Mon, 5 Jul 2021 15:13:57 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210705105656.1512997-1-sashal@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: sv
Content-Transfer-Encoding: 7bit
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=tmb smtp.mailfrom=tmb@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1625487238; a=rsa-sha256; cv=none;
        b=hCnEYoncizeqy34lwyMLQQBTf1EX6Ea1WX3O8GOucKp6SOQprCdiPOgycku/R2c6RL4hWl
        DjNKX+Bv93/wh0sTbj5tV3d+9Emh2PFXxTwoitx+mpig6rg96F0lUKf47MkM/u93XGeW7I
        a7ztDNbRjrzqZVaqRYsrBAwYQj/wYgY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1625487238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EMTlrR1pWMcGh4MxxvisxjlTz5qhudkx/zly5ijqBkI=;
        b=Astl2deZTsOji+lPw/xrLLlFt+RieiKKbL19+d2TMU33xbcaX++XkUDBIMjv46d4iknoMa
        6VXfe8qwFZVIFb1mfM43Ikq+4a7icfze8hgT/38EYkviG0nzWVlg9yS7yZbvSCf/Mgq6ZW
        qBQ98WpSL46aCmyTa0F5Gk/WePmAF9c=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 5.7.2021 kl. 13:56, skrev Sasha Levin:
> 
> This is the start of the stable review cycle for the 5.13.1 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:49:46 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.13.y&id2=v5.13
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
>

This one should be added  too:

 From 66d9282523b3228183b14d9f812872dd2620704d Mon Sep 17 00:00:00 2001
From: Mel Gorman <mgorman@techsingularity.net>
Date: Mon, 28 Jun 2021 16:02:19 +0100
Subject: [PATCH] mm/page_alloc: Correct return value of populated 
elements if
  bulk array is populated


to unbreak nfs in 5.13 series ...

the cause and fix is confirmed in several threads both on lkml and stable@


--
Thomas

