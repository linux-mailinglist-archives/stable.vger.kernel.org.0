Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5626D1955
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 10:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCaIFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 04:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbjCaIFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 04:05:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CF618817
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 01:05:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA53CB82CD9
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 08:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCCFC433D2;
        Fri, 31 Mar 2023 08:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680249905;
        bh=9TYDO62f1mZzxtic7cls9h8J1YG9DFuZoC4hhWMHIMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ufjksh//xD7mkGVnOGrpO/cp5x7o3PE2GB/Hmej9zWa6G/xQT/m9tZDdzuRG0xUWp
         yLmruzng+fhV3TWHIshMAR6pLtuX0lxhpfnlQyvmAihd+UmIA1IDo/hk/dYw51PDJ5
         Ax9by5BWtvrmhdBR7toBUHuGfX/h6VuObBkmNSI8=
Date:   Fri, 31 Mar 2023 10:05:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ilari =?iso-8859-1?B?SuTkc2tlbORpbmVu?= 
        <ijaaskelainen@outlook.com>
Cc:     "linux-stable.git mailing-list" <stable@vger.kernel.org>
Subject: Re: linux-5.15.105 broke /dev/sd* naming (probing)
Message-ID: <ZCaULkVk6iHHJYm2@kroah.com>
References: <GV1PR10MB62412F2794019C35025C7360A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <GV1PR10MB62412F2794019C35025C7360A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 31, 2023 at 10:52:55AM +0300, Ilari Jääskeläinen wrote:
> As I attached a USB SSD into CentOS 9 Stream computer, after a short
> while it swaps /dev/sdb into /dev/sdc and the I/O gets ruined.
> Kind regards, Ilari Jääskeläinen.
> 

Is this using the CentOS kernel, or a kernel.org release?

And if a device changes names like that, it implies it was disconnected
and then reconnected, what does the kernel logs say when this happened?

thanks,

greg k-h
