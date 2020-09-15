Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481B4269D7A
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 06:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgIOE2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 00:28:16 -0400
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:60422 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726019AbgIOE2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 00:28:16 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 2FFA5182CED34;
        Tue, 15 Sep 2020 04:28:15 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3872:3874:4321:5007:6117:10004:10400:10848:11232:11658:11914:12050:12297:12740:12760:12895:13069:13211:13229:13311:13357:13439:14659:21080:21627:21987:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: edge48_1415aac2710e
X-Filterd-Recvd-Size: 1630
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Tue, 15 Sep 2020 04:28:13 +0000 (UTC)
Message-ID: <5a9007605dec96c81ec85bc3dcc78faaa9ed06a0.camel@perches.com>
Subject: Re: [PATCH v5] lib/string.c: implement stpcpy
From:   Joe Perches <joe@perches.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        stable@vger.kernel.org
Date:   Mon, 14 Sep 2020 21:28:12 -0700
In-Reply-To: <20200915042233.GA816510@ubuntu-n2-xlarge-x86>
References: <20200914160958.889694-1-ndesaulniers@google.com>
         <20200914161643.938408-1-ndesaulniers@google.com>
         <20200915042233.GA816510@ubuntu-n2-xlarge-x86>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-09-14 at 21:22 -0700, Nathan Chancellor wrote:
> It would be nice to get this into mainline sooner rather than later so
> that it can start filtering into the stable trees. ToT LLVM builds have
> been broken for a month now.

People that build stable trees with new compilers
unsupported at the time the of the base version
release are just asking for trouble.


