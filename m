Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28794D20CA
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 19:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349333AbiCHS6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 13:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348996AbiCHS6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 13:58:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4DFDF21;
        Tue,  8 Mar 2022 10:57:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7733F61687;
        Tue,  8 Mar 2022 18:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456F0C340EB;
        Tue,  8 Mar 2022 18:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646765876;
        bh=eRFO90gliTb1JSPlmNLHEowDWgaJ4yng3mh10kA4vb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qdEij3tHDsnEqVv1MSltNY57gZg3+y00Bvso5lPd1rXwFLw2zipBGzzSyoIXYfTJ4
         dg4T/8QTIIbQ6EcJ6QUqPbroaR902Vp6dnmIqDPensJZJ/CvBvTRq5sb66CgDU6UwB
         eZrDCh/ANt+WxELcqwzg8VrNvzelYpHOFKdk5LaQ=
Date:   Tue, 8 Mar 2022 19:57:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/184] 5.16.13-rc2 review
Message-ID: <YienMYvdhGPCcPSv@kroah.com>
References: <20220307162147.440035361@linuxfoundation.org>
 <20220308185219.GA3686655@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308185219.GA3686655@roeck-us.net>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 10:52:19AM -0800, Guenter Roeck wrote:
> On Mon, Mar 07, 2022 at 05:28:30PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.16.13 release.
> > There are 184 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 09 Mar 2022 16:21:20 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Your cycles are getting too short for my test system to provide results
> in time. It gets overwhelmed, especially when there are updates affecting
> all stable branches which trigger a complete rebuild of all those branches.

Sorry, but this one had to go out a bit sooner for reasons I don't want
to speculate about :)

Anyway, I checked your builders, and they all looked ok except the 5.15
tree, which I know is broken on MIPS right now.

thanks,

greg k-h
