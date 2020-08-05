Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC523C9E4
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 12:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgHEK2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 06:28:45 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11277 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728170AbgHEK0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 06:26:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596623179; x=1628159179;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=h/0isfh8p8B1tbntU7DOOWsRw+KNgTWlrOkmU2ux2KQ=;
  b=I0WW5w/i3V14QLplvh4/UDH/vF6Ba6FjTz/8A1phbJgwmlB2boGC0JLx
   3FISCo8uT71oXwhlVPANK/3C7n+y7gXzm8iK+sdnbH4qaba7POiEbEbKE
   PeUWQmptvaphFAm+O9jMExk92gujrAlf2UzLNUQy36jyWifOl2z/d+3d1
   GGa7kxSASH8N2YhHe/D3eprTVdCz9JZBdQNn34gBqLD5ExJzbuauonCvy
   Xzs+0q/M4O8xwc7GY7QElASYJw63cOjA6/zLclDTbWeFHm2OoDO/w/gUW
   Qu5NJ5rAL4zIEkq+RP3P+O/BuV2yn0F28VtUrphgM+fVtoPhc8H/qZgBI
   Q==;
IronPort-SDR: /tllqZmaNSf0pwVngbbkvrWa4jPFHORmq6vu9xyHDGcSsHwMl/qi4RNeuiLjTRfDbsjhW8OpW5
 XpDoR0jI099Yp0G6vt/om2Pojc8aDZfLbMoob8LgnthK26Rb0cSfYsTVQ4Ern0hBZIR6KSwrm9
 kPXw0Spmdy4JWwlpp9wKLil6PbUJBOBwtSzvJ1Q9EHvDltd2hSqGxudITIM9Pzo9fB2E6u2jC9
 P5rBXhyk54OnjHb69E6cbn3W3ylV+tI3USE+3ZbUWFWzpalrEMNZiY6+7xUABrZfkQ0JFAQwrq
 eUE=
X-IronPort-AV: E=Sophos;i="5.75,436,1589212800"; 
   d="scan'208";a="253548017"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2020 18:25:16 +0800
IronPort-SDR: tmI21nJS/lX63fAYjytIkd1PWsChQ6KHyBIxA5KxqlfhiOGJCJCNheH3zB+KLrZxhRCjNircE2
 7NeegtjBktaQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 03:12:36 -0700
IronPort-SDR: VUewrqLbnzqHz+1znrMauq+iKaQ9F6wif5BzAqHWU2V2ZT7K1lVDvG0MTfXji6pud1QgJHJ3zk
 LoEnDGt9JhZA==
WDCIronportException: Internal
Received: from unknown (HELO redsun52) ([10.149.66.28])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 03:25:15 -0700
Date:   Wed, 5 Aug 2020 11:25:11 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@wdc.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] riscv: ptrace: Use the correct API for `fcsr'
 access
In-Reply-To: <20200805024807.GM1236603@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.21.2008051117180.24175@redsun52.ssa.fujisawa.hgst.com>
References: <20200805020745.GL1236603@ZenIV.linux.org.uk> <mhng-cd1ff2e9-7d34-4d56-8d79-b2d02a239290@palmerdabbelt-glaptop1> <20200805024807.GM1236603@ZenIV.linux.org.uk>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 5 Aug 2020, Al Viro wrote:

> > I'm not sure I understand what you're saying, but given that branch replaces
> > all of this I guess it's best to just do nothing on our end here?
> 
> It doesn't replace ->put() (for now); it _does_ replace ->get() and AFAICS the
> replacement is much saner:
> 
> static int riscv_fpr_get(struct task_struct *target,
>                          const struct user_regset *regset,
>                          struct membuf to)
> {
> 	struct __riscv_d_ext_state *fstate = &target->thread.fstate;
> 
> 	membuf_write(&to, fstate, offsetof(struct __riscv_d_ext_state, fcsr));
> 	membuf_store(&to, fstate->fcsr);
> 	return membuf_zero(&to, 4);     // explicitly pad
> }

 I'm glad to see the old interface go, it was cumbersome.

> user_regset_copyout() calling conventions are atrocious and so are those of
> regset ->get().  The best thing to do with both is to take them out of their
> misery and be done with that.  Do you see any problems with riscv gdbserver
> on current linux-next?  If not, I'd rather see that "API" simply go away...
> If there are problems, I would very much prefer fixes on top of what's done
> in that branch.

 I can push linux-next through regression-testing with RISC-V gdbserver 
and/or native GDB if that would help.  This is also used with core dumps, 
but honestly I don't know what state RISC-V support is in in the BFD/GDB's 
core dump interpreter, as people tend to forget about the core dump 
feature nowadays.

  Maciej
