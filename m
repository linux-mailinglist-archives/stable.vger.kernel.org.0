Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D1620E96E
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 01:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgF2Xhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 19:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgF2Xhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 19:37:47 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D59C206F1;
        Mon, 29 Jun 2020 23:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593473867;
        bh=jwY2o3i7A/yilz2MIuZg3u9zREXVh4++QwAfajlJ9l4=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=QnKqIkK1Mtx4Lx4nmaKwHDuiOd0k9+8ngFNH1vIGu8nJpMDUEN7dZg5OVCz6DCWU3
         RZ5vFPXRwWRSNN6WKEgVJvW0r4AeJyj3qRbFmjNf9elEMd1pEa791bd0d+v1e3TdiD
         GsJ7ELoqXLrhZ2QhtSAXrXUW6ARFVFfOQxFADq4s=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <mhng-f15789ef-8446-4dbe-a483-19d2f6c37b96@palmerdabbelt-glaptop1>
References: <mhng-f15789ef-8446-4dbe-a483-19d2f6c37b96@palmerdabbelt-glaptop1>
Subject: Re: [PATCH] clk: sifive: allocate sufficient memory for struct __prci_data
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     vincent.chen@sifive.com, mturquette@baylibre.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        linux-riscv@lists.infradead.org, schwab@suse.de,
        vincent.chen@sifive.com, stable@vger.kernel.org
To:     Palmer Dabbelt <palmer@dabbelt.com>
Date:   Mon, 29 Jun 2020 16:37:46 -0700
Message-ID: <159347386681.1987609.8025910491933969394@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Palmer Dabbelt (2020-06-29 16:34:10)
> On Mon, 29 Jun 2020 16:23:47 PDT (-0700), sboyd@kernel.org wrote:
> >
> > Does that mean applied to sifive tree? I see it in next but only noticed
> > this by chance because it wasn't sent to the linux-clk mailing list.
>=20
> Sorry, I was going a bit too fast and didn't realize this wasn't in arch/=
riscv/
> so I didn't wait for an ack.  I put it on my fixes branch, which is what =
I sent
> for the RCs.  That's merged into linux-next as well, as far as I understa=
nd
> that's the normal way to do things.  It ended up in Linus' tree as d0a5fd=
f4cc83
> ("clk: sifive: allocate sufficient memory for struct __prci_data"), which=
 is in
> rc3.
>=20
> We don't really have a SiFive tree, the SiFive stuff just goes in through=
 the
> RISC-V tree.  In theory I've been meaning to split them up for a while, b=
ut
> given the maintainers are the same I just never got around to doing so.
>=20
> LMK if I screwed something up.

No worries. I would have noticed this patch earlier if it had been sent
to the linux-clk mailing list which I use to catch patches that should
be reviewed for the clk tree. I'm not overly concerned. Thanks.
