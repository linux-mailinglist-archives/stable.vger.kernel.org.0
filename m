Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7431E316701
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 13:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhBJMpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 07:45:09 -0500
Received: from mail.jv-coder.de ([5.9.79.73]:38498 "EHLO mail.jv-coder.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230200AbhBJMnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 07:43:19 -0500
Received: from [192.168.178.40] (unknown [188.192.1.224])
        by mail.jv-coder.de (Postfix) with ESMTPSA id D947B9F713;
        Wed, 10 Feb 2021 12:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1612960938; bh=jobc+08FAOyjmkbANrhe+gJitxkT/44/+3m3HJpaN80=;
        h=To:From:Subject:Message-ID:Date:MIME-Version;
        b=ZijUB3wnnfuxuaLfy+tpo4xCu41WohXoxZtnN0eX4G5ZJ1FfaRjsXvTs0Rd7v8Qk1
         YBcijXKiMMdPr/2U6ntBdhHspCwyMaJub0TWq6K1pSldaNUhuOYi/bcXZwMNLnRVnb
         Ir7ucsgiKMXs6sytttnVvhoR9Hp7Ur5xia8qHYsA=
To:     stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        John Stultz <john.stultz@linaro.org>
From:   Joerg Vehlow <lkml@jv-coder.de>
Subject: [4.14] Failing selftest timer/adjtick
Message-ID: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
Date:   Wed, 10 Feb 2021 13:43:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF autolearn=ham
        autolearn_force=no version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.jv-coder.de
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

we found that on the selftest timer/adjtick fails on arm64 (tested on 
some renesas board and in qemu) quite frequently.
By bisecting the kernel I found that it stopped failing after commit 
78b98e3c5a66 (timekeeping/ntp: Determine the multiplier directly from 
NTP tick length).
Should this patch be applied to 4.14 and is it even possible or could it 
break something else?

Thanks,
Joerg
