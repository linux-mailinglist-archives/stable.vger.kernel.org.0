Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F83455C7A5
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbiF0Pds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 11:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbiF0Pdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 11:33:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE7D1A386;
        Mon, 27 Jun 2022 08:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA711B81889;
        Mon, 27 Jun 2022 15:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCCAC3411D;
        Mon, 27 Jun 2022 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656344002;
        bh=MODfoA89vJj35aXZx9pXeYCTfJcntXQZkYHfV0wodr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JkI+MrL82XV7RcwK0Hoh8wUfWIEAQ1cUg9mGlg8UqhE6xdkui8NIy7lgWO43+yAEF
         sfAJFTQ/PjS/RNRwS6Qa0ifX3bODsWFoJ6AdJfYQz3sSWB66uYcrto+MkHp3DoJWrL
         eQtXcQzDfIZYvDsCg6CCIt2hJgf5kdfLkDlI0SHAyctLpsgH5UuKs4Zk7aCLS7JiKU
         nfrvDxv8Q36ypOtElZQ66ICux9MBLnLAOOQB7P6yEgPoVW66epWsKASFI0qFg0JoiD
         RlOcFjfALUgjVYt64S+Cs+hP3y2XKjHBZogItR9oZC+Rt4EZjwkzDRUosFAs/EMYS6
         xVjXDWGaDp/UQ==
Date:   Mon, 27 Jun 2022 08:33:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.18 097/181] Revert "net/tls: fix tls_sk_proto_close
 executed repeatedly"
Message-ID: <20220627083313.285787a5@kernel.org>
In-Reply-To: <20220627111947.372126973@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
        <20220627111947.372126973@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jun 2022 13:21:10 +0200 Greg Kroah-Hartman wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit 1b205d948fbb06a7613d87dcea0ff5fd8a08ed91 ]
> 
> This reverts commit 69135c572d1f84261a6de2a1268513a7e71753e2.
> 
> This commit was just papering over the issue, ULP should not
> get ->update() called with its own sk_prot. Each ULP would
> need to add this check.
> 
> Fixes: 69135c572d1f ("net/tls: fix tls_sk_proto_close executed repeatedly")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Mm? How did 69135c572d1f get into stableh? 
I reverted it before it hit Linus's tree.
Don't see the notification about it either.
