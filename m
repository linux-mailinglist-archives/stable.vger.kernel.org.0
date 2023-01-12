Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63CDC666928
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 04:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbjALDCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 22:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234465AbjALDCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 22:02:17 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7A6148802;
        Wed, 11 Jan 2023 19:02:16 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id 6DD3F20B4621; Wed, 11 Jan 2023 19:02:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6DD3F20B4621
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1673492536;
        bh=EboQ/tANIzrC+zV+18LZwAuMyobjIOu0Z9Yh/rM37gU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bKCjvwvhNFMaPTj5HhLjolldx3+/+CU3+x+1z9WsfCQ20gk4I23X/0VkkpK/Cipl2
         /Empcaj6HYBHLzoFe4LrspraW8sSobiQX1Cv2JSYs+UEaVBxrD9pIcWauu6yH7i3Kx
         vHUmFGXR3uqS0vcrz5Poll3oaHQjTg2kAOE0MpXw=
Date:   Wed, 11 Jan 2023 19:02:16 -0800
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <20230112030216.GB17118@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230110180018.288460217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
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

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and compared dmesg against 6.1.4. Also haven't
encountered any problems so far using 6.1.y compared to 5.15.y on WSL.
:)  

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
