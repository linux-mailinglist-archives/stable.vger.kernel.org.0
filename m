Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664415AEE06
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiIFOoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiIFOnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:43:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCC69DB56;
        Tue,  6 Sep 2022 07:03:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60C4561512;
        Tue,  6 Sep 2022 14:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50EBC433C1;
        Tue,  6 Sep 2022 14:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662472907;
        bh=j0TAG9++VbQQ9LCoxQPoMsJoaNjyXs8pLQwddrq7nqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b2xu3kBJoVhoAGHdoExQLF+ehMPzTjB5NEfB9W1RXL2q7wKBTdGgO0lTqJIK1mmkJ
         NM5jmOxvdIxnoEi6ZXyZyP+2TsiaRzEPrCvZ7+rGKwUFGzLuzLq/zHvqxn9K+CimlH
         MYTUT5eDMnqXIXjIvNuHsA8Q96VgobgHvls8597JYsqMV8CDLf52H3MU3Dr+Ze4AI0
         K4pqUWuhny8HbD+dTond12F817hP8Y77QMrVlGcCePOB37P50CGmksXEy94eLs9zLe
         pnQ/j2djtcQgeugf8599QkK/2x5u6VT7Q1jK34pVR8kOXKdAm5/+2d3H29bBpkyec8
         hF9Glur61qCYw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVZ9E-0007wk-8H; Tue, 06 Sep 2022 16:01:52 +0200
Date:   Tue, 6 Sep 2022 16:01:52 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-4.19 0/4] USB: backports to 4.19
Message-ID: <YxdS0EXyZrTiHdLL@hovoldconsulting.com>
References: <20220906134915.19225-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906134915.19225-1-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 03:49:11PM +0200, Johan Hovold wrote:
> And here are the corresponding backports to 4.19.
> 
> Johan
> 
> 
> Johan Hovold (4):
>   usb: dwc3: fix PHY disable sequence

This one needs another spin for 4.14...

>   usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup

>   USB: serial: ch341: fix lost character on LCR updates
>   USB: serial: ch341: fix disabled rx timer on older devices

But these two should hopefully apply to the older trees too now.

Johan
