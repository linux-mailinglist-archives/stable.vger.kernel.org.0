Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C6835A1B6
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 17:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhDIPJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 11:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbhDIPJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 11:09:46 -0400
Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [IPv6:2001:4ca0:0:103::81bb:ff8a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0B1C061760;
        Fri,  9 Apr 2021 08:09:33 -0700 (PDT)
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
        by postout2.mail.lrz.de (Postfix) with ESMTP id 4FH1kc4kkvzyZx;
        Fri,  9 Apr 2021 17:09:28 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavisd-new); dkim=pass (2048-bit key)
        reason="pass (just generated, assumed good)" header.d=tum.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tum.de; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received; s=postout; t=1617980968; bh=NWqPCJ
        5otCgmU2TaIjoNOEHXKuUYy2WtTu9XO4ohzvo=; b=KggAEOz1wXMOKPzEXY3Zgb
        JLgMgHU8qeBbPr2FI6feWUErEx+yIDoQlQXiHr68I87L24RSwllJ9ptny/fuFdRS
        F/EwRf8qloF5BnT9najABA/ADF+M193Xyr3nX84SqkNCmmnZwJrQPTE73jqtONpj
        oI+JoA2N1O//PILNM5ikHP+toXGqNUn+0iVN3mjChgCCGiZ/RUuPjY3bDrq5TM+1
        jwOSTUDS/CuhslPkd4ydDylpSWlFw3/u7zxOQ0hAzgxx2w0zUj5TytsETD0RxJZx
        rAiXUE6FfHnlCJZU8SDbLAkzVYz6Z+rgM0/BNztD8sfqJqc7Ljef9Cnsu09REZAA
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
        with LMTP id bUw474Xa325m; Fri,  9 Apr 2021 17:09:28 +0200 (CEST)
Received: from endor.yaviniv (unknown [IPv6:2001:4ca0:0:f294:bce0:50e2:fadb:742a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4FH1kb69zvzyZW;
        Fri,  9 Apr 2021 17:09:27 +0200 (CEST)
Date:   Fri, 9 Apr 2021 17:09:25 +0200
From:   Andrei Rabusov <a.rabusov@tum.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/41] 5.10.29-rc1 review
Message-ID: <YHBuJT2IQbVXeZx0@endor.yaviniv>
References: <20210409095304.818847860@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 11:53:22AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.29 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.29-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

For my i686 with gcc 10.2 no regressions were found
Selftest result [ok/not ok]: [1436/80]

Tested-by: A. Rabusov <a.rabusov@tum.de>
