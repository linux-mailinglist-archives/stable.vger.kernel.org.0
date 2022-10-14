Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3E15FF6B0
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 01:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJNXNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 19:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJNXNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 19:13:41 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E2264DBBFA;
        Fri, 14 Oct 2022 16:13:33 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id 9B8C420FB603; Fri, 14 Oct 2022 16:13:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9B8C420FB603
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1665789213;
        bh=BVhwSUyt5iHvOqnlsHND32OgZB70wDd5dfE0wVbLfR8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o7SfZlWVyh9Y88d+edqNOwLFI/R3eUWYZJoBoZbrrfzypyeyfHlKf8yOTXxft2b5H
         AddOnmbqvmj9pvhpwjafhywoz6LagA6jFlc6NWBIW47hDJLPVyXykeAGVSHv0DFUi7
         qcBXRpVJc5IZCBvHhpDrxQRhxnQt79NWn4ahMkdY=
Date:   Fri, 14 Oct 2022 16:13:33 -0700
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/33] 5.15.74-rc2 review
Message-ID: <20221014231333.GA13269@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221014082515.704103805@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014082515.704103805@linuxfoundation.org>
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

On Fri, Oct 14, 2022 at 10:26:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.74 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Oct 2022 08:25:00 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 and WSL arm64

Built, booted, and compared dmesg against 5.15.73.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
