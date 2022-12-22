Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6921265413C
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 13:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiLVMpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 07:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiLVMpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 07:45:30 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B0F26A84;
        Thu, 22 Dec 2022 04:45:29 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p8Kwy-0006V9-Ar; Thu, 22 Dec 2022 13:45:28 +0100
Message-ID: <a858f1fc-1927-c4d1-3efe-f2aff23a2cbb@leemhuis.info>
Date:   Thu, 22 Dec 2022 13:45:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v5 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id
 timeout #forregzbot
Content-Language: en-US, de-DE
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20221205201527.13525-1-ftoth@exalondelft.nl>
 <20221205201527.13525-2-ftoth@exalondelft.nl>
 <20221220194334.GA942039@roeck-us.net>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20221220194334.GA942039@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1671713129;162976ba;
X-HE-SMSGID: 1p8Kwy-0006V9-Ar
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Note: this mail contains only information for Linux kernel regression
tracking. Mails like these contain '#forregzbot' in the subject to make
then easy to spot and filter out. The author also tried to remove most
or all individuals from the list of recipients to spare them the hassle.]

On 20.12.22 20:43, Guenter Roeck wrote:

> this patch results in some qemu test failures, specifically xilinx-zynq-a9
> machine and zynq-zc702 as well as zynq-zed devicetree files, when trying
> to boot from USB drive. The log shows

Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot ^introduced 8a7b31d545d3
#regzbot title usb: ulpi: various qemu test failures
#regzbot monitor:
https://lore.kernel.org/all/20221221201805.19436-1-ftoth@exalondelft.nl/
#regzbot fix: Revert "usb: ulpi: defer ulpi_register on ulpi_read_id
timeout"
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
