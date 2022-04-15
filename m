Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E6350315E
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 01:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbiDOWPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 18:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiDOWPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 18:15:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C0443AC0;
        Fri, 15 Apr 2022 15:12:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3343AB83122;
        Fri, 15 Apr 2022 22:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87644C385A5;
        Fri, 15 Apr 2022 22:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650060765;
        bh=IBufb3Gm1JcqhqSv4q0CpDybcSeVhHU23jPjU9g0zdw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=no6uEs3nnOoDwgDFxj730uyg8gD0k/Z3sZiVh1wWhKr5cDKWOajsz2ks+jIVLRcc1
         5Z7xGHBDtyaHN0wowwZtA+HIDfTH0B5wyKcNv90arJDvrZJLkqUfSvtkF2hughktZY
         siOIfe5SeVAli06g++wP9xlQXSPT7erTXd/4/VL4=
Date:   Fri, 15 Apr 2022 15:12:44 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v10] mm, hugetlbfs: Allow for "high" userspace addresses
Message-Id: <20220415151244.c29ad0c9c481dab0ade1022b@linux-foundation.org>
In-Reply-To: <ab847b6edb197bffdfe189e70fb4ac76bfe79e0d.1650033747.git.christophe.leroy@csgroup.eu>
References: <ab847b6edb197bffdfe189e70fb4ac76bfe79e0d.1650033747.git.christophe.leroy@csgroup.eu>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 15 Apr 2022 16:45:13 +0200 Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> This is a fix for commit f6795053dac8 ("mm: mmap: Allow for "high"
> userspace addresses") for hugetlb.

So the "hugetlbfs" in the Subject: is a tpyo?
