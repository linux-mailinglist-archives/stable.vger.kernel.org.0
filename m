Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3BE4388C3
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 14:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhJXMGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 08:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229867AbhJXMGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Oct 2021 08:06:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8843860E9B;
        Sun, 24 Oct 2021 12:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635077043;
        bh=347rhVOZpf14PR/MtIZ0NVcBWWUV7MF0ZSZHrOFOtiM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sbE1uDWsaKk6B6J5mhrvjNYWiA9zAc5ugfSZ+5UNHLC30orUFCnHOY2VIrs7m344M
         l6AGsLm7FMK3bTbCpiyECdsr3IKR1okkbY07G76ZGWDOvW3YGIBLLqXGPrcrLuZ58W
         O0Zx2KotmLQ5Yrq+vf8drPB94Ngoghd8X48j/mPo=
Date:   Sun, 24 Oct 2021 14:04:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.14 1/2] s390/pci: cleanup resources only if necessary
Message-ID: <YXVLsMbqZ389YHX8@kroah.com>
References: <20211021141341.344756-1-schnelle@linux.ibm.com>
 <20211021141341.344756-2-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021141341.344756-2-schnelle@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 21, 2021 at 04:13:40PM +0200, Niklas Schnelle wrote:
> commit 023cc3cb1e4baa8d1900a4f2e999701c82ce2b6c upstream.

This is not a commit in Linus's tree :(

