Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCEE1773EC
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 11:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgCCKVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 05:21:50 -0500
Received: from elvis.franken.de ([193.175.24.41]:49476 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgCCKVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 05:21:50 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1j94gM-0006jL-00; Tue, 03 Mar 2020 11:21:46 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 29770C0EC4; Tue,  3 Mar 2020 11:18:18 +0100 (CET)
Date:   Tue, 3 Mar 2020 11:18:18 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Paul Boddie <paul@boddie.org.uk>,
        Paul Cercueil <paul@crapouillou.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: Re: [PATCH v5 2/5] MIPS: DTS: CI20: fix PMU definitions for ACT8600
Message-ID: <20200303101818.GA12103@alpha.franken.de>
References: <cover.1583005548.git.hns@goldelico.com>
 <02f18080fa0e0c214b40431749ca1ce514c53d37.1583005548.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02f18080fa0e0c214b40431749ca1ce514c53d37.1583005548.git.hns@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 29, 2020 at 08:45:45PM +0100, H. Nikolaus Schaller wrote:
> There is a ACT8600 on the CI20 board and the bindings of the
> ACT8865 driver have changed without updating the CI20 device
> tree. Therefore the PMU can not be probed successfully and
> is running in power-on reset state.
> 
> Fix DT to match the latest act8865-regulator bindings.
> 
> Fixes: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes")

I see checkpatch warnings in this patch, could please fix them ?
And please seperate fixes from improvments, thank you.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
