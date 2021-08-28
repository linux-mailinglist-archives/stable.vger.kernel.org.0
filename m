Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF7D3FA2F2
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 03:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhH1Bh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 21:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232979AbhH1Bh1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 21:37:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7802A60ED3;
        Sat, 28 Aug 2021 01:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630114597;
        bh=90QJALT3mDZYXRc7UstiPxgoPI6zd+4PYzEukLlnkDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j6SqVnh8uZZbNUd8IiK/3ogufpf7xgO7MWuBJ4CywZhp8GyOwOroAht7KtbAYAK9p
         4zGEUtiqt4IhdLtXbCF61ud9/gIDnF7xUAUD/jahCk49+Tee/AxuNAABuB6mnS0+9M
         3WhxEOsDR+BNNJwGIx4azUScw92J7sXA/5Ino0hYuFiKrKfPxYx77VQGUbqENUZG77
         c3/DXjV59hUzjlfgmpp0lyz7JWGgSN6AhbleUyojku0pMC21Mhvt/F2xugaaO2jyq2
         7MlPl3OrJuJCkL72upVlACET3T636JDNjmlHUkeTaCEdL77+jZtf163aCgApUaB4Fa
         c7VpVJkHPyieQ==
Date:   Fri, 27 Aug 2021 21:36:36 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     gregkh@linuxfoundation.org, laoar.shao@gmail.com,
        akpm@linux-foundation.org, surenb@google.com,
        stable@vger.kernel.org, christian@brauner.io,
        keescook@chromium.org, dhaval.giani@oracle.com
Subject: Re: [PATCH 5.4.y 0/1] missing upstream commit 9066e5c causing:
 kernel panic: System is deadlocked on memory
Message-ID: <YSmTJIUOm0s+/hfI@sashalap>
References: <1629298747-19233-1-git-send-email-george.kennedy@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1629298747-19233-1-git-send-email-george.kennedy@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 18, 2021 at 09:59:06AM -0500, George Kennedy wrote:
>Upstream commit 9066e5c is missing from 5.4.y causing
>kernel panic: System is deadlocked on memory
>during 5.4.141-rc1 Syzkaller reproducer testing.

Queued up, thanks!

-- 
Thanks,
Sasha
