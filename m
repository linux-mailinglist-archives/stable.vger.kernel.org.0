Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C674261E
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 14:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409117AbfFLMk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 08:40:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46386 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408385AbfFLMk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 08:40:56 -0400
Received: from mail-wr1-f70.google.com ([209.85.221.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hb2Yg-0006O8-Jb
        for stable@vger.kernel.org; Wed, 12 Jun 2019 12:40:54 +0000
Received: by mail-wr1-f70.google.com with SMTP id b14so7318885wrn.8
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 05:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VrK+5w6wVdk7h4HwgR7kIxMZIIwMUW/I2VBxJs4ejPI=;
        b=CZgF61yw28q4yvq1mjZ/y+XNR6ARBkm6M7JX+xiNTXzaF4WOaLfJs9oUpeb1pgajCO
         fmNbqlgsX7Ui+ccS6MvU+A4I0335//5hLyWtV6YP0TSvf0AXKUw/21dA0Mibj38nUn85
         kmUu1n6t/XIoen7HoPafXwZ2x12EFsgBwmejruDImUKXIEyQiBL4/jUTNl0vtTzusRnm
         oNT36PhCfSgm4/R3NSh0r8gFgdA5FAZwfEQvwdh3+LoSsIuOhJV84G5Tw5P366epMdlk
         15AU4Md8/fBrzkwUjK6qp79u21AihwnXu8ii7Af2F/fGk3Y5OjlTZA4r/f+P4o0zZei8
         S8fw==
X-Gm-Message-State: APjAAAWbk9hQXTbIt+uefunaLiVx+fQMXlOTKcCj3HvvFOJYys2NOU9U
        +uyjKNfBtc2d+Q+MICGjwDDWGguY84rCRl/SHoSFX/WZyCc8j/Gko30V5ZQMcFfskF331XJKqGw
        3/SzxDDyG3Aaqin4xtHUSmEj3gkuvL8jrrzhTAR5rBaIsmMGoUA==
X-Received: by 2002:a5d:53d2:: with SMTP id a18mr4871540wrw.98.1560343253834;
        Wed, 12 Jun 2019 05:40:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyBvfuiEuBGRitbfJWHXkAkAE1jkdz65wRyMFsexu514qahpb7YWU71NUv1iIYi0hX0WSYub+LVT8liks8ZR0A=
X-Received: by 2002:a5d:53d2:: with SMTP id a18mr4871531wrw.98.1560343253700;
 Wed, 12 Jun 2019 05:40:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190523172345.1861077-1-songliubraving@fb.com> <20190523172345.1861077-2-songliubraving@fb.com>
In-Reply-To: <20190523172345.1861077-2-songliubraving@fb.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Wed, 12 Jun 2019 09:40:17 -0300
Message-ID: <CAHD1Q_wraiFkLP72pFfGhON+KZe7yo3ktXvsAA40QVcXvzviSA@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org
Cc:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg and Sasha, is there any news about these patches?
Just checked the stable branches 5.1.y and 5.0.y, they seem not merged.

If there's anything pending from my side, let me know.
Thanks in advance,


Guilherme
