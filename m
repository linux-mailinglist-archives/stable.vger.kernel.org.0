Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8368235557D
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 15:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbhDFNnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 09:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhDFNnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 09:43:21 -0400
Received: from postout1.mail.lrz.de (postout1.mail.lrz.de [IPv6:2001:4ca0:0:103::81bb:ff89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2D5C06174A;
        Tue,  6 Apr 2021 06:43:12 -0700 (PDT)
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 4FF7yK2H6CzyRn;
        Tue,  6 Apr 2021 15:43:05 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavisd-new); dkim=pass (2048-bit key)
        reason="pass (just generated, assumed good)" header.d=tum.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tum.de; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received; s=postout; t=1617716585; bh=ikAJti
        260zdCu2Gt9KwSWN6eiJFnkVr4V7OdjBqRH5w=; b=mO0CzYZs/ZH4a8NOhbKD6+
        U+EDIYAm9uxwrIdWzxlseg7WtosA71IsgvxXopbeU1FJ4hBADIO0gffQK81ia0ll
        vVBwOBSdo8r8T3BocUaNW+36kyqQI6AqGi2+OUf7Sgme1liF4Yb5g1UosP7AwqB1
        4nzeeAfkPkz1XDm6tmn6w7O5+NeVhWyWnftE1V2EmGpD47MUNjYhQqHmsiGlE2Gn
        9E7ojZZX5FiMGqm5mf1xGZepyGcSIsyfhZ1NZK4Xgk2ri/HEeBP8nX5Znbus/QKO
        4R4LQY+Y2J70/2Eafxx5ljKvR9Y8fUvjX7xaNJei4vuvbVOqMIVCHFvKUu4Jp90Q
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
        with LMTP id X9kbhbGegS1i; Tue,  6 Apr 2021 15:43:05 +0200 (CEST)
Received: from endor.yaviniv (unknown [IPv6:2001:4ca0:0:f294:bce0:50e2:fadb:742a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by postout1.mail.lrz.de (Postfix) with ESMTPSA id 4FF7yJ3kXczyRq;
        Tue,  6 Apr 2021 15:43:04 +0200 (CEST)
Date:   Tue, 6 Apr 2021 15:43:01 +0200
From:   Andrei Rabusov <a.rabusov@tum.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/126] 5.10.28-rc1 review
Message-ID: <YGxlZfRR6hS/Kfco@endor.yaviniv>
References: <20210405085031.040238881@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 10:52:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.28 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.28-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Fine with mine i686 gcc 10.2
No selftest regressions were found
Selftest results [ok/not ok]: [1436/80]

Tested-by: Andrei Rabusov <a.rabusov@tum.de>

P.S.
Sorry, as always I forgot to do reply-all instead of just reply
