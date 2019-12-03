Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC100110562
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 20:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfLCTnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 14:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726893AbfLCTnd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 14:43:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 969AC206EC;
        Tue,  3 Dec 2019 19:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575402213;
        bh=SM0rYSykbk7tf2FAMkHp85Q+Xwfmlf1KnW/8RwZfe5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lA3ApHnaIe4TfRVp1tYFqtZxuNftBqD6Ls3dtM2j3Hf3vCKnnDuiLAUT15EGJV551
         GJ1iJzz7CW0GF2Qm+z3ZjCuwHPLn/1rW+c1Uh1G3PxsrKM0tDWogSG3nGeSJElfia2
         Z2728TFQbUxqcqxvmZXmm+4fpxdPWqa/K4RImHx0=
Date:   Tue, 3 Dec 2019 20:43:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [stable 4.19][PATCH 06/17] remoteproc: fix rproc_da_to_va in
 case of unallocated carveout
Message-ID: <20191203194330.GA2847072@kroah.com>
References: <20191128165002.6234-1-mathieu.poirier@linaro.org>
 <20191128165002.6234-7-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128165002.6234-7-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 09:49:51AM -0700, Mathieu Poirier wrote:
> From: Loic Pallardy <loic.pallardy@st.com>
> 
> commit 74457c40f97a98142bb13153395d304ad3c85cdd upstream
> 
> With introduction of rproc_alloc_registered_carveouts() which
> delays carveout allocation just before the start of the remote
> processor, rproc_da_to_va() could be called before all carveouts
> are allocated.
> This patch adds a check in rproc_da_to_va() to return NULL if
> carveout is not allocated.
> 
> Fixes: d7c51706d095 ("remoteproc: add alloc ops in rproc_mem_entry struct")

This commit only shows up in 4.20, not 4.19, so why is this patch
relevant for 4.19?

thanks,

greg k-h
