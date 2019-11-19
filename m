Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B9C101A8C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 08:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfKSHzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 02:55:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbfKSHzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 02:55:41 -0500
Received: from localhost (unknown [89.205.134.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D3EE2230E;
        Tue, 19 Nov 2019 07:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574150140;
        bh=37wJrRBfo8WY+M3jJIK/qbXrZdo+eM19U3dlEql2StE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h+ueStdTmc+UKPHB1SmysVxfvOJUX/ZjqIUN9MoYlyZbCsNR4bbgiP1vNAMXBvqsY
         /6YRoH1v9Z2+HyztQXR0JYZVjIN4U24DuK5JJcOntfxIo0bUKpoEFOPB5MdLaNQ2CS
         3PCea2U6slNOvn59wUl95Kf9+25RTl8oqpQ1InJw=
Date:   Tue, 19 Nov 2019 08:55:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jouni Hogander <jouni.hogander@unikie.com>
Subject: Re: [PATCH 5.3 09/48] slip: Fix memory leak in slip_open error path
Message-ID: <20191119075537.GA1858193@kroah.com>
References: <20191119050946.745015350@linuxfoundation.org>
 <20191119050955.380296035@linuxfoundation.org>
 <eb6fcac2-abdd-cb83-0942-09878b5e4751@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6fcac2-abdd-cb83-0942-09878b5e4751@hartkopp.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 08:43:45AM +0100, Oliver Hartkopp wrote:
> Hello Greg,
> 
> thanks for taking care of the slip.c patches.
> 
> The original issue was reported by Jouni for "slcan.c" which is also
> referenced in this commit message. But it was probably overlooked at
> upstream time that it should go into stable too.
> 
> The slcan.c fix is here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ed50e1600b4483c049ce76e6bd3b665a6a9300ed

Thanks, now queued up.

greg k-h
