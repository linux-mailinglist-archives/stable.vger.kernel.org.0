Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092B1261EC6
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgIHTzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732480AbgIHTzN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 15:55:13 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909CBC061755
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 12:55:13 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id w1so330016edr.3
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 12:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qyyoit1klEBl04XmzBDYSuFu0B8oH25yDBH/PKvgEzU=;
        b=JM1teX8y1L/bp3ig5jMNwEX1U9kAVue9D0LgzT9QQNL4iwKtHw3PdxCnmMSbPiKBwU
         EI1/sf+0QrTFUHFgP8ItN3y58UIYw9lLJXknJ7SwssKi22lZwvxuc4RqRg/vbt9Jxqbk
         pgZgVRFy/4cll1LwZvFKCp9wUQhLYDxuOoRrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qyyoit1klEBl04XmzBDYSuFu0B8oH25yDBH/PKvgEzU=;
        b=HfjsaknaHd4AJ/wcekzkpt85m54I9ec8JsZ4SSfrNM20Kkk5BPaA0D55eBl6vi/OdL
         LQAB01H37OXDJHKVw9Q4OzJWoGyA8midibJfI8MX5zDuTzzLr8Z8SxneSLm1Tpq1/mi3
         dZ6SbiEaZcaDlc09UUQOB9sPTAAnORz6gUXv3F5a6XCBAFoS6zEql4pkcUQjrf1yYaen
         Z5YXutSdx3poyjfOiFnepT/yx2GapOC1dD3pZszIDTSnXYh/pPxpcxRk3+NffBoxVJWb
         kGvGHbhFg1V9e6dm0HoZAltbMbxMAVeW0jC4E9XqwvwNICdkBfAhEL5xcDEmzHgj7Zfo
         zbQg==
X-Gm-Message-State: AOAM531lQD6JfJBbfHk/KDn3/OBFT6xN4BA26/4pLxyVP5j7ReYBmafA
        VHq4pJoobbvX1UrDmkILByy7vxf9cVVm0Q==
X-Google-Smtp-Source: ABdhPJzz0UYPI1XPGcUS9CSh+WwqS8k6vMVvpc/OqwLubHuQoFFc0wFytge9cZ1spdYcgnMoSs5ApA==
X-Received: by 2002:aa7:c98d:: with SMTP id c13mr695137edt.199.1599594911915;
        Tue, 08 Sep 2020 12:55:11 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id i3sm262670edn.55.2020.09.08.12.55.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 12:55:11 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id z23so90023ejr.13
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 12:55:11 -0700 (PDT)
X-Received: by 2002:a17:906:4101:: with SMTP id j1mr49953ejk.473.1599594910694;
 Tue, 08 Sep 2020 12:55:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200908152229.689878733@linuxfoundation.org> <20200908152231.250461330@linuxfoundation.org>
 <CAHQZ30B5JzOwUhiyLsbbYpFJdWQeH6vR3Ze-Gtr5-BCnw1AVBw@mail.gmail.com> <20200908173542.GA220950@kroah.com>
In-Reply-To: <20200908173542.GA220950@kroah.com>
From:   Raul Rangel <rrangel@chromium.org>
Date:   Tue, 8 Sep 2020 13:54:59 -0600
X-Gmail-Original-Message-ID: <CAHQZ30C8eQ7tq7LteFpz5BQFdtgEeJAdz9FxbqKk8pr+vcRFMA@mail.gmail.com>
Message-ID: <CAHQZ30C8eQ7tq7LteFpz5BQFdtgEeJAdz9FxbqKk8pr+vcRFMA@mail.gmail.com>
Subject: Re: [PATCH 5.4 031/129] mmc: sdhci-acpi: Fix HS400 tuning for AMDI0040
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> >
> > Should we pull that in too, or is it fine to wait for the next merge?
>
> It depends on wha tyou want to do.  I can drop this now and add both
> later, or just be "bug compatible" with Linus's tree until this patch
> gets merged into it, and then I can take it.
>
> Your call...
>
The patch got pulled into a few branches, so not sure how easy it is
to drop it from all of them. I guess let's just leave it and be "bug
compatible".

Thanks,
Raul
