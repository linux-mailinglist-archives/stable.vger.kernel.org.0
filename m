Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038A55320C1
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 04:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbiEXCNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 22:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiEXCNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 22:13:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59459CC89;
        Mon, 23 May 2022 19:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8032F60FD6;
        Tue, 24 May 2022 02:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42558C385A9;
        Tue, 24 May 2022 02:13:30 +0000 (UTC)
Date:   Mon, 23 May 2022 22:13:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <song@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Kernel Team <kernel-team@fb.com>, stable@vger.kernel.org
Subject: Re: [PATCH] ftrace: clean up hash direct_functions on register
 failures
Message-ID: <20220523221328.2f9bd72b@gandalf.local.home>
In-Reply-To: <CAPhsuW48q=_aFh6SO8fBJ-Zh9upRDo0RL3QySbnkum9EROBLyw@mail.gmail.com>
References: <20220512220808.766832-1-song@kernel.org>
        <CAPhsuW48q=_aFh6SO8fBJ-Zh9upRDo0RL3QySbnkum9EROBLyw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 May 2022 11:57:22 -0700
Song Liu <song@kernel.org> wrote:

> Hi Steven,
> 
> Could you please share your thoughts on this fix?

I'll take a look at it tomorrow, when I look at all my past patches.

Sorry for the delay, I've been behind schedule on something that is
hopefully ready.

-- Steve
