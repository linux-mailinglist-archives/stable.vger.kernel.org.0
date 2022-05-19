Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3194852D35B
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiESM7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiESM7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:59:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A3EBC6FC
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 784F561631
        for <stable@vger.kernel.org>; Thu, 19 May 2022 12:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD3DC385B8;
        Thu, 19 May 2022 12:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652965103;
        bh=Pvvmoo68Zza0TES6BJ+8zGOoZwbHIQt1diq2FDBUwWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ej6CMQAH5/GcyaeJL+UYnUzwwjZDI54Ur2Ik7hxsO30eqUuR+gXyUxtiypcLwHMYd
         vMQCf4KezjoJZwBylSB+Mxqjm2e3GIDSlHAVNjHDzTeucLkOXN57YGyTUvXvGQs2Ot
         NGrQK8Iaj+7C1t/CrTTIuAqr8bzrKNKhuvjU9ykk=
Date:   Thu, 19 May 2022 14:57:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc:     akpm@linux-foundation.org, dvyukov@google.com, elver@google.com,
        glider@google.com, songmuchun@bytedance.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15.y] mm/kfence: reset PG_slab and memcg_data before
 freeing __kfence_pool
Message-ID: <YoY+ze7WxyvIOgz7@kroah.com>
References: <165270762342182@kroah.com>
 <YoTLReuLMhkLhyb8@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoTLReuLMhkLhyb8@hyeyoo>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 18, 2022 at 07:32:37PM +0900, Hyeonggon Yoo wrote:
> commit 2839b0999c20c9f6bf353849c69370e121e2fa1a upstream.

Now queued up, thanks.

greg k-h
