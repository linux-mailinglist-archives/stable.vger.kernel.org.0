Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E914364BDF2
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 21:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237288AbiLMUdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 15:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236408AbiLMUdL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 15:33:11 -0500
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F136D5F46;
        Tue, 13 Dec 2022 12:33:06 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 2BDKPa1d030311;
        Tue, 13 Dec 2022 14:25:36 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 2BDKPZ42030308;
        Tue, 13 Dec 2022 14:25:35 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Tue, 13 Dec 2022 14:25:35 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH] [BACKPORT FOR 4.14] libtraceevent: Fix build with binutils 2.35
Message-ID: <20221213202535.GL25951@gate.crashing.org>
References: <c4629a12d4a2a21ff131624d3ef1d9f8b5fd64ad.1670954579.git.christophe.leroy@csgroup.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4629a12d4a2a21ff131624d3ef1d9f8b5fd64ad.1670954579.git.christophe.leroy@csgroup.eu>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 07:03:07PM +0100, Christophe Leroy wrote:
> In binutils 2.35, 'nm -D' changed to show symbol versions along with
> symbol names, with the usual @@ separator.

2.37 instead?  And --without-symbol-versions is there to restore the
old behaviour.  The script is parsing the output already so this patch
is simpler maybe, but :-)


Segher
