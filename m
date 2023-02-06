Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BC468B613
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 08:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjBFHMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 02:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBFHMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 02:12:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602D6CE;
        Sun,  5 Feb 2023 23:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E13C160CE8;
        Mon,  6 Feb 2023 07:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56D3C433D2;
        Mon,  6 Feb 2023 07:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675667564;
        bh=LsLH3jBO12QKh3Xi1FZhgwHQZkDfk6ZGnO+uu7Ij+Cg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Evdhd9dLdsAAmEhE5K/dFDt6VYM5/G2luLtgqLa/xCoawqvnwkQkqNgwxZlu/YhJh
         r0/QipWMHqBk3ct51Y+zS7rGgy41Wvpw/A0pOeMsYk0E4rWZfPJnCCYd2/PKm5DBh2
         CzH68o8K5VJHPGUOtVU5WfaJPVzzCu7ZDebw3YGs=
Date:   Mon, 6 Feb 2023 08:12:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ron Economos <re@w6rz.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/20] 5.15.92-rc1 review
Message-ID: <Y+CoaR9hEzyB+6s5@kroah.com>
References: <20230203101007.985835823@linuxfoundation.org>
 <de146bc5-50b8-f347-31cf-70b5e93a4541@w6rz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de146bc5-50b8-f347-31cf-70b5e93a4541@w6rz.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 04, 2023 at 12:55:36AM -0800, Ron Economos wrote:
> On 2/3/23 2:13 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.92 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.92-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Built and booted successfully on RISC-V RV64 (HiFive Unmatched).
> 
> Tested-by: Ron Economos <re@w6rz.net>
> 

Thanks for testing and letting me know,

greg k-h
