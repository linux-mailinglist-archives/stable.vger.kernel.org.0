Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03E42DEECA
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgLSMjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgLSMjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:39:01 -0500
Date:   Sat, 19 Dec 2020 13:39:41 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608381501;
        bh=+rxOSpd0xjH/lbT/Hi/DiF9ahXavyX+3hq3W7ILuK1Q=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=yMu1Wb2H3L9eINz5kKiOo4owtMuZ9FoO3isxr/GTVu1P+kowmBGLKdGjkxJVXUH58
         qCmVwzn+1y5WGKq8YYNihL3XWNvDkqjDAuDKGmWqujX3fa49W5Wl7h7dtWabLBP+Bl
         cOIfw9/ughYGoBShqkvK4L7tR1XD5s26OtfeNMxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kamal Mostafa <kamal@canonical.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 5.4.y] Revert "selftests/ftrace: check for do_sys_openat2
 in user-memory test"
Message-ID: <X930jfiyt087XQVw@kroah.com>
References: <20201216181353.30321-1-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216181353.30321-1-kamal@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 16, 2020 at 10:13:53AM -0800, Kamal Mostafa wrote:
> This reverts commit 9110e2f2633dc9383a3a4711a0067094f6948783.
> 
> This commit is not suitable for 5.4-stable because the openat2 system
> call does not exist in v5.4.
> 
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  .../selftests/ftrace/test.d/kprobe/kprobe_args_user.tc        | 4 ----
>  1 file changed, 4 deletions(-)

Nice catch, now queued up, thanks.

greg k-h
