Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4103E58A544
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 06:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiHEEX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 00:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiHEEX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 00:23:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15745205F5
        for <stable@vger.kernel.org>; Thu,  4 Aug 2022 21:23:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB45BB82029
        for <stable@vger.kernel.org>; Fri,  5 Aug 2022 04:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1345C433D7;
        Fri,  5 Aug 2022 04:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659673404;
        bh=nHEC3V652KY5TSyMY912Lq8m2m2W0EGb3rKkPDZpK7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RqvHMf9uHDt4UvX5Q9+p37ba3TKmq2eQtGk6l2fMCJXPWxBTxmdFIi1DqZrcqlHNx
         7VzvmVw72KeNXx3mojM8mCr3exLVT7bsXGozCAAucTgzdT+rESKTcw5UltOXNxa6/V
         V68JR/L27WZwkIEpcDUbe+zJh6L8NcV1C3ZT+euE=
Date:   Fri, 5 Aug 2022 06:23:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Augusto <augusto7744@aol.com>
Cc:     stable@vger.kernel.org
Subject: Re: kernel issues
Message-ID: <YuybNwoDERSXooXs@kroah.com>
References: <c27fc190-306d-c648-ea3a-e52839da2160.ref@aol.com>
 <c27fc190-306d-c648-ea3a-e52839da2160@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c27fc190-306d-c648-ea3a-e52839da2160@aol.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 04, 2022 at 07:24:23PM -0300, Augusto wrote:
> Hello.
> Thanks for read my message.
> In https://docs.kernel.org/admin-guide/reporting-issues.html has information
> to send message to stable@vger.kernel.org.
> I see an problem with BTRFS when using dm-writecache module.
> I wish report that bug issue.
> Where is the correct area to report kernel modules bugs ?

Please read Documentation/admin-guide/reporting-issues.rst for how to do
this properly.

good luck!

greg k-h
