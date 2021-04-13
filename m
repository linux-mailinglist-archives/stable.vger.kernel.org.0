Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB16635DCD2
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 12:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237066AbhDMKvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 06:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236800AbhDMKvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 06:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A46A0613C1;
        Tue, 13 Apr 2021 10:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618311073;
        bh=GUVbX0zhKvYriQfu09SBc8I1JP5h+n6r4zwVejxic94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKDIMk7e6Mj9G1qKR8clrukF9Eq6ALUJy8/Li+s+sXB8CdYpJtZCbg52CDuNsSiJS
         I9wmVfM2aXEHUSKR89t+R3TKj8C715T+FgFDL8arHcRqEIe5lmEhmilXf7v95Ve7ic
         KPPMvV4x3orwlwfZtNtcSClKVjWfNHac5Gv2CcgY=
Date:   Tue, 13 Apr 2021 12:51:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.4 097/111] net: sched: bump refcount for new action in
 ACT replace mode
Message-ID: <YHV3ntI2dnYC+2IA@kroah.com>
References: <20210412084004.200986670@linuxfoundation.org>
 <20210412084007.483296509@linuxfoundation.org>
 <YHV0SagpvPYZznFT@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHV0SagpvPYZznFT@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 11:36:57AM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Apr 12, 2021 at 10:41:15AM +0200, Greg Kroah-Hartman wrote:
> > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > 
> > commit 6855e8213e06efcaf7c02a15e12b1ae64b9a7149 upstream.
> 
> This has been reverted upstream by:
> 4ba86128ba07 ("Revert "net: sched: bump refcount for new action in ACT replace mode"")

Ah, I added that to the 5.10 and 5.11 queues, but not 4.19 or 5.4, odd,
my fault, thanks for letting me know, I'll go fix that up...

greg k-h
