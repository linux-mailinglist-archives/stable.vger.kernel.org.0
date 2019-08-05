Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FDB824C8
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 20:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfHESTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 14:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbfHESTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 14:19:31 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB86F214C6;
        Mon,  5 Aug 2019 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565029170;
        bh=JcOyHGnvJbkKZAaNNwgc9g3yP2z3wX2Ay4Kx76HjVQU=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=tTQcM4Yja+YjnDgwLWJ7lDTeAFzlebskea74Hf5kuPAqQFC5CPbrfLbAjBZ28dsI4
         11w6bAdpSWg0lyLxcYnZmHT50xVvadOMgi/lTlh8JqX6jnhF/9fJ8sN2p2h79SywPX
         oBU5wae9g3mb6dUZ7vEIhucp7HHxoOrJ2fQCSTkU=
Date:   Mon, 05 Aug 2019 18:19:29 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Mike Christie <mchristi@redhat.com>
To:     josef@toxicpanda.com, linux-block@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/1] nbd: fix max number of supported devs
In-Reply-To: <20190804191006.5359-1-mchristi@redhat.com>
References: <20190804191006.5359-1-mchristi@redhat.com>
Message-Id: <20190805181930.AB86F214C6@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.2.6, v4.19.64, v4.14.136, v4.9.187, v4.4.187.

v5.2.6: Build OK!
v4.19.64: Build OK!
v4.14.136: Failed to apply! Possible dependencies:
    2189c97cdbed ("block/ndb: add WQ_UNBOUND to the knbd-recv workqueue")

v4.9.187: Failed to apply! Possible dependencies:
    20032ec38d16 ("nbd: reset the setup task for NBD_CLEAR_SOCK")
    5ea8d10802ec ("nbd: separate out the config information")
    9442b739207a ("nbd: cleanup ioctl handling")
    9561a7ade0c2 ("nbd: add multi-connection support")
    feffa5cc7b47 ("nbd: fix setting of 'error' in NBD_DO_IT ioctl")

v4.4.187: Failed to apply! Possible dependencies:
    0e4f0f6f63d3 ("nbd: Cleanup reset of nbd and bdev after a disconnect")
    1f7b5cf1be43 ("nbd: Timeouts are not user requested disconnects")
    23272a6754b8 ("nbd: Remove signal usage")
    37091fdd831f ("nbd: Create size change events for userspace")
    5ea8d10802ec ("nbd: separate out the config information")
    9561a7ade0c2 ("nbd: add multi-connection support")
    97240963eb30 ("nbd: fix race in ioctl")
    9b4a6ba9185a ("nbd: use flags instead of bool")
    fd8383fd88a2 ("nbd: convert to blkmq")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
