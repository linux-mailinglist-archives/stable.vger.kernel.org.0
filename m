Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7814A53650A
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 17:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbiE0Pxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 11:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348574AbiE0Pxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 11:53:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B6B13F1F4;
        Fri, 27 May 2022 08:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DB35B82590;
        Fri, 27 May 2022 15:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669C5C385A9;
        Fri, 27 May 2022 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653666829;
        bh=BCie4tdmITRGtNGnNzdJn426UjGbuq3xUWkFE0l+Ah0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q/9i4ziQROYuVqZtsuxhd6d6L6Tze4aZQMap/AZeHqkRQY1u1DkF0UZo3gBIsNiJp
         s8TjEqR4kwQplOojHqseschaZ9k9cbhvP9WWxqVHmt4dmusmUd+16hsrAsirnPncXx
         gqhU2cZV+Y3w8UCfGfJErSX9nIPUebqeZPXYoUpM=
Date:   Fri, 27 May 2022 17:53:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Chris.Paterson2@renesas.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/163] 5.10.119-rc1 review
Message-ID: <YpD0CVWSiEqiM+8b@kroah.com>
References: <20220527084828.156494029@linuxfoundation.org>
 <20220527141421.GA13810@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527141421.GA13810@duo.ucw.cz>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 27, 2022 at 04:14:21PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.119 release.
> > There are 163 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Is there some kind of back-story why we are doing massive changes to
> /dev/random? 5.19-rc1 is not even out, so third of those changes did
> not get much testing.

Did you miss the posting on the stable list that described all of this:
	https://lore.kernel.org/all/YouECCoUA6eZEwKf@zx2c4.com/

> It seems we hit some problems, but I'm not sure if they are kernel
> problems or test infrastructure problems. Perhaps Chris can help?
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/549589225

I do not know how to decypher random test summaries like this, sorry.

greg k-h
