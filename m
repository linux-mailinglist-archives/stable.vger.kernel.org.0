Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E974360E083
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 14:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiJZMUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 08:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbiJZMUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 08:20:53 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CE95F99B;
        Wed, 26 Oct 2022 05:20:52 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1onfOp-0000Mf-V2; Wed, 26 Oct 2022 14:20:48 +0200
Message-ID: <63294047-20e7-6ff2-01b8-a267b0ecb4af@leemhuis.info>
Date:   Wed, 26 Oct 2022 14:20:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [REGRESSION] introduced in 5.10.140 causes drives to drop from
 LSI SAS controller (Bisected to 6d17a112e9a63ff6a5edffd1676b99e0ffbcd269)
 #forregzbot
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     regressions@lists.linux.dev
Cc:     stable@vger.kernel.org, linux-scsi@vger.kernel.org
References: <CADy0EvLGJmZe-x9wzWSB6+tDKNuLHd8Km3J5MiWWYQRR2ctS3A@mail.gmail.com>
 <350ec615-ffe8-2e0e-149d-4bf45932a585@acm.org>
 <ddec1a2f-1d55-ac42-9877-0d7119d087cd@leemhuis.info>
In-Reply-To: <ddec1a2f-1d55-ac42-9877-0d7119d087cd@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1666786852;3454d1b2;
X-HE-SMSGID: 1onfOp-0000Mf-V2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

On 22.09.22 13:38, Thorsten Leemhuis wrote:
>
> Hmm, nothing happened here for a week. :-/ That's not how this should be
> when it comes to regressions...
> 
> Jason, any news on this? 

#regzbot invalid: reporter MIA
