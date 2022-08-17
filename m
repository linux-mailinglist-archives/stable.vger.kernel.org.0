Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E584A596FF5
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 15:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiHQNeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 09:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239361AbiHQNeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 09:34:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0D6B7FB;
        Wed, 17 Aug 2022 06:34:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0747361381;
        Wed, 17 Aug 2022 13:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32C0C433D7;
        Wed, 17 Aug 2022 13:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660743251;
        bh=VJjaESeTcpR3pNf2yk31v/MAq8krPW3qtCOLglDY3KY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xQAIzIwaUhZUgIkIExJZ1dJBfC04siz7xT8lwtw8St2wQ8R8YzRw14XYLjQrq4sjj
         erJfG62Pu7m5Sm4b6ScBg6heW1lM9sPMdkDR10hUPyQ0aiNyL/ybiwif8CzZOmOr9R
         CICFU4nBeI+uJEg2l0G8MibRZXqzPR+v+EzN+Wsg=
Date:   Wed, 17 Aug 2022 15:34:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0000/1094] 5.18.18-rc2 review
Message-ID: <YvzuUdrBqGlW880H@kroah.com>
References: <20220816124604.978842485@linuxfoundation.org>
 <20220817042445.GC1880847@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817042445.GC1880847@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 09:24:45PM -0700, Guenter Roeck wrote:
> On Tue, Aug 16, 2022 at 02:59:27PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.18.18 release.
> > There are 1094 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 18 Aug 2022 12:43:14 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 481 pass: 480 fail: 1
> Failed tests:
> 	arm:bletchley-bmc:aspeed_g5_defconfig:notests:usb0:net,nic:aspeed-bmc-facebook-bletchley:rootfs
> 
> The failing boot test is new and not a concern. I'll see if I can figure
> out why it fails. If it is too difficult to fix (for example because 5.18
> simply doesn't support usb on bletchley-bmc), I'll just skip it next time.
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

5.18 is only going to be alive for one more week at most, so I wouldn't
worry too much about this.

thanks!

greg k-h
