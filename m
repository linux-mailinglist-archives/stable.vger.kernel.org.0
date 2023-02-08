Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C3268F3EB
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 18:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjBHRBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 12:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjBHRBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 12:01:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F141EFD4;
        Wed,  8 Feb 2023 09:01:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B19D4616FA;
        Wed,  8 Feb 2023 17:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D5DC433D2;
        Wed,  8 Feb 2023 17:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675875694;
        bh=WxT5xhayypkrZEYEVZEKseAEzokJIqJYFfDjgjZbKUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o1uuNIlH1PUToVk+xtsIMYYW1qcn1qo87FyDf3UCKO9/OZXJZ5h0xwZHGBJinBDV2
         5Y1AU+XE0vOPplGBcDjTOHpdnHf5uHrhCX0sEX98uP3mGyFy/eT7eRpneuZwIA5iED
         9zQo0bmDotq8ZVEfVEkQV+JaXoGdCzqBwCqiPrQ4=
Date:   Wed, 8 Feb 2023 18:01:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mark Pearson <mpearson-lenovo@squebb.ca>
Cc:     linux-usb@vger.kernel.org, Miroslav Zatko <mzatko@mirexoft.com>,
        Dennis Wassenberg <dennis.wassenberg@secunet.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: core: add quirk for Alcor Link AK9563 smartcard
 reader
Message-ID: <Y+PVau/cczvkllxr@kroah.com>
References: <mpearson-lenovo@squebb.ca>
 <20230208165018.1088701-1-mpearson-lenovo@squebb.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208165018.1088701-1-mpearson-lenovo@squebb.ca>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 08, 2023 at 11:50:18AM -0500, Mark Pearson wrote:
> The Alcor Link AK9563 smartcard reader used on some Lenovo platforms
> doesn't work. If LPM is enabled the reader will provide an invalid
> usb config descriptor. Added quirk to disable LPM.
> 
> Verified fix on Lenovo P16 G1 and T14 G3
> 
> Tested-by: Miroslav Zatko <mzatko@mirexoft.com>
> Tested-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
> Cc: stable@vger.kernel.org
> 

Blank line still not needed :(

> Signed-off-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
> Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
> ---
> Changes in v2: Put entry in correct position in quirks list.

Still in the incorrect place :(



