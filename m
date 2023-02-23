Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B108F6A0E15
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 17:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbjBWQdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 11:33:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234113AbjBWQdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 11:33:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8A11C596;
        Thu, 23 Feb 2023 08:33:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CD7A61745;
        Thu, 23 Feb 2023 16:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19C6C433D2;
        Thu, 23 Feb 2023 16:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677169997;
        bh=NjJW6XDSoIc601Vvr8eNDHLQaJx/X1Ai+x6GDT6f4k4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0su6GgDUGW6j2Dj46q6i++XAJaDG9nNpOry81Y7zAI/p9p49UQjSjDeuijpxuqMTf
         qsQq2l+FsSa+Qpl/THTmBZg3j1zzJE3Qz2nKrXlUL+Cf/gQJPFRrRL0kKq4+cmP5uZ
         gOvF2Shj+T3+4957wWOkG7tdrd4CjndnPAEPLn+w=
Date:   Thu, 23 Feb 2023 17:33:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Message-ID: <Y/eVSi4ZTcOmPBTv@kroah.com>
References: <20230223141542.672463796@linuxfoundation.org>
 <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 07:36:39AM -0800, Guenter Roeck wrote:
> On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.96 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> > Anything received after that time might be too late.
> > 
> 
> 
> $ git describe
> v5.15.95-38-gd6f4f9746d40
> groeck@server:~/src/linux-stable$ !ls
> ls -l scripts/pahole-version.sh
> -rw-rw-r-- 1 groeck groeck 269 Feb 23 07:33 scripts/pahole-version.sh
> 
> This results in:
> 
> make[1]: Entering directory '/tmp/buildbot-builddir'
> scripts/pahole-flags.sh: 10: /opt/buildbot/slave/stable-queue-5.15/build/scripts/pahole-version.sh: Permission denied
> scripts/pahole-flags.sh: 12: [: Illegal number:
> scripts/pahole-flags.sh: 16: [: Illegal number:
> scripts/pahole-flags.sh: 20: [: Illegal number:
> 
> and all builds fail for me.

This is a fun thing, the patch shows it being set to 0755, so `git am`
should be doing the right thing here.  Let me dig to see if I can change
something in my scripts to resolve this...

thanks,

greg k-h
