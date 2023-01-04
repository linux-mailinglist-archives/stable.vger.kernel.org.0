Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3793F65D2B9
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjADMce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjADMcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:32:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB66834762
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:32:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56B8461259
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4976BC433D2;
        Wed,  4 Jan 2023 12:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672835548;
        bh=zJSXtqMzKmGR8cix7XMl+QTnrgM39MvldICEdGYyxWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ONjChtq8w9weQ/OUAkDqRwOjp79k7CpbZEBEK0wb5+uAz1oTTkWKl4XK7xZNStxEW
         dRcFG4wFaIs2uJht/4cHkb0AU0vKEFOh51rlPYMipa6pxrHrkcGomfIIHDOYn7WKPI
         9DRQQa0Ii17u5jOo2pVmKKupwXOec/boChXMDn/E=
Date:   Wed, 4 Jan 2023 13:32:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Semyon Verchenko <semverchenko@factor-ts.ru>
Cc:     stable@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 5.10 0/2] wifi: rtlwifi: 8192de: fix IQK reload checking
Message-ID: <Y7Vx2QfK3Q1e7YcF@kroah.com>
References: <20221223123416.71557-1-semverchenko@factor-ts.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223123416.71557-1-semverchenko@factor-ts.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 23, 2022 at 03:34:14PM +0300, Semyon Verchenko wrote:
> SVACE reports always true condition issue at
> tl92d_phy_reload_iqk_setting() in 5.10 stable releases. The problem has
> been fixed by the following patches which can be cleanly applied to the
> 5.10 branch.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.

Now queued up, thanks.

greg k-h
