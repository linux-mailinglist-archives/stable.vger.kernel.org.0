Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F51572DBE
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 07:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiGMFyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 01:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbiGMFyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 01:54:31 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC71920F4D;
        Tue, 12 Jul 2022 22:54:04 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oBVJx-0007nB-Tn; Wed, 13 Jul 2022 07:54:01 +0200
Message-ID: <baf81019-89a1-dc79-c80e-fe2dd1c8ee58@leemhuis.info>
Date:   Wed, 13 Jul 2022 07:54:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Ben Greening <bgreening@gmail.com>, stable@vger.kernel.org
Cc:     regressions@lists.linux.dev, rafael@kernel.org,
        linux-acpi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <CALF=6jEe5G8+r1Wo0vvz4GjNQQhdkLT5p8uCHn6ZXhg4nsOWow@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [Regression] ACPI: video: Change how we determine if brightness
 key-presses are handled
In-Reply-To: <CALF=6jEe5G8+r1Wo0vvz4GjNQQhdkLT5p8uCHn6ZXhg4nsOWow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1657691644;010699b9;
X-HE-SMSGID: 1oBVJx-0007nB-Tn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[CCing Hans, who authored 3a0cf7ab8d ("ACPI: video: Change how we
determine if brightness key-presses are handled")]

On 13.07.22 07:27, Ben Greening wrote:
> (resending because of HTML formatting)
> Hi, I'm on Arch Linux and upgraded from kernel 5.18.9.arch1-1 to
> 5.18.10.arch1-1. The brightness keys don't work as well as before.
> Gnome had 20 degrees of brightness, now it's 10, and Xfce went from 10
> to 5. Additionally, on Gnome the brightness keys are a little slow to
> respond and there's a bit of a stutter. Don't know why Xfce doesn't
> stutter, but halving the degrees of brightness for both makes me
> wonder if each press is being counted twice.
> 
> Reverting commit 3a0cf7ab8d in acpi_video.c and rebuilding
> 5.18.10.arch1-1 fixed it.

BTW, in case someone gets slightly confused like I was here:
3a0cf7ab8d is a mainline commit that was backported to 5.18.y as
1ed81b354d8c recently.

> The laptop is a Dell Inspiron n4010 and I use "acpi_backlight=video"
> to make the brightness keys work. Please let me know if there's any
> hardware info you need.
> 
> #regzbot introduced: 3a0cf7ab8d

BTW, thx for the report!

Ciao, Thorsten
