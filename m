Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857A25AEE3A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbiIFOz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233783AbiIFOzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:55:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DC5A570E;
        Tue,  6 Sep 2022 07:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE28FB816A0;
        Tue,  6 Sep 2022 13:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D8FC433C1;
        Tue,  6 Sep 2022 13:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472443;
        bh=vYYkxPfb2/GCDIjtBi6KVk15jMRzi+kITFp3Fbi8+lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C7OaLKRVgNwYg1Lrwc1xEjGeeAP3Gx9aMA3ygbWwh4KVVz9dEZXJ2qlTcV5LUYlg1
         8fec+4glb8RjW7ajIL4pqRlWyvenlPe30ShEtGxWPhow4oRtKzaEeHPrjRVUXASpTP
         5p8VmokmQUVlVKiCotSua26cFunMhO9JS8plpv0g=
Date:   Tue, 6 Sep 2022 15:41:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-5.4 0/3] USB: stable backports to 5.4
Message-ID: <YxdOHV2WUxKBIKWa@kroah.com>
References: <20220906133435.26452-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906133435.26452-1-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 03:34:32PM +0200, Johan Hovold wrote:
> Here are backports of the three patches that didn't apply to 5.4.
> 
> Johan
> 
> 
> Johan Hovold (3):
>   usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
>   USB: serial: ch341: fix lost character on LCR updates
>   USB: serial: ch341: fix disabled rx timer on older devices
> 
>  drivers/usb/dwc3/dwc3-qcom.c | 14 +++++++++++++-
>  drivers/usb/dwc3/host.c      |  1 +
>  drivers/usb/serial/ch341.c   | 15 +++++++++++++--
>  3 files changed, 27 insertions(+), 3 deletions(-)
> 
> -- 
> 2.35.1
> 

All now queued up, thanks!

greg k-h
