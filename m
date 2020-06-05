Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E9F1EFA18
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgFEOK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728054AbgFEOK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:57 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6F6D20872;
        Fri,  5 Jun 2020 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366257;
        bh=Jpjqof4aPqADd4R06A+sEJoYSDY+9vQCYgWKRa6i+PA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=jOiUCr3W2Il6j1WfolujrNJqHWv4ZvPbNrgUhJ4F30z04n8t2wLArnbBwcdTFvzmu
         HjXcGMPYloFcQj4VzuZsj9sAfsMFevT6SjuUQeuQ5yO1Nnhb6A/4NEuH3JqPefxgzX
         suiZm6oWGcV5Nhf9J/djGZBOzZSxAXBZwzz5GFzc=
Date:   Fri, 05 Jun 2020 14:10:56 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jia He <justin.he@arm.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Cc:     Asias He <asias@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] virtio_vsock: Fix race condition in virtio_transport_recv_pkt
In-Reply-To: <20200530123206.63335-1-justin.he@arm.com>
References: <20200530123206.63335-1-justin.he@arm.com>
Message-Id: <20200605141056.C6F6D20872@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225.

v5.6.15: Build OK!
v5.4.43: Build failed! Errors:
    net/vmw_vsock/virtio_transport_common.c:1109:40: error: ‘t’ undeclared (first use in this function); did you mean ‘tm’?
    net/vmw_vsock/virtio_transport_common.c:1109:9: error: too many arguments to function ‘virtio_transport_reset_no_sock’

v4.19.125: Build failed! Errors:
    net/vmw_vsock/virtio_transport_common.c:1042:40: error: ‘t’ undeclared (first use in this function); did you mean ‘tm’?
    net/vmw_vsock/virtio_transport_common.c:1042:9: error: too many arguments to function ‘virtio_transport_reset_no_sock’

v4.14.182: Build failed! Errors:
    net/vmw_vsock/virtio_transport_common.c:1038:40: error: ‘t’ undeclared (first use in this function); did you mean ‘tm’?
    net/vmw_vsock/virtio_transport_common.c:1038:9: error: too many arguments to function ‘virtio_transport_reset_no_sock’

v4.9.225: Build failed! Errors:
    net/vmw_vsock/virtio_transport_common.c:968:40: error: ‘t’ undeclared (first use in this function); did you mean ‘tm’?
    net/vmw_vsock/virtio_transport_common.c:968:9: error: too many arguments to function ‘virtio_transport_reset_no_sock’


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
