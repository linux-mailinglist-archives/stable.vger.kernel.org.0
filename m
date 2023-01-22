Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCF4676DB7
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjAVOfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjAVOfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:35:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0E71A486
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:35:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD30060AFD
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3D5C433D2;
        Sun, 22 Jan 2023 14:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674398100;
        bh=kh875/ImTKJ0FJY3SaK1zV4DboGYYskMl5T1KBMu00Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YPQkb4tyTrCDfK+ETgvvzTLGBrT7jdgeSUMzqKvyqKwKYUZEv0ZommKdxQwhFxRad
         1ppKOV+HHd9nPuOM8MXIXfV4JVxXt5NM0i7/udkBrBD79fi7fBcXY887RoBVspko0r
         N0PNwTOPKzSLDUFk83tdJWpaMNjhlM5GgbmSQTns=
Date:   Sun, 22 Jan 2023 15:34:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lang.Yu@amd.com, aaron.liu@amd.com, alexander.deucher@amd.com,
        yifan1.zhang@amd.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amdgpu: correct MEC number for gfx11
 APUs" failed to apply to 6.1-stable tree
Message-ID: <Y81JkeiRo+HpE7L+@kroah.com>
References: <167439388959240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167439388959240@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 02:24:49PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 0ddadc3a2208 ("drm/amdgpu: correct MEC number for gfx11 APUs")

Now fixed this up, no need for a backport.

greg k-h
