Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FB959132B
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 17:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbiHLPhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 11:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237856AbiHLPhl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 11:37:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D485C367
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 08:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8251860918
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 15:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDBFC433C1;
        Fri, 12 Aug 2022 15:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660318659;
        bh=VuY3ej9//D0Ymc2txW2USL9D4EzLcy2epSCnFsT13p8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xQAlR+EBP7efEPLDBzq2O5rorQ6eXKuFOU6wmiRZH+tIkARRljQbRkJLfKnd0/cz9
         mQn5QtT/+f6AxIX+QVFQFphw5x1QLkv7CIn3W2gvwrrnKfELFh6iKsjggDPeNiyVHx
         SY+406OuUgodNDDDUFOtZmcDvbdA66ehWN31bovI=
Date:   Fri, 12 Aug 2022 17:37:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH 5.10 0/1] Backport support for tracing capacity constants
Message-ID: <YvZzwc7x+0QzTPlH@kroah.com>
References: <1660255683-1889-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1660255683-1889-1-git-send-email-khoroshilov@ispras.ru>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 12, 2022 at 01:08:02AM +0300, Alexey Khoroshilov wrote:
> Syzkaller reports a number of "BUG: MAX_LOCKDEP_CHAINS too low!" warnings
> on 5.10 branch and it means that the fuzz testing is terminated prematurely.
> Since upstream patch that allows to increase limits is applied cleanly
> and our testing demonstrated that it works well, we suggest to backport
> it to the 5.10 branch.

What about all of the newer kernels branches, it is needed in 5.15.y,
5.18.y and 5.19.y, right?  What's so special about 5.10.y?

thanks,

greg k-h
