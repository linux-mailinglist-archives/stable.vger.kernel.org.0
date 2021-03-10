Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C967E333C59
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 13:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCJMPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 07:15:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231691AbhCJMOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 07:14:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 199C664FDD;
        Wed, 10 Mar 2021 12:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615378478;
        bh=+DbSHUFMmHU2MuFqGpTA//OBY9pG4LlFYdcOtubwYY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCH4p0rEfNizehGxKgON69+l9KhvpiOKNtG4VvLLF3Hov6xApsCkLL8MUwvWL7ijD
         90c4dESkhxZwub5VmJXa5/azZn++t4ki/Rw5BK7PFDO2ztK+ApmytVqObcGKeh5cBa
         ZvlwacI8S60skKrwFT9zxsgaR8N6PI1Jq2O6ea3E=
Date:   Wed, 10 Mar 2021 13:14:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrey Ryabinin <arbn@yandex-team.com>
Cc:     stable@vger.kernel.org, jroedel@suse.de, will@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable 5.10-5.11] iommu/amd: Fix sleeping in atomic in
 increase_address_space()
Message-ID: <YEi4K9nEzhPWlqaH@kroah.com>
References: <161512522533161@kroah.com>
 <20210309182430.18849-1-arbn@yandex-team.com>
 <20210309182430.18849-3-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309182430.18849-3-arbn@yandex-team.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 09, 2021 at 09:24:29PM +0300, Andrey Ryabinin wrote:
> commit 140456f994195b568ecd7fc2287a34eadffef3ca upstream.

All now queued up, thanks.

greg k-h
