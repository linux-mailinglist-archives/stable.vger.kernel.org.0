Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA918327803
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 08:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhCAHFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 02:05:55 -0500
Received: from mail.jv-coder.de ([5.9.79.73]:50374 "EHLO mail.jv-coder.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232350AbhCAHEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 02:04:21 -0500
Received: from [192.168.178.40] (unknown [188.192.1.224])
        by mail.jv-coder.de (Postfix) with ESMTPSA id 3ECDA9F72D;
        Mon,  1 Mar 2021 07:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jv-coder.de; s=dkim;
        t=1614582195; bh=cGoDm6YWoX68pZfoTlvUBH+buECulN6Mb0bJ45mg8wk=;
        h=Subject:To:From:Message-ID:Date:MIME-Version;
        b=a9CP03NhZQCepP+o68rRMQktLKto+pz9h45Qtm8VWG3qh8HcSvmkScDgb++/3wZCV
         aoLfJ+x+r4Dr50AC+kIRnjyE5IzZClmIqazsAii6io0o4dVCjDdK6ekH2TL4yEWS+b
         0v8R9kBgfrYgvl8mx7jszqbH+YqyQ1p7ELF66cKs=
Subject: Re: [4.14] Failing selftest timer/adjtick
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>
References: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
 <YCPZA7nkGGDru3xw@kroah.com>
 <239b8a9a-d550-11e3-4650-39ad5bd85013@jv-coder.de>
 <20210210131916.GC1903164@localhost>
 <897e03f9-4062-d34f-0445-ff4f047ccd13@jv-coder.de>
 <20210211105944.GG1903164@localhost>
From:   Joerg Vehlow <lkml@jv-coder.de>
Message-ID: <c0a32d60-073e-3faa-6529-97b1a8c7fdaf@jv-coder.de>
Date:   Mon, 1 Mar 2021 08:04:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210211105944.GG1903164@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.jv-coder.de
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mi

On 2/11/2021 11:59 AM, Miroslav Lichvar wrote:
> I don't think it is specific to arm or that it is a regression. I
> think the virtual machine just happens to be too idle for the test.
> There may be unrelated changes, maybe in the kernel, qemu, or
> applications, that caused the rate of the clock updates to decrease so
> much that the instability now triggers the failure in the test.  The
> issue with the clock was there since NO_HZ was introduced, but it
> becomes more severe as the activity of the kernel decreases.
Thanks for the hint towards NO_HZ. Running the tests with some 
background load makes them pass reliably.

Jörg
