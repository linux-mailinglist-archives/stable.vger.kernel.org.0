Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932625FE934
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 09:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJNHHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 03:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiJNHHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 03:07:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA4AC34E5;
        Fri, 14 Oct 2022 00:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75CE0B82211;
        Fri, 14 Oct 2022 07:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8B6C433D6;
        Fri, 14 Oct 2022 07:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665731265;
        bh=67Q2M9/5IxUi9WdjZ9zJloR+UIMjTGAO6YW6PrdKa2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=heLkhqMbQdjBC2j91TGDPNlhHogGDWTwOcAVbngE6fIpk+WDy3FJLDBM1jUVHpY2K
         XSfW8QkDry48eSBgDPlpyGqfudkiD1VcQhUo4eKeZ5T6bOjBf6/dS7o6VBy2WWRmHp
         aCsIj3AKzdy7WUhDpiTGJDWMqAJ4hAwwQEONTZ00=
Date:   Fri, 14 Oct 2022 09:08:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] Documentation: process: update the list of current LTS
Message-ID: <Y0kK7WrfFutYcFzZ@kroah.com>
References: <20221013183414.667316-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013183414.667316-1-ndesaulniers@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 11:34:14AM -0700, Nick Desaulniers wrote:
> 3.16 was EOL in 2020.
> 4.4 was EOL in 2022.
> 
> 5.10 is new in 2020.
> 5.15 is new in 2021.
> 
> We'll see if 6.1 becomes LTS in 2022.
> 
> Link: https://lore.kernel.org/stable/514c425e2b4dca71a11b0c669746d3122f7039a5.camel@decadent.org.uk/
> Link: https://lore.kernel.org/stable/1643877137240249@kroah.com/
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  Documentation/process/2.Process.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/process/2.Process.rst b/Documentation/process/2.Process.rst
> index e05fb1b8f8b6..9ae64376a8d4 100644
> --- a/Documentation/process/2.Process.rst
> +++ b/Documentation/process/2.Process.rst
> @@ -130,12 +130,12 @@ for a longer period.  As of this writing, the current long term kernels
>  and their maintainers are:
>  
>  	======  ================================	=======================
> -	3.16	Ben Hutchings				(very long-term kernel)
> -	4.4	Greg Kroah-Hartman & Sasha Levin	(very long-term kernel)
>  	4.9	Greg Kroah-Hartman & Sasha Levin
>  	4.14	Greg Kroah-Hartman & Sasha Levin
>  	4.19	Greg Kroah-Hartman & Sasha Levin
>  	5.4	Greg Kroah-Hartman & Sasha Levin
> +	5.10	Greg Kroah-Hartman & Sasha Levin
> +	5.15	Greg Kroah-Hartman & Sasha Levin
>  	======  ================================	=======================
>  
>  The selection of a kernel for long-term support is purely a matter of a


Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
