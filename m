Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C6B50DE01
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 12:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbiDYKjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 06:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiDYKjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 06:39:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1095FB7C8;
        Mon, 25 Apr 2022 03:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3790B8128F;
        Mon, 25 Apr 2022 10:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC36C385A7;
        Mon, 25 Apr 2022 10:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650882968;
        bh=wkyNxnKYvpuBo7kmCBxnLUwwRMn5XI30arFCVougD+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fJJ/Pe5gF0UyKVzOXciVE3aqwc6iWwdwdYr988a7lID1iQ8yjBxPZE6CYNvnKBVwI
         DyfBf6AzVmnP2OUwy1fiUJ59QMW6ySgHu6T5onoZe/2j7hzuMygTzuHrTooWQqCqZY
         U2zcNMEmgto2jAUNTCmWHt9P4niJptV5mitbJLd8=
Date:   Mon, 25 Apr 2022 12:36:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shile Zhang <shile.zhang@linux.alibaba.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Wen Kang <kw01107137@alibaba-inc.com>, stable@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10.y] drm/cirrus: fix a NULL vs IS_ERR() checks
Message-ID: <YmZ5lZMkjo3XlYdN@kroah.com>
References: <20211228132556.108711-1-shile.zhang@linux.alibaba.com>
 <YcsWcqVN7Dwue1I2@kroah.com>
 <f4dedbfc-0cca-a6cb-996b-4bd928008269@linux.alibaba.com>
 <YcsZqU8M11elHqg3@kroah.com>
 <1cc25ebe-2c68-458b-15a2-fc4c80ba2054@linux.alibaba.com>
 <Ycshhu6pXC4Pt1YK@kroah.com>
 <c74d61a5-31dc-0946-5a35-e1a4cd549b6e@linux.alibaba.com>
 <YcxjGDxgF+mA7vLY@kroah.com>
 <ae3ebd93-e3c0-ec2e-24be-07241b558b5e@linux.alibaba.com>
 <550e9439-adf6-3df8-41a0-9a7ee5447907@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <550e9439-adf6-3df8-41a0-9a7ee5447907@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 24, 2022 at 11:27:17AM +0800, Shile Zhang wrote:
> Hi David and Daniel,
> 
> Sorry but could you please help to check this issue?
> Due to the function 'drm_gem_shmem_vmap' could return ERROR pointers which
> will cause the kernel crash due to 'cirrus_fb_blit_rect' only check the
> pointer.
> 
> Since the related code has been refactoring in mainline, so this issue only
> happened in stable 5.10.y branch.
> 
> @Greg
> I think it is probably not realistic to backport the related refactoring
> from mainline directly, so I just give this bugfix patch only for 5.10.y
> branch.

I'm sorry, but I do not have "this bugfix" in my queue anymore,
considering it is so old.  Please rebase and resubmit.

thanks,

greg k-h
