Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2153B66DAB5
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 11:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbjAQKQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 05:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236610AbjAQKQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 05:16:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0291D91F;
        Tue, 17 Jan 2023 02:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D94B5B81263;
        Tue, 17 Jan 2023 10:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B94C433D2;
        Tue, 17 Jan 2023 10:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673950558;
        bh=sPvnnxQs7gz++ohDYQSkOddbBDV23XwrHutOGT4x8WM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jJry6yWyC9moc9pRdKmhkZz8bbWbgQQQ9M622DocpHPQ/xH73Vho24VwCpfP53+UB
         aEnVhCnJrbEe5KDNn2ffYPEthkryuyKt+IS3vb0Ss84C52hwR6etktVp9cD7jxsd9r
         84AdoZDKx5cqvlYhwIolm4tDu5EIZTo7N6h1VeFo=
Date:   Tue, 17 Jan 2023 10:17:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8Znr6CAFi8ikhdH@kroah.com>
References: <20230116154803.321528435@linuxfoundation.org>
 <20230117151136.CB79.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117151136.CB79.409509F4@e16-tech.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 03:11:37PM +0800, Wang Yugui wrote:
> Hi,
> 
> fstests(generic/034, xfs) panic when 6.1.7-rc1, but not panic when 6.1.6.
> 
> It seems patch *1 related.
> *1 Subject: blk-mq: move the srcu_struct used for quiescing to the tagset
> From: Christoph Hellwig <hch@lst.de>
> 
> This patch has been drop from 6.1.2-rc1. and it now added in 6.1.7-rc1 again.
> 
> the panic in 6.1.7-rc1 is almost same as that in 6.1.2-rc1.

Argh, yes, let me go drop these again.

Sasha, can you blacklist these from your tools so they don't get picked
up again?

thanks,

greg k-h
