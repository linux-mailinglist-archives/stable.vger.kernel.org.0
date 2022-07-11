Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CE25707AF
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 17:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiGKPw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 11:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiGKPwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 11:52:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733E577A65;
        Mon, 11 Jul 2022 08:52:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D759960EBB;
        Mon, 11 Jul 2022 15:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A596C34115;
        Mon, 11 Jul 2022 15:52:12 +0000 (UTC)
Date:   Mon, 11 Jul 2022 11:52:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Zanussi, Tom" <tom.zanussi@linux.intel.com>
Cc:     Zheng Yejian <zhengyejian1@huawei.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        stable@vger.kernel.org, trix@redhat.com, zhangjinhao2@huawei.com
Subject: Re: [PATCH v2] tracing/histograms: Fix memory leak problem
Message-ID: <20220711115211.4f613cbe@gandalf.local.home>
In-Reply-To: <7b562ff6-3f44-053b-d8e6-3c40be145446@linux.intel.com>
References: <20220708210335.79a38356@gandalf.local.home>
        <20220711014731.69520-1-zhengyejian1@huawei.com>
        <7b562ff6-3f44-053b-d8e6-3c40be145446@linux.intel.com>
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

On Mon, 11 Jul 2022 09:27:44 -0500
"Zanussi, Tom" <tom.zanussi@linux.intel.com> wrote:

> So I'm wondering if this means that that the original unnecessary bugfix
> was based on a bug in the clang static analyzer or if that would just be
> considered a false positive...

Good question. I'd like to know this, as if it is the case, I want to
report that in my pull request to Linus.

-- Steve
