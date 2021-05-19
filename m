Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90706389964
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 00:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhESWlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 18:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhESWlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 18:41:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96D356124C;
        Wed, 19 May 2021 22:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621463991;
        bh=vHiAlSUgF96JriDDSq5+AGTXZMO3GTxUgURx957DskQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VPHnwVunFX8DuDkoahrZsbX9iNqgBT829rcxN7OkRuSMwyE3K9O+Vv9X+oDN6tROC
         afTEiiRZwY+aGfUN2F0nOUpS++K2Z1paIQ0ZRUkyF+QfqM9u9Gkfrj0n+ZCdYuvPD8
         ETk2ekV723q4B1HrtpkNnr6hCofnFFxIN37JK0qQ6+QxRqr5RxuZk20tkDnCQguZcn
         V1k+9qy5VSmD/uMTcpmxHtjjulGo0BixNDg/XMVK1htYWZaPICWXiV/jSegB1B2S/j
         eqeS0Bx5QBaUm+O5Gxdw2mjTEq5Mn12q75mrpV/ptdh6aGdQZmLReoHKfRls6BEHIM
         PjVum8AiAN5UA==
Date:   Wed, 19 May 2021 18:39:50 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Richard Weinberger <richard@nod.at>
Cc:     stable <stable@vger.kernel.org>, tomas.melin@vaisala.com,
        gregkh@linuxfoundation.org, linux-serial@vger.kernel.org
Subject: Re: Please backport b86f86e8e7c5 ("serial: 8250: fix potential
 deadlock in rs485-mode")
Message-ID: <YKWTtiOY2EXxItnl@sashalap>
References: <919527621.20381.1621452034259.JavaMail.zimbra@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <919527621.20381.1621452034259.JavaMail.zimbra@nod.at>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 09:20:34PM +0200, Richard Weinberger wrote:
>Hi!
>
>Please backport commit b86f86e8e7c5 ("serial: 8250: fix potential deadlock in rs485-mode") to stable.
>The issue is real, I was hit by it on 4.14.

Will do, thanks!

-- 
Thanks,
Sasha
