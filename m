Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCE0238FF
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732242AbfETN6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 09:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732237AbfETN6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 09:58:14 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D7E9216FD;
        Mon, 20 May 2019 13:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558360693;
        bh=ptjQrcM3Ydb3MpRColzNgQu1ETExOjPZ1pDGjOjsfvw=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=13V35cVmQNS7zJi1vp2CqPdtFOE+GeFVfC93r72Z3lYh/+M5bKL2R/JkPW8ZLybkv
         1ej/FhFarKjQ0F21daiSiLRWIBDp2QptitDn8OzlIJUtS++M/bN+2jsiKriyXpbdjS
         4/9Ja45I4RzL5trhQ4+3Tkg/0Z/ipf1qd/UlL7bI=
Date:   Mon, 20 May 2019 13:58:12 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: incremental send, fix file corruption when no-holes feature is enabled
In-Reply-To: <20190520085542.29282-1-fdmanana@kernel.org>
References: <20190520085542.29282-1-fdmanana@kernel.org>
Message-Id: <20190520135813.4D7E9216FD@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 16e7549f045d Btrfs: incompatible format change to remove hole extents.

The bot has tested the following trees: v5.1.3, v5.0.17, v4.19.44, v4.14.120, v4.9.177, v4.4.180, v3.18.140.

v5.1.3: Build OK!
v5.0.17: Build OK!
v4.19.44: Build OK!
v4.14.120: Failed to apply! Possible dependencies:
    22d3151c2c4c ("Btrfs: send, fix incorrect file layout after hole punching beyond eof")

v4.9.177: Failed to apply! Possible dependencies:
    22d3151c2c4c ("Btrfs: send, fix incorrect file layout after hole punching beyond eof")

v4.4.180: Failed to apply! Possible dependencies:
    22d3151c2c4c ("Btrfs: send, fix incorrect file layout after hole punching beyond eof")

v3.18.140: Failed to apply! Possible dependencies:
    22d3151c2c4c ("Btrfs: send, fix incorrect file layout after hole punching beyond eof")


How should we proceed with this patch?

--
Thanks,
Sasha
