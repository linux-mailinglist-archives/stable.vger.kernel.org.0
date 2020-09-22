Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE2F27498E
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 21:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgIVTyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 15:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726577AbgIVTyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 15:54:36 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1091420888;
        Tue, 22 Sep 2020 19:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600804476;
        bh=EVvtrNvY7M7nmW7KyojI7fNa2JCwdcIDoGeZCG4RKo8=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=ZCN5SoqfmWYUOM+hFgzwfkCrs08sIvc0Jv4XJHiMVjE2jJkVyt7K3zc7LKBQm5gI9
         4XjuTaGR2X6Az6OCE8U4z/bn7kHzbhgXNQaChMIgYaJfhYkLBjn0pCAT/7pLX3NId3
         9JzWhYAis6O0sfNDX0rNL8Yi3wDOjdTyPVCfHVwE=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200831202657.8224-1-dinguyen@kernel.org>
References: <20200831202657.8224-1-dinguyen@kernel.org>
Subject: Re: [PATCH] clk: socfpga: stratix10: fix the divider for the emac_ptp_free_clk
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     dinguyen@kernel.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, stable@vger.kernel.org
To:     Dinh Nguyen <dinguyen@kernel.org>
Date:   Tue, 22 Sep 2020 12:54:34 -0700
Message-ID: <160080447476.310579.6134027737733592363@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dinh Nguyen (2020-08-31 13:26:57)
> The fixed divider the emac_ptp_free_clk should be 2, not 4.
>=20
> Fixes: 07afb8db7340 ("clk: socfpga: stratix10: add clock driver for
> Stratix10 platform")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---

Applied to clk-fixes
