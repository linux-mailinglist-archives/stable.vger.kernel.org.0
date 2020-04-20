Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD151B075F
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 13:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgDTLYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 07:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgDTLYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 07:24:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A325C2054F;
        Mon, 20 Apr 2020 11:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587381848;
        bh=64Sh/9LjI5Es7PGWpRsQiA4NfCDyp3IJp9JaPc3wmE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1t9YimHoOXFPV0KR6fAcBK2th+DPgsWj/c6b7q+m1DQSGcEa2yIOpDV1LwwJqbzLT
         Fl0TBlUHIj+h5Qg1HjiGDjdEvgBovMfdB+mNmzu7m+mGQ4Cj+pFgbTF4xiYDuS34/9
         azVKIue9rG4ZGD54KpyGfB2qI5raQ6K/85xXKApc=
Date:   Mon, 20 Apr 2020 13:24:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/13] Backported fixes taken from Sony's Vendor tree
Message-ID: <20200420112405.GA3763215@kroah.com>
References: <20200403121859.901838-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 03, 2020 at 01:18:46PM +0100, Lee Jones wrote:
> A recent review of the Sony Xperia Development kernel tree [0] resulted
> in the discovery of various patches which have been backported from
> Mainline in order to fix an array of issues.  These patches should be
> applied to Stable such that everyone can benefit from them.
> 
> Note: The review is still on-going (~50%) - more to follow.

All but one now queued up, thanks!

greg k-h
