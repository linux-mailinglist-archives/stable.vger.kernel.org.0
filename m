Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FD46D6C2C
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 20:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbjDDSdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 14:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbjDDSdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 14:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C9E76A1;
        Tue,  4 Apr 2023 11:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65FA063551;
        Tue,  4 Apr 2023 18:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E15C433D2;
        Tue,  4 Apr 2023 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680633020;
        bh=uujWBZow7hrMUvJAdkQExIQ+86oyKtTw332Yz5dCrRY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CK3BliWK8/fI3gxsrjLjx7gCpVJHlNMVmnNrFDylt54l0wpoUYRFqF6v3mRTvnqkD
         jdvZ4hD7j5jYj1bMwg8K6PzTr/1XKFhFilY91RV0IFTv8so8+Un51q9d7QUQ8pDaRj
         sJZjfYIcKuesGAlvINchqQFPTNtEjI1TRt9y7YtE=
Date:   Tue, 4 Apr 2023 20:30:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/84] 4.19.280-rc1 review
Message-ID: <2023040434-uprising-cleaver-055a@gregkh>
References: <20230403140353.406927418@linuxfoundation.org>
 <ZCwOLBxxGIHEyMZ2@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCwOLBxxGIHEyMZ2@duo.ucw.cz>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 04, 2023 at 01:46:52PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.280 release.
> > There are 84 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> 
> > Jesse Brandeburg <jesse.brandeburg@intel.com>
> >     intel-ethernet: rename i40evf to iavf
> 
> I don't think this one is suitable for stable. It is huga and has huge
> impact, in part it renames module...

Why is renaming a module a problem?

It's needed for other fixes in this release, and to make maintaining
this branch easier over time, like we have done for other
drivers/subsystems in the past.

thanks,

greg k-h
