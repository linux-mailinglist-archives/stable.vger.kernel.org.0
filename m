Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77535F4D80
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 03:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiJEBqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 21:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiJEBpo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 21:45:44 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07DD067470;
        Tue,  4 Oct 2022 18:45:39 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id 98A5820E6F47; Tue,  4 Oct 2022 18:45:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 98A5820E6F47
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1664934338;
        bh=AahI0MKXEXgIzmIIVQ0MW1cNzIo4hwSD+wmT3oOHStA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y+5OpK3Up5oSKrUolBYw1Axm08EVcXN9jjwdVwc+sPNgeXcmHFrzMhrhzzfPT/ZlB
         HauVaUIAvc1/XThJ+2LhvGq8kl5VeJonpU5vvYuPooWnCub+1XWgaDZ7KCTDGN9+6C
         rZ+BMdsdIBJ6kP/c7IYrg1Gh/qiexI9R2LniDk3w=
Date:   Tue, 4 Oct 2022 18:45:38 -0700
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
Message-ID: <20221005014538.GA18766@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221003070721.971297651@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
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

On Mon, Oct 03, 2022 at 09:10:25AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.72 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 and WSL ARM64

Built, booted, and compared dmesg results against 5.15.71.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
