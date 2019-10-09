Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94BB8D13DD
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 18:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbfJIQTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 12:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731083AbfJIQTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 12:19:31 -0400
Received: from localhost (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B9782067B;
        Wed,  9 Oct 2019 16:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570637969;
        bh=8OFuYNdXenlIjXhNk+D84skEN7SLhZksMmULahT16D4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RUtF2zmoOA+Eyi5K7g4B0P1QN6UnntoqpXCRKzFWti0cpfF8VaNRqyfctxgOzK793
         5+hggukDZPOHe30wTWuPrOdLMzyAYdTX83ggiL60exti/cDqaDaTHFC/hDQWREuKo1
         ttBuOSNBHEyzVPHxnmOIrHdY5GwQBzwlKDT8zhQo=
Date:   Wed, 9 Oct 2019 12:19:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Jaroslav Kysela <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH 0/1] [for 4.14] VAG power control improvement for
 sgtl5000 codec
Message-ID: <20191009161928.GT1396@sasha-vm>
References: <20191009143836.16009-1-oleksandr.suvorov@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191009143836.16009-1-oleksandr.suvorov@toradex.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 02:38:40PM +0000, Oleksandr Suvorov wrote:
>
>This backport is for 4.14-stable.

I queued this one and the 4.9/4.4 patches, thanks!

-- 
Thanks,
Sasha
