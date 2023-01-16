Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADAA66C2F4
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjAPO4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjAPO4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:56:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AE822DCA;
        Mon, 16 Jan 2023 06:45:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93542B80E72;
        Mon, 16 Jan 2023 14:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A64C433F0;
        Mon, 16 Jan 2023 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673880327;
        bh=QENT3/o77DrxIX5y2/X2KutjovyA1smRJxICKJ/Qxjo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xxkUSfq/fOLhO+LuNw/iICNfRJjUr2F5WOR+phmgQigPZtUwnF2qQs8Oht+l63D8M
         5PHfXcSDY7av1D4UuQ6ixv0EzU3ttkdAze8eM0rNDBj5an9j3d3157rlm6v0fgMa0g
         hyMXSZ5s+K9NuVSCiqo5Qx5yGhMHEs5uUWFZ8z6M=
Date:   Mon, 16 Jan 2023 15:45:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     mkv22@cantab.net
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: Mainline stable kernel kbd backlight stops working from 6.1.6 in
 t2 Macs
Message-ID: <Y8VjBJVei/I+Q67G@kroah.com>
References: <CAC+-fDs=YHjsWvNAUVT=D=+JU9FQ-dJ_L4esqJveQiiGLcW2Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC+-fDs=YHjsWvNAUVT=D=+JU9FQ-dJ_L4esqJveQiiGLcW2Lw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 06:12:12AM +0530, mkv22@cantab.net wrote:
> Apologies that I am unable to attach more detailed information from dmesg
> or logs as the update was in a production laptop and had to be rolled back
> to 6.1.5 immediately and lost the dmesg output.

Any chance to run 'git bisect' to find the offending change?

thanks,

greg k-h
