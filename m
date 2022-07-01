Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F51562EF9
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 10:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiGAIwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 04:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbiGAIwT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 04:52:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29E274DCA;
        Fri,  1 Jul 2022 01:51:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13AE6B82EF6;
        Fri,  1 Jul 2022 08:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08F8C3411E;
        Fri,  1 Jul 2022 08:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656665489;
        bh=+QSL0m0eIiziPqFqgzuKDd8TeSEVNhR96nMUCfU0Q+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xzsjo3dtfqkBJJG6aMOkqsPefCM28aZ0GOJJnxCcw4faSeCr1EVnNkgBWhqFctMu/
         3b4FUJCy5QiAr5sWOipZJM093r6nwK182+zRpw/28zGWW2uqrf0gJ2w41C532oFqpN
         NqO41lsFOAg7GsXuEt7505B6S/BJYOWPHLwtkEpoBQzieTT8SBvHYV02et/INMahLi
         CXu2NVbwwvjOtL9cdsmK0hZBeM5Uy/awYLUaR8HDzdyepDYok8HsQ+AKYH8BtZRU1d
         uaMF7Jh4/OFbDb3FkGBTM8K57NoIa15z0w+jInNluJIgaTY2PKi7ON/tRlcM7Z4+X4
         KncOtU2x9oBFg==
Date:   Fri, 1 Jul 2022 10:51:23 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/28] 5.15.52-rc1 review
Message-ID: <20220701085123.j6xxzjp2oiokb55p@wittgenstein>
References: <20220630133232.926711493@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220630133232.926711493@linuxfoundation.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 30, 2022 at 03:46:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.52 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.52-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Ran xfstests after the backport series I gave you:

sudo ./check -g idmapped (xfs, ext4, btrfs, ...)
sudo ./runltp -f fs_perms_simple,fs_bind,containers,cap_bounds,cve,uevent,filecaps

all tests pass.

Thank you!
Christian
