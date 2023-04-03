Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C216D4537
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjDCNEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjDCNEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:04:50 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5AF40C1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:04:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 56ECCCE1129
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 13:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D6DC433D2;
        Mon,  3 Apr 2023 13:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680527078;
        bh=BCodbqMijr9WcVLjGfMoxGVzPWUsCtF3S8G71CwRTK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Onw1Vz94mAWi0XyM72kx55V/faO7Y9vo0knytDluLN2J8VovtzZW0TGPxtotpcqY4
         93C8LvEL4OiUf35C/jSWtHrGdNYsbtWmaR+whZjVMQ/qtwq7sIn/hPvfoN4Xai+c+f
         Uj+5gwJdSDLhPDediD4EsIwnGU00503HU0k8xnDE=
Date:   Mon, 3 Apr 2023 15:04:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>
Subject: Re: Patch "drm/meson: Fix error handling when afbcd.ops->init fails"
 has been added to the 5.4-stable tree
Message-ID: <2023040325-renewal-scrubbed-f02b@gregkh>
References: <20230330111618.2889687-1-sashal@kernel.org>
 <CAFBinCAvUURHmGrcmsmNQMvhSe4P_QOCOsrWttzW+3SfoZ7P1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFBinCAvUURHmGrcmsmNQMvhSe4P_QOCOsrWttzW+3SfoZ7P1g@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 11:27:07PM +0200, Martin Blumenstingl wrote:
> Hi Sasha,
> 
> On Thu, Mar 30, 2023 at 1:16 PM Sasha Levin <sashal@kernel.org> wrote:
> >
> > This is a note to let you know that I've just added the patch titled
> >
> >     drm/meson: Fix error handling when afbcd.ops->init fails
> >
> > to the 5.4-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >
> > The filename of the patch is:
> >      drm-meson-fix-error-handling-when-afbcd.ops-init-fai.patch
> > and it can be found in the queue-5.4 subdirectory.
> >
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> I think this patch was added to allow backporting of another patch:
> drm-meson-fix-missing-component-unbind-on-bind-error.patch
> 
> Unfortunately this breaks the build as old kernels (5.4 and older)
> don't have AFBC support yet. That build failure has been:
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202303310016.tc4BlcbT-lkp@intel.com/
> 
> I think that there are few to no meson users on 5.4 or older kernels.
> Can you please drop these patches from the 5.4 and 4.19 backport queue?

Dropped from 4.19 and 5.4 now, thanks.

greg k-h
