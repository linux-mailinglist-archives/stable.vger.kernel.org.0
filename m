Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591605823E3
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 12:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiG0KKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 06:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiG0KKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 06:10:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E4626FB;
        Wed, 27 Jul 2022 03:10:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BD7D6182F;
        Wed, 27 Jul 2022 10:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AE1C433D6;
        Wed, 27 Jul 2022 10:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658916646;
        bh=EnJkkdJO/pQiJy5NDS3FoBWw8gJqA7yUL49NPtjzTMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nJ8op6rZEhxJeO9kVUhluUHmvg0ZxjW1S4atFRvJOLgllXzussK469eRxI+7QrJOi
         05mlnI3Qk0lPvMhHLIuuSfDIqK2Wy6zHqWUDu/jJ/I2xW6bHJhQ6qH+e0GL4AppauL
         6YkwU49fEjup9rf4Y0Dba6A8Q+aMa17DS74Hto8g=
Date:   Wed, 27 Jul 2022 12:10:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tianchen Ding <dtcccc@linux.alibaba.com>
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org, lmb@cloudflare.com,
        sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 373/575] selftests: bpf: Convert sk_lookup ctx
 access tests to PROG_TEST_RUN
Message-ID: <YuEPI/8xAMPl5XDw@kroah.com>
References: <20211115165356.685521944@linuxfoundation.org>
 <6258c4a1-0132-5afe-8dab-afa4ca3c49d6@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6258c4a1-0132-5afe-8dab-afa4ca3c49d6@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 25, 2022 at 10:53:38AM +0800, Tianchen Ding wrote:
> Hi Greg.
> 
> We found a compile error when building tools/testing/selftests/bpf/ on 5.10.
> 
> tools/testing/selftests/bpf/prog_tests/sk_lookup.c:1092:15: error: 'struct bpf_sk_lookup' has no member named 'cookie'
>  1092 |  if (CHECK(ctx.cookie == 0, "ctx.cookie", "no socket selected\n"))
> 
> It requires 7c32e8f8bc33 ("bpf: Add PROG_TEST_RUN support for sk_lookup programs") from upstream.
> 
> Maybe the left patches of this patchset are needed for 5.10 LTS?
> https://lore.kernel.org/bpf/20210303101816.36774-1-lmb@cloudflare.com/

If so, please submit them with the git commit ids so that I can fix this
up.

thanks,

greg k-h
