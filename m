Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F77B5FBA60
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 20:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJKSbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 14:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJKSbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 14:31:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28335281A;
        Tue, 11 Oct 2022 11:31:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EA6D61255;
        Tue, 11 Oct 2022 18:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479F4C433D6;
        Tue, 11 Oct 2022 18:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665513065;
        bh=1HRhamvUd66S4HgoLlvM4SBrlk3KR1FlFU47apYrMWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qY2BLUBd5p8RxFm0dKtPnf2o04xI+OdXP/GBBI8e9gW50xLfdCLFwUaHKUR+vOoKI
         5tZmnM3f6crYoHX7QmXgEn16ieuKgBZIEobUB4MvFSoqGN0SqaNjaW2OrCen6vekxe
         K6vGtaDszVDNzJn72k8UnB1WpLVT44fSTcui1Ud0=
Date:   Tue, 11 Oct 2022 20:31:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     corbet@lwn.net, conduct@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jlee@linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] docs: update mediator contact information in CoC doc
Message-ID: <Y0W2lKIoYDpbJ+LF@kroah.com>
References: <20221011171417.34286-1-skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011171417.34286-1-skhan@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 11, 2022 at 11:14:17AM -0600, Shuah Khan wrote:
> Update mediator contact information in CoC interpretation document.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> ---
>  Documentation/process/code-of-conduct-interpretation.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/process/code-of-conduct-interpretation.rst b/Documentation/process/code-of-conduct-interpretation.rst
> index 4f8a06b00f60..43da2cc2e3b9 100644
> --- a/Documentation/process/code-of-conduct-interpretation.rst
> +++ b/Documentation/process/code-of-conduct-interpretation.rst
> @@ -51,7 +51,7 @@ the Technical Advisory Board (TAB) or other maintainers if you're
>  uncertain how to handle situations that come up.  It will not be
>  considered a violation report unless you want it to be.  If you are
>  uncertain about approaching the TAB or any other maintainers, please
> -reach out to our conflict mediator, Joanna Lee <joanna.lee@gesmer.com>.
> +reach out to our conflict mediator, Joanna Lee <jlee@linuxfoundation.org>.
>  
>  In the end, "be kind to each other" is really what the end goal is for
>  everybody.  We know everyone is human and we all fail at times, but the
> -- 
> 2.34.1
> 

Thanks, I'll queue this up after -rc1 is out.

greg k-h
