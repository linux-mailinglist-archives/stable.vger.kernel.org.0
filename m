Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C0617F28
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 19:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfEHRfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 13:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfEHRfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 13:35:23 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFFBF21726;
        Wed,  8 May 2019 17:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557336923;
        bh=D5oYv12EgZbTo/RBYo4r7MelGMC1ktuMOi58r0P/8fY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tYg8DjS95MbVrrI00lYF1Z51VtMwLc6neeT9JEeB7wNozFoXb2mdBkXrB4Ppl21Ka
         j1J9sVqkIDIlT+eLmy/junnNAcUQDGnnf2KbPUDeaMl5iI2/xfKcXNSVwEGpB2efMI
         9qrWRHSzy1x0nSPo8mnTue+ojf9DjiB1DCUbdLlE=
Date:   Wed, 8 May 2019 13:35:21 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH AUTOSEL 4.19 29/53] drm/amdkfd: Add picasso pci id
Message-ID: <20190508173521.GJ1747@sasha-vm>
References: <20190427014051.7522-1-sashal@kernel.org>
 <20190427014051.7522-29-sashal@kernel.org>
 <BN6PR12MB18098B1A85760FCFFFDD3C37F73F0@BN6PR12MB1809.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <BN6PR12MB18098B1A85760FCFFFDD3C37F73F0@BN6PR12MB1809.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 27, 2019 at 01:49:27PM +0000, Deucher, Alexander wrote:
>NACK.  4.19 did not contain support for picasso. Please drop this patch for 4.19.

Dropped, thank you!

--
Thanks,
Sasha
