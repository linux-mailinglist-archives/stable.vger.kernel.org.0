Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2EF6D8B3A
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 01:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbjDEXrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 19:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbjDEXrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 19:47:17 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43D4172B5;
        Wed,  5 Apr 2023 16:47:11 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id B3420210DEF1; Wed,  5 Apr 2023 16:47:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B3420210DEF1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1680738430;
        bh=yNAS5erRHhc/EFovP6vHaxgN265p2mfiB1fFyCTB5Ps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i8wtK9UPGKsH/hQJPEblp8Q6kuursJLm1edttlRDGEHQKBvD9GGnufAYR3CfXxm2j
         2oMf29rR+yni6ErUPADLi/D+JxmFvZ9qU37T5InL8qmMhswYu0CKJS1AAgJCglkCTp
         mZ22BaHALA/7hjZldRK4mkGR6lXf38c10Eo+8sDY=
Date:   Wed, 5 Apr 2023 16:47:10 -0700
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
Message-ID: <20230405234710.GB5053@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230405100309.298748790@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
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

On Wed, Apr 05, 2023 at 12:03:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:32 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
