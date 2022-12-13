Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D19C64B80F
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 16:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiLMPHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 10:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236066AbiLMPHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 10:07:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAAB218A7;
        Tue, 13 Dec 2022 07:07:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 993476158D;
        Tue, 13 Dec 2022 15:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D26FC433D2;
        Tue, 13 Dec 2022 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670944045;
        bh=X59SuqTKmCW8FjdihUzqEkUaQKUu+lUWXER55/hIJOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1N9DAe5AAJVetVEYK/fLMePCiS7CBFq0YlQmK/A4xIM2Oe21BhGx8bfgsmhJi4cBa
         BtEPPqOKuVTiuWBgUW5LxSJfEKUEXV7L29WPI7DLwkfHbc/vOuSh9/YWFcph6s2I7n
         52MRoV7ux2FsjItBf5SJVwT7BDbPwqUUyPom8+uE=
Date:   Tue, 13 Dec 2022 16:07:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH 5.4 00/67] 5.4.227-rc1 review
Message-ID: <Y5iVK4Yjre7cKhWH@kroah.com>
References: <20221212130917.599345531@linuxfoundation.org>
 <CA+G9fYtdgLx0hrtGk7G8Jvt2GhY-FoCTp0KtF8ngGix289G2QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtdgLx0hrtGk7G8Jvt2GhY-FoCTp0KtF8ngGix289G2QQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 02:50:21PM +0530, Naresh Kamboju wrote:
> On Mon, 12 Dec 2022 at 18:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.227 release.
> > There are 67 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.227-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> NOTE:
> Following build warning found,
> 
> mm/hugetlb.c: In function 'follow_huge_pmd_pte':
> mm/hugetlb.c:5191:1: warning: label 'out' defined but not used [-Wunused-label]
>  5191 | out:
>       | ^~~
> 
> details of commit causing this build warning.
>    mm/hugetlb: fix races when looking up a CONT-PTE/PMD size hugetlb page
>    commit fac35ba763ed07ba93154c95ffc0c4a55023707f upstream.

Thanks, I'll go drop that commit now.

greg k-h
