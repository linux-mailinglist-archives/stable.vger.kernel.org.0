Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA6955ADF
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 00:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfFYWPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 18:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfFYWPN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 18:15:13 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B691620883;
        Tue, 25 Jun 2019 22:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561500912;
        bh=8qTkfS/4sezfPP01RsGhg7FS4aonLn9/wHCnef6132A=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=IMLS8thwDC59JuDZtM/8G3qRVOM2sezntC8PHj1xZ0qDsIiNEj84uIQyOEmW2cpW/
         HMh1Mjwkz1NCiK5UiJs6gquxhP6o2hX7S6LK0zbxrQU8KMtmWfn+6VxPDogxO4d6qS
         FIu9kLNyG2yKp/5PnHIt5OVkYflxji5DYbW1kuKI=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1560132969-1960-1-git-send-email-weiyi.lu@mediatek.com>
References: <1560132969-1960-1-git-send-email-weiyi.lu@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Rob Herring <robh@kernel.org>, Weiyi Lu <weiyi.lu@mediatek.com>
From:   Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH v2] clk: mediatek: mt8183: Register 13MHz clock earlier for clocksource
Cc:     James Liao <jamesjj.liao@mediatek.com>,
        Fan Chen <fan.chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-clk@vger.kernel.org,
        srv_heupstream@mediatek.com, stable@vger.kernel.org,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Dehui Sun <dehui.sun@mediatek.com>
User-Agent: alot/0.8.1
Date:   Tue, 25 Jun 2019 15:15:12 -0700
Message-Id: <20190625221512.B691620883@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Weiyi Lu (2019-06-09 19:16:09)
> The 13MHz clock should be registered before clocksource driver is
> initialized. Use CLK_OF_DECLARE_DRIVER() to guarantee.
>=20
> Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>

Do you have a Fixes: tag in mind? Otherwise, the patch looks OK to me.

