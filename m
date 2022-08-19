Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDC9599A93
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348592AbiHSLKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348776AbiHSLKe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:10:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C1EF4936
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 04:10:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9818A61720
        for <stable@vger.kernel.org>; Fri, 19 Aug 2022 11:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B35DC433D6;
        Fri, 19 Aug 2022 11:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660907433;
        bh=IfOfehsAoB8zA1ZFmvT0NxSZGoYT4PAkcdF67dw8Kt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3GX/ls1wFmOeySddXYLlGIgKa+33bntQjxZReDvGkJ5xvF00wJ6OG7xR0NSJVGal
         ADSXR+isJBaL9gX3RNIkgLQMfiojBkIoG2cQtGnbRYaitlrHTCK1fBX++1WiWlg7kT
         CRLH2VitNMp+kXcdh5O+JtX+dD1ndP3AaviP4XKM=
Date:   Fri, 19 Aug 2022 13:10:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <smfrench@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 5.15.y 1/2] ksmbd: prevent out of bound read for
 SMB2_WRITE
Message-ID: <Yv9vppy5K+kaSTW3@kroah.com>
References: <20220816004431.30133-1-hyc.lee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816004431.30133-1-hyc.lee@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 09:44:30AM +0900, Hyunchul Lee wrote:
> [ Upstream commit ac60778b87e45576d7bfdbd6f53df902654e6f09 ]
> 

Both now queued up, thanks.

greg k-h
