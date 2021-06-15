Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907C93A798A
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 10:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhFOIzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 04:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhFOIzz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 04:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39E4860FEA;
        Tue, 15 Jun 2021 08:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623747231;
        bh=A/Rpgc9jE0a90CdoZllJ+qe/9E3HAlXgj8YNO9Lf9dY=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=QQanxGzKvKbLObybBWtEibS1JkDPMC+0N9ZT2VOBqzmCuQn/U8cdR9Fqx/L1VZaTj
         dguHkmTCDaqIkbPK+3GDvH2fNDbdCcVvvjQG/d2a7nekrq1jpsPRlOC9HDoxTV+q44
         WSoo8XDOjW5qhOURAnXcUPZFk2EbwTwLKAZ30WwqDVg8uQXwlrtOwDd4opDM+v9IVl
         AC1uRnikE4u5rWsWWiqvdjBazUDG3cbLrTPQSNrXBuOaCWRWqbii3y7sq/kxdO7spJ
         I3daBjLccAJqLyPHddxGud38fJ4LFJ6mdDrvXlgd3ejklXk2W32PPN7MIkEG2saBn0
         hG1YDbyz0o0CA==
Date:   Tue, 15 Jun 2021 10:53:48 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Pascal Giard <pascal.giard@etsmtl.ca>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Nguyen <daniel.nguyen.1@ens.etsmtl.ca>
Subject: Re: [PATCH] HID: sony: fix freeze when inserting ghlive ps3/wii
 dongles
In-Reply-To: <20210604161023.1498582-1-pascal.giard@etsmtl.ca>
Message-ID: <nycvar.YFH.7.76.2106151053340.18969@cbobk.fhfr.pm>
References: <20210604161023.1498582-1-pascal.giard@etsmtl.ca>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 4 Jun 2021, Pascal Giard wrote:

> This commit fixes a freeze on insertion of a Guitar Hero Live PS3/WiiU
> USB dongle. Indeed, with the current implementation, inserting one of
> those USB dongles will lead to a hard freeze. I apologize for not
> catching this earlier, it didn't occur on my old laptop.

Applied to for-5.13/upstream-fixes branch, thanks.

-- 
Jiri Kosina
SUSE Labs

