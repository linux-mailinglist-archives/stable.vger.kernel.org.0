Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB0C6A0BF7
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 15:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbjBWOiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 09:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBWOh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 09:37:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E76822A3B;
        Thu, 23 Feb 2023 06:37:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF4161726;
        Thu, 23 Feb 2023 14:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB954C433D2;
        Thu, 23 Feb 2023 14:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677163077;
        bh=k8OZ+XKI9h2PK95SecGRPfXbOpiiARbQmbsuznL8wIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YN0SoJ3dmPlBwrhLPPSiZacoHO52wE2yZaD0LGTTun7f7je9CdXpZ2Rxwgs/tbDNx
         29nMxiqwifAQuy26jWehz0d6eRUzAG++Xjgtxtj7erQ7Mp7Nh+FKbhRgx9qd4shNRg
         xOhFiynwVVpJtyJYhQh7ccW9TYKzUnT2B9bNT0A0=
Date:   Thu, 23 Feb 2023 15:37:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/46] 6.1.14-rc1 review
Message-ID: <Y/d6QnQrVMK8DHUK@kroah.com>
References: <20230223130431.553657459@linuxfoundation.org>
 <Y/d5KdOfh5rXUeqk@wendy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/d5KdOfh5rXUeqk@wendy>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 02:33:13PM +0000, Conor Dooley wrote:
> On Thu, Feb 23, 2023 at 02:06:07PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.14 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> 
> > Dave Hansen <dave.hansen@linux.intel.com>
> >     uaccess: Add speculation barrier to copy_from_user()
> 
> This breaks the build for me on RISC-V, you need to take f3dd0c53370e
> ("bpf: add missing header file include") from Linus' tree.
> It was broken in mainline too, so it is probably broken everywhere you
> backported it :(

Already fixed up and in -rc2.

thanks,

greg k-h
