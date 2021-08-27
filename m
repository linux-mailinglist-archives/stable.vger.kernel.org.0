Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581523F9AF2
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 16:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245306AbhH0OjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 10:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245290AbhH0OjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 10:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00A3760E93;
        Fri, 27 Aug 2021 14:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630075106;
        bh=AoalIVBhFwI7FaCTxFA9OGabjrZAsh0NnGJ5zEwwzfA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jtw7U1+t0ugCkpmJofi4ZF+vnxc9HF02rg6zWpfHJjQRLomibNbL/NDb3DFrOJKKl
         kOBPIrpHtEpvMsfBnQtN8VD6v4frR+uqjqWn9ZyRnrdLBde4HyDWWdFFuaqblG9+kC
         JC8TN9HHUuZ66pii1MIX6tDTJIGQZqx42icrmRIw=
Date:   Fri, 27 Aug 2021 16:38:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Salvatore Bonaccorso <carnil@debian.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH 4.19 0/3] BPF fixes for CVE-2021-3444 and CVE-2021-3600
Message-ID: <YSj43Lpw9bilHuIn@kroah.com>
References: <20210827135533.146070-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827135533.146070-1-cascardo@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 27, 2021 at 10:55:30AM -0300, Thadeu Lima de Souza Cascardo wrote:
> The upstream changes necessary to fix these CVEs rely on the presence of JMP32,
> which is not a small backport and brings its own potential set of necessary
> follow-ups.
> 
> Daniel Borkmann, John Fastabend and Alexei Starovoitov came up with a fix
> involving the use of the AX register.
> 
> This has been tested against the test_verifier in 4.19.y tree and some tests
> specific to the two referred CVEs.

THanks for these, now queued up!

greg k-h
