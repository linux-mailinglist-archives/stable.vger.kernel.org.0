Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017B1256A86
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 23:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgH2V71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Aug 2020 17:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgH2V70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Aug 2020 17:59:26 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 234BF208CA;
        Sat, 29 Aug 2020 21:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598738366;
        bh=SLslw1z/EfVxplCaotocksM0ttlEFA95aQcPpHQp3J4=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=x9kXWyv8aUTP7CJBKZB28rH4Ec+BXc/V/RLusNAt6c18Jpnx4hM6HKYBt2TlHnlqv
         cfC4NpWADKkMIYoANBHLJ2X3cygionW1BrnaMnJX8+BPpmqfzjGiZD79fWfh1tg9So
         YMS7sg/QKpGkgMxNNmKXyF+D6iQSuEhasyBq5w3I=
Date:   Sat, 29 Aug 2020 21:59:25 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] gfs2: Make sure we don't miss any delayed withdraws
In-Reply-To: <20200829092656.1173430-1-agruenba@redhat.com>
References: <20200829092656.1173430-1-agruenba@redhat.com>
Message-Id: <20200829215926.234BF208CA@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: ca399c96e96e ("gfs2: flesh out delayed withdraw for gfs2_log_flush").

The bot has tested the following trees: v5.8.5.

v5.8.5: Failed to apply! Possible dependencies:
    462582b99b60 ("gfs2: add some much needed cleanup for log flushes that fail")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
