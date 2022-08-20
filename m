Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AA459B276
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiHUHBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiHUHA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA53026130;
        Sun, 21 Aug 2022 00:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7673EB80BAB;
        Sun, 21 Aug 2022 07:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65784C433C1;
        Sun, 21 Aug 2022 07:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065224;
        bh=ffHVVFpOVAC4haOmS4JIHeJAyZ6zq1a1Ad3JiDFnatU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QEmcV5/MSyN0wBZMyqvnJlOrxO5+tlBcUls5efQvzdG4Bf/xErq6+If8PLBcz5of1
         hgT7jPQXiG6Au0VZzTGSX/yQiD+VZgnx3PRerqH4T1NRa5deQvEZgeDEJ5XiwVrTzK
         4gM6aVO4bel7Mzlw2QHaUOLbA1XEtVLeCjcpQlVg=
Date:   Sat, 20 Aug 2022 20:17:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH 5.15 00/14] 5.15.62-rc1 review
Message-ID: <YwElVs4PwcPwQGsp@kroah.com>
References: <20220819153711.658766010@linuxfoundation.org>
 <CA+G9fYtXnZP2vdAi4eU_ApC_YFz6TqTd6Eh5Mumb2=0Y_dK5Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtXnZP2vdAi4eU_ApC_YFz6TqTd6Eh5Mumb2=0Y_dK5Yw@mail.gmail.com>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 20, 2022 at 01:57:05PM +0530, Naresh Kamboju wrote:
> On Fri, 19 Aug 2022 at 21:11, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.62 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.62-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro's test farm.
> Following regression found on s390.
> 
> > Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> >     kexec_file: drop weak attribute from functions
> 
> The s390 defconfig build failed on stable-rc 5.15 with gcc-11 and clang.
> 
> 
> arch/s390/kernel/machine_kexec_file.c:336:5: error: redefinition of
> 'arch_kexec_kernel_image_probe'
> int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
>     ^
> include/linux/kexec.h:190:1: note: previous definition is here
> arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
> unsigned long buf_len)
> ^
> 1 error generated.
> 

argh, these kexec patches are such a pain.  I'll go drop them from 5.15
now and push out a -rc2 that hopefully will fix this.

thanks,

greg k-h
