Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA28C2249
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 15:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbfI3NjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 09:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfI3NjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Sep 2019 09:39:09 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A221216F4;
        Mon, 30 Sep 2019 13:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569850749;
        bh=hISo5FprdgrNyDcqOhLwulTy4rRMPNAHrPi+MwWttnA=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=e9hv3kaOnD8isplJxPj3GUSlUPi5gfjuDLjqZyOHHLt5upjJv4ZIfX6TN23V19Js/
         tIXAadUG+U04/gjAyS+W+a4LFNCb53UUlkwnnu/i69G3ehqNMySOpAA4Ls5nauncmF
         hnNAQEsHVyLhRqcmRJoaN9V12fKaIhNrN89r0sng=
Date:   Mon, 30 Sep 2019 13:39:08 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix memory leak due to concurrent append writes with fiemap
In-Reply-To: <20190930092025.31118-1-fdmanana@kernel.org>
References: <20190930092025.31118-1-fdmanana@kernel.org>
Message-Id: <20190930133909.0A221216F4@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.16+

The bot has tested the following trees: v5.3.1, v5.2.17, v4.19.75.

v5.3.1: Build OK!
v5.2.17: Build OK!
v4.19.75: Failed to apply! Possible dependencies:
    7073017aeb98 ("btrfs: use offset_in_page instead of open-coding it")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
