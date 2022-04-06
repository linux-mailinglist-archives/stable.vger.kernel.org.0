Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52E44F6322
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiDFPYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236478AbiDFPXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:23:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A574855CFE9;
        Wed,  6 Apr 2022 05:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D981EB81C87;
        Wed,  6 Apr 2022 12:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882B4C385A3;
        Wed,  6 Apr 2022 12:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649247790;
        bh=eHm0dErpwo30/M5xumPzcun9XsFwEuyogZ+rXajt7gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lGUEhKHjVtCTEE1JsnWrL0eiPDTCBB2lfHuOdSIS5BNKYFGsCVbcymu4z/OvcbkRs
         j0OmLgPvuDAE7M4LiXS5oMvJ7udy8BQtrKDb1CcnWN/20vXSaSR3swO2+YmOROx+W4
         IuAT19YrB9vbptMxyDJ3oDCEqUVJQhPKExh/QNng=
Date:   Wed, 6 Apr 2022 14:23:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        ranjani.sridharan@linux.intel.com
Subject: Re: [PATCH 5.15 000/913] 5.15.33-rc1 review
Message-ID: <Yk2GK3QRGYJqWu1m@kroah.com>
References: <20220405070339.801210740@linuxfoundation.org>
 <4273d632-9686-3809-2ef0-e87bb431f798@linuxfoundation.org>
 <CADYN=9+=Z=9g2r6-14kY9OQets+K=tzVeejiqTJyDJgKctddYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9+=Z=9g2r6-14kY9OQets+K=tzVeejiqTJyDJgKctddYw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 11:52:18AM +0200, Anders Roxell wrote:
> On Wed, 6 Apr 2022 at 01:06, Shuah Khan <skhan@linuxfoundation.org> wrote:
> >
> > On 4/5/22 1:17 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.33 release.
> > > There are 913 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.33-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > >
> >
> > Build failed on my system. The following is the problem commit. There
> > are no changes to the config between 5.15.32 and this build.
> >
> > Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> >      ASoC: SOF: Intel: hda: Remove link assignment limitation
> 
> I saw the same build error, after applying the following patches it
> builds fine again.
> 
> a792bfc1c2bc ("ASoC: SOF: Intel: hda-stream: limit PROCEN workaround")
> 81ed6770ba67 ("ASoC: SOF: Intel: hda: expose get_chip_info()")

Thanks, but I'll just go drop the offending commit here. If this is
still needed in the stable trees, can someone email stable@vger with the
needed information and I will be glad to reconsider it.

greg k-h
