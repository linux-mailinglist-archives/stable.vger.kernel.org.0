Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4251269F371
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjBVL1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjBVL0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:26:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F0732E75;
        Wed, 22 Feb 2023 03:26:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67D61B8125F;
        Wed, 22 Feb 2023 11:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D299FC433D2;
        Wed, 22 Feb 2023 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677065195;
        bh=bWvbgjp5RvB8PjMBAsX01lO9+dUd+JPhnTBNgA4gKBQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a58VsPwplYxex7nF2WVjfQIqO6HiRduekX0YWxsghAB8I8xQq3IVD3hf2oj3LBvTd
         vX/Nvki3KzEnC3IaQP610uz3lNnuJIVCfa7MhF8cUe5arr/T3EJPlKD5SoeIYHqFhV
         vJaAmqGNGCxF2Dun7lgSOABe87xY22W9Ea75kDLY=
Date:   Wed, 22 Feb 2023 12:26:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     maennich@google.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 1/5] MAINTAINERS: Add scripts/pahole-flags.sh to BPF
 section
Message-ID: <Y/X76CbLPwEE2BRG@kroah.com>
References: <20220201205624.652313-1-nathan@kernel.org>
 <20230222112141.278066-2-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222112141.278066-2-maennich@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 11:21:39AM +0000, maennich@google.com wrote:
> From: Nathan Chancellor <nathan@kernel.org>
> 
> Currently, scripts/pahole-flags.sh has no formal maintainer. Add it to
> the BPF section so that patches to it can be properly reviewed and
> picked up.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Link: https://lore.kernel.org/bpf/20220201205624.652313-2-nathan@kernel.org
> Signed-off-by: Matthias Maennich <maennich@google.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4f50a453e18a..176485e625a0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3407,6 +3407,7 @@ F:	net/sched/act_bpf.c
>  F:	net/sched/cls_bpf.c
>  F:	samples/bpf/
>  F:	scripts/bpf_doc.py
> +F:	scripts/pahole-flags.sh
>  F:	tools/bpf/
>  F:	tools/lib/bpf/
>  F:	tools/testing/selftests/bpf/
> -- 
> 2.39.2.637.g21b0678d19-goog
> 

No need for MAINTAINERS updates for older kernels as no one should be
making new patches against them, right?

thanks,

greg k-h
