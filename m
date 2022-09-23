Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C06A5E7957
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 13:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbiIWLVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 07:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiIWLVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 07:21:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C1C13790A;
        Fri, 23 Sep 2022 04:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E12FB62150;
        Fri, 23 Sep 2022 11:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A539FC433D6;
        Fri, 23 Sep 2022 11:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663932106;
        bh=nW/sLfHy+sjn8Qk6jbVO3RDe1tqlOxvnBGHmopu36Ro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vIw2K4K4iDZpsiLkrhcAM/Xqg08nuHW+u9tTAeBjNHfCSPAOT/wgoULvyVunoOfOl
         BL+tqeyk5Xq9eAQga23ieGOdW/ooDnCE10F1LKvJ5ChbI1epGZwSYmFbdVbBbMQkTs
         4oSACwnp0M4uRA5j5zTZiGYyDhA6VyWzlkN9Sw6A=
Date:   Fri, 23 Sep 2022 13:21:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/45] 5.15.70-rc1 review
Message-ID: <Yy2Wx0nxFmvI+dNq@kroah.com>
References: <20220921153646.931277075@linuxfoundation.org>
 <20220922164323.GB1138811@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922164323.GB1138811@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 09:43:23AM -0700, Guenter Roeck wrote:
> On Wed, Sep 21, 2022 at 05:45:50PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.70 release.
> > There are 45 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 159 pass: 158 fail: 1
> Failed builds:
> 	arm64:allmodconfig
> Qemu test results:
> 	total: 486 pass: 486 fail: 0
> 
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> arch/arm64/kernel/kexec_image.c:136:23: error: 'kexec_kernel_verify_pe_sig' undeclared here

Thanks, I've fixed this now.

greg k-h
