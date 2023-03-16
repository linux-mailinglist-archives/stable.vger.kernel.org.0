Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA20D6BCEDD
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 13:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjCPMCE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 08:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCPMCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 08:02:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0621CC48BD;
        Thu, 16 Mar 2023 05:02:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84F5761FA4;
        Thu, 16 Mar 2023 12:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BADC433EF;
        Thu, 16 Mar 2023 12:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678968121;
        bh=Gd8IqJ9rNvlvSXjTXtwWWOlllzwIQdOslXN75zxBLJg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pN2+ByTIvP37YBCXWhop3g2j0ST2mWPgmYIQAMy82wyUj17ay/pKm+mD682dncVFj
         ApAif9SAv2eWTJ1Kn5wwsIVqq4igmeLHudNINubwC8vggLIG/zMuPlSAQ9mdD3bz+R
         Tswh+T/M58oLyvDzpMMAACQkv0j8ucTkClMGtU/E=
Date:   Thu, 16 Mar 2023 13:01:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: Re: [PATCH 4.14 00/20] 4.14.310-rc2 review
Message-ID: <ZBMFN+6+zWzmtL3Y@kroah.com>
References: <20230316083335.429724157@linuxfoundation.org>
 <TYCPR01MB10588DFCA0CABA9028F2FD723B7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
 <ZBL+ueZuSk51GhFE@kroah.com>
 <TYCPR01MB1058859F0D4457BD3BCEEB868B7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCPR01MB1058859F0D4457BD3BCEEB868B7BC9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 11:57:55AM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: 16 March 2023 11:34
> > 
> > On Thu, Mar 16, 2023 at 11:25:29AM +0000, Chris Paterson wrote:
> > > Hello Greg,
> > >
> > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Sent: 16 March 2023 08:50
> > > >
> > > > This is the start of the stable review cycle for the 4.14.310 release.
> > > > There are 20 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> > > > Anything received after that time might be too late.
> > >
> > > It sounds like there may be an -rc3 on the way, but for what it's worth...
> > 
> > There is?  Only for 4.19.y.
> 
> Ah, I was referring to you saying you'd drop "clk: qcom: mmcc-apq8084: remove spdm clocks".
> I was assuming that meant another RC.
> /me must stop assuming things...

Dropping a patch that is not causing build or test errors generally does
not mean a new -rc is to be released .

thanks,

greg k-h
