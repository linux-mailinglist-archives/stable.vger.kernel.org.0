Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB536B9BFA
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 17:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbjCNQpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 12:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCNQpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 12:45:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BE37C95B;
        Tue, 14 Mar 2023 09:45:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D86ADB81A5E;
        Tue, 14 Mar 2023 16:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF06AC4339E;
        Tue, 14 Mar 2023 16:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678812309;
        bh=j2xWUAOZSRLlO/ev+lt9E+QU+qllIxZ9a5PL9SD5idA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qVwMBJRs70EPFJFbvMtr7dCV/KMvQmv3KsTGOExBirxoxX1UEcib60nXgEKl9sD1h
         yxYJmwiulz4T4SlMB+bZ5ZUV8pukRYEFhGTzaMG0cZ2utYRXXSUBAJG7JfKn5VOmTu
         Mx/abtD6PTZ5my0X9DJayXi6If1LJUdygk8nQYN56cbi9whFfWJPlTeu+ZNOt9VoFy
         1YbkUP/ZWCsq1G/tr+Sx2IEgbAAvBjFfq10A8PmJs83dSuz7LVWY77LKcd8Sg+5zWI
         b3kPQW6VSPjJGl3UFEGwVzo8IHUjM1Fmcqnkyrt6qwSspfsmRS/PxlolTKjvjJ9T6w
         NK58KUFuP8cgw==
Date:   Tue, 14 Mar 2023 17:45:06 +0100
From:   Andi Shyti <andi.shyti@kernel.org>
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     andi.shyti@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] i2c: xgene-slimpro: Fix out-of-bounds bug in
 xgene_slimpro_i2c_xfer()
Message-ID: <20230314164506.mp5himopvx6zzt7n@intel.intel>
References: <20230314160416.2813398-1-harperchen1110@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314160416.2813398-1-harperchen1110@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Wei,

On Tue, Mar 14, 2023 at 04:04:16PM +0000, Wei Chen wrote:
> The data->block[0] variable comes from user and is a number between
> 0-255. Without proper check, the variable may be very large to cause
> an out-of-bounds when performing memcpy in slimpro_i2c_blkwr.
> 
> Fix this bug by checking the value of writelen.
> 
> Fixes: f6505fbabc42 ("i2c: add SLIMpro I2C device driver on APM X-Gene platform")
> Signed-off-by: Wei Chen <harperchen1110@gmail.com>

Reviewed-by: Andi Shyti <andi.shyti@kernel.org>

Thanks,
Andi

PS Remember the Cc: tag
