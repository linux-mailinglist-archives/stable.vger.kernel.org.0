Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B5960E3E2
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 16:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbiJZO6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 10:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbiJZO6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 10:58:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E28C1187A8
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 07:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36C72B822C2
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 14:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813FEC433D7;
        Wed, 26 Oct 2022 14:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666796280;
        bh=Yw6a5cMfSXTIkIuEiIeVn+GlfLEB75K8Ho7aDZP3yUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=InjONw98Pv5stmAX4Qf2gBpE2LgDzX566Av+URBuF+klHfS73r9BGaB0hb7oZOdi8
         +76mCjm4ROcaIbAeev19EZUouITtMgoBJfsVk0z2ZoSoHaS+MEZdW/N3TgxG0G7FYl
         c7jTcuBbSbkRLkQSwBWK960NmEbzfhaZsfllJlK0=
Date:   Wed, 26 Oct 2022 16:57:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Vacura <w36195@motorola.com>
Cc:     stable@vger.kernel.org
Subject: Re: usb: gadget: uvc: scatter gather support fixes to 5.15+
Message-ID: <Y1lK9n32kzRXSvu1@kroah.com>
References: <Y07MhTJpuqr9xA3E@p1g3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y07MhTJpuqr9xA3E@p1g3>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 10:55:49AM -0500, Dan Vacura wrote:
> Hi Greg,
> 
> Requesting for the following patches to be picked to stable 5.15+ where
> the following change was integrated: e81e7f9a0eb9 ("usb: gadget: uvc:
> add scatter gather support")
> 
> Without these fixes data corruption and smmu panics will occur in the
> uvc gadget driver.
> 
> The fixes to be integrated are:
> 
>  859c675d84d4 ("usb: gadget: uvc: consistently use define for headerlen")
>  f262ce66d40c  ("usb: gadget: uvc: use on returned header len in video_encode_isoc_sg")
>  61aa709ca58a ("usb: gadget: uvc: rework uvcg_queue_next_buffer to uvcg_complete_buffer")
>  9b969f93bcef ("usb: gadget: uvc: giveback vb2 buffer on req complete")
>  aef11279888c ("usb: gadget: uvc: improve sg exit condition")
> 
> They apply cleanly on 5.15.y

All now queued up, thanks.

greg k-h
