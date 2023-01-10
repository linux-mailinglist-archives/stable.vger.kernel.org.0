Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A264E664546
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 16:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbjAJPtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 10:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbjAJPtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 10:49:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5ED4730E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 07:49:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74715616F6
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 15:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD64C433D2;
        Tue, 10 Jan 2023 15:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673365778;
        bh=SkGNfyRAqHeqTLVlJIJPJkN7bdASUBIlyOjuDBZvL9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vXYfl7coAl2BUWayzu4KUISRJwBaFJ3JPy35u+zj8gccs7pk8m/YAgU1mUr1f/pVM
         h9kOGSEv5za9ODWF3FfShJ4md/W9uztJ2cyvd15h6W0NeEj036MQgaWa7gLVbmm7uc
         GXwvYyBUe2MQbyoyOI4dMVwgigP4YHGEzE75H30Q=
Date:   Tue, 10 Jan 2023 16:49:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tyler Hicks <code@tyhicks.com>
Cc:     stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [PATCH 5.15 5.10 1/1] selftests: set the BUILD variable to
 absolute path
Message-ID: <Y72JDysNVItMWrcF@kroah.com>
References: <20230106220816.763835-1-code@tyhicks.com>
 <20230106220816.763835-2-code@tyhicks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106220816.763835-2-code@tyhicks.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 04:08:16PM -0600, Tyler Hicks wrote:
> From: Muhammad Usama Anjum <usama.anjum@collabora.com>
> 
> commit 5ad51ab618de5d05f4e692ebabeb6fe6289aaa57 upstream.
> 
> The build of kselftests fails if relative path is specified through
> KBUILD_OUTPUT or O=<path> method. BUILD variable is used to determine
> the path of the output objects. When make is run from other directories
> with relative paths, the exact path of the build objects is ambiguous
> and build fails.
> 
> 	make[1]: Entering directory '/home/usama/repos/kernel/linux_mainline2/tools/testing/selftests/alsa'
> 	gcc     mixer-test.c -L/usr/lib/x86_64-linux-gnu -lasound  -o build/kselftest/alsa/mixer-test
> 	/usr/bin/ld: cannot open output file build/kselftest/alsa/mixer-test
> 
> Set the BUILD variable to the absolute path of the output directory.
> Make the logic readable and easy to follow. Use spaces instead of tabs
> for indentation as if with tab indentation is considered recipe in make.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Tyler Hicks (Microsoft) <code@tyhicks.com>
> ---
>  tools/testing/selftests/Makefile | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 

Now queued up, thanks.

greg k-h
