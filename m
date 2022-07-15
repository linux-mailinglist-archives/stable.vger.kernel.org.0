Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528BA57606E
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 13:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiGOL3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 07:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiGOL3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 07:29:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690A587F51;
        Fri, 15 Jul 2022 04:27:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D97BB82B96;
        Fri, 15 Jul 2022 11:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828EEC34115;
        Fri, 15 Jul 2022 11:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657884474;
        bh=7Ut7Z7zkcb2r4iw5c/4mZyCXflm0G+uWzAn6npSUFX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KIbMP7uMEwQTaCegEntvF5xNm87R9Vcx6c4a5l4eJ+HU1xpXddar3zc3nyOfX5z9k
         4pZ//LwcDM+4JaAz+sFqRdcAdnOziZpQEmi+xACztITDJSpHI0xs6vJmm2hgmMHXaf
         XWML6RHO40ZUPWDOzo6bzw9RloNFMMJIjMnXWaik=
Date:   Fri, 15 Jul 2022 13:27:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
Message-ID: <YtFPN7ctriCPVNWs@kroah.com>
References: <20220712183236.931648980@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 08:38:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.12 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.

With all the problems that this, and the 5.15.y and 5.10.y trees are
having right now, I'm going to postpone this whole set of -rc releases
and get to them next week, when all of the needed fixup patches have hit
Linus's tree.

Sorry for the delay all, and thank you to everyone for all of the
testing.  The problems are purely due to the fact that we were forced to
do this type of work "in private" with very limited ability for testing
by the normal larger kernel community like we rely on.  We don't have
fancy or huge private testing labs where we can do all of this work as
we are an open source project, and we rely on open testing in public.

So thanks all for your understanding with the delay.  If you _really_
need protection from RETBLEED, you can grab these patches now, as maybe
the corner cases we have hit so far don't affect you.  Otherwise they
should be ready next week, and I'll do a whole new round of -rc1 with
them.

greg k-h
