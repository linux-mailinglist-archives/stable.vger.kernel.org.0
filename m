Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EABA480155
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 17:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhL0QAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 11:00:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56756 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240972AbhL0QAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 11:00:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D04A6B810A2;
        Mon, 27 Dec 2021 16:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04168C36AE7;
        Mon, 27 Dec 2021 16:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640620807;
        bh=UdTvWBp2jSaVvzn2O786rHh31sYKBsj4gE4jncRH6xw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sWCdQNfyoWoKZV8TezoQ5KGht71o8g5OYe6aMea6CyxyKIVTdB/bP2Q2rsu50tIlm
         kpT5E2XNWWm7I45SP+qrnkbT7ovRneoxDljJDYk1ASPHnJYroTmHbgm3wvpicP1/uI
         lO2fLTxhg7HKgIfB3aNKIEl+lpr2Mrh/hWCU1X98=
Date:   Mon, 27 Dec 2021 17:00:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Samuel =?utf-8?B?xIxhdm9q?= <samuel@cavoj.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 5.15 114/128] Input: i8042 - enable deferred probe quirk
 for ASUS UM325UA
Message-ID: <YcnjBHKy64XU7Plr@kroah.com>
References: <20211227151331.502501367@linuxfoundation.org>
 <20211227151335.325998991@linuxfoundation.org>
 <a0258f0acbe50d4ea3c73724eafd4ed1@cavoj.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a0258f0acbe50d4ea3c73724eafd4ed1@cavoj.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 27, 2021 at 04:53:38PM +0100, Samuel Čavoj wrote:
> Hi Greg,
> 
> it seems this patch is misapplied -- please see the context in the original
> diff. The quirk in question itself was only added in a recent patch which
> is not present in stable:
> commit 9222ba68c3f406 --
> https://lore.kernel.org/all/20211117063757.11380-1-tiwai@suse.de/
> 
> This seems to be the case for all stable branches.

Ah, good catch, now dropped from all stable branches, thanks!

greg k-h
