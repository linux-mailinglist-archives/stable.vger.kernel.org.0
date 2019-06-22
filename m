Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8145D4F7C3
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 20:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFVSNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 14:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfFVSNu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 14:13:50 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C8F320862;
        Sat, 22 Jun 2019 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561227229;
        bh=PtbC7W+6tNFbvpDBqITDfGMZNEIVMI975PlpkBAy260=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=jk+Ik0ClG6jCrQUO4tPMjvBNnNhIk2cCjeHuU+0AraFhNkDWIU7P+IbiL7GGfZmcJ
         vf8c2gGKti+MdBTn/uJoSgKMujg1N2VfUZLRZBg+uFdJ76V1cL+ykAv+mGqXZC9GCb
         Iy/D9c7hP/T4Ca+rk1qZc/rkFCw4PdpQHHQ478TM=
Date:   Sat, 22 Jun 2019 18:13:48 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5.2-rc5] Bluetooth: Fix regression with minimum encryption key size alignment
In-Reply-To: <20190622134701.7088-1-marcel@holtmann.org>
References: <20190622134701.7088-1-marcel@holtmann.org>
Message-Id: <20190622181349.8C8F320862@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: d5bb334a8e17 Bluetooth: Align minimum encryption key size for LE and BR/EDR connections.

The bot has tested the following trees: v5.1.12, v4.19.53, v4.14.128, v4.9.182, v4.4.182.

v5.1.12: Build failed! Errors:
    net/bluetooth/l2cap_core.c:1356:24: error: ‘HCI_MIN_ENC_KEY_SIZE’ undeclared (first use in this function); did you mean ‘SMP_MIN_ENC_KEY_SIZE’?

v4.19.53: Build failed! Errors:
    net/bluetooth/l2cap_core.c:1355:24: error: ‘HCI_MIN_ENC_KEY_SIZE’ undeclared (first use in this function); did you mean ‘SMP_MIN_ENC_KEY_SIZE’?

v4.14.128: Build failed! Errors:
    net/bluetooth/l2cap_core.c:1355:24: error: ‘HCI_MIN_ENC_KEY_SIZE’ undeclared (first use in this function); did you mean ‘SMP_MIN_ENC_KEY_SIZE’?

v4.9.182: Build OK!
v4.4.182: Build OK!

How should we proceed with this patch?

--
Thanks,
Sasha
