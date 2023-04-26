Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9436EEBDA
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 03:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238366AbjDZBVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 21:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbjDZBVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 21:21:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7A1977A;
        Tue, 25 Apr 2023 18:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09F0160FCE;
        Wed, 26 Apr 2023 01:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE775C433D2;
        Wed, 26 Apr 2023 01:21:35 +0000 (UTC)
Date:   Tue, 25 Apr 2023 21:21:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tze-nan.Wu" <Tze-nan.Wu@mediatek.com>
Cc:     <mhiramat@kernel.org>, <bobule.chang@mediatek.com>,
        <cheng-jui.wang@mediatek.com>, <wsd_upstream@mediatek.com>,
        <stable@vger.kernel.org>, <npiggin@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: [PATCH v5] ring-buffer: Ensure proper resetting of atomic
 variables in ring_buffer_reset_online_cpus
Message-ID: <20230425212132.53789b24@gandalf.local.home>
In-Reply-To: <20230425211737.757208b3@gandalf.local.home>
References: <20230426010446.10753-1-Tze-nan.Wu@mediatek.com>
        <20230425211737.757208b3@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Apr 2023 21:17:37 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> For some reason, this email did not make it to
> linux-trace-kernel@vger.kernel.org, and therefore did not make it into
> patchwork?
> 

And the email was definitely Cc'd properly, as my reply made it to lore,
but not the original email.

 https://lore.kernel.org/linux-trace-kernel/20230425211737.757208b3@gandalf.local.home/

-- Steve
