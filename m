Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB324E3B68
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 10:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiCVJFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 05:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiCVJFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 05:05:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D155F3E5FB
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 02:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63C956165E
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 09:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4E5C340EC;
        Tue, 22 Mar 2022 09:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647939829;
        bh=1oVZOJg30rAaQeliXHnjLl/kE1Rn/xi3Ej1/bkDvBx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j92FsCQuZgCfV3SGLujZ4vMmoxvrxQWoVVv0GZxkYUoe6NQoRDiIrNHVIT8Ny1+kV
         qkXYZRn0ZxaPz49hSF5FDgB4Jj8FXosLmTBxQpQOxSZrYe54KHfDBSMpJQkFVSvCKD
         6ezYC6rTRSuXh3dv6FhCy86d930mL4nu/RpkUQQY=
Date:   Mon, 21 Mar 2022 16:55:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH stable-5.15] MAINTAINERS: update Krzysztof Kozlowski's
 email
Message-ID: <Yjif3B1NQBr6z4c+@kroah.com>
References: <20220321144743.17896-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321144743.17896-1-krzk@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 21, 2022 at 03:47:43PM +0100, Krzysztof Kozlowski wrote:
> From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> commit 5125091d757a251a128ec38d2397c9d160394eac upstream.
> 
> Use Krzysztof Kozlowski's @kernel.org account in maintainer entries.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Link: https://lore.kernel.org/r/20220307172805.156760-1-krzysztof.kozlowski@canonical.com'
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  .mailmap    |  1 +
>  MAINTAINERS | 28 ++++++++++++++--------------
>  2 files changed, 15 insertions(+), 14 deletions(-)

We do not normally do MAINTAINERS updates for older kernel trees as no
one should be doing development against them.

Any reason why this is different?

thanks,

greg k-h
