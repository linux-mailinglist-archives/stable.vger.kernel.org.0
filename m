Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E853935C6F5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 15:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbhDLND5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 09:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239916AbhDLND5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 09:03:57 -0400
Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [IPv6:2001:4ca0:0:103::81bb:ff8a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F09C061574;
        Mon, 12 Apr 2021 06:03:39 -0700 (PDT)
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
        by postout2.mail.lrz.de (Postfix) with ESMTP id 4FJpny3XsKzyW5;
        Mon, 12 Apr 2021 15:03:34 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavisd-new); dkim=pass (2048-bit key)
        reason="pass (just generated, assumed good)" header.d=tum.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tum.de; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received; s=postout; t=1618232614; bh=PQuezw
        +/EQQNYIxoFckyY++qYp//ZBdNYNI/RklVJcQ=; b=qerAbPe6YnbofuvRvUmMrd
        MzuNns2SwFLbYOtl8QHJ3OuYyBu/3kHxHMcGfC6ppx2BnUfsz5FrskGOof1SFe9M
        2twgj2GjSxWNylFrcecMUu2ZyuijTk/Iago+aSUD/xTu9VynzSduThqpXVEqjf/e
        //wZKaS19OE5+tVk4e+eC2Ul04nhSr+Mxi2c58R+flXrhWyoiKwZxOd3yfWj5SoK
        tM57TcduveWHMIWRBDQ9Ds1x7JzQn7dSRp4h6cr6z9Vixb9HYpT+clI2yC/dB5wx
        tpBFh5ZNI4D9s5JJs+LTul2NyKRQM7MfBlMIeebx417ynWRcO169UAY0PPNKJCdQ
        ==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
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
Received: from postout2.mail.lrz.de ([127.0.0.1])
        by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id OuIfMKVfWllN; Mon, 12 Apr 2021 15:03:34 +0200 (CEST)
Received: from endor.yaviniv (unknown [IPv6:2001:4ca0:0:f294:bce0:50e2:fadb:742a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4FJpnx4tPhzyW6;
        Mon, 12 Apr 2021 15:03:33 +0200 (CEST)
Date:   Mon, 12 Apr 2021 15:03:31 +0200
From:   Andrei Rabusov <a.rabusov@tum.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/188] 5.10.30-rc1 review
Message-ID: <YHRFI/azs/C/Hmga@endor.yaviniv>
References: <20210412084013.643370347@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello all,

On Mon, Apr 12, 2021 at 10:38:34AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.30 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.30-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

I tested 5.10.30-rc1 on my i686, the kernel was compiled with gcc 10.2
using make localmodconfig. I found no issues to compile and run the
kernel.

Selftest resluts [ok/not ok]: [1434/82]

"Regression" (compared with 5.10.29-rc1):

75d74
< not ok 1 selftests: rtc: rtctest # TIMEOUT 90 seconds
80d78
< not ok 9 selftests: timers: rtcpie # exit=255

These test results were fluctuating for the previous kernels as well,
thus I can't conclude that this "regression" is actually a real
regression.

Tested-by: Andrei Rabusov <a.rabusov@tum.de>
