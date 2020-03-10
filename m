Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD2617F685
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 12:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCJLm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 07:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbgCJLm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 07:42:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E7602468C;
        Tue, 10 Mar 2020 11:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583840546;
        bh=OYk9R63uZQjFHBBfyRtJsbr05HQ2oP9ywwEB50+PLvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wPA5jb4baXTx4ckSiDsQpF9oNkUs8wv9bmpSEkPVLPJsCoMcdQYdNC1Yfq2KZGOJt
         IfV4RBLlZNkCMa8Q4vNFgffcnRTB6aLLOwPRWemOc7g4Xlq0iiUP3oFB54dZXzqG11
         Wg108CtzS+KCzhtELro5wOXn8WMRNt9zQlJCNTMI=
Date:   Tue, 10 Mar 2020 12:42:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Deepak Ukey <deepak.ukey@microchip.com>,
        Viswas G <Viswas.G@microchip.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [stable-4.19 2/2] scsi: pm80xx: Fixed kernel panic during error
 recovery for SATA drive
Message-ID: <20200310114224.GF3106483@kroah.com>
References: <20200309101739.32483-1-jinpu.wang@cloud.ionos.com>
 <20200309101739.32483-3-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309101739.32483-3-jinpu.wang@cloud.ionos.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 09, 2020 at 11:17:39AM +0100, Jack Wang wrote:
> From: Deepak Ukey <deepak.ukey@microchip.com>
> 
> commit 196ba6629cf95e51403337235d09742fcdc3febd upstream
> 
> Disabling the SATA drive interface cause kernel panic. When the drive
> Interface is disabled, device should be deregistered after aborting all
> pending I/Os. Also changed the port recovery timeout to 10000 ms for
> PM8006 controller.
> 
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c | 6 +++++-
>  drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.h | 2 ++
>  3 files changed, 8 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
