Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9A05F7BAB
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 18:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJGQky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 12:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJGQkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 12:40:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9992128738;
        Fri,  7 Oct 2022 09:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3487961DB9;
        Fri,  7 Oct 2022 16:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A36C433C1;
        Fri,  7 Oct 2022 16:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665160846;
        bh=GIYpx5Sy7XvmcvilPfy35uGtzBoJlfuANKT/MFaPWDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kPBUwEj4yMW4txJHxbj1tleOOFWyV5wrUEYHsi7PaKxcQ7d9OuFIu5L1z+7EtanCU
         9amyR1gxul9OIp6RC9rgccyTAbU0J7ECQWC2EZAD/R6WRt8x62i9nnPiaa5Hb5EjF8
         48Z9wY1nfrI9eE0tY/OgSLbExL69eIEUcOthnbX0=
Date:   Fri, 7 Oct 2022 18:41:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yong w <yongw.pur@gmail.com>
Cc:     jaewon31.kim@samsung.com, linux-kernel@vger.kernel.org,
        mhocko@kernel.org, stable@vger.kernel.org, wang.yong12@zte.com.cn
Subject: Re: [PATCH v2 stable-4.19 0/3] page_alloc: consider highatomic
 reserve in watermark fast backports to 4.19
Message-ID: <Y0BWuJHsK6XDk2nx@kroah.com>
References: <Yyn7MoSmV43Gxog4@kroah.com>
 <20220925103529.13716-1-yongw.pur@gmail.com>
 <YzmwKxYVDSWsaPCU@kroah.com>
 <CAOH5QeB2EqpqQd6fw-P199w8K8-3QNv_t-u_Wn1BLnfaSscmCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOH5QeB2EqpqQd6fw-P199w8K8-3QNv_t-u_Wn1BLnfaSscmCg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top


On Fri, Oct 07, 2022 at 04:53:50PM +0800, yong w wrote:
> Is it ok to add my signed-off-by? my signed-off-by is as follows:
> 
>   Signed-off-by: wangyong <wang.yong12@zte.com.cn>

For obvious reasons, I can not take that from a random gmail account
(nor should ZTE want me to do that.)

Please fix up your email systems and do this properly and send the
series again.

thanks,

greg k-h
