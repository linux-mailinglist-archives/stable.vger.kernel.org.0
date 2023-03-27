Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8DB6CAF0B
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjC0TpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjC0TpO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 15:45:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975472D7E;
        Mon, 27 Mar 2023 12:45:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54287B818CF;
        Mon, 27 Mar 2023 19:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1654C433EF;
        Mon, 27 Mar 2023 19:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679946311;
        bh=96J6SDF996CRM/onTR9RxkN2jbXMAHb7+WLbo7EPRAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kqQAWvFIagaqH02YbNxOEXbMmTNFaG/y81fgbjJ+NXaHyIDU0ZKkfg1PHSh+DAx3J
         8mwPTl4RFfADOpJChbbepMnj+sV46MlaL4SnBbMBqzF1Bj+1qRStr+Au4ioXe7NXAJ
         rVjBeKQ09h4QRtQ2XB/1q6yZrGRQQEumDncNOpDQ=
Date:   Mon, 27 Mar 2023 12:45:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 5/8] maple_tree: fix write memory barrier of nodes once
 dead for RCU mode
Message-Id: <20230327124509.e69ea53187ce08a509ff2e44@linux-foundation.org>
In-Reply-To: <20230327190540.73lyataw7am5pvou@revolver>
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
        <20230327185532.2354250-6-Liam.Howlett@oracle.com>
        <20230327190540.73lyataw7am5pvou@revolver>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Mar 2023 15:05:40 -0400 "Liam R. Howlett" <Liam.Howlett@Oracle.com> wrote:

> Link: https://lkml.kernel.org/r/20230227173632.3292573-6-surenb@google.com
> Fixes: 54a611b60590 ("Maple Tree: add new data structure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

The earlier version had a signed-off-by:Suren, which I am retaining.
