Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4923D3959E9
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 13:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhEaLzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 07:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231245AbhEaLzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 07:55:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7E9A60FEB;
        Mon, 31 May 2021 11:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622462018;
        bh=NqmYPw6SpbKhQ+zJsK+qROJORj1PJuYYxFB6P+vzDTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nGfPICJbSRHHQ2lY+z+I3kpoOR8mFa3Rp6N083B5EbzNQWJtAnG+0yUD8T8AyQNdp
         X3bKoqyrPjstHlbtsBuTvGKUpmBXKSqf+sZkZKGkCRG86Bwo9OMLVZDKBG40XoyZlV
         FN3O6Qlwe/KB4niQ78LgdVmfXr+/ojYXLAgNDtvE=
Date:   Mon, 31 May 2021 13:53:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     stable@vger.kernel.org, catalin.marinas@arm.com, elver@google.com,
        mark.rutland@arm.com
Subject: Re: [PATCH stable 5.12.y] arm64: mm: don't use CON and BLK mapping
 if KFENCE is enabled
Message-ID: <YLTOP64/MbnlAoPN@kroah.com>
References: <162229637024181@kroah.com>
 <20210531165538.60482a70@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531165538.60482a70@xhacker.debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 04:55:38PM +0800, Jisheng Zhang wrote:
> commit e69012400b0cb42b2070748322cb72f9effec00f upstream.
> 

Thanks, now queued up.

greg k-h
