Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2527A3D92C6
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 18:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbhG1QIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 12:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237366AbhG1QIF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Jul 2021 12:08:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B908A600D1;
        Wed, 28 Jul 2021 16:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627488483;
        bh=inXo2VjLL2P6S+Zku1YvAujPqf0X5USz/flmC3GPqcE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YOXxWFTm0oX3LU/CfHOinhag69Ws5B/mTqSZ2EXGn7mVk7oVc3wBpZICBmN+05vU/
         0TYGPzMV4Ejkt0cpdZkYprN8N3O4yAf4oHNFOQ1yqlZF5Lxi10R7hQtoBJ1v0YbgnZ
         I6TXgbO8c7QdMJqrd9IG0ytB2Fsz4E6q+Lx2eaeU=
Date:   Wed, 28 Jul 2021 18:08:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hui Wang <hui.wang@canonical.com>
Cc:     linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org, manuelkrause@netscape.net,
        pgnet.dev@gmail.com
Subject: Re: [PATCH] Revert "ACPI: resources: Add checks for ACPI IRQ
 override"
Message-ID: <YQGA4Kj2Imz44D3k@kroah.com>
References: <20210728151958.15205-1-hui.wang@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728151958.15205-1-hui.wang@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 28, 2021 at 11:19:58PM +0800, Hui Wang wrote:
> The commit 0ec4e55e9f57 ("ACPI: resources: Add checks for ACPI IRQ
> override") introduces regression on some platforms, at least it makes
> the UART can't get correct irq setting on two different platforms,
> and it makes the kernel can't bootup on these two platforms.
> 
> This reverts commit 0ec4e55e9f571f08970ed115ec0addc691eda613.
> 
> Regression-discuss: https://bugzilla.kernel.org/show_bug.cgi?id=213031
> Reported-by: PGNd <pgnet.dev@gmail.com>
> Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> ---
>  drivers/acpi/resource.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
