Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74AF365825
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 13:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhDTLy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 07:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhDTLy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 07:54:58 -0400
Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [IPv6:2001:4ca0:0:103::81bb:ff8a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2A1C06174A;
        Tue, 20 Apr 2021 04:54:27 -0700 (PDT)
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
        by postout2.mail.lrz.de (Postfix) with ESMTP id 4FPhtQ2z71zyWJ;
        Tue, 20 Apr 2021 13:54:22 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavisd-new); dkim=pass (2048-bit key)
        reason="pass (just generated, assumed good)" header.d=tum.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tum.de; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received; s=postout; t=1618919662; bh=op7Di6
        PHNRtoWWFnBrYz80x4rQ07mSfH2KKSChuJOpI=; b=aFEKF9M6KD4szR6Jbe7NsH
        enHV62FGNACS55M6Ekq2rIGU9Nhjt7f91JaqbPifJGwpeLBAQ8u1YBtqwqodkZLe
        gNYTLaJ1N4BhglcL5DfzolVeJkJPj7ZFlyJk4sfvlVMQ2giG21adsXY202rhdJ5M
        vRMoLMD6cqZYi9v11tquWRt3MRiHpWCEbsLZhyGps1hngRsyCb0Z8PWal8ExVryI
        VFaeIaOQPZUPQPdrCpmtLPOFTGXgpAWCU6vOL7Ot0/rGLaTazkvIpotRaGo258HC
        TirstppHz1bfm1r0UzAeVSYbLFbjhsWDLL4x1ol5GNBb62D/NN8rvcLp2swDUHuw
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
        with LMTP id NoDwh_ccxypF; Tue, 20 Apr 2021 13:54:22 +0200 (CEST)
Received: from yaviniv.e18.physik.tu-muenchen.de (yaviniv.e18.physik.tu-muenchen.de [10.152.72.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4FPhtM4VgMzyWF;
        Tue, 20 Apr 2021 13:54:19 +0200 (CEST)
Date:   Tue, 20 Apr 2021 13:54:15 +0200
From:   Andrei Rabusov <a.rabusov@tum.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.32-rc1 review
Message-ID: <YH7A5zclP6USkEpY@yaviniv.e18.physik.tu-muenchen.de>
References: <20210419130527.791982064@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 03:05:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.32 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On my i686 (gcc 10.3) I found no issues with the new rc

Selftest results [ok/not ok]: [1435/81]

Tested-by: Andrei Rabusov <a.rabusov@tum.de>
