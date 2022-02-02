Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F704A7405
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 15:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiBBO5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 09:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345203AbiBBO5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 09:57:47 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F9CC06173B
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 06:57:47 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nFH4q-0003Kw-9n; Wed, 02 Feb 2022 15:57:44 +0100
Date:   Wed, 2 Feb 2022 15:57:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     stable@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: 4.19.y stable request: nat soft lockup fix
Message-ID: <Yfqb6BKXBqrkMkBa@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha, Greg,

Could you queue following two commits for 4.19.y tree?

6ed5943f8735e2b778d92ea4d9805c0a1d89bc2b
netfilter: nat: remove l4 protocol port rovers

a504b703bb1da526a01593da0e4be2af9d9f5fa8
netfilter: nat: limit port clash resolution attempts

This resolves softlockup when most of the ephemeral ports
are in use.

Its also needed on older kernels but unfortunately they
won't apply as-is. We will try to get modified backports
for older releases and forward them to stable@ later.


Thanks,
Florian


