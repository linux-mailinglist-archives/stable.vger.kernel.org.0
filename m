Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2260E5B4
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbiJZQsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbiJZQsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:48:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5562CFF264;
        Wed, 26 Oct 2022 09:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E815361FB7;
        Wed, 26 Oct 2022 16:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FBCC433D6;
        Wed, 26 Oct 2022 16:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666802879;
        bh=N4pHwh+tY/v5x/wFmlPjVR8THFTPHGXNBhEs3/MGs9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pLZ/B8Wv0pu2V3uqRUFKBPEVKhEdE1jIpLu3LqmCGfVzJSUIpKeEJryJfgnxLQwP9
         3XRmyI3D04S50xeJwNY8mcezi7j8NoesrmlnfEQAKXycv8wG6mCqPv1pQgahQAoYw1
         +Jl2ESk7qjwlazzon29GNoHSKF0EyahlvZPejr9I=
Date:   Wed, 26 Oct 2022 18:47:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     axboe@kernel.dk, yukuai3@huawei.com, stable@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@hawei.com
Subject: Re: [PATCH 5.10 2/3] blk-wbt: call rq_qos_add() after wb_normal is
 initialized
Message-ID: <Y1lkvFXjEMA80AFO@kroah.com>
References: <20221018014326.467842-1-yukuai1@huaweicloud.com>
 <20221018014326.467842-3-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018014326.467842-3-yukuai1@huaweicloud.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 09:43:25AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> commit 8c5035dfbb9475b67c82b3fdb7351236525bf52b upstream.

I need a 5.15 version of this, and the 3/3 patch in order to be able to
apply the 5.10.y version.

Can you please send that, and then resend the remaining patches here for
5.10.y?

thanks,

greg k-h
