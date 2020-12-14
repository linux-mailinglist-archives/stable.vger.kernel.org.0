Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2570B2D9AB4
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 16:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgLNPRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 10:17:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438598AbgLNPRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 10:17:31 -0500
Date:   Mon, 14 Dec 2020 10:16:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607959007;
        bh=7DxumA/ic+kumc6ZLIwtVEMav+wzV5ZcKzAQRwtusEc=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=q7nMV1CyVP9j8gaJIkuSReysJTiVYNArDkOpi/nKAZQ+AdVDFyVtPsifGG3RIqG5R
         XH72esxCzGcFwcxEJZN+/Uoni3hcoAptCxLugqwM1hAQNB4YxXMvnrYnRI9NfT0E2s
         QnrXPbgQljc2HkMtByGHtFqTxkCw4S7pHmezVEBFXAMw/D1fS7F1OeXIIR9jXZbpsu
         WWJ6CeIZaeK1Oj3HwaP0roscAhXapzwNDozyqxwgFXGF2GgA1tH5Y5iw2w+OGMm30t
         vylINlj5nYvxosPJxIWnq7WVglPJX2uEGTpak/Mq4F1pWymkFhNw90BCr3lVNljBtX
         KRmX56BDxLzjA==
From:   Sasha Levin <sashal@kernel.org>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Hounschell <markh@compro.net>,
        Karol Herbst <kherbst@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 4.14 2/8] drm/nouveau: make sure ret is
 initialized in nouveau_ttm_io_mem_reserve
Message-ID: <20201214151646.GT643756@sasha-vm>
References: <20201212160859.2335412-1-sashal@kernel.org>
 <20201212160859.2335412-2-sashal@kernel.org>
 <642b5479-d4d9-37a7-3b14-3162374829d5@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <642b5479-d4d9-37a7-3b14-3162374829d5@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 14, 2020 at 10:49:55AM +0100, Christian König wrote:
>Hi Sasha,
>
>please don't apply this patch to any older kernel.
>
>The fix was only needed for a patch which went in with the 5.10 pull 
>request.

I'll drop it, thanks!

-- 
Thanks,
Sasha
