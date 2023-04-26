Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D30C6EEE7E
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 08:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbjDZGm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 02:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239381AbjDZGm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 02:42:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C059B0;
        Tue, 25 Apr 2023 23:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CB5C6334D;
        Wed, 26 Apr 2023 06:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE9EC433EF;
        Wed, 26 Apr 2023 06:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682491374;
        bh=BbD0U7ebbi3qqSF7uHQF72OPJWuCMl7jaAsF2SMWrRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=luXqmbPJZ5rMrScH7ZMstT27C7ziFsdr//ltLEmE02Hd4C8t+vyQ0rAtcoVbDuiO+
         2Jd8Ky5NlXit+psANPgmBkID/pJQx5kIoqiWP9RRyc30Zkf3eJ+OGv/aPw7AZwqmri
         8pU0LDSIE0217MnBKdc6P5WSK7fBF8QyN7aIlGjQ=
Date:   Wed, 26 Apr 2023 08:42:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chia-I Wu <olvaffe@gmail.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/amdgpu: add a missing lock for AMDGPU_SCHED
Message-ID: <2023042627-hypnosis-unlovely-d679@gregkh>
References: <20230426061718.755586-1-olvaffe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426061718.755586-1-olvaffe@gmail.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 25, 2023 at 11:17:14PM -0700, Chia-I Wu wrote:
> mgr->ctx_handles should be protected by mgr->lock.
> 
> v2: improve commit message
> 
> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> Cc: stable@vger.kernel.org

What commit id does this fix?  How far back in stable kernels should
this go?

thanks,

greg k-h
