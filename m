Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757F76D8B29
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 01:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjDEXnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 19:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDEXnW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 19:43:22 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C496D6E82;
        Wed,  5 Apr 2023 16:43:21 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id 22940210DEF2; Wed,  5 Apr 2023 16:43:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 22940210DEF2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1680738201;
        bh=KWKd0z6saujkNnNub5skEGsTzVOWwv/Q+owcUxrhETY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ty0uhn9K0rBIrf67Idj5jjEkOeoJdvcnXuxS9YXDgNCEpqYv++n2SRCWjQfBVIa7A
         0Er2E9rDzyciV8PVNA5saCl2yJjJRe5vMkoEMf3hQ9+9FpOp0G2gn5TdwTS0pBuB9A
         k/eAn8fEDSc7y+HUm3fV1bFDQjEQT3EO5er5yEKk=
Date:   Wed, 5 Apr 2023 16:43:21 -0700
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
Message-ID: <20230405234321.GA5053@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230405100302.540890806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 12:03:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.

Builds and boots on x86 and arm64 WSL. No regressions found through
dmesg.

Thank you Greg for the updated -rc. :) 

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
