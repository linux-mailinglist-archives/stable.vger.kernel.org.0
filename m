Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C3F64CFDD
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 20:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbiLNTHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 14:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238450AbiLNTG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 14:06:59 -0500
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCC5926C3;
        Wed, 14 Dec 2022 11:06:46 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 2BEJ1LWU014253;
        Wed, 14 Dec 2022 13:01:21 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 2BEJ1JSw014250;
        Wed, 14 Dec 2022 13:01:19 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 14 Dec 2022 13:01:19 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH] [BACKPORT FOR 4.14] libtraceevent: Fix build with binutils 2.35
Message-ID: <20221214190119.GO25951@gate.crashing.org>
References: <c4629a12d4a2a21ff131624d3ef1d9f8b5fd64ad.1670954579.git.christophe.leroy@csgroup.eu> <20221213202535.GL25951@gate.crashing.org> <8d1c27fe-bac5-8007-a852-f9c15a49a6ba@csgroup.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8d1c27fe-bac5-8007-a852-f9c15a49a6ba@csgroup.eu>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 14, 2022 at 03:33:24PM +0000, Christophe Leroy wrote:
> Le 13/12/2022 à 21:25, Segher Boessenkool a écrit :
> > On Tue, Dec 13, 2022 at 07:03:07PM +0100, Christophe Leroy wrote:
> >> In binutils 2.35, 'nm -D' changed to show symbol versions along with
> >> symbol names, with the usual @@ separator.
> > 
> > 2.37 instead?  And --without-symbol-versions is there to restore the
> > old behaviour.  The script is parsing the output already so this patch
> > is simpler maybe, but :-)
> 
> Do you mean that the original commit from Ben should have done it 
> differently ?

Probably.

> My patch is only a backport of original commit 39efdd94e314 
> ("libtraceevent: Fix build with binutils 2.35") due to Makefile being at 
> a different place in 4.14.

<shrug>.  It's not such a great idea to spread misinformation further,
imo.  Maybe the mailing list archives will help dampen that already now.

Thanks,


Segher
