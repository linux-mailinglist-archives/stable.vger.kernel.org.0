Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D025ED34C
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 05:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiI1DKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 23:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbiI1DKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 23:10:46 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E3B2101C5;
        Tue, 27 Sep 2022 20:10:46 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1131)
        id CB12E20DEC6B; Tue, 27 Sep 2022 20:10:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CB12E20DEC6B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1664334645;
        bh=9R1APBpUi1o1sp729JOiHO9RnCgre4EowbGJjGriUQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MCximEeEtNIr7VKr6UZhKmAuxWziJt5LHnPf8yvQ+i1zMYPi9x9ODQIWzQ18Vhhh6
         L9YQ5mB1vIZEJs1kshQpsvn+V0+HGAsQ7fneGtu1iSvQjHlyeoLnVrcghfIQ8dO2Fw
         Urj+nrzbGpc6P9HaZxqR3Qdl4MkN0NmFHHLucUK4=
Date:   Tue, 27 Sep 2022 20:10:45 -0700
From:   Kelsey Steele <kelseysteele@linux.microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/143] 5.15.71-rc2 review
Message-ID: <20220928031045.GA32639@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20220926163551.791017156@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163551.791017156@linuxfoundation.org>
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

On Mon, Sep 26, 2022 at 06:37:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.71 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 and WSL ARM64

Built, booted, and compared DMESG and LTP results against 5.15.70.

Thank you, Greg.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
