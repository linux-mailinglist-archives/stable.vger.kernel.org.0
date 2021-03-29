Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EA834CF4D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 13:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhC2Lr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 07:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbhC2LrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 07:47:22 -0400
Received: from postout2.mail.lrz.de (postout2.mail.lrz.de [IPv6:2001:4ca0:0:103::81bb:ff8a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20E3C061574;
        Mon, 29 Mar 2021 04:47:21 -0700 (PDT)
Received: from lxmhs52.srv.lrz.de (localhost [127.0.0.1])
        by postout2.mail.lrz.de (Postfix) with ESMTP id 4F89mM0gbfzyY0;
        Mon, 29 Mar 2021 13:47:15 +0200 (CEST)
Authentication-Results: postout.lrz.de (amavisd-new); dkim=pass (2048-bit key)
        reason="pass (just generated, assumed good)" header.d=tum.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tum.de; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :x-mailer:organization:references:in-reply-to:message-id:subject
        :subject:from:from:date:date:received:received; s=postout; t=
        1617018434; bh=fyRt8Q17qbrtWYv3G4QVMKWyQh6rQJdkL/LO34jc++M=; b=g
        b9Hx45R+RV+qCvyvFB+N6Waj9Vi8+pEopX2H6I3roXVgEEd71m9p19cYcaSKrYmv
        p9V/HN9FO7yYvEudZssVY8ATHeWAvzGVzqQai+FRvqCArzhloZ1p3n4YnWtv439g
        /86f+5h7sjObEoYRAe6E4zSabqZaOiuqlrzijmfRCyA/T/B54v900ARYzgumCQal
        KopxfZqi4dF5Dhpb/sr179gyrw1dKTFRFltNX2KFq3PcUKHEGIpDffqEPZuBbrE+
        mfMMosHqSWGaMNvIOekk2zHzgQiBOHeV1QmxWLvIdg9epKkHpbNvpxAHchC1wHu2
        1RPzyO2NX+vyk4FBf8T/A==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs52.srv.lrz.de
X-Spam-Flag: NO
X-Spam-Score: -2.875
X-Spam-Level: 
X-Spam-Status: No, score=-2.875 tagged_above=-999 required=5
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
        LRZ_MSGID_AN_AN=0.001, LRZ_URL_HTTP_SINGLE=0.001,
        LRZ_URL_PLAIN_SINGLE=0.001] autolearn=no autolearn_force=no
Received: from postout2.mail.lrz.de ([127.0.0.1])
        by lxmhs52.srv.lrz.de (lxmhs52.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id 4_lPgwMgQBi1; Mon, 29 Mar 2021 13:47:14 +0200 (CEST)
Received: from yaviniv.e18.physik.tu-muenchen.de (yaviniv.e18.physik.tu-muenchen.de [10.152.72.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by postout2.mail.lrz.de (Postfix) with ESMTPSA id 4F89mL0C8xzyY3;
        Mon, 29 Mar 2021 13:47:13 +0200 (CEST)
Date:   Mon, 29 Mar 2021 13:47:13 +0200
From:   Andrei Rabusov <a.rabusov@tum.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/221] 5.10.27-rc1 review
Message-ID: <20210329134713.05d7ffaf@yaviniv.e18.physik.tu-muenchen.de>
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
Organization: TUM E18
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 09:55:31 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.10.27 release.
> There are 221 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.27-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-5.10.y and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

No issues were found (tested on i686, gcc 10.2, localmodconfig).
Selftest status [ok/not ok]: [1434/81] (the same as for 26-rc3).

Tested-by: Andrei Rabusov <a.rabusov@tum.de>
