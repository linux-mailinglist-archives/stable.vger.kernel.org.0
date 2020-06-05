Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EEA1EFA0C
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgFEOKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728013AbgFEOKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:50 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A67B9207ED;
        Fri,  5 Jun 2020 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366249;
        bh=rcm+MzYJWW0HBrLAlA/clxwwWrQYek/Pi6H0xXSDmz8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=hssMuOaZF9ccKGU3R4+BrCtnEM32gac4P3+suhCJGVJr5mVvEVowSf1YtVJuyE3FK
         yeWCScGm0szjmDKwOQ6BRxfaMClOURILvlCCp9uWnXDgTndjC95SlWB6ORZPsayI3n
         LKGvVeCHFHdGti1zJ32zTRi8tfjB1zc8Zu4bAvBc=
Date:   Fri, 05 Jun 2020 14:10:49 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jia He <justin.he@arm.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] virtio_vsock: Fix race condition in virtio_transport_recv_pkt
In-Reply-To: <20200529152102.58397-1-justin.he@arm.com>
References: <20200529152102.58397-1-justin.he@arm.com>
Message-Id: <20200605141049.A67B9207ED@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

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

v4.4.225: Failed to apply! Possible dependencies:
    06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
