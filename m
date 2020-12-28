Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433D32E6A1E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 19:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgL1Svk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 13:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbgL1Svk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 13:51:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B531221F8;
        Mon, 28 Dec 2020 18:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609181459;
        bh=KX4NZzabGMTKNUQe8pLfvyR3mEnwdWu/VuP08b7f/h8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VEFqtJUaaMp9NCLwaoyhp7AHGEd+y8I0+oH9skDs9zjpdfJWMZoLocz6uQZn86z9q
         VCG2rWu8epugtD0Csq+ONjid5WzKeeSKMrNF+JaNrRxeBpjwrSMvvzQgpyXcG+6CMl
         uc7VUga+11pscVCWIZGZNymJp0bpbq1dDg+YhQnLR/QiZIXpA30FmT92TS9jVGj3ZY
         pUZl5Uo8hLkuSGaUJeYX2RXe3IQsPtrOSODwtYgfMI43tn0B3osiHXaPgdW+df6eeS
         LzqPPsiNlPGOTkF5PVI/6oMYOCXY2abmEO7DKPk/0QoLpfoN6hS/kei83bPM2+Xmqg
         bT8rvz6o2GeGg==
Date:   Mon, 28 Dec 2020 10:50:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vincent Bernat <vincent@bernat.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 098/717] net: evaluate
 net.ipvX.conf.all.ignore_routes_with_linkdown
Message-ID: <20201228105058.7c66e522@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228125025.671560851@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
        <20201228125025.671560851@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 13:41:36 +0100 Greg Kroah-Hartman wrote:
> From: Vincent Bernat <vincent@bernat.ch>
> 
> [ Upstream commit c0c5a60f0f1311bcf08bbe735122096d6326fb5b ]
> 
> Introduced in 0eeb075fad73, the "ignore_routes_with_linkdown" sysctl
> ignores a route whose interface is down. It is provided as a
> per-interface sysctl. However, while a "all" variant is exposed, it
> was a noop since it was never evaluated. We use the usual "or" logic
> for this kind of sysctls.

I'd recommend to drop 98 and 99, at least for now.

The kernel always behaved this way, and it remains to be seen if anyone
depended on that (mis) behavior.

This needs to hit a real release.
