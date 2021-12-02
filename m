Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730E4466D71
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 00:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349343AbhLBXKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 18:10:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35072 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240957AbhLBXKf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 18:10:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71B8DB82529;
        Thu,  2 Dec 2021 23:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195A4C00446;
        Thu,  2 Dec 2021 23:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638486430;
        bh=wmM58uRK/qC9dcL8saFQjfElAN065Lt+br3Tvg/P2Oo=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=Pt3YMnKfCig8NYEIG7y7JiLjm92T72vX8bxZ7RJZioO1QtRawx0el9n/Ns8dNnMRS
         Re46axk1RgjzPmFkwP7BK2Dsjv/q0lhiu2Eoy7Lr/dMRt+raQot7JMrVaNxSS8u8UJ
         VnUDHOqdl6oP/q1pn5kj03FrEBHj7IFqw2rhkvryiK9q3fYOMJfPOqRlmTpZcNfKBY
         ZGyX5+4JMXjfGd20OaaQbWInCj1MTnMCd3qw09rW945D6Idx9FC/04EccdN9J9i6sm
         MmzdibnDzU4ngtM7UFNw6nFqhQnfQngOf2VjY3Bin/PQxM86Ytcz0RbjU1jNMSkqlu
         qNlFGT4Do1iYw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211115233407.1046179-1-dmitry.baryshkov@linaro.org>
References: <20211115233407.1046179-1-dmitry.baryshkov@linaro.org>
Subject: Re: [PATCH] clk: qcom: regmap-mux: fix parent clock lookup
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        stable@vger.kernel.org
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Taniya Das <tdas@codeaurora.org>
Date:   Thu, 02 Dec 2021 15:07:08 -0800
User-Agent: alot/0.9.1
Message-Id: <20211202230710.195A4C00446@smtp.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dmitry Baryshkov (2021-11-15 15:34:07)
> The function mux_get_parent() uses qcom_find_src_index() to find the
> parent clock index, which is incorrect: qcom_find_src_index() uses src
> enum for the lookup, while mux_get_parent() should use cfg field (which
> corresponds to the register value). Add qcom_find_cfg_index() function
> doing this kind of lookup and use it for mux parent lookup.
>=20
> Fixes: df964016490b ("clk: qcom: add parent map for regmap mux")
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> ---

Applied to clk-fixes
