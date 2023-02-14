Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301B1696846
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 16:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjBNPj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 10:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjBNPj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 10:39:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F03211C3;
        Tue, 14 Feb 2023 07:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TbTmBsVhLS3xTFi9MDeIoKuL1H6cXmj+Hl0VBWR0AgA=; b=b389amDwLf74veKQIEV7laNsXJ
        C8OENdXsTGBTwPScLOmeZp3pxphLKJOs/AxjWYk406uXq1Opl6V+YvxtLbZOUGbGEVcOmZ13gAp/Y
        Lw43QtLL91qDnbGCDKCBboBkf9GvM/1/rVQqCq0RMBcoPEDjPjWKVTmNyAS1NUeQUTZ1NEeOxf/E5
        IaJiTnnyjrZOx4EzNXMoSOUi7Yv1HXcIgp9RH65BVpia2wCeJxsf6sLk8zoLXBIqaDsEaa9kSddUx
        erV6mTSF6ATLibeKzcl82w2424Kj/xk4R+gVvROqLnhwkcpVykEssdrpOhKuwP/RiCVnmc+X2eS1Q
        1Z23J35A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48864)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pRxPM-0005gl-Bs; Tue, 14 Feb 2023 15:39:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pRxPK-000427-I1; Tue, 14 Feb 2023 15:39:50 +0000
Date:   Tue, 14 Feb 2023 15:39:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sasha Levin <sashal@kernel.org>
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
Message-ID: <Y+urRgBmITDFjI8o@shell.armlinux.org.uk>
References: <20230213144745.696901179@linuxfoundation.org>
 <cc3f4cfb-adbc-c3b7-1c21-bb28e98499d8@gmail.com>
 <Y+soPsujgwChdgr7@kroah.com>
 <Y+ugWb4vsEyvd9W0@shell.armlinux.org.uk>
 <Y+ukMhMS7DvuFLOJ@sashalap>
 <Y+uoAEzpM588j/lw@shell.armlinux.org.uk>
 <Y+upu2+mLUG9R6+/@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+upu2+mLUG9R6+/@sashalap>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 10:33:15AM -0500, Sasha Levin wrote:
> On Tue, Feb 14, 2023 at 03:25:52PM +0000, Russell King (Oracle) wrote:
> > On Tue, Feb 14, 2023 at 10:09:38AM -0500, Sasha Levin wrote:
> > > On Tue, Feb 14, 2023 at 02:53:13PM +0000, Russell King (Oracle) wrote:
> > > > On Tue, Feb 14, 2023 at 07:20:46AM +0100, Greg Kroah-Hartman wrote:
> > > > > On Mon, Feb 13, 2023 at 11:50:24AM -0800, Florian Fainelli wrote:
> > > > > > On 2/13/23 06:49, Greg Kroah-Hartman wrote:
> > > > > > > This is the start of the stable review cycle for the 5.10.168 release.
> > > > > > > There are 139 patches in this series, all will be posted as a response
> > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > let me know.
> > > > > > >
> > > > > > > Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> > > > > > > Anything received after that time might be too late.
> > > > > > >
> > > > > > > The whole patch series can be found in one patch at:
> > > > > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc1.gz
> > > > > > > or in the git tree and branch at:
> > > > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > > > > > and the diffstat can be found below.
> > > > > > >
> > > > > > > thanks,
> > > > > > >
> > > > > > > greg k-h
> > > > > >
> > > > > > There is a regression coming from:
> > > > > >
> > > > > > nvmem: core: fix registration vs use race
> > > > > >
> > > > > > which causes the following to happen for MTD devices:
> > > > > >
> > > > > > [    6.031640] kobject_add_internal failed for mtd0 with -EEXIST, don't try
> > > > > > to register things with the same name in the same directory.
> > > > > > [    7.846965] spi-nor: probe of spi0.0 failed with error -17
> > > > > >
> > > > > > attached is a full log with the call trace. This does not happen with
> > > > > > v6.2-rc8 where the MTD partitions are successfully registered.
> > > > >
> > > > > Can you use `git bisect` to find the offending commit?
> > > >
> > > > The reason for this is because, due to how my patch series was
> > > > backported, you have ended up with nvmem_register() initialising
> > > > its embedded device, and then calling device_add() on it _twice_.
> > > >
> > > > Basically, the backport of:
> > > >
> > > > 	"nvmem: core: fix registration vs use race"
> > > >
> > > > is broken, because the original patch _moved_ the device_add() and
> > > > that has not been carried forward to whatever got applied to stable
> > > > trees.
> > > >
> > > > It looks like the 5.15-stable version of this patch was correct.
> > > >
> > > > Maybe whoever tried to fixup the failure needs to try again?
> > > 
> > > I've dropped the backport series from both 5.15 and 5.10.
> > 
> > So you've dropped what looks to be a perfectly good backport in 5.15,
> > and all of the 5.10 despite it just being the last patch which is the
> > problem. Sounds like a total over-reaction to me.
> 
> The context is that we want to get the releases out today, and neither
> of us will have time to verify that we did the right thing in 5.15 in
> the next few hours.
> 
> I'm just defering it to the next release cycle which is probably a few
> days away, not completely throwing it away.... why is it such a big
> deal?

Maybe because you didn't explain that it was being dropped
_temporarily_?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
