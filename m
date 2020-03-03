Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCDE1775EE
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 13:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgCCMcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 07:32:35 -0500
Received: from elvis.franken.de ([193.175.24.41]:49595 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgCCMcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 07:32:35 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1j96iu-0003ir-00; Tue, 03 Mar 2020 13:32:32 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 43958C0EC5; Tue,  3 Mar 2020 13:32:14 +0100 (CET)
Date:   Tue, 3 Mar 2020 13:32:14 +0100
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
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v5 2/5] MIPS: DTS: CI20: fix PMU definitions for ACT8600
Message-ID: <20200303123214.GA15333@alpha.franken.de>
References: <cover.1583005548.git.hns@goldelico.com>
 <02f18080fa0e0c214b40431749ca1ce514c53d37.1583005548.git.hns@goldelico.com>
 <20200303101818.GA12103@alpha.franken.de>
 <85F9D066-EAF6-4840-8F54-24E6D8A534DC@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85F9D066-EAF6-4840-8F54-24E6D8A534DC@goldelico.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 01:10:22PM +0100, H. Nikolaus Schaller wrote:
> > And please seperate fixes from improvments, thank you.
> 
> What do you mean by "separate"? Two separate patches?
> This patch only contains fixes (which I would consider
> all of them to be improvements).

There are two patches with Fixes tag, which IMHO should go
into 5.6 via mips-fixes branch. All others are going
via mips-next into 5.7. So it helps me, if they come in different
patch series (or as single patches).

I see other DT changes in your other patch series. Are the changes
there independent from each other or do they require correct order
when appling them ?

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
