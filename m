Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E98666511
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 21:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbjAKUwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 15:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbjAKUw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 15:52:28 -0500
Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E490A3F105;
        Wed, 11 Jan 2023 12:52:26 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5b2e8e20.dip0.t-ipconnect.de [91.46.142.32])
        by mail.itouring.de (Postfix) with ESMTPSA id 55E0B127843;
        Wed, 11 Jan 2023 21:52:22 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 19038F01581;
        Wed, 11 Jan 2023 21:52:22 +0100 (CET)
Subject: Re: [PATCH] maple_tree: Fix mas_empty_area_rev() lower bound
 validation
To:     Liam Howlett <liam.howlett@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maple-tree@lists.infradead.org" <maple-tree@lists.infradead.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "amanieu@gmail.com" <amanieu@gmail.com>
References: <20230111200136.1851322-1-Liam.Howlett@oracle.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <ae39b767-3356-d0a6-4a2d-9154d2eede4f@applied-asynchrony.com>
Date:   Wed, 11 Jan 2023 21:52:22 +0100
MIME-Version: 1.0
In-Reply-To: <20230111200136.1851322-1-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-01-11 21:02, Liam Howlett wrote:
> mas_empty_area_rev() was not correctly validating the start of a gap
> against the lower limit.  This could lead to the range starting lower
> than the requested minimum.
> 
> Fix the issue by better validating a gap once one is found.
> 
> This commit also adds tests to the maple tree test suite for this issue
> and tests the mas_empty_area() function for similar bound checking.
> 
> Cc: stable@vger.kernel.org
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216911
> Reported-by: amanieu@gmail.com
> Fixes: 54a611b60590 ("Maple Tree: add new data structure")
> Link: https://lore.kernel.org/linux-mm/0b9f5425-08d4-8013-aa4c-e620c3b10bb2@leemhuis.info/
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
