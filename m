Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC247304D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234225AbhLMPTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:19:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37030 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhLMPTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 10:19:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 503546111D;
        Mon, 13 Dec 2021 15:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F2FC34602;
        Mon, 13 Dec 2021 15:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639408783;
        bh=Q/WYKWA+urJ0ADwJn9AdInCvtHW0NmNQnJ/3cWdaBHk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oKVRdYlaQ6Am42LniEyz7aJS1v+ubOAJaA70AEAJ92+rkKGWN9lSxUpnnSyxeoPxi
         wsak+QW9BtA17RdZW5NAgzEYnYVaXQGmCQ6vimVch55Axq/pi0utS6jTWB8RYyL5Z1
         tzODjqGz8U+NYlnXOe0wJA+pgYEYHgzuupO1U7SQ=
Date:   Mon, 13 Dec 2021 16:19:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] libata: if T_LENGTH is zero, dma direction should
 be DMA_NONE
Message-ID: <YbdkjKH/jv57SYJl@kroah.com>
References: <1639408164-4210-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639408164-4210-1-git-send-email-george.kennedy@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:09:24AM -0500, George Kennedy wrote:
> Avoid data corruption by rejecting pass-through commands where
> T_LENGTH is zero (No data is transferred) and the dma direction
> is not DMA_NONE.
> 
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
> ---
>  drivers/ata/libata-scsi.c | 6 ++++++
>  1 file changed, 6 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
