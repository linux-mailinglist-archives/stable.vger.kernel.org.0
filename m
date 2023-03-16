Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5C56BC805
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 09:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCPIAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 04:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjCPIAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 04:00:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FCC5FDA;
        Thu, 16 Mar 2023 00:59:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66C6761F63;
        Thu, 16 Mar 2023 07:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DA6C433D2;
        Thu, 16 Mar 2023 07:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678953596;
        bh=RBthfk4j3fRZwzUCODUd5Qdwu+15KXppdNriYMiR/CM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dyOOz/FQHkGv2fCHU7PmeKC5e+OOdAZd/Nd+zne8Cmva3rxZh2+Y5NfxTJ4s4cTV+
         oOZXCMcLnwCH9fEfTEiUDzZzKLYhNJPY2inVaAqZF7AXt2mtjPo9o2OoIxLb08gXH7
         Sxbd3pPaFhX9BnSM90wjdgm7vHI7CO5wsLoMhckE=
Date:   Thu, 16 Mar 2023 08:59:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/145] 5.15.103-rc1 review
Message-ID: <ZBLMei6P5/ZNiCZ5@kroah.com>
References: <20230315115738.951067403@linuxfoundation.org>
 <6ed70071-96a3-4f79-17e4-c94f3ef868e2@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ed70071-96a3-4f79-17e4-c94f3ef868e2@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 08:29:45AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 15/03/23 06:11, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.103 release.
> > There are 145 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> We're seeing PowerPC build failures like the following (GCC-8, GCC-12, Clang-16):
> 
> -----8<-----
> In file included from /builds/linux/drivers/usb/host/ehci-hcd.c:1298:
> /builds/linux/drivers/usb/host/ehci-ppc-of.c:122:13: error: use of undeclared identifier 'NO_IRQ'
>         if (irq == NO_IRQ) {
>                    ^
> 1 error generated.
> ----->8-----

Will be fixed in -rc2

> 
> Then, Perf fails on Arm and i386 with GCC-12:
> 
> -----8<-----
> In function 'parse_events_term__num',
>     inlined from 'parse_events_multi_pmu_add' at util/parse-events.c:1687:9:
> util/parse-events.c:3100:64: error: array subscript 'YYLTYPE[0]' is partly outside array bounds of 'char[4]' [-Werror=array-bounds]
>  3100 |                 .err_term  = loc_term ? loc_term->first_column : 0,
>       |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
> util/parse-events.c: In function 'parse_events_multi_pmu_add':
> util/parse-events.c:1678:39: note: object 'config' of size 4
>  1678 |                                 char *config;
>       |                                       ^~~~~~
> cc1: all warnings being treated as errors
> ----->8-----

This is odd as this file isn't modified, but other build fixes for perf
for 5.15 were made.  Let's see if this still happens in -rc2 and if so,
if you could bisect to track down the offending commit that would be
great.

thanks,

greg k-h
