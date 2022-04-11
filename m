Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6849C4FB7B1
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 11:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344540AbiDKJi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 05:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344529AbiDKJiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 05:38:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC29403E0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 02:36:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD02860B60
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 09:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA7FC385A5;
        Mon, 11 Apr 2022 09:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649669791;
        bh=2iDtxutVhicp4j5v/vtocvb00g9bQlFy562U0ETldMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R8KBaNw4oXV5xzJRLTkLfx/djxIiZahuc280Y2HMqXqeazXRP1xNwB3mtMeCfr997
         hJvEkHYjf0v6mnGeH55m4p+ebbbbXclYPQuhQ3TPaMqzNmL5QDQpUVDVtRKtUsavAp
         pIoztA4YYY+xRCfvyi5ZInUGNOt+7XgKGlw8vgkg=
Date:   Mon, 11 Apr 2022 11:36:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ketsui <esgwpl@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Please backport commit dfbba2518aac4204203b0697a894d3b2f80134d3
Message-ID: <YlP2nFAuSQ+JruQX@kroah.com>
References: <YlHEbgyXT9crVF7O@mainframe.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlHEbgyXT9crVF7O@mainframe.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 10, 2022 at 12:37:50AM +0700, Ketsui wrote:
> Commit 87ebbb8c612b broke suspend-to-ram on kernel 5.17, trying to resume
> with it results in an unusable system. I've tried reverting it from 5.17
> and found that resuming works once again.

Now applied, thanks!

greg k-h
