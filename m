Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C92F48F1D6
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 22:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiANVHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 16:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiANVHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 16:07:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3069DC06161C;
        Fri, 14 Jan 2022 13:07:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECA88B82A28;
        Fri, 14 Jan 2022 21:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43703C36AE9;
        Fri, 14 Jan 2022 21:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642194452;
        bh=ZL7v3SjQIdKufAKqWNrLkle1oD9dG0wh6lJBBoIu6+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z7eLuaFKMW1RHr6hy8fkkVtQhncSszfBq+4pa8xmWkX/FsFkoPdfFIKntonMDNs4M
         Hji2k3S74pwnfTZAdyTKX4sZjWhbcQX3CWFVhHpnr1VfFHV2zbf7SFFo+/pGeb8c1C
         dqD1ETWX7AJ9Hhd/Q3XArjBu9OFctdDPFv7u2Q7sVXQjmvazDBxwhYsN9LKqcKUca/
         eBByR+O1t4QxYx4SxTGP9xklOYqadIO+S5qxK/zF0isaUuExb9UJ5xVmYuTUf2G1i3
         XNDrwRBaBdKsPRbQMBMlSB4sycaILXf3ACL8PrU031idel235b2H8qmJd0CePTgsoF
         4eSVhs48OyKLQ==
Date:   Fri, 14 Jan 2022 23:07:19 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Tadeusz Struk <tstruk@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] tpm: Fix error handling in async work
Message-ID: <YeHmB0BWgfVGPL55@iki.fi>
References: <20220111055228.1830-1-tstruk@gmail.com>
 <Yd8fY/wixkXhXEFH@iki.fi>
 <3c2eeee7-0d3e-8000-67ad-3054f229cbe0@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c2eeee7-0d3e-8000-67ad-3054f229cbe0@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 10:47:29AM -0800, Tadeusz Struk wrote:
> On 1/12/22 10:35, Jarkko Sakkinen wrote:
> > These look good to me! Thank you. I'm in process of compiling a test
> > kernel.
> 
> Thanks Jarkko,
> You can run the new test before and after applying the change and see
> how it behaves. Also just noticed a mistake in the comment, sorry but
> it was quite late when I sent it.
> 
> +	/*
> +	 * If ret is > 0 then tpm_dev_transmit returned the size of the
> +	 * response. If ret is < 0 then tpm_dev_transmit failed and
> +	 * returned a return code.
> +	 */
> 
> In the above could you please replace:
> 
> s/returned a return code/returned an error code/
> 
> before applying the patch. I would appreciate that.

Please send new versions, there's also this:

def test_flush_invlid_context()

I'd figure "invlid" should be  "invalid"

You can add, as these changes do not change the semantics of the
patches:

Tested-by: Jarkko Sakkinen <jarkko@kernel.org>

It's always best if you author the final version, as then a clear
reference on what was accepted exist at lore.kernel.org.

BR, Jarkko
