Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5105B44AF
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 08:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiIJGfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 02:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiIJGfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 02:35:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC063205C;
        Fri,  9 Sep 2022 23:35:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2757D60C79;
        Sat, 10 Sep 2022 06:35:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAD4C433D7;
        Sat, 10 Sep 2022 06:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662791723;
        bh=LOPhUXm3gvvVChDSqxzIvyt5kOTUWhTju0aR+fQJQVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zvdw8PiYiz7AnGS+/kMHH1dNiYF6EKq0dAPwIYAACivmlLxjpr+9EbkFHsJpVJZ7F
         g3046fEDrQJ5xF5vT8HvgpzmSC+a3lJT8cNgmajssvc7zlYPJcFYdPIjaoVwGaLyLC
         ZU2tVw5D5+FT7KxYfMSE260TiuFORwjrEGkIv9tc=
Date:   Sat, 10 Sep 2022 08:35:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, stable@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-4.14] driver core: Don't probe devices after
 bus_type.match() probe deferral
Message-ID: <YxwwQWuUdq/VNuUF@kroah.com>
References: <20220908190144.3731136-1-isaacmanjarres@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908190144.3731136-1-isaacmanjarres@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 08, 2022 at 12:01:43PM -0700, Isaac J. Manjarres wrote:
> commit 25e9fbf0fd38868a429feabc38abebfc6dbf6542 upstream.

Both backports now queued up, thanks.

greg k-h
