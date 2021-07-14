Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA9F3C7E1E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 07:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbhGNFvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 01:51:35 -0400
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:53825 "EHLO ofcsgdbm.dwd.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237964AbhGNFvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 01:51:35 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2021 01:51:32 EDT
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn2.dwd.de (Postfix) with ESMTP id 4GPmXw247jz2y1f
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 05:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dwd.de; h=
        content-type:content-type:mime-version:references:message-id
        :in-reply-to:subject:subject:from:from:date:date:received
        :received:received:received:received:received:received:received;
         s=dwd-csg20210107; t=1626241184; x=1627450785; bh=U59j7UzeM92zw
        He1nvUvl+FppbR6AWCLbAxag5rWzr8=; b=cNQ6s2Yer2eP7IyxYrDfD8Jdy3rF3
        JIViBGwF135BTk5JF2S+AV24e7Fw0Vy7jYJnMBt/dEoidgtA7Ba0KFC5Hr6BhvMv
        b813cdtMcK6wTf6CQMsptuOPmweGv2B/e71Ykt0fo9xoc8SIcc8gCvJRpccwnZYU
        TCvnkyLD691JCN2kFXRnQwDmAVja+sa8xmRGiSTi8k1/PKAiRguJ5o6Kw+Q+XSdH
        HSTzZc8RRVulCJ63WkmJ1MgZxDocznUEx0sLTc4y2nje/+K+3EBDmUbHeoDr8HyU
        LYFoawB9AQQ2WyRdWcg6l/jvHap5uyp80hQyEec0q6IdYuo4FFHpxjWAA==
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2ctev1.dwd.de ([172.30.232.67])
        by localhost (ofcsg2dn2.dwd.de [172.30.232.25]) (amavisd-new, port 10024)
        with ESMTP id inBWqWjXSgm1 for <stable@vger.kernel.org>;
        Wed, 14 Jul 2021 05:39:44 +0000 (UTC)
Received: from ofcsg2ctev1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 074115E3C29
        for <root@ofcsg2dn2.dwd.de>; Wed, 14 Jul 2021 05:39:42 +0000 (UTC)
Received: from ofcsg2ctev1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id ED77A5E3C28
        for <root@ofcsg2dn2.dwd.de>; Wed, 14 Jul 2021 05:39:41 +0000 (UTC)
X-DDEI-TLS-USAGE: Unused
Received: from ofcsgdbm.dwd.de (unknown [172.30.232.25])
        by ofcsg2ctev1.dwd.de (Postfix) with ESMTP
        for <root@ofcsg2dn2.dwd.de>; Wed, 14 Jul 2021 05:39:41 +0000 (UTC)
Received: from ofcsgdbm.dwd.de by localhost (Postfix XFORWARD proxy);
 Wed, 14 Jul 2021 05:39:44 -0000
Received: from ofcsg2dvf2.dwd.de (ofcsg2dvf2.dwd.de [172.30.232.11])
        by ofcsg2dn2.dwd.de (Postfix) with ESMTPS id 4GPmXv6q8Qz2xWb;
        Wed, 14 Jul 2021 05:39:43 +0000 (UTC)
Received: from ofmailhub.dwd.de (ofldap.dwd.de [141.38.39.196])
        by ofcsg2dvf2.dwd.de  with ESMTP id 16E5dhZp008956-16E5dhZq008956;
        Wed, 14 Jul 2021 05:39:43 GMT
Received: from praktifix.dwd.de (praktifix.dwd.de [141.38.44.46])
        by ofmailhub.dwd.de (Postfix) with ESMTP id 68EBEE2BEB;
        Wed, 14 Jul 2021 05:39:43 +0000 (UTC)
Date:   Wed, 14 Jul 2021 05:39:43 +0000 (GMT)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
Message-ID: <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
References: <20210712060912.995381202@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-FE-Policy-ID: 2:2:1:SYSTEM
X-TMASE-Version: DDEI-5.1-8.6.1018-26280.005
X-TMASE-Result: 10--11.674500-10.000000
X-TMASE-MatchedRID: eVEkOcJu0F6WfDtBOz4q2ycRqaHJVb+namDMhjMSdnnk1kyQDpEj8E1N
        J2MN+nPkSHSWZchqtCGn9WnUf4yXmVzhU0/oppo2uZBZOg7RfX9UIaneDj+GO2yIID37xcHKsb9
        HPmxftEn5yPaI4eFKR/kuGZQ5f5nDnEMCM6PzyYEK4MBRf7I7prw+GCqPUrbcdRQm2zQUJy9NiQ
        0QX2fZcvLlOXoBFD4JcNBmT2QB6gU9d1nHWxkekB/R5SKe31AR8wxV8JR3NqhOEILBOBemL2SSW
        xIg3If8N/kqi/+CMmintV427o9FVLI9IhPaTqbkS0GlPH9kR3ItnKKO+U2eJejMOEZ5AL0SWeSe
        ZNBL5JbNc1d0+ZnEhH8mA3sDDq0A5MIx11wv+CPiRhduhvElsvJT+hf62k2Y+gsSeW2jNCevG39
        WDjVoN5Zl9Wi1ChMDXdzMgWuHHk1jfFUYBEvIH2A7bUFBqh2V
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-DDEI-PROCESSED-RESULT: Safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Mon, 12 Jul 2021, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 5.13.2 release.
> There are 800 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
With this my system no longer boots:

   [  OK  ] Reached target Swap.
   [   75.213852] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
   [   75.213926] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
   [   75.213962] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
   [FAILED] Failed to start Wait for udev To Complete Device Initialization.
   See 'systemctl status systemd-udev-settle.service' for details.
            Starting Activation of DM RAID sets...
   [      ] (1 of 2) A start job is running for Activation of DM RAID sets (..min ..s / no limit)
   [      ] (2 of 2) A start job is running for Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling (..min ..s / no limit)

System is a Fedora 34 with all updates applied. Two other similar
systems with AMD CPUs (Ryzen 4750G + 3400G) this does not happen
and boots fine. The system where it does not boot has an Intel
Xeon E3-1285L v4 CPU. All of them use a dm_crypt root filesystem.

Any idea which patch I should drop to see if it boots again. I already
dropped

   [PATCH 5.13 743/800] ASoC: Intel: sof_sdw: add quirk support for Brya and BT-offload

and I just see that this one should also be dropped:

   [PATCH 5.13 768/800] hugetlb: address ref count racing in prep_compound_gigantic_page

Will still need to test this.

Holger
