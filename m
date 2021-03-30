Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B5934E858
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 15:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhC3NEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 09:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbhC3NE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 09:04:28 -0400
Received: from postout1.mail.lrz.de (postout1.mail.lrz.de [IPv6:2001:4ca0:0:103::81bb:ff89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B0DC061574;
        Tue, 30 Mar 2021 06:04:27 -0700 (PDT)
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 4F8qQw6YtNzyVs;
        Tue, 30 Mar 2021 15:04:24 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavisd-new); dkim=pass (2048-bit key)
        reason="pass (just generated, assumed good)" header.d=tum.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tum.de; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received; s=postout; t=1617109464; bh=sfDhCO
        DWlyQVGUuyDwdvVxAO3aVQ6nsZvUx5T1fGqy0=; b=GcddPUYZ2zYnMZ8IxAL5Vi
        TKrAcrepSBhojh1JNXLzO8ZEjKxJN5jXK9q6vJEHpKBJLNOE36QH8BdKrVc9lKdM
        aGLSs1jNuHRGBkZFtpDE9p5U1jjwnzrUng2p4XRYvAkmSkiO8URR2UCKk3BmnaHr
        3uaQFH8M9YMIwCxgmzfUsJBhPSRCc0rc/4jtjUrJ7RDIHEv+O88dXGNvZSIzeFgv
        Bhd5QcoeetLfP7ZDFDm0lcJsmeJcRy4I6eIQeEYSzR1jFoGHj+XsOZQKCk9xM7T9
        SsLgtYtt4jKLWz/NRL1x8N2QAEX5b8OjuyaWV3/fG6rug79XKd23nH6+/tJwaL/Q
        ==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs51.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.876
X-Spam-Level: 
X-Spam-Status: No, score=-2.876 tagged_above=-999 required=5
        tests=[ALL_TRUSTED=-1, BAYES_00=-1.9, DMARC_ADKIM_RELAXED=0.001,
        DMARC_ASPF_RELAXED=0.001, DMARC_POLICY_NONE=0.001,
        LRZ_DMARC_FAIL=0.001, LRZ_DMARC_FAIL_NONE=0.001,
        LRZ_DMARC_POLICY=0.001, LRZ_DMARC_TUM_FAIL=0.001,
        LRZ_DMARC_TUM_REJECT=3.5, LRZ_DMARC_TUM_REJECT_PO=-3.5,
        LRZ_ENVFROM_FROM_ALIGNED_STRICT=0.001, LRZ_ENVFROM_FROM_MATCH=0.001,
        LRZ_ENVFROM_TUM_S=0.001, LRZ_FROM_HAS_A=0.001,
        LRZ_FROM_HAS_AAAA=0.001, LRZ_FROM_HAS_MDOM=0.001,
        LRZ_FROM_HAS_MX=0.001, LRZ_FROM_HOSTED_DOMAIN=0.001,
        LRZ_FROM_NAME_IN_ADDR=0.001, LRZ_FROM_PHRASE=0.001,
        LRZ_FROM_PRE_SUR_PHRASE=0.001, LRZ_FROM_TUM_S=0.001,
        LRZ_HAS_IN_REPLY_TO=0.001, LRZ_HAS_SPF=0.001, LRZ_HAS_URL_HTTP=0.001,
        LRZ_URL_HTTP_SINGLE=0.001, LRZ_URL_PLAIN_SINGLE=0.001]
        autolearn=no autolearn_force=no
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id aijYiZpF6ltN; Tue, 30 Mar 2021 15:04:24 +0200 (CEST)
Received: from endor.yaviniv (unknown [IPv6:2001:4ca0:0:f294:bce0:50e2:fadb:742a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by postout1.mail.lrz.de (Postfix) with ESMTPSA id 4F8qQv3nPJzyWS;
        Tue, 30 Mar 2021 15:04:23 +0200 (CEST)
Date:   Tue, 30 Mar 2021 15:04:18 +0200
From:   Andrei Rabusov <a.rabusov@tum.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/219] 5.10.27-rc2 review
Message-ID: <YGMh0t1iMOP8uqe9@endor.yaviniv>
References: <20210329101340.196712908@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329101340.196712908@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 12:14:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.27 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 10:13:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.27-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I found no problems with 5.10.27-rc2 on my i686, gcc 10.2
Selftest results [ok/not ok]: [1437/80]
Improvement (compared with -rc1): rtctest.1 now is ok:

$ grep rtctest ../log/5.10.27/rc2/selftests.log | grep ok
ok 1 selftests: rtc: rtctest
$ grep rtctest ../log/5.10.27/rc1/selftests.log | grep ok
not ok 1 selftests: rtc: rtctest # TIMEOUT 90 seconds

Tested-by: Andrei Rabusov <a.rabusov@tum.de>
