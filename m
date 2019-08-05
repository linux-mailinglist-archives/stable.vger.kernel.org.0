Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1044B81442
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 10:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfHEIcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 04:32:18 -0400
Received: from smtp.duncanthrax.net ([89.31.1.170]:55825 "EHLO
        smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfHEIcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 04:32:18 -0400
X-Greylist: delayed 2810 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2019 04:32:17 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=duncanthrax.net; s=dkim; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date;
        bh=eNNoRG6ySGyiRkIpARXfn6+DB0g7ZGfxSJZERPcdB2A=; b=WsiO8lHe03MkhQKaxe2VH7bmbk
        pk460WxM3UVYS+1YjnC0DtcQ6rFXP7tua+LSjlqg0k8njOBIobJpvGEf163u+p2yzekAIARafYy2z
        0XGcs2aDHDkDW+bEGTSOC6RotvlYh+pCx+ZUjgjPwchJzsQnWfm5jQdw2VlUqwPFWIp4=;
Received: from frobwit.duncanthrax.net ([89.31.1.178] helo=t470p.stackframe.org)
        by smtp.eurescom.eu with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.86_2)
        (envelope-from <svens@stackframe.org>)
        id 1huXgM-0008Sl-3x; Mon, 05 Aug 2019 09:45:26 +0200
Date:   Mon, 5 Aug 2019 09:45:24 +0200
From:   Sven Schnelle <svens@stackframe.org>
To:     gregkh@linuxfoundation.org
Cc:     deller@gmx.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] parisc: fix race condition in patching
 code" failed to apply to 5.2-stable tree
Message-ID: <20190805074524.GA10502@t470p.stackframe.org>
References: <1564983055189121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564983055189121@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 07:30:55AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.2-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
 
The reason is that 5.2 doesn't have DYNAMIC_FTRACE suport, so this can be
ignored.

Regards
Sven
