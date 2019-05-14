Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275BA1C02E
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 02:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfENAnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 20:43:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbfENAnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 May 2019 20:43:09 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 073A22168B;
        Tue, 14 May 2019 00:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557794588;
        bh=iTBRPMV3fAdsJ2g2ky+PwiIjaGRBbzz7zXr+NYbRI08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2mxV2gWNBMW/hX0Or69dkaJkUCGuNOw7deDUilycDjszboYQjUq5mgXBslZc0bhJm
         6TX0k1/LhRpw1hUG9+LJIwrj1C1fRdPBHSgVHLVHQKj/O9ULAKpcMhzzw54BSUgG7Z
         h2DKo3VM+ro4HebT2us3vkGzl+sM//HLCF5UyZpU=
Date:   Mon, 13 May 2019 20:43:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Raul E Rangel <rrangel@chromium.org>
Cc:     stable@vger.kernel.org, linux-mmc@vger.kernel.org,
        djkurtz@google.com, adrian.hunter@intel.com, zwisler@chromium.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        =?iso-8859-1?Q?Cl=E9ment_P=E9ron?= <peron.clem@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [stable/4.14.y PATCH 0/3] mmc: Fix a potential resource leak
 when shutting down request queue.
Message-ID: <20190514004306.GF11972@sasha-vm>
References: <20190513175521.84955-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190513175521.84955-1-rrangel@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 13, 2019 at 11:55:18AM -0600, Raul E Rangel wrote:
>I think we should cherry-pick 41e3efd07d5a02c80f503e29d755aa1bbb4245de
>https://lore.kernel.org/patchwork/patch/856512/ into 4.14. It fixes a
>potential resource leak when shutting down the request queue.
>
>Once this patch is applied, there is a potential for a null pointer dereference.
>That's what the second patch fixes.
>
>The third patch is just an optimization to stop processing earlier.

Is this actually part of a fix? Why do we want this optimization?

--
Thanks,
Sasha
