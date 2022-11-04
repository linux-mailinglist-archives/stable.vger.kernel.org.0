Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1166195C2
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 13:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbiKDMCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 08:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiKDMCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 08:02:48 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4688C2D1C8
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 05:02:46 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oqvPH-0005aZ-60; Fri, 04 Nov 2022 13:02:43 +0100
Message-ID: <464d46df-cad0-720a-9193-6e569d9c1d91@leemhuis.info>
Date:   Fri, 4 Nov 2022 13:02:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: Regression: Fwd: Re: [PATCH] riscv: mmap with PROT_WRITE but no
 PROT_READ is invalid #forregzbot
Content-Language: en-US, de-DE
To:     regressions@lists.linux.dev
Cc:     linux-riscv@lists.infradead.org, stable@vger.kernel.org
References: <d6c9e249-08bd-4439-7dcc-371b32e7b851@canonical.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <d6c9e249-08bd-4439-7dcc-371b32e7b851@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1667563366;3d22cd8d;
X-HE-SMSGID: 1oqvPH-0005aZ-60
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Note: this mail is primarily send for documentation purposes and/or for
regzbot, my Linux kernel regression tracking bot. That's why I removed
most or all folks from the list of recipients, but left any that looked
like a mailing lists. These mails usually contain '#forregzbot' in the
subject, to make them easy to spot and filter out.]

On 11.10.22 18:52, Dimitri John Ledkov wrote:
> #regzbot ^introduced 2139619bcad7ac44cc8f6f749089120594056613

#regzbot fixed-by: 9e2e6042a7ec
