Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333C95633B4
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 14:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiGAMvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 08:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiGAMvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 08:51:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8847A33360;
        Fri,  1 Jul 2022 05:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C8C3B80D20;
        Fri,  1 Jul 2022 12:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95901C3411E;
        Fri,  1 Jul 2022 12:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656679895;
        bh=0eZCwmWUf0Pr71aLNMDwbeH8YMHTIJoFZCQ9YG/ubkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u+e0ZdSrmvfJo7nLQcw/tIACQ2DWGy7VzU+rX7PzH5MIyvuXOkDVlb1de8xVGpMXi
         GixfV053DRu5A6UBKyw66fTFwaSDG1TwY0zmRL4/gW5hk4YUeqFpVp1ftk9a77UWPg
         r9m4JRdsoQhb6F9kz8CEo3TlqXEW0zuUa7RBnFH6jarvWqfoi9M0avciZ6dkcCnZU/
         rv1YdZn/E0EIOPqrVI116l0iUqcmP7TDW49d0G7eCCrRj8yangc8fZUxsmhE6VQGtu
         tTYkl2aYc02O+8l6df6dRzbxwu72ti/w9P1/BLdYQ9L7CpEd1LC/Koo9dfS3AXMc7g
         S1HCaUHYnqfbw==
Date:   Fri, 1 Jul 2022 14:51:29 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/28] 5.15.52-rc1 review
Message-ID: <20220701125129.s4slwczhjslykv4b@wittgenstein>
References: <20220630133232.926711493@linuxfoundation.org>
 <20220701085123.j6xxzjp2oiokb55p@wittgenstein>
 <Yr63DJxPwsE0rMVp@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yr63DJxPwsE0rMVp@kroah.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 01, 2022 at 10:57:48AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 01, 2022 at 10:51:23AM +0200, Christian Brauner wrote:
> > On Thu, Jun 30, 2022 at 03:46:56PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.52 release.
> > > There are 28 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.52-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Ran xfstests after the backport series I gave you:
> > 
> > sudo ./check -g idmapped (xfs, ext4, btrfs, ...)
> > sudo ./runltp -f fs_perms_simple,fs_bind,containers,cap_bounds,cve,uevent,filecaps
> > 
> > all tests pass.
> 
> Nice!
> 
> Want to respond with a Tested-by so that the tools will pick it up for
> the release commit?

Absolutely,
Tested-by: Christian Brauner (Microsoft) <brauner@kernel.org> 
