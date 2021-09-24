Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79F5417E01
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 01:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345905AbhIXXFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 19:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345913AbhIXXFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 19:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 796B1610C9;
        Fri, 24 Sep 2021 23:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632524615;
        bh=MDyoMyw5XRPLJ8/flEai7YGm6xufLAYKrMrfKNzyD6U=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=T+nkKkg2ATgCJN/e1PLZ5MkQ1iGa1/8taB/S8yP6gCbzfNxkknB5lj2RM7zdU4wQl
         8FRpxZAq4pqEEXv/1wgSjN9dz/uPQyDxCycIBR/ZO951q8+X5EuImRM1/CWieeZsFH
         AOCSJ9oxLx7OL9GwNyEQYoIJnPOjrYuYeWpvtat7g/WFSCRUWOPfel7/YQh9H4uCTu
         rkpS82K8j6WMNsWrMq2q94Q2Qr7QKggYi2A8BE43v8ZLv+lMQpCwfc5TgiZPQoatkY
         HG2VzgCd8FMnAnkQ+e9BOogBuTN+0QuqyGPefxYh9y08vnMGD2IHK3rOMHNZWZi8uE
         TVlPOy2xfY6cA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210916225126.1427700-1-dinguyen@kernel.org>
References: <20210916225126.1427700-1-dinguyen@kernel.org>
Subject: Re: [PATCHv2] clk: socfpga: agilex: fix duplicate s2f_user0_clk
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     dinguyen@kernel.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, stable@vger.kernel.org
To:     Dinh Nguyen <dinguyen@kernel.org>
Date:   Fri, 24 Sep 2021 16:03:34 -0700
Message-ID: <163252461419.3714697.17173111663166196223@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dinh Nguyen (2021-09-16 15:51:26)
> Remove the duplicate s2f_user0_clk and the unused s2f_usr0_mux define.
>=20
> Fixes: f817c132db67 ("clk: socfpga: agilex: fix up s2f_user0_clk
> representation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---

Applied to clk-fixes
