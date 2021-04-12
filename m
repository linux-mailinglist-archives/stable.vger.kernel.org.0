Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D5735CAF5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbhDLQWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238872AbhDLQV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CC5360200;
        Mon, 12 Apr 2021 16:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244501;
        bh=F9MZfGBdo6Ia24Mrrd0zSAoGtdBVeDq1mYJClGuku1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fl8nBJOSegNwq85qUpaLFvyT5Fv6bGMXhdb+m/ogzoNnRMJ4/mngyJaZSOlwg/kFb
         i84ZqIyi1j3qt0/5xi6NOsThUia/xS/vNNzRoZLIzkxEVdTjJPp6gz3vAfiI3fx9+O
         QkkDPL2x0NU5nGOCKl51f7HlA8BgwrD8E/fZR/GHj/IKADSVnRaklNKvMVP6FogXE0
         Vy+EL4Wick7WNRm089YB56nicfScs3HF8cY8+cEkLgIdcaAY5vLgUQP9llL0/Lz9vI
         /lx1jDwCSdSYD6GBN4dzLGZMhFg1soWuYmSauXfgX5GX18Y+X34ZX5sp4Wu5iw8cqF
         CNJ3WFkEwPWOA==
Date:   Mon, 12 Apr 2021 12:21:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Newer stable-tools
Message-ID: <YHRzlIXXLUzfV0WT@sashalap>
References: <f6ad8f77-6dd7-647e-5d4a-983754ba8442@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f6ad8f77-6dd7-647e-5d4a-983754ba8442@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Krzysztof!

On Mon, Apr 12, 2021 at 12:58:16PM +0200, Krzysztof Kozlowski wrote:
>Hi Greg, Sasha and everyone,
>
>I am looking at stable-tools from Sasha [1] in hope in re-using it. The
>problem I want to solve is to find easier commits in the distro tree,
>which were fixed or reverted upstream. Something like steal-commits from
>the stable-tools [1].

You're probably looking for stable-has-fixes :)

>However the tools themself were not updated since some time and have
>several issues, so the questions are:
>1. Do you have somewhere updated version which you would like to share?

So I've cleaned up and pushed the few patches I had locally to that
repo. It's not that it's abandoned, but rather it was working just fine
for me for the past few years so there wasn't anything too big done on
that front.

>2. Do you have other stable-toolset which you could share?

FWIW, Greg has his own set of scripts: https://github.com/gregkh/gregkh-linux/tree/master/scripts

-- 
Thanks,
Sasha
