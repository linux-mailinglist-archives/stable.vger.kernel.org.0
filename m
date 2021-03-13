Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98407339BAF
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 05:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhCMEIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 23:08:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233114AbhCMEHl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 23:07:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F05D064F33;
        Sat, 13 Mar 2021 04:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615608461;
        bh=qAIJ73TNXMvsFWU4VxAVUcfJQoTgSA0TpJw+ZkYfkL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=etLH1ZVlNu0h5ysWiWK4GJXuwJZqVhkY9H0ilBnbqhKkmskA90XCPNmLYrazT6vAh
         9j//SZ2zHB1bjNNpPwnIS16SNgyREee5vdRKZw9SwJMqKlaHlGnYCYV118rfWrYub4
         8L4t+0f7Rm+6AzzcXUkDGkrr6GIxJLyABwPdRv+DPpWyTP0nZp5ggfKR+UezRsyeuX
         xCkuhv+7uf5QPiDOyQljU+iGEYscuX4CMB0t3qciu4/hQGgr9/IOs3xvZXa0xeh8K/
         fO2xAiwTg0UFpHtCTKhQ7olHxRQl2U7IGGp/Ig4/TbEQ5Xn9hbhKk4HEC2mvOIFxKj
         TJX1eOnrUKFsg==
Date:   Fri, 12 Mar 2021 23:07:39 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>, candle.sun@unisoc.com,
        Miles Chen =?utf-8?B?KOmZs+awkeaouik=?= 
        <miles.chen@mediatek.com>, Stephen Hines <srhines@google.com>,
        Luis Lozano <llozano@google.com>,
        Sandeep Patil <sspatil@google.com>
Subject: Re: ARCH=arm LLVM_IAS=1 patches for 5.10, 5.4, and 4.19
Message-ID: <YEw6i39k6hqZJS8+@sashalap>
References: <CAKwvOdka=y54W=ssgCZRgr2B+NaYFHF07KnnNDfrwv79-geSQw@mail.gmail.com>
 <YEs+iaQzEQYNgXcw@kroah.com>
 <CAKwvOd=xr5je726djQeMMrZAuNcJpX9=R-X19epVy85cjbNbqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOd=xr5je726djQeMMrZAuNcJpX9=R-X19epVy85cjbNbqw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 09:28:56AM -0800, Nick Desaulniers wrote:
>My mistake, meant to lop those last two commits off of 4.19.y, they
>were the ones I referred to earlier working their way through the ARM
>maintainers tree.  Regenerated the series' (rather than edit the patch
>files) additionally with --base=auto. Re-attached.

Queued up, thanks!

-- 
Thanks,
Sasha
