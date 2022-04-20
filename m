Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE8C508F88
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 20:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381535AbiDTShq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 14:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346657AbiDTSh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 14:37:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966301A3A5
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 11:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31EB160AEB
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 18:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AAFC385A1;
        Wed, 20 Apr 2022 18:34:39 +0000 (UTC)
Date:   Wed, 20 Apr 2022 14:34:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     bristot@kernel.org, zanussi@kernel.org, <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Have traceon and traceoff
 trigger honor the instance" failed to apply to 4.9-stable tree
Message-ID: <20220420143438.1e3a5a7c@gandalf.local.home>
In-Reply-To: <164602997992124@kroah.com>
References: <164602997992124@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Feb 2022 07:32:59 +0100
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Unfortunately, this has a lot more missing that needs to be added to make
this work for 4.9. I don't have the time to update it :-/ It's not a
critical bug. Just one that gives surprising behavior.

-- Steve
