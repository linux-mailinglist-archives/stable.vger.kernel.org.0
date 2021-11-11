Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45B144CE71
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 01:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhKKAoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 19:44:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232077AbhKKAoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 19:44:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86ED26135E;
        Thu, 11 Nov 2021 00:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636591279;
        bh=hhTl/K3vGzRFZ3vjhy7pDbKkn6USsecqA6WNitwGUGk=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=N4YAEYew+VeYugIXPsKBigKFuYUo+PkHXePWFofolFcvM+F4aHIyZhEPkJ1wn3LLf
         ZcvG1irdlEbT5Jet+UZ7DISPOpxd9pcQLEPp77MZWPcGYhN+JYNKb6oHPtqMfe5KFX
         yBeEuRVd6pYxxjVWDJXUxe01H+jVsqdzkQOVrbY8IyPkN0m4e+lZQa/rhEvBEK5fia
         BACwM+kjtY4XhkRBoutMwKPdqK38NGnB3HdL1yWnGaP/uugNEaD9yehptySANwK58M
         fw3pOUUFu8TKNeyHAvG4fCNuCP5diMEhHfWWdFGWHRbAGxI1bX526OsFttTlCEbQIy
         fqt1AdGctnVMw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211109164650.2233507-3-robh@kernel.org>
References: <20211109164650.2233507-1-robh@kernel.org> <20211109164650.2233507-3-robh@kernel.org>
Subject: Re: [PATCH 2/2] clk: versatile: clk-icst: Ensure clock names are unique
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Guenter Roeck <linux@roeck-us.net>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
To:     Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Date:   Wed, 10 Nov 2021 16:41:18 -0800
User-Agent: alot/0.9.1
Message-Id: <20211111004119.86ED26135E@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Rob Herring (2021-11-09 08:46:50)
> Commit 2d3de197a818 ("ARM: dts: arm: Update ICST clock nodes 'reg' and
> node names") moved to using generic node names. That results in trying
> to register multiple clocks with the same name. Fix this by including
> the unit-address in the clock name.
>=20
> Fixes: 2d3de197a818 ("ARM: dts: arm: Update ICST clock nodes 'reg' and no=
de names")
> Cc: stable@vger.kernel.org
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-clk@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Stephen Boyd <sboyd@kernel.org>
