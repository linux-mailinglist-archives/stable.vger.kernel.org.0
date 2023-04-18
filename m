Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12DD6E5F14
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 12:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjDRKmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 06:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjDRKme (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 06:42:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7942626B9;
        Tue, 18 Apr 2023 03:42:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BCD46285B;
        Tue, 18 Apr 2023 10:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDE9C433EF;
        Tue, 18 Apr 2023 10:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681814534;
        bh=l/yiMks2uKIEi13QsAkG6JBlKO/hBWqQ7fDjDgvKw/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uMsrTpQIl7pfeQv5uHLn4gLnYjjZd4Ai+2Quahk9iAGq4w+A5EnzPuVeUrlGUJ8Pu
         yXte0nWAbxFPhd3QI29GZqlS/kObEtAb1pJhu+qWCg0gPk39tchW8CLdZvToRzqZeZ
         NAjUWKpJU+HFi4LZmIcjsbfQ+MejdyC/YCZl+rPw=
Date:   Tue, 18 Apr 2023 12:42:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc:     stable@vger.kernel.org, RCU <rcu@vger.kernel.org>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        Ziwei Dai <ziwei.dai@unisoc.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 1/1] linux-6.1/rcu/kvfree: Avoid freeing new kfree_rcu()
 memory after old grace period
Message-ID: <2023041844-chasing-skincare-4cfe@gregkh>
References: <20230418102518.5911-1-urezki@gmail.com>
 <20230418102518.5911-3-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418102518.5911-3-urezki@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 12:25:18PM +0200, Uladzislau Rezki (Sony) wrote:
> From: Ziwei Dai <ziwei.dai@unisoc.com>
> 
> commit 5da7cb193db32da783a3f3e77d8b639989321d48 upstream.
> 

What about 6.2.y?  You do not want anyone upgrading and having a
regression, right?

Please submit a backport for that tree too if you want any of these to
be applied.

thanks,

greg k-h
