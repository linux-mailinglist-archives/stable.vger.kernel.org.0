Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0100A6DD98A
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjDKLjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjDKLjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:39:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8143C23
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8C5A61E08
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 11:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4AEC433D2;
        Tue, 11 Apr 2023 11:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681213176;
        bh=3IK3l9R+5HjI/aIF2u1XPvGBZ8gHPw2YFVfCjEkjLVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b7WemUwp0mJnHa1ldi0filOzYJZ5UTubAsHA0qPS6KDjL9aUK9VP3SVV231FiG6Zo
         AMWHbtpcULbjdR9Yv9ytxg8lvI3QSdfIL8jdDs/W/IJsFaGmvdSYphjzlRPWfZQVTl
         IwpfIUbivUqc/93h+WryB8uklNFTj0tjSUmR9ELQ=
Date:   Tue, 11 Apr 2023 13:39:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ricardo =?iso-8859-1?Q?Ca=F1uelo?= <ricardo.canuelo@collabora.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] selftests: intel_pstate: ftime() is deprecated
Message-ID: <2023041111-rewrap-cabana-3966@gregkh>
References: <20230411111533.1442349-1-ricardo.canuelo@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230411111533.1442349-1-ricardo.canuelo@collabora.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 01:15:33PM +0200, Ricardo Cañuelo wrote:
> From: Tommi Rantala <tommi.t.rantala@nokia.com>
> 
> commit fc4a3a1bf9ad799181e4d4ec9c2598c0405bc27d upstream.
> 
> Use clock_gettime() instead of deprecated ftime().
> 
>   aperf.c: In function ‘main’:
>   aperf.c:58:2: warning: ‘ftime’ is deprecated [-Wdeprecated-declarations]
>      58 |  ftime(&before);
>         |  ^~~~~
>   In file included from aperf.c:9:
>   /usr/include/sys/timeb.h:39:12: note: declared here
>      39 | extern int ftime (struct timeb *__timebuf)
>         |            ^~~~~
> 
> Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Reviewed-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>

As you are passing this on to us, you need to also sign off on it as per
our documentation.

thanks,

greg k-h
