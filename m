Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A4B3B55DC
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 01:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhF0Xn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 19:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231508AbhF0Xn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 19:43:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C327F619BE;
        Sun, 27 Jun 2021 23:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624837291;
        bh=wD2TzDWyHolFUv+y7tX09AWODSabXYvqpOq8b/vea+4=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=seyoNJB/eMWN+EmHTTeZW4WIdkxnWpldlJIyTmnJoQQZCQ6P/XPiVY33/ifvNoqzt
         QF+0K0lHiv6QSJSFwijGiE2EZGabL5YI9AOe9WDeJUP37uVEQWawcJDM3GO4wBmKHM
         lL31QWRjNGBrbpsWOtejLMnZExK05RuS+RPdYvtd7qRSqiEeQa+1myU3KLzHp4bkuU
         xkLdW22xZK66wEwm0oduv6TaTIWRFx9KT+LP+r9Tc1qtu89nj6c8DxJ1+4CRM4IhMh
         YjWCPKJjo5mOjF6a1B9OUlpm/R+sHGAQd9k5wFk8j+BB6IvrNkf4MSGD4PQpc6JtCY
         nrTWIwzOyHn5w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210611025201.118799-1-dinguyen@kernel.org>
References: <20210611025201.118799-1-dinguyen@kernel.org>
Subject: Re: [PATCHv3 1/4] clk: agilex/stratix10: remove noc_clk
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     dinguyen@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org
To:     Dinh Nguyen <dinguyen@kernel.org>, linux-clk@vger.kernel.org
Date:   Sun, 27 Jun 2021 16:41:30 -0700
Message-ID: <162483729064.3259633.3304742325485460626@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Dinh Nguyen (2021-06-10 19:51:58)
> Early documentation had a noc_clk, but in reality, it's just the
> noc_free_clk. Remove the noc_clk clock and just use the noc_free_clk.
>=20
> Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agil=
ex platform")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---

Applied to clk-next
