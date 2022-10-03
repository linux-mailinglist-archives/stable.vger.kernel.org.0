Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224C95F2890
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 08:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJCGWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 02:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJCGWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 02:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10241CFEA
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 23:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5035F60EED
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 06:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5E1C433D6;
        Mon,  3 Oct 2022 06:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664778131;
        bh=xWnQqnlkyo17IUJcKzNNtKgQ2UW8Yp2NfjCFo3eykAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iWP7Jo0YSPnfR1YjuzW+adwPvPdNlCc/xyYFttu6jQ6vlzq5EzxfEEu+jCre8mEUv
         hTESVdvJyGzuRAa0JEb9zqeOsItJ/X6rLZi/O2/dDeqpgZ/ydwOFvirOzNFBL4bDwF
         EmrYCasbRZomPshQmTjxrd1XJ46Odu6Uf78caQWg=
Date:   Mon, 3 Oct 2022 08:22:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Levi Yun <ppbuk5246@gmail.com>
Cc:     stable@vger.kernel.org, sj@kernel.org, akpm@linux-foundation.org,
        damon@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH for-stable-5.19.y] fix possible memleak on
 damon_sysfs_add_target
Message-ID: <Yzp/uo+iKota3Oaz@kroah.com>
References: <20221002225444.70464-1-ppbuk5246@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221002225444.70464-1-ppbuk5246@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 07:54:45AM +0900, Levi Yun wrote:
> commit 1c8e2349f2d0 ("damon/sysfs: fix possible memleak on damon_sysfs_add_target") upstream.

Now queued up, thanks,

greg k-h
