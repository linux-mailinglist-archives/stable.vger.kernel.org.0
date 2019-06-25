Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72AE755ACF
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 00:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfFYWOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 18:14:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFYWOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 18:14:16 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0DC22086D;
        Tue, 25 Jun 2019 22:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561500855;
        bh=ZcG6s2SVVPlQMCLBl239NuNMjuljQYUwEP8YAEKAtsQ=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=Ydzac1ENQGs8JHN5EL5E+CkJH82B6XZ3c9ps/ajN91KLrj3uAj/+VpNZmZCdy27gF
         j+kmQ0rJLpj2ZbPXomZ68FzknKOIshM5pYbIqyrdhTjjiWWhao81hbRMTErmFENX0n
         gDVC1TZk2QIFCy7IUZZGjEqeE/telP1NRjhfAJ2M=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1560138293-4163-1-git-send-email-weiyi.lu@mediatek.com>
References: <1560138293-4163-1-git-send-email-weiyi.lu@mediatek.com>
To:     Matthias Brugger <matthias.bgg@gmail.com>,
        Weiyi Lu <weiyi.lu@mediatek.com>
From:   Stephen Boyd <sboyd@kernel.org>
Subject: Re: [RFC v1] clk: core: support clocks that need to be enabled during re-parent
Cc:     James Liao <jamesjj.liao@mediatek.com>,
        Fan Chen <fan.chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-clk@vger.kernel.org,
        srv_heupstream@mediatek.com, stable@vger.kernel.org,
        Weiyi Lu <weiyi.lu@mediatek.com>,
        Biao Huang <biao.huang@mediatek.com>
User-Agent: alot/0.8.1
Date:   Tue, 25 Jun 2019 15:14:14 -0700
Message-Id: <20190625221415.B0DC22086D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Weiyi Lu (2019-06-09 20:44:53)
> When using property assigned-clock-parents to assign parent clocks,
> core clocks might still be disabled during re-parent.
> Add flag 'CLK_OPS_CORE_ENABLE' for those clocks must be enabled
> during re-parent.
>=20
> Signed-off-by: Weiyi Lu <weiyi.lu@mediatek.com>

Can you further describe the scenario where this is a problem? Is it
some sort of clk that is enabled by default out of the bootloader and is
then configured to have an 'assigned-clock-parents' property to change
the parent, but that clk needs to be "enabled" so that the framework
turns on the parents for the parent switch?

