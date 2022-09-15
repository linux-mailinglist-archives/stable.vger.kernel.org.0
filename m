Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534F25B9C60
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 15:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiIONxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 09:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiIONxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 09:53:31 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 870E599240;
        Thu, 15 Sep 2022 06:53:28 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id 21E452057C45; Thu, 15 Sep 2022 06:53:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 21E452057C45
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1663250008;
        bh=sZTMQwJc76ykomIDWKwnb/MXKHCZeEUd7Mg/6F2abu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=De6wYUr8L8HHFQlD+2Z29i5fEqavZtAWWTN04QSm6wnQjmVYC+iu+UXwKyToogTB7
         wsUMRhbMgeXDg+351Ogxtj9KzT2i823x1g6tY5C6UV5f1PP42ikUAzGAbZN9pi/XjQ
         +fjGoUow5z0/lzNu3NilF5AMcYnBnyoMeDakNpkc=
Date:   Thu, 15 Sep 2022 06:53:28 -0700
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/121] 5.15.68-rc1 review
Message-ID: <20220915135328.GB7523@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20220913140357.323297659@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
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

On Tue, Sep 13, 2022 at 04:03:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.68 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.

Built and tested on WSL x86 and WSL arm64 - no regressions found. 

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
