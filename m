Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8D05821D7
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 10:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiG0IPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 04:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiG0IPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 04:15:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46599D134
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 01:15:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE412616CB
        for <stable@vger.kernel.org>; Wed, 27 Jul 2022 08:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A80C433D6;
        Wed, 27 Jul 2022 08:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658909719;
        bh=gDy8ppgxsQ9FGjBC8McQw4VAzoz8I/PjhHlPsOKelLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gLDWOdelk0we4c5JbHX+/lmgTOsYVU4pqjdNnA//nem0bjXLwC98vR2uIeykMypfc
         Sf4/DRiwkS/4wStVa7GrdW/KHglE9MSGZ+F59PJAJYy26tHsAX+lFAlvc4ufPskU2o
         pPNnHjte57kMmbvvyW0/xX7wntb1FUjpHX1xuHM0=
Date:   Wed, 27 Jul 2022 10:15:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     stable@vger.kernel.org
Subject: Re: apply 'exfat: use updated exfat_chain directly during renaming'
 to 5.15.y/5.18.y please
Message-ID: <YuD0FJ8DcNjCIHuU@kroah.com>
References: <20220726063556.958C.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726063556.958C.409509F4@e16-tech.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 26, 2022 at 06:35:57AM +0800, Wang Yugui wrote:
> Hi,
> 
> apply 'exfat: use updated exfat_chain directly during renaming' to 5.15.y/5.18.y please.
> 
> because it fix some problem of the patch
> 'exfat-fix-referencing-wrong-parent-directory-informa.patch'
> just applied in to 5.15.y/5.18.y
> 
> exfat: use updated exfat_chain directly during renaming
>     Fixes: d8dad2588add ("exfat: fix referencing wrong parent directory information after renaming")

Now queued up.

Next time also give me a hint as to what the git commit id in Linus's
tree that I need to pick, so I don't have to dig through the changelog.

thanks,

greg k-h
