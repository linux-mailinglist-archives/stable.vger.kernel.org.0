Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB206541F5
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 14:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiLVNdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 08:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiLVNdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 08:33:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690642B275;
        Thu, 22 Dec 2022 05:32:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32E2FB81D30;
        Thu, 22 Dec 2022 13:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63507C433D2;
        Thu, 22 Dec 2022 13:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671715975;
        bh=7LR0l7yAD1N13182E2DUGhjtgRZlgRJBPWSovE/SLwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lP5lxrht9dKWOqHtaThhNrUxW2Wq+HHrwS/rpu5v/NRZlrrk+HUmdaygzS8+uOR6H
         Ly30cnInhJiXqtwYXZq9rVF6t8XrMTQX7/rT9xYkdPDFAPo10/mG9Jf833luXAVkl7
         j6c8ArydGuSUKr+NrATEvYMh5CX08ORQm+NJ+yYM=
Date:   Thu, 22 Dec 2022 14:32:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     sashal@kernel.org, corbet@lwn.net, stable@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com
Subject: Re: [PATCH] Documentation: stable: Add rule on what kind of patches
 are accepted
Message-ID: <Y6RchEaXUvg+9nKv@kroah.com>
References: <20221222091658.1975240-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221222091658.1975240-1-tudor.ambarus@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 11:16:58AM +0200, Tudor Ambarus wrote:
> The list of rules on what kind of patches are accepted, and which ones
> are not into the “-stable” tree, did not mention anything about new
> features and let the reader use its own judgement. One may be under the
> impression that new features are not accepted at all, but that's not true:
> new features are not accepted unless they fix a reported problem.
> Update documentation with missing rule.
> 
> Link: https://lore.kernel.org/lkml/fc60e8da-1187-ca2b-1aa8-28e01ea2769a@linaro.org/T/#mff820d23793baf637a1b39f5dfbcd9d4d0f0c3a6
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> ---
>  Documentation/process/stable-kernel-rules.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
> index 2fd8aa593a28..266290fab1d9 100644
> --- a/Documentation/process/stable-kernel-rules.rst
> +++ b/Documentation/process/stable-kernel-rules.rst
> @@ -22,6 +22,7 @@ Rules on what kind of patches are accepted, and which ones are not, into the
>     maintainer and include an addendum linking to a bugzilla entry if it
>     exists and additional information on the user-visible impact.
>   - New device IDs and quirks are also accepted.
> + - New features are not accepted unless they fix a reported problem.

No need to call this out, it falls under the "fixes a problem" option,
right?

The goal is not to iterate every single option here, that would be
crazy.  Let's keep it short and simple, our biggest problem is that
people do NOT read this document, not that it does not list these types
of corner cases.

So thanks for the patch, but I will not accept it.

thanks,

greg k-h
