Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F0B6ECF73
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjDXNna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjDXNn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:43:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B478683D7;
        Mon, 24 Apr 2023 06:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81CDB6247E;
        Mon, 24 Apr 2023 13:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD1FC433EF;
        Mon, 24 Apr 2023 13:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682343737;
        bh=XSXN1bgcItMhDQ9pn/sLSuLbsqZ/zD5C6bDop0OKkrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LOu7Of7WnYjJtI1FDXEkCovtolNB4SycFn2KW1hZDoeX/jhU4Ex7hp9QRzB0ynfKX
         P/E7JeOPre5REgerXNm/bh5sGi2X7cskfrIhgPlYsds90g8wdQuWh72CAIssjDKnb7
         TRVE6UUvsa5YJSKjSUZokz5NDZqTKFRkC2tYZADXIpYGi9iJxL2yJFsoPGEvlIspNJ
         RjRrJNNdw0IiWRqNZl9+rxUzuSHLqszWmt6Jo5uY0DrbVxrqxz3vO+RzZNyEdZAKii
         Bf3l2HEECJVN0hV1YrSvMuQMVd5U7rF98YD3bPQlMmqPylOLIl4kY7elCXBIIfPkQW
         Uz6coTBgLnyQQ==
Date:   Mon, 24 Apr 2023 14:42:13 +0100
From:   Lee Jones <lee@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Martin Schiller <ms@dev.tdt.de>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] leds: trigger: netdev: recheck
 NETDEV_LED_MODE_LINKUP on dev rename
Message-ID: <20230424134213.GG50521@google.com>
References: <20230419210743.3594-1-ansuelsmth@gmail.com>
 <20230419210743.3594-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230419210743.3594-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Apr 2023, Christian Marangi wrote:

> Dev can be renamed also while up for supported device. We currently
> wrongly clear the NETDEV_LED_MODE_LINKUP flag on NETDEV_CHANGENAME
> event.
> 
> Fix this by rechecking if the carrier is ok on NETDEV_CHANGENAME and
> correctly set the NETDEV_LED_MODE_LINKUP bit.
> 
> Fixes: 5f820ed52371 ("leds: trigger: netdev: fix handling on interface rename")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v5.5+
> ---
>  drivers/leds/trigger/ledtrig-netdev.c | 3 +++
>  1 file changed, 3 insertions(+)

Applied, thanks

-- 
Lee Jones [李琼斯]
