Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC565FBE8B
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 02:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJLAAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 20:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiJLAAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 20:00:14 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B8911BEBE;
        Tue, 11 Oct 2022 17:00:08 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id B05DF20EC332; Tue, 11 Oct 2022 17:00:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B05DF20EC332
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1665532807;
        bh=wTZ9npt/g4A0DLlsr1yM0eoyYSbiaP4D5LUS3qTFWX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b76NHQD72WK10hJkLgIc1Hp2Hr/fQibLNWkVmUWJnQSW0HRvCtaVeHcIXUCo4XIy4
         +FVrnIN5Aa2aqg4Usv/AXkxsKkwG5EiGjC8fYF3VK4ZkExQpdjBH6izj6ijUNSXxbO
         mUYH5nnRbzTFrjMgCG2QWzKNAZbu9SW86ZXFH8WA=
Date:   Tue, 11 Oct 2022 17:00:07 -0700
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/35] 5.15.73-rc2 review
Message-ID: <20221012000007.GA17305@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221010191226.167997210@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010191226.167997210@linuxfoundation.org>
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

On Mon, Oct 10, 2022 at 09:12:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.73 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:17 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 and WSL arm64

Built, booted, and compared dmesg and LTP results against 5.15.72.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
