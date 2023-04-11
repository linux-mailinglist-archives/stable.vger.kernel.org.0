Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA9C6DE16F
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 18:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjDKQsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 12:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjDKQsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 12:48:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70C95590;
        Tue, 11 Apr 2023 09:48:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8282060DF2;
        Tue, 11 Apr 2023 16:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85416C433D2;
        Tue, 11 Apr 2023 16:48:28 +0000 (UTC)
Date:   Tue, 11 Apr 2023 12:48:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tze-nan Wu <Tze-nan.Wu@mediatek.com>
Cc:     <mhiramat@kernel.org>, <bobule.chang@mediatek.com>,
        <wsd_upstream@mediatek.com>, <cheng-jui.wang@mediatek.com>,
        <npiggin@gmail.com>, <stable@vger.kernel.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v3] ring-buffer: Prevent inconsistent operation on
 cpu_buffer->resize_disabled
Message-ID: <20230411124826.04d19759@gandalf.local.home>
In-Reply-To: <20230411124403.2a31e12d@gandalf.local.home>
References: <20230409024616.31099-1-Tze-nan.Wu@mediatek.com>
        <20230410073512.13362-1-Tze-nan.Wu@mediatek.com>
        <20230411124403.2a31e12d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Apr 2023 12:44:03 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Please have each new patch be a new thread, and not a Cc to the previous

Should have been "reply to the previous" :-p

-- Steve

> version of the patch. As it makes it hard to find in INBOXs.

