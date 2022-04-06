Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938584F6367
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 17:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbiDFP26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 11:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236144AbiDFP2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 11:28:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B0749FA34;
        Wed,  6 Apr 2022 05:28:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 109F061AEC;
        Wed,  6 Apr 2022 12:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8611C385A3;
        Wed,  6 Apr 2022 12:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649248099;
        bh=S8aLImcHU3dDFVrMBdNfuI4XqRinX0SocFRJGZO3bLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mzhOY7NJaltNxw9eq13CtHGzUKhfw2JgKRQE6sXtJ4Vahv2iVgNEmG922JOANlSa5
         XlaCOINyLS6D6LlTeD464eoKiEtabNCCsWziiqoFhrVzwxFn2AD+d9/DYdjOFyewcW
         KUVJIsTDMwu6jiZemffmCdt3TiHyg6yHOHfvkt0A=
Date:   Wed, 6 Apr 2022 14:28:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Justin Forbes <jforbes@fedoraproject.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 0000/1126] 5.17.2-rc1 review
Message-ID: <Yk2HYLNuhVp1Qmkq@kroah.com>
References: <20220405070407.513532867@linuxfoundation.org>
 <YkzgWEyDZXFrCbju@fedora64.linuxtx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkzgWEyDZXFrCbju@fedora64.linuxtx.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 05, 2022 at 07:35:36PM -0500, Justin Forbes wrote:
> On Tue, Apr 05, 2022 at 09:12:27AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.17.2 release.
> > There are 1126 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Apr 2022 07:01:33 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> This fails to build on x86_64, but builds on all other architectures for
> Fedora using the fedora configs. Specifically 
> [PATCH 5.17 0943/1126] ASoC: Intel: sof_es8336: use NHLT information to set dmic and SSP
> is missing a dependent patch, upstream commit 679aa83a0fb70dcbf9e97cbdfd573e6fc8bf9b1a
> ASoC: soc-acpi: add information on I2S/TDM link mask.  Applying this
> patch makes x86_64 build again.

I've just dropped the offending commit, thanks!

greg k-h
