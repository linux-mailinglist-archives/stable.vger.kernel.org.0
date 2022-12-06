Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A3164423E
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 12:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiLFLhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 06:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235059AbiLFLhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 06:37:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858A5C9;
        Tue,  6 Dec 2022 03:37:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 173EB61684;
        Tue,  6 Dec 2022 11:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF436C433B5;
        Tue,  6 Dec 2022 11:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670326651;
        bh=4GLFz/egUMuzv4JiXJTbKWzf5OjW9OOGiDGRCOpKNSE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u2MC6C5N/1A+icu8L/D8T1bQAzoLVA6oq75jdTEVz8plA5I6YC0BblB4xmIKbq9Ej
         wqdd+cvmygMcFfbmqOYhtZlUZDg/hduacQCHOXs3r94dPLvfRGN5x7X+4wtzX5pKXl
         AC/+h7iuNWcVXSqdTVWebYo8V/rMmg68tzRDKkSs=
Date:   Tue, 6 Dec 2022 12:37:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org,
        Kamal Dasu <kdasu.kdev@gmail.com>, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.9 00/62] 4.9.335-rc1 review
Message-ID: <Y48pbLT3dmA1iQPu@kroah.com>
References: <20221205190758.073114639@linuxfoundation.org>
 <80305ea1-4d52-b1d3-e078-3c1084d96cc7@nvidia.com>
 <2bb37989-7c22-ae06-6568-8419ce57e44b@gmail.com>
 <e00f6e66-fd51-5b55-6cd1-ec9abe038022@gmail.com>
 <77fff5aa-ddd2-6bc7-f0b4-46b93e87338b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <77fff5aa-ddd2-6bc7-f0b4-46b93e87338b@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 11:23:15AM +0200, Adrian Hunter wrote:
> On 6/12/22 02:11, Florian Fainelli wrote:
> > On 12/5/22 14:48, Florian Fainelli wrote:
> >> On 12/5/22 14:28, Jon Hunter wrote:
> >>> Hi Greg,
> >>>
> >>> On 05/12/2022 19:08, Greg Kroah-Hartman wrote:
> >>>> This is the start of the stable review cycle for the 4.9.335 release.
> >>>> There are 62 patches in this series, all will be posted as a response
> >>>> to this one.  If anyone has any issues with these being applied, please
> >>>> let me know.
> >>>>
> >>>> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> >>>> Anything received after that time might be too late.
> >>>>
> >>>> The whole patch series can be found in one patch at:
> >>>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.335-rc1.gz
> >>>> or in the git tree and branch at:
> >>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> >>>> and the diffstat can be found below.
> >>>>
> >>>> thanks,
> >>>>
> >>>> greg k-h
> >>>>
> >>>> -------------
> >>>> Pseudo-Shortlog of commits:
> >>>>
> >>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>>      Linux 4.9.335-rc1
> >>>>
> >>>> Adrian Hunter <adrian.hunter@intel.com>
> >>>>      mmc: sdhci: Fix voltage switch delay
> >>>
> >>>
> >>> I am seeing a boot regression on a couple boards and bisect is pointing to the above commit.
> >>
> >> Same thing here, getting a hard lock for our devices with the SDHCI controller enabled, sometimes we are lucky to see the following:
> >>
> >> [    4.790367] mmc0: SDHCI controller on 84b0000.sdhci [84b0000.sdhci] using ADMA 64-bit
> >> [   25.802351] INFO: rcu_sched detected stalls on CPUs/tasks:
> >> [   25.807871]  1-...: (1 GPs behind) idle=561/140000000000000/0 softirq=728/728 fqs=5252
> >> [   25.815892]  (detected by 0, t=21017 jiffies, g=61, c=60, q=55)
> >> [   25.821834] Task dump for CPU 1:
> >> [   25.825069] kworker/1:1     R  running task        0   509      2 0x00000002
> >> [   25.832164] Workqueue: events_freezable mmc_rescan
> >> [   25.836974] Backtrace:
> >> [   25.839440] [<ce32fea4>] (0xce32fea4) from [<ce32fed4>] (0xce32fed4)
> >> [   25.845803] Backtrace aborted due to bad frame pointer <cd2f0a54>
> >>
> >> Also confirmed that reverting that change ("mmc: sdhci: Fix voltage switch delay") allows devices to boot properly.
> >>
> >> Had not a chance to test the change when submitted for mainline despite being copied, sorry about that.
> >>
> >> Since that specific commit is also included in the other stable trees (5.4, 5.10, 5.15 and 6.0) I will let you know whether the same issue is present in those trees shortly thereafter.
> > 
> > This only appears to impact 4.9, Adrian is there a missing functional dependency for "mmc: sdhci: Fix voltage switch delay" to work correctly on the 4.9 kernel?
> 
> The thing that leaps to mind is that "mmc: sdhci: Fix voltage switch delay" returns out of sdhci_set_ios() without releasing the spinlock which was removed in later kernels.  I expect below would help, but a revert might allow a more considered response - it is a holiday here today.

I'll just drop them for now from 4.9, thanks!

greg k-h
