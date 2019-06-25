Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5955911
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 22:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfFYUkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 16:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfFYUkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 16:40:19 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F235A2063F;
        Tue, 25 Jun 2019 20:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561495218;
        bh=RPZO+8ujD6hDAFZNfN1/0Dv3SkFsw6/fX6f54/5F6ho=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=gzc/nSp8zafQ1s20HLs5ylki7JgOPLqBvutsVmQE+s9oequqA3luXs5b7tmqJM1je
         Zs+SYxLFAVOb8xOV+4uplCYUXqFszjfo/wL/FOapY+4EZ4soUJid6w6Ujspb9KPs5K
         hjuFbXu5rVMXRHa6tvwo87gq8eh9uoB5tNemWsW8=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190607151246.8700-1-dinguyen@kernel.org>
References: <20190607151246.8700-1-dinguyen@kernel.org>
To:     Dinh Nguyen <dinguyen@kernel.org>, linux-clk@vger.kernel.org
From:   Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH] clk: socfpga: stratix10: fix divider entry for the emac clocks
Cc:     dinguyen@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org
User-Agent: alot/0.8.1
Date:   Tue, 25 Jun 2019 13:40:17 -0700
Message-Id: <20190625204017.F235A2063F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dinh Nguyen (2019-06-07 08:12:46)
> The fixed dividers for the emac clocks should be 2 not 4.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---

Applied to clk-fixes

