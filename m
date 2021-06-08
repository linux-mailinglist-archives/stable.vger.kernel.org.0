Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86ED39F977
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 16:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233540AbhFHOr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 10:47:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233336AbhFHOr2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 10:47:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14EBA610A2;
        Tue,  8 Jun 2021 14:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623163519;
        bh=mcoAg7wVNKOXs1ZSynfjU8N0VfhE2JmPZwOp1/v6YuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2INPShTeR52kZaOQ6CLaXvppjhcg+zRAD6fMi753WmT0hwQ8wvtfBmA+TBPoqGPMV
         FURj+ZaffLIp3l9FjpgTlXfMIcFznc9tnWKaRAgq/2CiTSEKMB8fVYo+kW0b8q1Gl/
         R6oLs27iA+Uc80Dkva/Y6dNptkZZM4Ii2Htx7QDc=
Date:   Tue, 8 Jun 2021 16:45:16 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 4.19 0/9] bpf: fix verifier selftests on inefficient
 unaligned access architectures
Message-ID: <YL+CfFu0JuLC5zwd@kroah.com>
References: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622604473-781-1-git-send-email-yangtiezhu@loongson.cn>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 02, 2021 at 11:27:44AM +0800, Tiezhu Yang wrote:
> With the following patch series, all verifier selftests pass on the archs which
> select HAVE_EFFICIENT_UNALIGNED_ACCESS.
> 
> [v2,4.19,00/19] bpf: fix verifier selftests, add CVE-2021-29155, CVE-2021-33200 fixes
> https://patchwork.kernel.org/project/netdevbpf/cover/20210528103810.22025-1-ovidiu.panait@windriver.com/
> 
> But on inefficient unaligned access architectures, there still exist many failures,
> so some patches about F_NEEDS_EFFICIENT_UNALIGNED_ACCESS are also needed, backport
> to 4.19 with a minor context difference.

Looks good, now queued up, thanks.

greg k-h
