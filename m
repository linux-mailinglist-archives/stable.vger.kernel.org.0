Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3802D5B7C
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 14:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389061AbgLJNVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 08:21:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388480AbgLJNU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 08:20:59 -0500
Date:   Thu, 10 Dec 2020 08:20:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607606419;
        bh=ftHWtKAQqg81G7QAGg0jzHziPJsoZfaLY7QssNuLWlY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Genz78YHrl1EpSZclX4TtYZk6lPFATwxY3OMrcdNbJWwWJSDrIZgsTA9h3LcfPdK0
         UNF3igUJ6Vw9W8+55kOEciL+d1hzFjVJ8dfY/0FknAl3jQRNcVlH2M1U9Q5c4xzlNu
         N1JAVXzqpl68SveoCuAq5plux/wEAZeWXGkx6bOKtDjb/zYMAmCJTay5OYlVYXHFLq
         gSYTUSlKhGsCXGt7HRxbZd3yaZ6LgvPp9AqcDYRiQvZJ8lY964wSEC62ExI6NRKin5
         gD0hnzdJ7/l+Pf3ABphjXIcImMRPK4HMptNvAdVKwhWPfN3J2Yk0/bwzlEze3boKLm
         6fR3VwAIpZ+MQ==
From:   Sasha Levin <sashal@kernel.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: request for 5.9/5.4-stable: 4f134b89a24b ("lib/syscall: fix
 syscall registers retrieval on 32-bit platforms")
Message-ID: <20201210132017.GO643756@sasha-vm>
References: <20201210121947.shepiv5mqewbtdzu@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201210121947.shepiv5mqewbtdzu@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 12:19:47PM +0000, Sudip Mukherjee wrote:
>Hi Greg, Sasha,
>
>4f134b89a24b ("lib/syscall: fix syscall registers retrieval on 32-bit platforms")
>is not marked for stable but I guess it should be in stable.
>Applies cleanly to 5.9-stable and 5.4-stable.

Queued up, thanks!

-- 
Thanks,
Sasha
