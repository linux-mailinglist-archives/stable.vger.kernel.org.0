Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2859586698
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 10:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiHAIwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 04:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiHAIwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 04:52:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008832F679;
        Mon,  1 Aug 2022 01:52:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90D6961029;
        Mon,  1 Aug 2022 08:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A4CC433D7;
        Mon,  1 Aug 2022 08:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659343920;
        bh=UUSSE82nxVKqS27Phsx9M3lpwwky5qxW8QBahnQN8CY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wc1KsCtvcrXj53L9zyFkW5vKlphg/qkmDzlYmFQU+uLm3BoWShweV4g9AWySb24Ot
         LJIFH71xc3n3qWK9zGuimNeNatfGpTgAnSuX2L8V9aaXo8AMEvJM1GK8elvH/JNLox
         nYjFPmJYxL5drt+PSjL+sZiDC8fXX0+TXKhPxTxM=
Date:   Mon, 1 Aug 2022 10:51:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tianchen Ding <dtcccc@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/3] fix build error in bpf selftests
Message-ID: <YueUJqQUUbr9n8wn@kroah.com>
References: <20220801072916.29586-1-dtcccc@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801072916.29586-1-dtcccc@linux.alibaba.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 03:29:13PM +0800, Tianchen Ding wrote:
> We found a compile error when building tools/testing/selftests/bpf/ on 5.10.y.
> tools/testing/selftests/bpf/prog_tests/sk_lookup.c:1092:15: error: 'struct bpf_sk_lookup' has no member named 'cookie'
>  1092 |  if (CHECK(ctx.cookie == 0, "ctx.cookie", "no socket selected\n"))
>       |               ^
> 
> To fix this bug, this patchset backports three patches from upstream:
> https://lore.kernel.org/bpf/20210303101816.36774-1-lmb@cloudflare.com/
> 
> Patch 1 and 2 are necessary for bpf selftests build pass on 5.10.y.
> Patch 3 does not impact building stage, but can avoid a test case
> failure (by skipping it).

Now queued up, thanks.

greg k-h
