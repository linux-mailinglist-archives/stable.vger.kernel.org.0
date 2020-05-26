Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD341E23B6
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 16:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgEZOLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 10:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgEZOLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 10:11:38 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CD55207CB;
        Tue, 26 May 2020 14:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590502297;
        bh=hUhxPDQEnB3ocs2Pc0Otn9EbQkR7u6VZynngvzWLlQo=;
        h=Date:From:To:To:To:CC:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:From;
        b=aoP4NGgL2sf7xzhONd9/L/eW4ICnImWF8csowjAu2bcSQWSpZ3mlyk4jOg65n1IW8
         fk5dXliSYcoKb2jOY6coNXCwwou3w5u2b1BvsJ8ASI7vY7iI9e3vz+FQDHn8hduHGM
         6YLDxg/17GudyJysTQkisEzns2RUx5gOjnpiJdpY=
Date:   Tue, 26 May 2020 14:11:36 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <linux-crypto@vger.kernel.org>
CC:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>
Cc:     Markus Elfring <Markus.Elfring@web.de>
Cc:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto: virtio: Fix src/dst scatterlist calculation in __virtio_crypto_skcipher_do_req()
In-Reply-To: <20200526031956.1897-2-longpeng2@huawei.com>
Message-Id: <20200526141137.6CD55207CB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

<20200123101000.GB24255@Red>
References: <20200526031956.1897-2-longpeng2@huawei.com>
<20200123101000.GB24255@Red>

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: dbaf0624ffa5 ("crypto: add virtio-crypto driver").

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181.

v5.6.14: Build OK!
v5.4.42: Failed to apply! Possible dependencies:
    eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")

v4.19.124: Failed to apply! Possible dependencies:
    eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")

v4.14.181: Failed to apply! Possible dependencies:
    500e6807ce93 ("crypto: virtio - implement missing support for output IVs")
    67189375bb3a ("crypto: virtio - convert to new crypto engine API")
    d0d859bb87ac ("crypto: virtio - Register an algo only if it's supported")
    e02b8b43f55a ("crypto: virtio - pr_err() strings should end with newlines")
    eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
