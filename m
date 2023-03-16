Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE36BCAB1
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 10:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjCPJX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 05:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjCPJX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 05:23:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC11B3296;
        Thu, 16 Mar 2023 02:23:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7B07B820BC;
        Thu, 16 Mar 2023 09:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12161C433D2;
        Thu, 16 Mar 2023 09:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678958632;
        bh=9fTMeBuj4pWb4ZEkn77Z2T6VSs8vZLru6yhzXFc39Hs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bp6DEOaRpqQpo05r322gNBaeXsyS12LBdhRbiQffRwa4IAQ0GGCnh4vp2AZJppisX
         sEzN5+xgpZOpH6zV+qYbiJzEAUVEMz9VU01h4r+10p8nSWeqhirbT3gutyPfgeCcdZ
         sGhnqDxZijg4mHUQ0dygcXiYAsMu8ZEs9Iu5NoUc=
Date:   Thu, 16 Mar 2023 10:23:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, paul.elder@ideasonboard.com
Subject: Re: [PATCH 4.14 00/20] 4.14.310-rc2 review
Message-ID: <ZBLgJfTDwqggdsJ6@kroah.com>
References: <20230316083335.429724157@linuxfoundation.org>
 <ZBLaULVciUIN+b4P@duo.ucw.cz>
 <ZBLaqsSWyRD+N4M9@duo.ucw.cz>
 <0a3a9c3d-8d04-5b58-0f74-eb20759b1430@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a3a9c3d-8d04-5b58-0f74-eb20759b1430@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 11:01:01AM +0200, Dmitry Baryshkov wrote:
> On 16/03/2023 11:00, Pavel Machek wrote:
> > (added patch authors to cc)
> > 
> > > > This is the start of the stable review cycle for the 4.14.310 release.
> > > > There are 20 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > > Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > > >      clk: qcom: mmcc-apq8084: remove spdm clocks
> > > 
> > > This looks like a cleanup, we should not need it in stable.
> 
> Totally agree here.

Now dropped, thanks.

greg k-h
