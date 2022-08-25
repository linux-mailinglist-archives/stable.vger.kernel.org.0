Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888F35A0CB9
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 11:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbiHYJfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 05:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239083AbiHYJfR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 05:35:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D06EA6AC8;
        Thu, 25 Aug 2022 02:35:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E9DAB8275C;
        Thu, 25 Aug 2022 09:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EFB6C433C1;
        Thu, 25 Aug 2022 09:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661420113;
        bh=wnNNBsD21VnG36hN5SKAwoYJpViNkoDmHGgamkOXTX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=noKJxVfTAQ2GCyTeZoWzR8amLMUyagJJlWlIJ+SVwZtrXBU9S+7hpgdg11Al6u3+1
         8uomz1mTLp67XPDEcMGikPYawoc6qk7+ITVL9tqKJW8Gn68fic1AvQm/fd4GpaylC2
         07sHSA1EEfbOnbNjNw7LMrYDBFe3Nux52RGKCEp8=
Date:   Thu, 25 Aug 2022 11:35:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     zhouzhixiu <zhouzhixiu@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "slade@sladewatkins.com" <slade@sladewatkins.com>
Subject: Re: [PATCH 5.4 000/389] 5.4.211-rc1 review
Message-ID: <YwdCTk+2ouwZkO6u@kroah.com>
References: <20220823080115.331990024@linuxfoundation.org>
 <3d191fcd-62bb-323f-ea2b-cf5599a75b07@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d191fcd-62bb-323f-ea2b-cf5599a75b07@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 25, 2022 at 05:20:46PM +0800, zhouzhixiu wrote:
> 
> On 2022/8/23 16:21, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.211 release.
> > There are 389 patches in this series, all will be posted as a response
> > to this one. If anyone has any issues with these being applied, please
> > let me know. Responses should be made by Thu, 25 Aug 2022 08:00:15
> > +0000. Anything received after that time might be too late. The whole
> > patch series can be found in one patch at: https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.211-rc1.gz
> > or in the git tree and branch at:
> > git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > linux-5.4.y and the diffstat can be found below. thanks, greg k-h
> 
> Tested on arm64 and x86 for 5.4.211-rc1,
> 
> Kernel repo:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> 
> Branch: linux-5.10.yVersion:
> 5.4.211-rc1Commit:1cece69eaa889a27cf3e9f2051fcc57eda957271Compiler: gcc
> version 7.3.0 (GCC) arm64:--------------------------------------------------------------------Testcase
> Result Summary:total: 9017passed: 9017failed: 0timeout: 0--------------------------------------------------------------------x86:--------------------------------------------------------------------Testcase
> Result Summary:total: 9017passed: 9017failed: 0timeout: 0--------------------------------------------------------------------Tested-by:
> Hulk Robot <hulkrobot@huawei.com>

Your emails are being sent in html format and not being accepted by the
mialing list.

Also this response is very odd :(
