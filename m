Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B545E3AD
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 14:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGCMTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 08:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfGCMTK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 08:19:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F17CA218A4;
        Wed,  3 Jul 2019 12:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562156349;
        bh=GpARfgYUgT5olAUEuC9ccJgpBkUXS4H7tRQyYVWvS3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eSzg0uUn6ek35jC7H7r+LIbYN4HyR4PzA3DQHqPUERTelLPZ0tMqk75xXE8I7zROC
         Xg5qbQLPMW+WF2krmTx/eU0aoLD/6EtjFiJoxo1djeK874bcT79GVczRzOSSJvG3ET
         TH9rpK16/n1Gfco5VsCQFAZE9kCrkUvlJ8CseqP0=
Date:   Wed, 3 Jul 2019 14:19:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: netfilter patches for -stable
Message-ID: <20190703121906.GF7784@kroah.com>
References: <20190702234321.cwqnmqhfymfg6hqh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702234321.cwqnmqhfymfg6hqh@salvia>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 01:43:21AM +0200, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> Would you consider to take the following patches for -stable?
> 
> e75b3e1c9bc5 netfilter: nf_flow_table: ignore DF bit setting
> 8437a6209f76 netfilter: nft_flow_offload: set liberal tracking mode for tcp
> 91a9048f2380 netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment
> 69aeb538587e netfilter: nft_flow_offload: IPCB is only valid for ipv4 family
> 
> Users report this is fixing a connection stall in:
> 
>         https://bugzilla.kernel.org/show_bug.cgi?id=203671

All now qeued up, thanks.

greg k-h
