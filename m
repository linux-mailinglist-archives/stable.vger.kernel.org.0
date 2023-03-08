Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAF46B0BBF
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 15:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbjCHOq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 09:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjCHOqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 09:46:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12312C66B;
        Wed,  8 Mar 2023 06:44:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EC2A6185C;
        Wed,  8 Mar 2023 14:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506A6C433D2;
        Wed,  8 Mar 2023 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678286675;
        bh=x7K563D1bIPVbxvD9d60t5KyNe2ANsTBa7TdsK1Ilp4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DNPAEiW0QndoNYuOw3x1ioiPS/T4IXPPHRn2fXqkMUSPPq+srjASJOidgqQ2xznt5
         yruCKQY+EkPuy7DryxJxvSbyzOrVTldp0Ptzg53glTSjffsYpxXi6B7T15W/8+fDFe
         GYv3pSGOS7IqnA9ciVEA2jSncLT80neJnnz77fGw=
Date:   Wed, 8 Mar 2023 15:44:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Message-ID: <ZAifUN1XpQ/ojXz8@kroah.com>
References: <20230308091912.362228731@linuxfoundation.org>
 <6883f095-cf2b-2c45-5786-a46ba1c13dd7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6883f095-cf2b-2c45-5786-a46ba1c13dd7@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 01:49:30PM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 08/03/2023 09:29, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.2.3 release.
> > There are 1000 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > Thierry Reding <treding@nvidia.com>
> >      arm64: tegra: Bump #address-cells and #size-cells
> 
> 
> The above change introduced a regression for Tegra, which Thierry has since
> fixed [0]. Please can you drop this for now?

Now dropped, and the patch after this in the series as well.

thanks,

greg k-h
