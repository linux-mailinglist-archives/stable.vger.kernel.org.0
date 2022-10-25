Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3E660C18D
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 04:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJYCQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 22:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJYCQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 22:16:17 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 257DC79604;
        Mon, 24 Oct 2022 19:16:17 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id AC8D420FEB7D; Mon, 24 Oct 2022 19:16:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AC8D420FEB7D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1666664176;
        bh=tE9WRoMKpk05z8CwKPDducghhYXGRwpvqxaFsVbfSKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lqugX4tHGWkrm3q9bn2Ctu51vegacVHukluYni4UCdXjycraC5bjuBwSfn1ozuXEg
         YE9UHW/FCgl0DYiwF1pM7AuWYnPXGNoLem9fwWjnfax4AghHRo34kXvDNuwOCKzLhG
         ru9JY7qMDjxhDnfmFj8X+6I9e1+T96YQoRdQf0l4=
Date:   Mon, 24 Oct 2022 19:16:16 -0700
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/530] 5.15.75-rc1 review
Message-ID: <20221025021616.GA6345@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221024113044.976326639@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
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

On Mon, Oct 24, 2022 at 01:25:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.75 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and compared dmesg against 5.15.74.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
