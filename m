Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6A33DB3B9
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 08:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbhG3Ggh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 02:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237264AbhG3Ggg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 02:36:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2633960C51;
        Fri, 30 Jul 2021 06:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627626991;
        bh=71oqT/5ucbos6VX6PyOidy5RBpZ5UKU5uHQeAmOmqN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HcdhTgxw0BTFl+GNBgzMbo53P9/IcafNAzvM5z5791lOf3JL2lcDL3mXOF2Fp2uQ8
         o/tribO0PieNpMZbzk60NjBdlsOwiQTcj5FTBM+WiMSK/1qeP960jOlIMPz/RP/PvV
         4VZRgMFg7WezsEsftUH/R955GGXtZKEVTulQOSgA=
Date:   Fri, 30 Jul 2021 08:36:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [RFC/PATCH 0/2] Backports CVE-2021-21781 for 4.4 and 4.9
Message-ID: <YQOd7bjtdgrTmoSd@kroah.com>
References: <20210730060805.342577-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730060805.342577-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 03:08:03PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> This is a patch series to CVE-2021-21781.
> The patch 9c698bff66ab ("RM: ensure the signal page contains defined
> contents") depepds on memset32. However, this function is not provided
> in 4.4 and 4.9. Therefore, we need the patch 3b3c4babd898 ("lib/string.c:
> add multibyte memset functions") to apply this feature.
> Another option is to implement only the memset32 function in
> arch/arm/kernel/signal.c only or using loop memset, but for simplicity
> we have taken the way of applying the original patch 3b3c4babd898
> ("lib/string.c: add multibyte memset functions") that provides memset32
> in mainline kernel.

All now queued up, thanks.

greg k-h
