Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BADEDD1E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 11:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfKDK5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 05:57:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbfKDK5Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 05:57:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E5D0222C2;
        Mon,  4 Nov 2019 10:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572865045;
        bh=tyErS5ayOQ1JPxQ7vqQgRlXP3j9QSDiomBqchoj4McI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wd890I2ORyZKygKH27IcPXwqUXEHmOr5GFFgqRtlLwsyGD46n+HZtCEHvVXIJQs+5
         koeBlT4BbpL3f/htRGeAE5lGUGJush1A0bBh6fZL4avhCL4L/+Aj4yraL6UTY1C3Gl
         Pcfpk56SG17SjhTqBurWHSl6IKcEep04XiiNqpxM=
Date:   Mon, 4 Nov 2019 11:57:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     stable@vger.kernel.org, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, sashal@kernel.org
Subject: Re: [PATCH linux-4.14.y 0/2] sctp: fix a memory leak
Message-ID: <20191104105722.GA1945210@kroah.com>
References: <cover.1572844054.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1572844054.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 04, 2019 at 01:16:24PM +0800, Xin Long wrote:
> These 2 patches are missed in linux-4.14.y, it will cause crash
> when commit 63dfb7938b13 ("sctp: change sctp_prot .no_autobind
> with true") is backported only.
> 
> Conflicts:
>   - Context difference in Patch 1/2 due to the lack of
>     Commit c981f254cc82.
> 
> Xin Long (2):
>   sctp: fix the issue that flags are ignored when using kernel_connect
>   sctp: not bind the socket in sctp_connect

Thanks for these, now queued up.

greg k-h
