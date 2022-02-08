Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0CE4AD957
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 14:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348335AbiBHNQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 08:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350458AbiBHMYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 07:24:35 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B771CC03FEC0;
        Tue,  8 Feb 2022 04:24:34 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nHPXq-0006Dt-4I; Tue, 08 Feb 2022 13:24:31 +0100
Message-ID: <c674269f-5dfe-ac61-01ac-20c393c56f48@leemhuis.info>
Date:   Tue, 8 Feb 2022 13:24:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
Content-Language: en-BS
To:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com>
 <a7fbb773-eb85-ccc7-8bfb-0bfab062ffe1@leemhuis.info>
 <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
 <CACjc_5puGpg85XseEjKxnwE2R_XoH8EWvdwp4g2WKNBmW7pX+w@mail.gmail.com>
 <37d074c7-b264-acac-4bf6-65caa4dbab1a@leemhuis.info>
 <CACjc_5o4n9CNXoER5Va6u0fQhuE9osnUSUwSbHPx0K1yiPUj8g@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <CACjc_5o4n9CNXoER5Va6u0fQhuE9osnUSUwSbHPx0K1yiPUj8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1644323074;49d1220f;
X-HE-SMSGID: 1nHPXq-0006Dt-4I
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

Top-posting for once, to make this easy accessible to everyone.

GPIO Maintainers and developers, what the status of this regression and
getting it fixed? It looks like there was no progress for quite a while.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

#regzbot poke

On 12.01.22 01:09, Marcelo Roberto Jimenez wrote:
> Hi,
> 
> On Mon, Jan 10, 2022 at 4:02 AM Thorsten Leemhuis
> <regressions@leemhuis.info> wrote:
>>
>> Hi, this is your Linux kernel regression tracker speaking.
>>
>> On 20.12.21 21:41, Marcelo Roberto Jimenez wrote:
>>> On Mon, Dec 20, 2021 at 11:57 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
>>>> On Sat, Dec 18, 2021 at 7:28 AM Thorsten Leemhuis
>>>> <regressions@leemhuis.info> wrote:
>>>>>
>>>>> [TLDR: I'm adding this regression to regzbot, the Linux kernel
>>>>> regression tracking bot; most text you find below is compiled from a few
>>>>> templates paragraphs some of you might have seen already.]
>>>>>
>>>>> On 17.12.21 16:35, Marcelo Roberto Jimenez wrote:
>>>>>> Some GPIO lines have stopped working after the patch
>>>>>> commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
>>>>>>
>>>>>> And this has supposedly been fixed in the following patches
>>>>>> commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
>>>>>> commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
>>>>>
>>>>> There seems to be a backstory here. Are there any entries and bug
>>>>> trackers or earlier discussions everyone that looks into this should be
>>>>> aware of?
>>>>
>>>> Agreed with Thorsten. I'd like to first try to determine what's wrong
>>>> before reverting those, as they are correct in theory but maybe the
>>>> implementation missed something.
>>>>
>>>> Have you tried tracing the execution on your platform in order to see
>>>> what the driver is doing?
>>>
>>> Yes. The problem is that there is no list defined for the sysfs-gpio
>>> interface. The driver will not perform pinctrl_gpio_request() and will
>>> return zero (failure).
>>>
>>> I don't know if this is the case to add something to a global DTD or
>>> to fix it in the sysfs-gpio code.
>>
>> Out of interest, has any progress been made on this front?
>>
>> BTW, there was a last-minute commit for 5.16 yesterday that referenced
>> the culprit Marcelo specified:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=master&id=c8013355ead68dce152cf426686f8a5f80d88b40
>>
>> This was for a BCM283x and BCM2711 devices, so I assume it won't help.
>> Wild guess (I don't know anything about this area of the kernel):
>> Marcelo, do the dts files for your hardware maybe need a similar fix?
> 
> I have tried to add "gpio-ranges" to the gpio-controllers in
> at91sam9x5.dtsi, but the system deadlocks, because in pinctrl-at91.c,
> function at91_pinctrl_probe() we have:
> 
> /*
> * We need all the GPIO drivers to probe FIRST, or we will not be able
> * to obtain references to the struct gpio_chip * for them, and we
> * need this to proceed.
> */
> for (i = 0; i < gpio_banks; i++)
>         if (gpio_chips[i])
>                 ngpio_chips_enabled++;
> 
>         if (ngpio_chips_enabled < info->nactive_banks) {
>                 dev_warn(&pdev->dev,
>                       "All GPIO chips are not registered yet (%d/%d)\n",
>                       ngpio_chips_enabled, info->nactive_banks);
>                devm_kfree(&pdev->dev, info);
>                 return -EPROBE_DEFER;
>         }
> 
> On the other hand, in gpiolib-of.c, function
> of_gpiochip_add_pin_range() we have:
> 
> if (!pctldev)
>         return -EPROBE_DEFER;
> 
> In other words, the pinctrl needs all the gpio-controllers, and the
> gpio-controllers need the pinctrl. Each returns -EPROBE_DEFER and the
> system deadlocks.
> 
>>
>> Ciao, Thorsten
>>
>> P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
>> on my table. I can only look briefly into most of them. Unfortunately
>> therefore I sometimes will get things wrong or miss something important.
>> I hope that's not the case here; if you think it is, don't hesitate to
>> tell me about it in a public reply, that's in everyone's interest.
>>
>> BTW, I have no personal interest in this issue, which is tracked using
>> regzbot, my Linux kernel regression tracking bot
>> (https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
>> this mail to get things rolling again and hence don't need to be CC on
>> all further activities wrt to this regression.
>>
>> #regzbot poke
>>
> 
> Regards,
> Marcelo.
> 
> 
