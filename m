Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C29526E07E
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 18:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgIQQVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 12:21:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbgIQQVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 12:21:00 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19CBF21D24;
        Thu, 17 Sep 2020 15:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600358015;
        bh=BJVv41PsQaV2DI/hWvqliPmjwjUkY1Qatzku6yaG6fQ=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ijZx6nH/gNYE8tTWFEnj6DqoV4qAMKgjBtQ2EqDnmHN7I6bK22S2EAoM38/mGUUNZ
         yAC3BB3JWY0XJPJEFK3xmjBs2gIrmI08rYLTr40UGtiJvij8G8ggQIW93eBt+nwRFA
         ib0/HQMZ5BNtxBRJyw3VPEkmTwGyNBfw1+Of610c=
Date:   Thu, 17 Sep 2020 15:53:34 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] scsi: Fix handling of host-aware ZBC disks
In-Reply-To: <20200915073347.832424-2-damien.lemoal@wdc.com>
References: <20200915073347.832424-2-damien.lemoal@wdc.com>
Message-Id: <20200917155335.19CBF21D24@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: b72053072c0b ("block: allow partitions on host aware zone devices").

The bot has tested the following trees: v5.8.9.

v5.8.9: Failed to apply! Possible dependencies:
    a3d8a2573687 ("scsi: sd_zbc: Improve zone revalidation")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
