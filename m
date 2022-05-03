Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68610518680
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 16:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbiECOZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 10:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236933AbiECOZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 10:25:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F692DA96
        for <stable@vger.kernel.org>; Tue,  3 May 2022 07:22:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D484B81ED0
        for <stable@vger.kernel.org>; Tue,  3 May 2022 14:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F106C385A9;
        Tue,  3 May 2022 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651587724;
        bh=EcQbw2tBBUVek6ewt6jFTkuMql816FNECKUaO7t0uZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xTwg8F2U65KgKlinKCUlIqCiH/VC7uGfL9VTCH+LfnO2wPWA9EBUrWjE9uWXhNIv9
         fPK2XEmGTTt+bHNJymNFg2E6RIx8YWd8jHCnknIVaPZeQsu53QZm74Lxq4ND1lJkxh
         uQGa63OOuV4pucZCJJI6wOBtP6OADCMOArlE2z5s=
Date:   Tue, 3 May 2022 16:22:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hillf Danton <hdanton@sina.com>,
        syzbot+0dc4444774d419e916c8@syzkaller.appspotmail.com,
        Emil Velikov <emil.velikov@collabora.com>,
        Sean Paul <seanpaul@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Eric Anholt <eric@anholt.net>, Sam Ravnborg <sam@ravnborg.org>,
        Rob Clark <robdclark@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 4.19 1/1] drm/vgem: Close use-after-free race in
 vgem_gem_create
Message-ID: <YnE6i83BK8kJhnz6@kroah.com>
References: <20220502113857.2126299-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502113857.2126299-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 02, 2022 at 02:38:57PM +0300, Ovidiu Panait wrote:
> From: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> commit 4b848f20eda5974020f043ca14bacf7a7e634fc8 upstream.
> 

Both now queued up, thanks!

greg k-h
