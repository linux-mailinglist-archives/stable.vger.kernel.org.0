Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD31217FE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbfLPSC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:02:26 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38808 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729086AbfLPSCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 13:02:24 -0500
Received: by mail-qk1-f195.google.com with SMTP id k6so3622581qki.5;
        Mon, 16 Dec 2019 10:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/wgIjX1dU2wQH6kmt/wxBh8DEI9OC0fPRFaMU5c+19U=;
        b=aK5FHjDX78JdmIlmY7UGSEKLyK+plDswCHD9EfXisDUKQelP/XMkWce0lfrZkZUJyg
         3UC66szQcE7PNLgccwlf59/DU2/S88c323rKOwvOimcYvXbcQq3jftigRUrw3yGgwfKO
         aK6zJH123/LmhoYyEpo/YBOtBw4tmQhG00QBrrosLUg83ENlpU3hsJBrdo7YfPPYJKzB
         zmIwmJUdhuBtX5+FYq/fg1mUZGgxJGJK/0qoZBbGbdyukYxJ2vaDyRkd7nNJYGx5UO3y
         zcmoJ9rieShg9yFWklosDfWp4SLtbQW1n5szZ8uNw2Cd9Rlq5mgoro/6us+dNZ2+H2RM
         uB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/wgIjX1dU2wQH6kmt/wxBh8DEI9OC0fPRFaMU5c+19U=;
        b=E6XaYTUysM5GJojTbuA+SSAwMQN0i4HyRW/8LPgUr/oDDWI4Xh9ylRY5013KekdVB1
         8fy+JfmKfwNHAsQrYwQx0OJHUIV/9LNdUJ7i6TCb2SnmS7U5I/ClWosgrHD2FZYFkRfP
         XFUzcAFvMjGtDfQDPN83LA+K9X+XO44wpcg4GATF0rm4akiH9SjBsa1KcisyKjSjwkLb
         3X97L/8Mtf7kNmMPCTHbReBYLrQUkjc2aCtxgT1jIrjFRq3Jio3Xix6R82ZVpSej0x/t
         obqBEMEGsT5Duwdq4mImp5bvRCi/0fmXp7A43pWVv6+7KXdaVZnbAe4k5+O5q0lMfckT
         r4zQ==
X-Gm-Message-State: APjAAAXFxLeM4cOCowm1L0fn06JQNqOIDX5ZmJOCosRZoFl0fCPZ8QdB
        BguEtTdcR59cyncOYsmuzWc=
X-Google-Smtp-Source: APXvYqzdu1sTCj4NZqYSRC6slwAaJGOIFip0P2vewuNZ7htej3nWePVTXo/8UzTYLV9SDoAn/6Sq9A==
X-Received: by 2002:a37:9f94:: with SMTP id i142mr582854qke.244.1576519343375;
        Mon, 16 Dec 2019 10:02:23 -0800 (PST)
Received: from iclxps (c-73-129-26-117.hsd1.md.comcast.net. [73.129.26.117])
        by smtp.gmail.com with ESMTPSA id r41sm7101996qtc.6.2019.12.16.10.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 10:02:22 -0800 (PST)
Message-ID: <2e689322e9c07a062454eed51b318d4c0b29799c.camel@gmail.com>
Subject: Re: [PATCH v5 2/4] lib: devres: add a helper function for ioremap_uc
From:   Tuowen Zhao <ztuowen@gmail.com>
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        mika.westerberg@linux.intel.com, stable@vger.kernel.org,
        linux@roeck-us.net
Date:   Mon, 16 Dec 2019 13:02:21 -0500
In-Reply-To: <20191216130634.GA1563846@kroah.com>
References: <20191016210629.1005086-3-ztuowen@gmail.com>
         <20191017143144.9985421848@mail.kernel.org>
         <b113dd8da86934acc90859dc592e0234fa88cfdc.camel@gmail.com>
         <20191018164738.GY31224@sasha-vm>
         <7eb0ed7d51b53f7d720a78d9b959c462adb850d4.camel@gmail.com>
         <20191216130634.GA1563846@kroah.com>
Content-Type: text/plain
User-Agent: Evolution 3.34.2 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks, sorry for the trouble.

Tuowen

