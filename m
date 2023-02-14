Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548E0696824
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 16:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjBNPdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 10:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjBNPdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 10:33:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7BE4EEC;
        Tue, 14 Feb 2023 07:33:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71587B81DDC;
        Tue, 14 Feb 2023 15:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9E8C433EF;
        Tue, 14 Feb 2023 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676388796;
        bh=aHy3Iiimaf1qswXNWdy2gKuRpQCCTYiwjKtlDK5+Nko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OKJBy5yG+mjxCmCNmSvuQ13jQ3a8EC3iKLd04yw7dNpJnlseSQ+CpGYarmgX0Ii1C
         M3jv5abdwIpI60q2oUUtRXYoQAmBaOmlsggQJfRPWouvZ/AGEYlzQNK8ZVMH5PS1qk
         WYGlSOkxPxODivJdfmEh03oXzkeWgfSLQpzqO6bbRVfZn93B9rKxEiYflBEsyv3ZUB
         Jyb+OFwbWPQkIgaC/b0lSlp5BqDbFUADR2MOv0lUa8C8NBosJjxHRUQHb11gPkhowj
         aqZP/LNwKugpUTaYtw/9m2eHw0aeSp/M3QVd/r30UCd5gfcy3Aru8bEhINzM4NQJiU
         ektnJ7CZJ/DSQ==
Date:   Tue, 14 Feb 2023 10:33:15 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Message-ID: <Y+upu2+mLUG9R6+/@sashalap>
References: <20230213144745.696901179@linuxfoundation.org>
 <cc3f4cfb-adbc-c3b7-1c21-bb28e98499d8@gmail.com>
 <Y+soPsujgwChdgr7@kroah.com>
 <Y+ugWb4vsEyvd9W0@shell.armlinux.org.uk>
 <Y+ukMhMS7DvuFLOJ@sashalap>
 <Y+uoAEzpM588j/lw@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y+uoAEzpM588j/lw@shell.armlinux.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 03:25:52PM +0000, Russell King (Oracle) wrote:
>On Tue, Feb 14, 2023 at 10:09:38AM -0500, Sasha Levin wrote:
>> On Tue, Feb 14, 2023 at 02:53:13PM +0000, Russell King (Oracle) wrote:
>> > On Tue, Feb 14, 2023 at 07:20:46AM +0100, Greg Kroah-Hartman wrote:
>> > > On Mon, Feb 13, 2023 at 11:50:24AM -0800, Florian Fainelli wrote:
>> > > > On 2/13/23 06:49, Greg Kroah-Hartman wrote:
>> > > > > This is the start of the stable review cycle for the 5.10.168 release.
>> > > > > There are 139 patches in this series, all will be posted as a response
>> > > > > to this one.  If anyone has any issues with these being applied, please
>> > > > > let me know.
>> > > > >
>> > > > > Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
>> > > > > Anything received after that time might be too late.
>> > > > >
>> > > > > The whole patch series can be found in one patch at:
>> > > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc1.gz
>> > > > > or in the git tree and branch at:
>> > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>> > > > > and the diffstat can be found below.
>> > > > >
>> > > > > thanks,
>> > > > >
>> > > > > greg k-h
>> > > >
>> > > > There is a regression coming from:
>> > > >
>> > > > nvmem: core: fix registration vs use race
>> > > >
>> > > > which causes the following to happen for MTD devices:
>> > > >
>> > > > [    6.031640] kobject_add_internal failed for mtd0 with -EEXIST, don't try
>> > > > to register things with the same name in the same directory.
>> > > > [    7.846965] spi-nor: probe of spi0.0 failed with error -17
>> > > >
>> > > > attached is a full log with the call trace. This does not happen with
>> > > > v6.2-rc8 where the MTD partitions are successfully registered.
>> > >
>> > > Can you use `git bisect` to find the offending commit?
>> >
>> > The reason for this is because, due to how my patch series was
>> > backported, you have ended up with nvmem_register() initialising
>> > its embedded device, and then calling device_add() on it _twice_.
>> >
>> > Basically, the backport of:
>> >
>> > 	"nvmem: core: fix registration vs use race"
>> >
>> > is broken, because the original patch _moved_ the device_add() and
>> > that has not been carried forward to whatever got applied to stable
>> > trees.
>> >
>> > It looks like the 5.15-stable version of this patch was correct.
>> >
>> > Maybe whoever tried to fixup the failure needs to try again?
>>
>> I've dropped the backport series from both 5.15 and 5.10.
>
>So you've dropped what looks to be a perfectly good backport in 5.15,
>and all of the 5.10 despite it just being the last patch which is the
>problem. Sounds like a total over-reaction to me.

The context is that we want to get the releases out today, and neither
of us will have time to verify that we did the right thing in 5.15 in
the next few hours.

I'm just defering it to the next release cycle which is probably a few
days away, not completely throwing it away.... why is it such a big
deal?

-- 
Thanks,
Sasha
