Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDAC30959A
	for <lists+stable@lfdr.de>; Sat, 30 Jan 2021 14:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhA3Nxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jan 2021 08:53:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4149 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbhA3NxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jan 2021 08:53:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6015649e0002>; Sat, 30 Jan 2021 05:52:30 -0800
Received: from [10.26.74.139] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 30 Jan
 2021 13:52:27 +0000
Subject: Re: [PATCH 4.9 00/30] 4.9.254-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
References: <20210129105910.583037839@linuxfoundation.org>
 <7002f2eaccbe4822ace69408bdf67448@HQMAIL105.nvidia.com>
 <f39129e5-6d38-6c33-f31e-cf15e4c0399d@nvidia.com>
 <YBVIlENhvmBEndsU@kroah.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1f078011-6a83-1954-7a37-56ca6cbc633f@nvidia.com>
Date:   Sat, 30 Jan 2021 13:52:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YBVIlENhvmBEndsU@kroah.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612014750; bh=NNzpjo/e/eV6BZMGPbT83UNazD73mTKRQb7uXe6/VGk=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=n8QKDAslj30ZBc7B1nanlYcjc2xe03MA36545kQXjenQniZA4T7Phg3twxSBDcL0b
         W9JHVaF8ylO2zIyqPKrTWb51+Da6mjhDUIjIZZsDgFUjL3CkDZdjBOVq5bIDDlttUQ
         JLeJSueegmH06tz/zuBq79p4tJAj0uH9JTn5b3Z7S6ZprVtBGD50vBi5uPAZs85kAh
         L8/+wv7YFnJ+1Yr0ca154cVBKHNWUYmx56+8CaSE7hSnCqENuTZHB4R/GwY2d1Q8qW
         yCnsWNtRiEmHEztoX6VkJ96dG0mYpIwZp/eaZOzRe2tc5M8qg57uwQuennlkEqQ17Y
         4CBfSiolO5s1Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/01/2021 11:52, Greg Kroah-Hartman wrote:

...

> vger.kernel.org has been having some problems for the past few days in
> sending messages out, which is why they wouldn't show up in lore as well
> if they never get sent from the server.
> 
> I can add you as a direct cc: to the -rc announcements if you want me
> to, to prevent this type of thing.  Just let me know if you, or anyone
> else, wants on them.


Yes if you could add me to cc list that would be great.

Thanks Jon

-- 
nvpublic
