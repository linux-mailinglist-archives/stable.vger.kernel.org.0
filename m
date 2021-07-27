Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56AF3D7D14
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhG0SIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhG0SH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:07:59 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914C0C061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 11:07:58 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z2so23293045lft.1
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 11:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/6k/5QHobf00b93ney5coTP2oEWGEUkiUXBaA9fLFlw=;
        b=LriaWcROb7uhzBmWNoOoupBdKrO2xo2ZCAWIXGH0YUW/+owRG18c9R1XYVVY//mEjt
         LpC1afbBjLeohhPBnMKMlA0CN43nc+Xv7AbWnNiHeXK6laBfAV6++fqvaETth2OmvriY
         JjLkHKxThPmdRqH9e8N1p+QCmOaaFNH5o82bOGRXZLnLSjAkTMg+Y9SQTZnU/Z7Y0fpp
         VuP+LunpGmTPtYuOvp15JyJsfa9M0EByFu1rNFw4Eh7kXWdpEg/zPNa0DlH6Stg/gLF+
         3JVl7ZGxFH2ZJ9Km3oKz7kAk9tESZhJI6WygZlYWgCBJGIMFVSKy3agtN0PRqvY5Bmqw
         MKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/6k/5QHobf00b93ney5coTP2oEWGEUkiUXBaA9fLFlw=;
        b=SuWmVJCz/uZSv+3E8N9RVAJkcByTvjn3PrbBe09WnJS8AOxmJb09to/gYB3lOJq0mA
         Z60B6hBbVE1D8fzTYFs+KbLpQSN2GwZn6TgkzkC//Q7p+Dd+6qdfgb4+JV1cY5Km7YlU
         hrQxM7HuUYWuFa7eGrFhYqH3fQWEnqimmcpqzhkdG1XUD1T7LveK6QCbygqgzlUuIf8v
         s2anaasHtIWXR63WoozVzwqkC+mwK9EckAlsj1CjSPLxX5NcZo4rOMmfk/apA/JAOfO3
         7E48dYwbrHv1vJ3Deqfxma/88PcqRryGALFJc3FF2MXFvXdGVLZoe2RYuYAKGGFY/5FB
         AP9Q==
X-Gm-Message-State: AOAM533XpyAEb4VvuhWPBn/DIohtxglxGloKY3zkWM9FF9ypqHhrRkYN
        VeWrSdXPgi2i8TJRn5SXHmM=
X-Google-Smtp-Source: ABdhPJwaDqpK92d+gE4FOxwBL8fD33HG+AHkImY9mLTfbiw5Keu0435yNMl0nO8JzatJKc9MN/9DoQ==
X-Received: by 2002:ac2:4341:: with SMTP id o1mr12478987lfl.360.1627409277022;
        Tue, 27 Jul 2021 11:07:57 -0700 (PDT)
Received: from reki (broadband-95-84-198-152.ip.moscow.rt.ru. [95.84.198.152])
        by smtp.gmail.com with ESMTPSA id s10sm335515ljp.80.2021.07.27.11.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:07:56 -0700 (PDT)
Date:   Tue, 27 Jul 2021 21:07:54 +0300
From:   Maxim Devaev <mdevaev@gmail.com>
To:     <gregkh@linuxfoundation.org>
Cc:     balbi@kernel.org, stable@vger.kernel.org
Subject: Re: patch "usb: gadget: f_hid: added GET_IDLE and SET_IDLE
 handlers" added to usb-linus
Message-ID: <20210727210754.20af2cda@reki>
In-Reply-To: <1627394158704@kroah.com>
References: <1627394158704@kroah.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> <gregkh@linuxfoundation.org> wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers
> 
> to my usb git tree which can be found at
> +		hidg->idle = value;

Please use the second version of the patch from the thread.
During the discussion, we found out that value should be shifted 8 bits to the right.

https://www.spinics.net/lists/linux-usb/msg214841.html
