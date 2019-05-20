Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0662309A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 11:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbfETJp2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 05:45:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729835AbfETJp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 05:45:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38CE420675;
        Mon, 20 May 2019 09:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558345527;
        bh=4vXFdwLK1B0XlJMDjNwrpIgMhq1oUgjy/ZgROm84esc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YabasQNyE0SGD+6SJeRzR2bRTqJnXfPI7MCXCBEXge2dqf5w4ivbAPfxpY6o3mg1g
         KtI2aYUdpAVPF9PIEc2XT1ZTYUXjJLSYV/YLp0+LMRawzvucXBgbAhvYlV3EJ5sUqU
         /i+SwOacEgXb8XKECDpaqRwWmuW+P8Fh+zSZGdVY=
Date:   Mon, 20 May 2019 11:45:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Benjamin Berg <benjamin@sipsolutions.net>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH 4.9] ath10k: allow setting coverage class
Message-ID: <20190520094525.GA23521@kroah.com>
References: <1558345149-3274-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1558345149-3274-1-git-send-email-pozega.tomislav@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 11:39:09AM +0200, Tomislav Požega wrote:
> From: Benjamin Berg <benjamin@sipsolutions.net>
> 
> Unfortunately ath10k does not generally allow modifying the coverage class
> with the stock firmware and Qualcomm has so far refused to implement this
> feature so that it can be properly supported in ath10k. If we however know
> the registers that need to be modified for proper operation with a higher
> coverage class, then we can do these modifications from the driver.
> 
> This is a hack and might cause subtle problems but as it's not enabled by
> default (only when user space changes the coverage class explicitly) it should
> not cause new problems for existing setups. But still this should be considered
> as an experimental feature and used with caution.
> 
> This patch implements the support for first generation cards (QCA9880, QCA9887
> and so on) which are based on a core that is similar to ath9k. The registers
> are modified in place and need to be re-written every time the firmware sets
> them. To achieve this the register status is verified after certain WMI events
> from the firmware.
> 
> The coverage class may not be modified temporarily right after the card
> re-initializes the registers. This is for example the case during scanning.
> 
> Thanks to Sebastian Gottschall <s.gottschall@dd-wrt.com> for initially
> working on a userspace support for this. This patch wouldn't have been
> possible without this documentation.
> 
> Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
> Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
> ---


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
