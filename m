Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA9D610ED8
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 12:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiJ1Km2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 06:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiJ1Km1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 06:42:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBA7252B8;
        Fri, 28 Oct 2022 03:42:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FD35B80139;
        Fri, 28 Oct 2022 10:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781BCC433D6;
        Fri, 28 Oct 2022 10:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666953744;
        bh=Gam20qC1+7dITgaY1kkmww2hgnCHG9A1vU6xUX6LcIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fx233X2td42L0ZoO57xGR6UMywW2sI1KvnhnEtIXv1XJuyroeYRAvxeODzENteKrr
         Drk0Ks6kBoBVYnHAM1KLKNYAYmL8kfV29Rxa4RJpXg04TQLtnc5VBW/3XepaEbpI/d
         CRJ+9XWDAKMzZLYgUXgV6JVRduRH7H7QnGKbaR7A=
Date:   Fri, 28 Oct 2022 12:42:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/79] 5.15.76-rc1 review
Message-ID: <Y1uyDV3i2heNmyne@kroah.com>
References: <20221027165054.917467648@linuxfoundation.org>
 <3624500e-8e07-ac95-8b15-2843a3c9d7c4@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3624500e-8e07-ac95-8b15-2843a3c9d7c4@roeck-us.net>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 27, 2022 at 11:18:42AM -0700, Guenter Roeck wrote:
> On 10/27/22 09:54, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.76 release.
> > There are 79 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> > Anything received after that time might be too late.
> > 
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> In file included from drivers/cpufreq/tegra194-cpufreq.c:10:
> drivers/cpufreq/tegra194-cpufreq.c:282:25: error: 'tegra194_cpufreq_of_match' undeclared here (not in a function); did you mean 'tegra194_cpufreq_data'?
>   282 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/module.h:244:15: note: in definition of macro 'MODULE_DEVICE_TABLE'
>   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
>       |               ^~~~
> include/linux/module.h:244:21: error: conflicting types for '__mod_of__tegra194_cpufreq_of_match_device_table'; have 'const struct of_device_id[2]'
>   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
>       |                     ^~~~~~
> drivers/cpufreq/tegra194-cpufreq.c:417:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
>   417 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
>       | ^~~~~~~~~~~~~~~~~~~
> include/linux/module.h:244:21: note: previous declaration of '__mod_of__tegra194_cpufreq_of_match_device_table' with type 'int'
>   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
>       |                     ^~~~~~
> drivers/cpufreq/tegra194-cpufreq.c:282:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
>   282 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
>       | ^~~~~~~~~~~~~~~~~~~
> make[3]: [scripts/Makefile.build:289: drivers/cpufreq/tegra194-cpufreq.o] Error 1 (ignored)
> ERROR: modpost: missing MODULE_LICENSE() in drivers/cpufreq/tegra194-cpufreq.o
> make[2]: [scripts/Makefile.modpost:133: modules-only.symvers] Error 1 (ignored)
> 
> I don't know what exactly happened, but commit b281adc68db8 ("cpufreq:
> tegra194: Fix module loading") introduces a second MODULE_DEVICE_TABLE
> at the wrong location, causing the build failure.

Ah, the "Fixes:" tag was wrong in the original commit in Linus's tree.
It should have said:
	Fixes: 0839ed1fd7ac ("cpufreq: tegra194: add soc data to support multiple soc")
which removed the existing MODULE_DEVICE_TABLE() entry.

So only kernels newer than 5.19 need this.  I'll go drop it from the
5.10.y and 5.15.y queues, thanks!

greg k-h
