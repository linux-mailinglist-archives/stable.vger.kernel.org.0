Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465C5346655
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 18:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhCWR3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 13:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhCWR3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 13:29:04 -0400
X-Greylist: delayed 452 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 23 Mar 2021 10:29:03 PDT
Received: from postout1.mail.lrz.de (postout1.mail.lrz.de [IPv6:2001:4ca0:0:103::81bb:ff89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E0DC061574;
        Tue, 23 Mar 2021 10:29:03 -0700 (PDT)
Received: from lxmhs51.srv.lrz.de (localhost [127.0.0.1])
        by postout1.mail.lrz.de (Postfix) with ESMTP id 4F4dSk6Vvkzyhj;
        Tue, 23 Mar 2021 18:21:26 +0100 (CET)
Authentication-Results: postout.lrz.de (amavisd-new); dkim=pass (2048-bit key)
        reason="pass (just generated, assumed good)" header.d=tum.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tum.de; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :x-mailer:organization:references:in-reply-to:message-id:subject
        :subject:from:from:date:date:received:received; s=postout; t=
        1616520086; bh=O6Gw2Sv4QuWxqHo644fu+3aSadGr5z7e6RC1L5LXMJY=; b=n
        r5V4TSpx7hiHbpcuRcqTaPOL6z3o7litlJSyowtecgGgUtE5mbITz0fJqiEddrUt
        t1FIuO4My3Gu9+A9hWcDKIMP+7PAPR1/hSHtoTBFO+Ud1Z9hcsWtgeP9YvNW9S7y
        56UCMjfmBerlcFtZSXoh2g4qFffhKo3SgINWDmpXcTmusOlvFzPCa03A8WGZIDqD
        zA2gMP0HO4L9liS2rv2niopGdPxRtz+xAWbgh8yCC0ZD5W3d2/dp51+/63FcOEzC
        UrkKJa5urfwDuAPcJC0uXRLRwDe2JuCbrcjVCBRQySC7LEyTbctXk/OzKA2AUHpQ
        dlLMvHpvHhTGgmos1Oxjg==
X-Virus-Scanned: by amavisd-new at lrz.de in lxmhs51.srv.lrz.de
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
Received: from postout1.mail.lrz.de ([127.0.0.1])
        by lxmhs51.srv.lrz.de (lxmhs51.srv.lrz.de [127.0.0.1]) (amavisd-new, port 20024)
        with LMTP id MJQLGXTNRglT; Tue, 23 Mar 2021 18:21:26 +0100 (CET)
Received: from yaviniv.e18.physik.tu-muenchen.de (yaviniv.e18.physik.tu-muenchen.de [10.152.72.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by postout1.mail.lrz.de (Postfix) with ESMTPSA id 4F4dSh4gr2zyhX;
        Tue, 23 Mar 2021 18:21:24 +0100 (CET)
Date:   Tue, 23 Mar 2021 18:21:23 +0100
From:   Andrei Rabusov <a.rabusov@tum.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/156] 5.10.26-rc2 review
Message-ID: <20210323182123.3ce89282@yaviniv.e18.physik.tu-muenchen.de>
In-Reply-To: <20210322151845.637893645@linuxfoundation.org>
References: <20210322151845.637893645@linuxfoundation.org>
Organization: TUM E18
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Mar 2021 16:19:10 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 5.10.26 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 15:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-5.10.y and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on i686 (ThinkPad R50p) with gcc 10.2 (slackware-current)

I spotted no problems with this rc.

Tested-by: Andrei Rabusov <a.rabusov@tum.de>

