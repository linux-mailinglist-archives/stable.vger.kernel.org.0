Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9B04666A7
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 16:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359053AbhLBPjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 10:39:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41510 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359051AbhLBPjL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 10:39:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E242B823B6
        for <stable@vger.kernel.org>; Thu,  2 Dec 2021 15:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25DBC53FCF;
        Thu,  2 Dec 2021 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638459346;
        bh=D0EJJqHEbvXfvMdFNFTsicc61NiLw2m3FfY5U9qwqgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tx72Xj2y3W4L67WvBGNqa/paiA4LEECaZ1xQaZmkbVS+AdGNIGDaHHKncfHCSWpUJ
         SaxiH7jRZG/U5SkLawfAdc4KhMc2tJyY5B5s8CsInp9BqkJjSgm2f7ifO8KBe1olcm
         OwXQM+tsrSlMMs/L1dOv7k8wjiZ40AZHfml0Yqpg=
Date:   Thu, 2 Dec 2021 16:35:43 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH v1] can: j1939: j1939_tp_cmd_recv(): check the dst
 address of TP.CM_BAM
Message-ID: <Yajnz5OhwHyCfFaq@kroah.com>
References: <20211201102549.3079360-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201102549.3079360-1-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 01, 2021 at 11:25:49AM +0100, Oleksij Rempel wrote:
> From: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> commit 164051a6ab5445bd97f719f50b16db8b32174269 upstream.
> 
> The TP.CM_BAM message must be sent to the global address [1], so add a
> check to drop TP.CM_BAM sent to a non-global address.
> 
> Without this patch, the receiver will treat the following packets as
> normal RTS/CTS transport:
> 18EC0102#20090002FF002301
> 18EB0102#0100000000000000
> 18EB0102#020000FFFFFFFFFF
> 
> [1] SAE-J1939-82 2015 A.3.3 Row 1.
> 
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Link: https://lore.kernel.org/all/1635431907-15617-4-git-send-email-zhangchangzhong@huawei.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> changes:
>  - rebase against v5.10.82

Now queued up, thanks!  Can you also do this for 5.4.y?

greg k-h
