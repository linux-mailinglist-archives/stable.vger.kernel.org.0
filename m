Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563D3478E97
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbhLQOyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhLQOyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:54:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1781C061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 06:54:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B45BB8289E
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 14:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57B4C36AE1;
        Fri, 17 Dec 2021 14:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639752889;
        bh=+tWtYZZeS8ktwi1/pJzPOvzKrpKxvODo0YQDYnT26qM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p6KFfpIJxsrIUjt3mU4eNOZR9oiKtQPh6rqnHU6VUCEMRATO9qrnexcxlTnZs5PND
         PGi0N5NnTNKyFL8sNdumTYx2ZzY/qfTRunI+QHk8ID8oZgtj1w61i6TeubPgbmfM71
         Fkik6sIngQht3BNRu0IcLoLu/DczNHZQLxIu0lAY=
Date:   Fri, 17 Dec 2021 15:54:46 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 1/2] x86: Make ARCH_USE_MEMREMAP_PROT a generic Kconfig
 symbol
Message-ID: <YbyktpQbbhImNkbe@kroah.com>
References: <20aa49e158bf5ad18df99febdac0a93790e1a746.1639685720.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20aa49e158bf5ad18df99febdac0a93790e1a746.1639685720.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 16, 2021 at 02:15:19PM -0600, Tom Lendacky wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> commit ce9084ba0d1d8030adee7038ace32f8d9d423d0f upstream
> to be applied to 4.14.

All now queued up, thnaks.

greg k-h
