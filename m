Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7391969EE8C
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 07:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjBVGB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 01:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBVGB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 01:01:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669B035249
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 22:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02A1BB811CF
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 06:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E70AC433D2;
        Wed, 22 Feb 2023 06:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677045684;
        bh=jVi7SxlX0FkG3Z3QZVwjgz8rC2mmoHLQYMwKm0ImshQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A+rhWSitL5+MILBswmtz51VCZsIp1TDv2edsYE57RZfi5ooDNBF/C27HTt62sYpJv
         8Gi/GErhVSgQzfyyxEWa46y9+531pFYMIsZPI5vEjB+k5luOId4iKVUaNMffqn44kk
         GxiPKwYwZA7+Mcu0W0UWt952SB7te97I8hG8z9C4=
Date:   Wed, 22 Feb 2023 07:01:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 v2 0/5] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Message-ID: <Y/WvsGwUfsenunAw@kroah.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
 <20230221230225.cll4lfsxhv2s4sms@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221230225.cll4lfsxhv2s4sms@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 05:02:25PM -0600, Tom Saeger wrote:
> On Fri, Feb 10, 2023 at 01:18:39PM -0700, Tom Saeger wrote:
> 
> I double-checked submission procedures and I believe everything is correct, 
> is there anything I still need to do?

Not top-post and have patience?  :)

They are in my queue, I wanted to wait until we had a "quieter" release
to put them in to make it easier to handle when this problamatic series
is let loose on all of the builders.

thanks,

greg k-h
