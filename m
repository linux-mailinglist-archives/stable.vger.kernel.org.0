Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5F653CCF3
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 18:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343638AbiFCQKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 12:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242040AbiFCQKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 12:10:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D9C2CDC2
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 09:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67F62B8237E
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 16:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11C0C34114;
        Fri,  3 Jun 2022 16:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654272620;
        bh=zFmioldLuo3Z5H59D49ic4kSB48kKyMUIs6acUr7lzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yadJWIXMrlYnbg3RvZMIfdrADUqbbOze6HyzQIzCpJEpgQmu2L12MZEy0eJc6Ow2a
         UD9UxVryhn2snhohaKslB1R6FNJdFlaCe+W6lP/LmLgL+YqScNi6APXn9qRgfqsUAF
         FiPrv/+zzzFq1ItYKTSHs1NzvFOqQLkTCUtY6m8U=
Date:   Fri, 3 Jun 2022 18:10:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org
Subject: Re: WTF: patch "[PATCH] Linux 5.18" was seriously submitted to be
 applied to the 1731160ff7c7bbb11bb1aacb14dd25e18d522779-stable tree?
Message-ID: <YpoyaXzBN61Y2pDf@kroah.com>
References: <1654271756154144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1654271756154144@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 05:55:56PM +0200, gregkh@linuxfoundation.org wrote:
> The patch below was submitted to be applied to the 1731160ff7c7bbb11bb1aacb14dd25e18d522779-stable tree.
> 
> I fail to see how this patch meets the stable kernel rules as found at
> Documentation/process/stable-kernel-rules.rst.
> 
> I could be totally wrong, and if so, please respond to 
> <stable@vger.kernel.org> and let me know why this patch should be
> applied.  Otherwise, it is now dropped from my patch queues, never to be
> seen again.

Ick, sorry, fat-fingered the script, this was wrong, obviously...
