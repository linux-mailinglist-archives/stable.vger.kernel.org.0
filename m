Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDF058DD56
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 19:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245109AbiHIRja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 13:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245088AbiHIRj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 13:39:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD96625C44;
        Tue,  9 Aug 2022 10:39:28 -0700 (PDT)
Date:   Tue, 9 Aug 2022 19:39:25 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     netfilter-devel@vger.kernel.org, kadlec@netfilter.org,
        fw@strlen.de, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] netfilter: nf_tables: do not allow RULE_ID to refer
 to another chain
Message-ID: <YvKbzc53xy+0Bh0B@salvia>
References: <20220809170148.164591-1-cascardo@canonical.com>
 <20220809170148.164591-3-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220809170148.164591-3-cascardo@canonical.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 02:01:48PM -0300, Thadeu Lima de Souza Cascardo wrote:
> When doing lookups for rules on the same batch by using its ID, a rule from
> a different chain can be used. If a rule is added to a chain but tries to
> be positioned next to a rule from a different chain, it will be linked to
> chain2, but the use counter on chain1 would be the one to be incremented.
> 
> When looking for rules by ID, use the chain that was used for the lookup by
> name. The chain used in the context copied to the transaction needs to
> match that same chain. That way, struct nft_rule does not need to get
> enlarged with another member.

Series applied, thanks
