Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C756EED65
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 06:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbjDZE6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 00:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238411AbjDZE6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 00:58:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1650F18D;
        Tue, 25 Apr 2023 21:58:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A99E8632C8;
        Wed, 26 Apr 2023 04:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988A7C433D2;
        Wed, 26 Apr 2023 04:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682485128;
        bh=ND7kEeaVi0isIsVRWJ6UNL0heB4TJzmEPRRJFkMtrEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z0OiiGg5mvA/RRoHQnEHnEN4C1ipXBE01k2wIwkgEsU9KP/QLPeXNvYA3rD+8OzNp
         o5HK0tkv17GOsy5ShM7Z1C8ZBNYsRH2m+4xlV8P9npo1byjF3ldSWGHi2hfpZQUFJw
         RiC57A/3s27XJn8QDZw6GZqu0a8HpPbHzgk/V+jA=
Date:   Wed, 26 Apr 2023 06:58:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chia-I Wu <olvaffe@gmail.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/amdgpu: add a missing lock for AMDGPU_SCHED
Message-ID: <ZEivhUGdECRpVztZ@kroah.com>
References: <20230426004831.650908-1-olvaffe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426004831.650908-1-olvaffe@gmail.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 25, 2023 at 05:48:27PM -0700, Chia-I Wu wrote:
> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> Cc: stable@vger.kernel.org

I know I can not take patches without any changelog text at all, maybe
the DRM developers are more lax, but it's not a good idea at all.

thanks,

greg k-h
