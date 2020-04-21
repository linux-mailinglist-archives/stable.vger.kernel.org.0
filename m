Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03DC1B30CB
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDUT4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDUT4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:56:23 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A91020747;
        Tue, 21 Apr 2020 19:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498983;
        bh=92sqrSPkQErIEihvZCpDELC2haa1dFyWUE+gZfEtXRQ=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=O2Zi+FG3u9nlMDf57NjvQUINE8D3D8DoqXOXphjpTaDpP5bB3ki67yXqPKiCU4ZMM
         /UkWTmCwsI+6Dfp60w1I3WIB3gRw+8a+f2x8sI4mf+FjC/PzFlR0kVJfudJ7tGRebN
         6YfjZnGpc4bxuIp4+geH1owrviG2qjdWrIae6Uhs=
Date:   Tue, 21 Apr 2020 19:56:22 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Malcolm Priestley <tvboxspy@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Cc:     stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Fix pairwise key entry save.
In-Reply-To: <da2f7e7f-1658-1320-6eee-0f55770ca391@gmail.com>
References: <da2f7e7f-1658-1320-6eee-0f55770ca391@gmail.com>
Message-Id: <20200421195623.2A91020747@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: f9ef05ce13e4 ("staging: vt6656: Fix pairwise key for non station modes").

The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116, v4.14.176, v4.9.219, v4.4.219.

v5.6.5: Build OK!
v5.5.18: Build OK!
v5.4.33: Build OK!
v4.19.116: Build OK!
v4.14.176: Build OK!
v4.9.219: Failed to apply! Possible dependencies:
    5e38e15e689b ("staging:vt6656:key.c Aligned code with open parenthesis")

v4.4.219: Failed to apply! Possible dependencies:
    5e38e15e689b ("staging:vt6656:key.c Aligned code with open parenthesis")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
