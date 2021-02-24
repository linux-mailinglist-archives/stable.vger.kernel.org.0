Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB353241DF
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 17:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhBXQOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 11:14:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235011AbhBXQLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 11:11:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B1BFF64EF5;
        Wed, 24 Feb 2021 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614183008;
        bh=zkyBJ4c4uTQ7yZ769N3yej2soXhbTbTNvhXc6eKlg5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bhe+3VanUpCmRXp5fJRDpDMGSf4DsO5wTkjm60bgzQG3F/+HwTSFFUZBU42zwJoZf
         lvJR+GRyyVUqbVUSV3ImK9xzVDGoK3a3ih5HBtbcfRxpbc0oSf0PY0LhgrZCjQ3DAy
         5Yfsr5ctPtg6EIaTfS+hbhxc/i8iVE44o5GTmfnx6+xFRcHN1j4wamtdZjUevNQX0U
         BpNpIc+AXO+Q0FaDPWaYZDjK1c4Gw87vcEnimiuVuU4RB/OTK5zr7pwsvKpb2FTlaP
         LnleP4otJ0nORZ2Y23JKSbOG6f4LNcAMitpaIkx12jA6cTsQqdhVucr0kTrV786OaH
         I/f/EDB3uGuiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A106B609F2;
        Wed, 24 Feb 2021 16:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] tools/resolve_btfids: Fix build error with older host
 toolchains
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161418300865.10573.15838869918524003805.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Feb 2021 16:10:08 +0000
References: <20210224052752.5284-1-jetswayss@gmail.com>
In-Reply-To: <20210224052752.5284-1-jetswayss@gmail.com>
To:     Kun-Chuan Hsieh <jetswayss@gmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, jolsa@kernel.org,
        andrii@kernel.org, stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 24 Feb 2021 05:27:52 +0000 you wrote:
> Older libelf.h and glibc elf.h might not yet define the ELF compression
> types.
> 
> Checking and defining SHF_COMPRESSED fix the build error when compiling
> with older toolchains. Also, the tool resolve_btfids is compiled with host
> toolchain. The host toolchain is more likely to be older than the cross
> compile toolchain.
> 
> [...]

Here is the summary with links:
  - [v2] tools/resolve_btfids: Fix build error with older host toolchains
    https://git.kernel.org/bpf/bpf/c/b8592e231fb8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


