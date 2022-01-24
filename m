Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B324C4985A1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 18:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244062AbiAXRBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 12:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244057AbiAXRBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 12:01:32 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83338C06173D
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 09:01:32 -0800 (PST)
Received: from mail.denx.de (unknown [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: festevam@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 42CF280820;
        Mon, 24 Jan 2022 18:01:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1643043691;
        bh=OBccyqam54ebOPTO065jMKR1BrBaQQOgB/Zw1nOQwY4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nhhE5vl43krTsKNY7hfRoOkbi6S0Sw28Vze136mpmQaVjS/mZrZyhVXPCDsCu54UY
         XPlNbSVGu47M0RHshcJGNG5trnVbkoLrMqS43kjZ+qWROXVxb0CP9p5njoD/Bc5HYO
         0Gr9GbV7cu31WXqzikaOEecxuK0mKCDNXMWzfAGEwkiKmMcwECpHXaqCFU267Va0H6
         sB3Libt5IABbPwFUKSKJAkFKaveDUQYAPVc1nbbL+Lv1icbymOyupug5B125SMBMSI
         FQ3SbxyQzxArHm45I04Tbt3v/QbqFTIgohNCjtQugA6Jjt8PeagUc16OVzK0sj1+CB
         VvBPIWxZjr3pQ==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 24 Jan 2022 14:01:31 -0300
From:   Fabio Estevam <festevam@denx.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: Re: [PATCH stable-5.10] ath10k: Fix the MTU size on QCA9377 SDIO
In-Reply-To: <Ye7V84vqcv5En/R6@kroah.com>
References: <20220124154454.1349296-1-festevam@denx.de>
 <Ye7O70cWHTlurYPO@kroah.com> <Ye7V84vqcv5En/R6@kroah.com>
Message-ID: <e7def4cfc8f10d97c651de61864acc3e@denx.de>
X-Sender: festevam@denx.de
User-Agent: Roundcube Webmail/1.3.6
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 24/01/2022 13:38, Greg KH wrote:

> Nope this breaks the build :(
> 
> Dropping it again.

Ops, sorry about that.

Fixed it and resent the correct one.

Thanks,

Fabio Estevam
