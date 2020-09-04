Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0649B25D75D
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgIDLaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730179AbgIDLax (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 07:30:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15356206B7;
        Fri,  4 Sep 2020 11:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599219051;
        bh=PdcmKbJtWb6sFYjGWVJbUzdbtqwY9Og9V0ADGZL0HQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tEWpCIJz6HvfRc6L8QHWbVOsFccl9OyhmruaUcyi/BAVb6GhXbRQNdAHBUXbQw4r7
         5QHWpymuYENtBk+zhPCn6mZ/2FGms1iwbnVZpegFuf9q1sMG8DHMc8by5sDbcsBRzn
         cPsbo1RUepYheGFpSF1bkeC1bRi1ntSjN5x5c0Ms=
Date:   Fri, 4 Sep 2020 13:31:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH stable v5.4 v2 0/3] KVM: arm64: Fix AT instruction
 handling
Message-ID: <20200904113112.GA2831752@kroah.com>
References: <20200901145040.111467-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901145040.111467-1-andre.przywara@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 01, 2020 at 03:50:37PM +0100, Andre Przywara wrote:
> Changes from v1:
> - (Re-)adding Marc's review tags from upstream. Differences to the
>   original patches are trivial for 2/3 and 3/3, and straight-forward
>   for 1/3.
> - Fix spelling of vaxorcism (hope my soul gets spared for the sacrilege)

Now queued up, thanks.

greg k-h
