Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37733C1928
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 20:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhGHS2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 14:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhGHS2L (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 14:28:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A7C961629;
        Thu,  8 Jul 2021 18:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625768729;
        bh=VUhbS0aYRE7upz1xPCGxNxW9HBlQrZArAtQjjBRnc/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fEdMAJiq9aHgBecPV0p8Gd2VC4qOBebyWxcn53QnlQEn6FbLcmlKEkqpeGNTGNv/z
         PM45mZ1N+OegOMndyICvp9n6zJIu5wtBlM86V/2VwPVf8U4BohO3PP/0jOW34cu9BQ
         PBLjSeAvaPh3um9BagllbtY149eeIWZpOgi/bpb0=
Date:   Thu, 8 Jul 2021 20:25:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Brian Cain <bcain@codeaurora.org>
Subject: Re: patches for stable releases (hexagon related)
Message-ID: <YOdDF+XfbRSymPb7@kroah.com>
References: <7ea73971-13db-cd24-29e0-7910de3c5b49@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ea73971-13db-cd24-29e0-7910de3c5b49@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 09:27:34PM -0700, Guenter Roeck wrote:
> Hi,
> 
> please consider applying the following patches to v5.10.y and v5.12.y
> stable branches.
> 
> 788dcee0306e Hexagon: fix build errors
> f1f99adf05f2 Hexagon: add target builtins to kernel
> 6fff7410f6be Hexagon: change jumps to must-extend in futex_atomic_*
> 
> The patches are needed to enable hexagon build tests using clang
> in v5.10.y and v5.12.y.

Now queued up. thanks.

greg k-h
