Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01714F6354
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbiDFP0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236090AbiDFP0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:26:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5775F90B1;
        Wed,  6 Apr 2022 05:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 186BAB8232A;
        Wed,  6 Apr 2022 12:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4107FC385A7;
        Wed,  6 Apr 2022 12:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649247890;
        bh=VXAqwleH/9FZW2pL8a52fjF/WAWTJuJF9KN83znJwp0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HxfZK3niCIpttqDTvrn+MhcnImqotYL7Z8+P8+ovfuMJxUiznMKGrln66zonahKVE
         dXkrKrly7b3rYB8L7Skwd9NRQr9oB9V4mqugE466H0xmS4nkwNPVr8CDbmFRO8/Zpu
         QQpru43kcyWvP97u/p0e1+sGS9ufH/5kMlt0HO1g=
Date:   Wed, 6 Apr 2022 14:24:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 0000/1017] 5.16.19-rc1 review
Message-ID: <Yk2GkNTTc3XYDU2X@kroah.com>
References: <20220405070354.155796697@linuxfoundation.org>
 <9882445d-ef29-689a-33de-ce66dfc79d31@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9882445d-ef29-689a-33de-ce66dfc79d31@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 05:03:24PM -0600, Shuah Khan wrote:
> On 4/5/22 1:15 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.16.19 release.
> > There are 1017 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.19-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> Build failed on my system. The following is the problem commit. There
> are no changes to the config between 5.16.18 and this build.
> 
> Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
>     ASoC: SOF: Intel: hda: Remove link assignment limitation

Now dropped from 5.10, 5.15, and 5.16 queues, thanks!

greg k-h
