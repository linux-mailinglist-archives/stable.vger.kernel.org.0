Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C4F4EBCCA
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 10:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242851AbiC3IfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 04:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbiC3IfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 04:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20EA68319
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 01:33:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6254B81BB6
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 08:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1CBC340EC;
        Wed, 30 Mar 2022 08:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648629203;
        bh=o2mhJUnoOvenlSGJRQR7RdkL44oraEGUTeYv0LH/t+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=11ID/D/9fkxYDYLGLsOXrHIFuMt3qv1RAgsWlANgGQS4+oIBVGQnbvXI15cTWJvKA
         nGbg+LqjnPrfCdDxs0FxBcYzGPkZfIIJMROZfgHBW0y5lxao/DMsm/4Ei8mI+mXMXM
         +TsUUFaBMDuHHSAcjdsTDQ+7pCojHFdHQJvIvDf8=
Date:   Wed, 30 Mar 2022 10:33:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     stable@vger.kernel.org, yf.wang@mediatek.com
Subject: Re: suggest commit 5b61343b50 to stable
Message-ID: <YkQV0OjQOoGV/QBg@kroah.com>
References: <20220330082157.3444-1-miles.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330082157.3444-1-miles.chen@mediatek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 04:21:57PM +0800, Miles Chen wrote:
> Hi reviewers,
> 
> I suggest to apply the following patch to stable kernel 5.4.y and 5.10.y:
> 
> commit: 5b61343b50590fb04a3f6be2cdc4868091757262
> Subject: iommu/iova: Improve 32-bit free space estimate
> kernel version to apply to: 5.4.y and 5.10.y

What about 5.15 and 5.16 and 5.17?  Why skip them?

thanks,

greg k-h
