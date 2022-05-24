Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48451532DD6
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 17:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbiEXPvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 11:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbiEXPvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 11:51:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12112DAB5;
        Tue, 24 May 2022 08:51:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 540A8B81978;
        Tue, 24 May 2022 15:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0D4C34113;
        Tue, 24 May 2022 15:51:12 +0000 (UTC)
Date:   Tue, 24 May 2022 11:51:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ftrace: clean up hash direct_functions on register
 failures
Message-ID: <20220524115110.06b3163b@gandalf.local.home>
In-Reply-To: <5992B5A2-090D-49AB-8CF1-B9B2A6B15350@fb.com>
References: <20220512220808.766832-1-song@kernel.org>
        <20220524104527.3a07878d@gandalf.local.home>
        <5992B5A2-090D-49AB-8CF1-B9B2A6B15350@fb.com>
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

On Tue, 24 May 2022 15:33:36 +0000
Song Liu <songliubraving@fb.com> wrote:

> Yeah, this does look better. Do I need to send v2 with this version?

Yes please. And as a new thread (not a reply to this one).

Thanks,

-- Steve
