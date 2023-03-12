Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865EF6B653E
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 12:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjCLLM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 07:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCLLMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 07:12:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF1B51C9C;
        Sun, 12 Mar 2023 04:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FE7EB80B08;
        Sun, 12 Mar 2023 11:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB944C4339B;
        Sun, 12 Mar 2023 11:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678619542;
        bh=Zv30hr0bTcMNOUSs9UrFFnKN7maJHlEJmjsz7Nkqsgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eqslb+I5ebg1ouRzVBbDgezjcZJ3lMU7191W0XiiESgjz6W5Dx2sCklgOlc9I1zS3
         6F1KWegzl91+zjY/mDrQYH51VG0sQ5cRt8gWShpa4uWsA2kf76rrBpoGjM55kzL+bV
         Bu/GA8N8sO5Ozj8/oDEG0IhQSW7a4dxzz1QFXuM8=
Date:   Sun, 12 Mar 2023 12:12:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "A.P. Jo." <apjo@tuta.io>
Cc:     Stable <stable@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bricked LTS Kernel: Questionable i915 Commit
Message-ID: <ZA2zkz8J6fuJsisw@kroah.com>
References: <NQJqG8n--3-9@tuta.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <NQJqG8n--3-9@tuta.io>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 12, 2023 at 09:04:01AM +0100, A.P. Jo. wrote:
> Dear Linux dev community,
> 
> 5.15.99 LTS and higher can't boot on many laptops using Intel graphics.
> 
> Originally spotted using Alpine Linux, see: https://gitlab.alpinelinux.org/alpine/aports/-/issues/14704.
> Seems to have been traced to commit 4eb6789f9177a5fdb90e1b7cdd4b069d1fb9ce45, see i915 git issue: https://gitlab.freedesktop.org/drm/intel/-/issues/8284.
> 
> Suggest releasing with patch undone or fixed.

There's a second report of this here:
	https://lore.kernel.org/r/d955327b-cb1c-4646-76b9-b0499c0c64c6@manjaro.org
I'll go revert this and push out a new release in an hour or so, thanks!

greg k-h
