Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6133B6450E0
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 02:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiLGBTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 20:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLGBT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 20:19:29 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA9E351320;
        Tue,  6 Dec 2022 17:19:28 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id 5B33720B83CB; Tue,  6 Dec 2022 17:19:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5B33720B83CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1670375968;
        bh=sd8kovaysO7xgbfTp2ZqWJMsIQ59/Ae4mCY9lSxD8G0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FRyYvdnmDDT5paZQQ/txj0BlgljpDQtSAK4zsdlzmZk2HwXsx95eFGdtZWzgYJGQi
         6gvAaFR4AyifvRgKG/wRmrvVKLoEvIwpzqFG0g7FG6exN/KpcYPGt2uiwWlAqcHqfa
         mtaIjfMe96/fxRhCnvgkN4o6oQHqyHIj+CbbQrY0=
Date:   Tue, 6 Dec 2022 17:19:28 -0800
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
Message-ID: <20221207011928.GA21598@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221206163439.841627689@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 05:39:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
> Anything received after that time might be too late.
No regressions found on WSL x86_64 or WSL arm64

Built, booted, and compared dmesg against 5.15.81.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
