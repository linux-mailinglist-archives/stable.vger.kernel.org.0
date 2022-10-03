Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC54F5F3199
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 16:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJCOAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 10:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiJCOAH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 10:00:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF27B6567;
        Mon,  3 Oct 2022 07:00:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA5A4B81116;
        Mon,  3 Oct 2022 14:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED484C433C1;
        Mon,  3 Oct 2022 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664805603;
        bh=ZVDTi8Xy1hta8C9rk+aLLvqebGnLtOAPumu81jaSi6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sJDXAy91VgOTTFei2d1IVvPMY3nNJxT8N6bCfwJV1Unw9hVAX74N3vw2gy/IWbFqS
         vIpgpgeWfQx5qJGG2Ai9GBDhxjStcNf2MjxapT++8BeyYi62f5Bn3awlNbPBdaMRSc
         lGkGmLHehA3wKBicdUmVui6eBoKvvjo3Ru8sieu0=
Date:   Mon, 3 Oct 2022 16:00:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/25] 4.19.261-rc1 review
Message-ID: <Yzrq4FkX+ulsn3se@kroah.com>
References: <20221003070715.406550966@linuxfoundation.org>
 <20221003134906.GA28203@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003134906.GA28203@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 03:49:06PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.261 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Will there be matching 4.9.331?

Someday, yes, I did not push out a 4.9.y-rc or 4.14.y-rc today, sorry.

thanks,

greg k-h
