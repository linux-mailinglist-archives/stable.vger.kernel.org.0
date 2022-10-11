Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651A95FB9B6
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 19:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJKReE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 13:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiJKRdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 13:33:22 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6A24BA5C
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 10:30:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oiJ3u-0005d3-H7; Tue, 11 Oct 2022 19:29:02 +0200
Date:   Tue, 11 Oct 2022 19:29:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vimal Agrawal <avimalin@gmail.com>
Cc:     stable@vger.kernel.org, fw@strlen.de,
        Vimal Agrawal <vimal.agrawal@sophos.com>
Subject: Re: [PATCH 4.14.y] netfilter: nf_queue: fix socket leak
Message-ID: <20221011172902.GC19620@breakpoint.cc>
References: <20221011172202.3709-1-vimal.agrawal@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011172202.3709-1-vimal.agrawal@sophos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vimal Agrawal <avimalin@gmail.com> wrote:
> Removal of the sock_hold got lost when backporting commit 4d05239203fa
> ("netfilter: nf_queue: fix possible use-after-free") to 4.14
> 
> This was causing a socket leak and was caught by kmemleak.
> Tested by running kmemleak again with this fix.

Thanks.

Reviewed-by: Florian Westphal <fw@strlen.de>
