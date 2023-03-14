Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCDA6B9C73
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 18:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCNRGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 13:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCNRF7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 13:05:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E328E532BE;
        Tue, 14 Mar 2023 10:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F4A46186A;
        Tue, 14 Mar 2023 17:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B02AC433EF;
        Tue, 14 Mar 2023 17:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678813557;
        bh=C9a2B8MGBer8D/2EYIob17Oq55MgxO4ekLktobGzFCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KIUxAin4AHLDHWl9F3evPbhU0u6Xj93CqdzpUk9F1B9f3T60yt3pljqH8hQNbaQd9
         POOmTA1A9bDHE62KWB+MbAIo2fdsl8mKvuKvu6hfTTTBYcbkyswXmEt/jYYN/G7cni
         GQ/ZzbwgilhYMWqk6R7Tk1aGKmrbAnWfvqy43ejKYjrrSW8twVRWrf3qoy84fHs8k7
         6Av4mhPwLyMcUz0pkps59/WwzdKgpDlVFbGrv5bm0SYaCoX6uLLLFqs+wrsD/c8BzK
         8X/icdDyBNkSJdAqD8PvpIiI1a1h/3CXH7fhp2X7xLSCTCu541mnTZDe/rJaFpU8Si
         bEf9SYLpv3X1g==
Date:   Tue, 14 Mar 2023 18:05:54 +0100
From:   Andi Shyti <andi.shyti@kernel.org>
To:     Wei Chen <harperchen1110@gmail.com>
Cc:     andi.shyti@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] i2c: xgene-slimpro: Fix out-of-bounds bug in
 xgene_slimpro_i2c_xfer()
Message-ID: <20230314170554.ubgioo2k7kbziskj@intel.intel>
References: <20230314165421.2823691-1-harperchen1110@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314165421.2823691-1-harperchen1110@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Wei,

On Tue, Mar 14, 2023 at 04:54:21PM +0000, Wei Chen wrote:
> The data->block[0] variable comes from user and is a number between
> 0-255. Without proper check, the variable may be very large to cause
> an out-of-bounds when performing memcpy in slimpro_i2c_blkwr.
> 
> Fix this bug by checking the value of writelen.
> 
> Fixes: f6505fbabc42 ("i2c: add SLIMpro I2C device driver on APM X-Gene platform")
> Signed-off-by: Wei Chen <harperchen1110@gmail.com>
> Cc: stable@vger.kernel.org

and...

Reviewed-by: Andi Shyti <andi.shyti@kernel.org>

Thanks,
Andi
