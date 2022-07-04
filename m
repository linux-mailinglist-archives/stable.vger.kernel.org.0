Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06873565302
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbiGDLFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiGDLFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:05:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C46101CD
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:05:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D994A61605
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE357C3411E;
        Mon,  4 Jul 2022 11:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656932748;
        bh=JUqK2LbXk04SQeeP/WyAtGZVEnAX8r3l5VayaczdYJw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QOaKv9IVceuxLmtOm/NreP33q1Dvn3WT7yB6JkhHO2byEFDqaPYxhSm768Og80gvu
         RuI9cpkfGbvhKZLPp9JeEJsuzQueDNil03np6ikm8fz2lnyMFwDWInoe2GRdjgtnHt
         Ys4bQlpYHtXAgkAnbgAyGdldh4uRuZEWtl/81A6g=
Date:   Mon, 4 Jul 2022 13:05:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Wen Yang <wenyang@linux.alibaba.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Bin Yang <bin.yang@intel.com>,
        Mark Gross <mark.gross@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19] x86/mm/cpa: Unconditionally avoid WBINDV when we can
Message-ID: <YsLJiSZ0mCCEckR2@kroah.com>
References: <20220704082817.4596-1-wenyang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704082817.4596-1-wenyang@linux.alibaba.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 04, 2022 at 04:28:17PM +0800, Wen Yang wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit ab3e9c0b75dcb13e9254ef68caa7f15bc66b6471 upstream.

This commit id is not in Linus's tree :(
