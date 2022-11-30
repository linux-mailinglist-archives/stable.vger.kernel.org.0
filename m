Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6A463CF86
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 08:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbiK3HFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 02:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiK3HFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 02:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CF654767
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 23:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61BFEB8199C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:05:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59167C433C1;
        Wed, 30 Nov 2022 07:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669791907;
        bh=4dBehnkG6b02fFYC7gKQYrtnb6IG5qICOe7EqEN4qR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B8BVPNSLOdIZB9EqdXIbQjnXmeG8t6HkNk53nXOHI+U2slSiWHb/cjrM275EqibOL
         O1QYjtOQKjrH3RQeptLhHbbrxTTFnbx2h3cXvwg9UT9JgHyanVEmHn6Yq5wYut0hZD
         Cl2ip50Z69ro1r4nrC8CcDZ/Z1mWeoHqJpPZj+Fc=
Date:   Wed, 30 Nov 2022 08:05:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     hinxx <hinxx@protonmail.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: sendfile(2) use with a char driver
Message-ID: <Y4cAn1foct0ItDzK@kroah.com>
References: <bb1-8NcxtVn8HSt49oYW5HaHrKdOa814M4_SnZAqAKxacGs9rbrHsadsdzZIDBaZ-w4Ki2H2InCY83bq0uBzOkj23YtHz3hYfqOFPKL87F0=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb1-8NcxtVn8HSt49oYW5HaHrKdOa814M4_SnZAqAKxacGs9rbrHsadsdzZIDBaZ-w4Ki2H2InCY83bq0uBzOkj23YtHz3hYfqOFPKL87F0=@protonmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 09:15:24PM +0000, hinxx wrote:
> I'm looking to use a sendfile(2) with a Xilinx XDMA kernel driver in order to move data from a PCIe board with Xilinx FPGA to the network card with "zero-copy".
> 
> Currently I'm getting EINVAL return status from sendfile(2) when providing opened XDMA device file descriptor as input fd.
> 
> The device driver provides a character device that can be mmap'ed.
> 
> There seem to be other restrictions. Can anyone provide insight on what would be needed to make this work?

Please contact the authors of your kernel driver, they can answer this
best.

good luck!

greg k-h
