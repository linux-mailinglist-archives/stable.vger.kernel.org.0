Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD72168B53B
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 06:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjBFFiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 00:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjBFFiH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 00:38:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0929EFD;
        Sun,  5 Feb 2023 21:38:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED1560C85;
        Mon,  6 Feb 2023 05:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F7AC433EF;
        Mon,  6 Feb 2023 05:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675661884;
        bh=u5PK756z5u83idtg+VqoPFsTqKHAqNBbMeRczXNHGZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x/AFkdWRvx118B0t5XeIg/RwXA9znDEEIaig3tQIbZm4HckaCRAWyFY06C6xp/jbE
         /M5dlg6F7eeA6FGqguSdpx0Cfx2m7T4vZfEB/PaqWWDYho0IKOrKux0vzT1BEfWhb7
         HNnny/PGt30Q9P3yjFz9oVCxbYileK8INy6JbL1A=
Date:   Mon, 6 Feb 2023 06:38:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, stable@vger.kernel.org,
        dave.hansen@linux.intel.com, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 10/18] cxl/region: Fix passthrough-decoder detection
Message-ID: <Y+CSOeHVLKudN0A6@kroah.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 05, 2023 at 05:03:24PM -0800, Dan Williams wrote:
> A passthrough decoder is a decoder that maps only 1 target. It is a
> special case because it does not impose any constraints on the
> interleave-math as compared to a decoder with multiple targets. Extend
> the passthrough case to multi-target-capable decoders that only have one
> target selected. I.e. the current code was only considering passthrough
> *ports* which are only a subset of the potential passthrough decoder
> scenarios.
> 
> Fixes: e4f6dfa9ef75 ("cxl/region: Fix 'distance' calculation with passthrough ports")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

If a patch really is a "fix" that needs to go to stable kernels, why is
it commit 10 out of 18?  Why isn't it going to Linus now for inclusion
in 6.2-final?  Does it depend on the 9 earlier patches in this series?

thanks,

greg k-h
