Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE094929BF
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 16:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345860AbiARPhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 10:37:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345835AbiARPhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 10:37:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF0CC061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 07:37:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4F20CCE1A05
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 15:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18941C00446;
        Tue, 18 Jan 2022 15:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642520261;
        bh=//SCQnLok7EMIkO0ihPwUdfss8kgJp8VvIABbDutpRE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E7uVSKBF8IATMOnuZU8W25ca1t59lDkSSggu/TLeVS+xkl6zgNF5vwb2QH1LJmM7w
         GQM2d9rBiErZli3Zy2BNY2hyW1geC/OpcVUQare0LgUIaq3BNKuoH0KeCTklLbb9Lt
         fbwIwFwtTtSUHOEfO9YLdL2CsKxjrJayHnwDcFjg=
Date:   Tue, 18 Jan 2022 16:37:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: Please backport b6b0d883bbb8 to v5.10
Message-ID: <YebewmWpzZ+7ix6q@kroah.com>
References: <87lezd1ado.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lezd1ado.fsf@mpe.ellerman.id.au>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 11:44:35PM +1100, Michael Ellerman wrote:
> Hi Greg,
> 
> Could you please backport:
> 
>   b6b0d883bbb8 ("powerpc/pseries: Get entry and uaccess flush required bits from H_GET_CPU_CHARACTERISTICS")

Do you really mean:
	65c7d070850e ("powerpc/pseries: Get entry and uaccess flush required bits from H_GET_CPU_CHARACTERISTICS")
instead?

I can not find b6b0d883bbb8 in Linus's tree :(

> to the v5.10 stable kernel. Thanks.

Assuming the above is the correct id, I have backported that to 5.10
now, thanks.

greg k-h
