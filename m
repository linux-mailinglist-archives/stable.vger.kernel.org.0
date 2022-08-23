Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166AD59EA64
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 19:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbiHWR5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 13:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbiHWR47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 13:56:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE506D9C7;
        Tue, 23 Aug 2022 09:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B607F61634;
        Tue, 23 Aug 2022 16:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D96C433B5;
        Tue, 23 Aug 2022 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661270503;
        bh=B5HCS1Zvo+tC6v63cqq1mybRwDvEEymaRNlGtv3xguE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g1nfU0iXWNMHiWn4KeeUEuzWRa9tXlY27F9eJ4mru86G43MmCNGN5dBXnU8V49RsO
         FxZ2c/tUtep3CWBnY+fUr/eyeHtNC3a07rto1BoFqjEU0wwBfWWQ+yWTbC6bblXCch
         Ebrjuhp9GjzUlMJV5ZcIARWLiDDN8dYfSdYXn8aHDat8fh4eBx0lm6Lfqzq+Ou5HwO
         KHuW60RQLpgJ3M4PohxXmIM4sIwwCnvPbWVkq9gG9ci8nVngrgWn9xW2QuJoi3yJz5
         hKVKe0fKJXfGl3p4beU7jSDsB5heNhF0w8VgoNUi08Ex64mTs0IkKAm95mduXwxTUf
         8HubFa6LbS2Qw==
Date:   Tue, 23 Aug 2022 21:31:35 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     srinivas.kandagatla@linaro.org, stable-commits@vger.kernel.org
Subject: Re: Patch "soundwire: qcom: Check device status before reading
 devid" has been added to the 5.15-stable tree
Message-ID: <YwT537rlrckb0/VV@matsya>
References: <16604006172842@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16604006172842@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13-08-22, 16:23, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     soundwire: qcom: Check device status before reading devid
> 
> to the 5.15-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      soundwire-qcom-check-device-status-before-reading-devid.patch
> and it can be found in the queue-5.15 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

This is causing regression in rc1 so can this be dropped from stable
please

-- 
~Vinod
