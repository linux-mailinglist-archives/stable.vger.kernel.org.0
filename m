Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3CE6976AC
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 07:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbjBOGzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 01:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbjBOGzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 01:55:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC985D53C;
        Tue, 14 Feb 2023 22:55:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 726F261A34;
        Wed, 15 Feb 2023 06:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD2BC433D2;
        Wed, 15 Feb 2023 06:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676444104;
        bh=iubP8yXcNToMx9a2qJfqUPAOhKiuH64xBy+JLMWqOcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=acHTA80ZfrGm82Mb7Joyzy9mqHb+B+t04DTzqpUqN9zfoprtEdYLAibv9Tq86ZxIt
         isD0F9YrYhffllcPC3xEjTG2tdIyDX6JrpJ1tmZp24hFTs4DI5dQ70WzMKVlMomRvs
         5iaTbTyNFmNszgxbNjBeud/aBFURWjjIibAjyAak=
Date:   Wed, 15 Feb 2023 07:55:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     stable@vger.kernel.org, Xiu Jianfeng <xiujianfeng@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable v5.15.y 1/1] crypto: add __init/__exit annotations
 to init/exit funcs
Message-ID: <Y+yBxXNjBLuonPKP@kroah.com>
References: <20230214195300.2432989-1-saeed.mirzamohammadi@oracle.com>
 <20230214195300.2432989-2-saeed.mirzamohammadi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214195300.2432989-2-saeed.mirzamohammadi@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 11:53:00AM -0800, Saeed Mirzamohammadi wrote:
> From: Xiu Jianfeng <xiujianfeng@huawei.com>
> 
> Add missing __init/__exit annotations to init/exit funcs.
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> (cherry picked from commit 33837be33367172d66d1f2bd6964cc41448e6e7c)
> Cc: stable@vger.kernel.org # 5.15+
> Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> ---
>  crypto/async_tx/raid6test.c | 4 ++--
>  crypto/curve25519-generic.c | 4 ++--
>  crypto/dh.c                 | 4 ++--
>  crypto/ecdh.c               | 4 ++--
>  crypto/ecdsa.c              | 4 ++--
>  crypto/rsa.c                | 4 ++--
>  crypto/sm2.c                | 4 ++--
>  7 files changed, 14 insertions(+), 14 deletions(-)

What bug/problem does this resolve?  Why is this needed in stable
kernels?
