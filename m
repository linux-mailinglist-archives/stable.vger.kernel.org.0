Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477D04E88B0
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 18:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbiC0QNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 12:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiC0QNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 12:13:06 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CC01C902
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 09:11:27 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 125-20020a1c0283000000b0038d043aac51so322847wmc.0
        for <stable@vger.kernel.org>; Sun, 27 Mar 2022 09:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=6GFJ7ancB1plEhfgVzWZYVl+G7Gv/ojaNkdikZ/2jZg=;
        b=orqlMfSrIwbyWYkxZvplXPR/LEXQlsFsphWNY42yJ+k9AqwBhabrHAiJkEGgEJQ4c5
         tVuDgtkcZUw1pUawPj2wupbIlL/noe5AYE2CHM7E0rKnye5waqjP/HxuCyT9FwuCnpK2
         xsMGqznycLaxDy5IQwMEQWsmr+IyiRLbLY0HGQDcchsthrw8OOApWaGgBVIrBl4JiXAj
         2/vaEs0dJJXrLC+rjpwDoOFI8FYSXTIWoUMrh6rMex8x0zFj05tukxn4PUD+cmQSsaMr
         JozTSLpuTmfQepoKzpTN39+u5OADe14u/40UVQWLBl4P62b8cwQ7VuhzncUvLB52PfFk
         c7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=6GFJ7ancB1plEhfgVzWZYVl+G7Gv/ojaNkdikZ/2jZg=;
        b=6PDTFX4/ZZ8sDNnhRWodvxoRYQMErWngFJqA8FVymPcVoNp5XnUw5PMAKZ6XaPFVBF
         Cyor/jGCtKirSeDHHKbnIdTlJB4y6ZkoXm1AFaP4oeumOdVVdH+xOzWhRbVnoISgZPRs
         iu959zOkBcON3aEMAM8tuzaUNILd90/9sKVnyyqvjxRFf50CYKrHvyXNek6XCZkudxUV
         IlTnN8CvCR+7G6yV7Rie4pKhiWqcGj0WIHHOPSviV5k9vi5TmaOuiaROzKCT3Afk8A8I
         1pqRDiosG31s6atga04dhF+2WEYE7ine49fprWndLISKm0k8dLNscoCTamXX++t9Pl2L
         8aRw==
X-Gm-Message-State: AOAM532Trbe/0CU+sTeBMl1GMRTKG3V0UTiFAEQn+nrMeeH04BjicMsk
        xWMfCY0OPzC6zOS4pmeosYcWim/ELm1pTw==
X-Google-Smtp-Source: ABdhPJxkS2ERSmOVuz2DI45w4YukiucqyQOcslY68QODGIq7pyctREMo4NgaLnq/arb34R/RiBevjA==
X-Received: by 2002:a05:600c:5029:b0:38c:9768:b4c with SMTP id n41-20020a05600c502900b0038c97680b4cmr19962707wmr.123.1648397486308;
        Sun, 27 Mar 2022 09:11:26 -0700 (PDT)
Received: from localhost (82-65-169-74.subs.proxad.net. [82.65.169.74])
        by smtp.gmail.com with ESMTPSA id v8-20020a1cf708000000b0034d7b5f2da0sm9633355wmh.33.2022.03.27.09.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 09:11:25 -0700 (PDT)
References: <1jk0cf6480.fsf@starbuckisacylon.baylibre.com>
 <20220327130801.15631-1-xiam0nd.tong@gmail.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     alsa-devel@alsa-project.org, broonie@kernel.org,
        khilman@baylibre.com, lgirdwood@gmail.com,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        martin.blumenstingl@googlemail.com, narmstrong@baylibre.com,
        perex@perex.cz, stable@vger.kernel.org, tiwai@suse.com
Subject: Re: [PATCH] soc: meson: fix a missing check on list iterator
Date:   Sun, 27 Mar 2022 18:05:26 +0200
In-reply-to: <20220327130801.15631-1-xiam0nd.tong@gmail.com>
Message-ID: <1j35j374us.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Sun 27 Mar 2022 at 21:08, Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:

> On Sun, 27 Mar 2022 13:03:14 +0200, Jerome Brunet <jbrunet@baylibre.com> wrote:
>> On Sun 27 Mar 2022 at 16:18, Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
>> 
>> > The bug is here:
>> > 	*dai_name = dai->driver->name;
>> >
>> > For for_each_component_dais(), just like list_for_each_entry,
>> > the list iterator 'runtime' will point to a bogus position
>> > containing HEAD if the list is empty or no element is found.
>> > This case must be checked before any use of the iterator,
>> > otherwise it will lead to a invalid memory access.
>> >
>> > To fix the bug, just move the assignment into loop and return
>> > 0 when element is found, otherwise return -EINVAL;
>> 
>> Except we already checked that the id is valid and know an element will
>> be be found once we enter the loop. No bug here and this patch does not
>> seem necessary to me.
>
> Yea, you should be right, it is not a bug here. id already be checked before
> enter the loop:
>
> if (id < 0 || id >= component->num_dai)
>                 return -EINVAL;
>
> but if component->num_dai is not correct due to miscaculation or others reason
> and the door is reopened, this patch can avoid a invalid memory
> access.

This is a speculation which just does not hold ATM. What this patch does
is adding dead code cause the last "return -EINVAL;" will never be
reached.

This no fix nor improvement.

> Anyway,
> it is a good choice to use the list iterator only inside the loop, as linus
> suggested[1]. and we are on the way to change all these use-after-iter cases.
>
> [1]https://lore.kernel.org/lkml/20220217184829.1991035-1-jakobkoschel@gmail.com/

You can make improvements as long as the code is kept clean an
maintainable. Dead code is not OK.
