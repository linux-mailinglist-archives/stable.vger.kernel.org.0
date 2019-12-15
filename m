Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB2611FBA7
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 23:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfLOWNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 17:13:48 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:41328 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfLOWNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 17:13:48 -0500
Received: by mail-pg1-f169.google.com with SMTP id x8so2527590pgk.8
        for <stable@vger.kernel.org>; Sun, 15 Dec 2019 14:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B3pJODeYlvkw6x9w1gXyVOilRHRZ3AjydpBMm26uujY=;
        b=y59nXGPf3gM79fiFIRdimNmtiBdon65lqg0dyJYa3lF8kH4Du95gsQrHd8kJjNF9y1
         a7IgcI7uJpeRGK8gTbG7NUs9rp5oa0StQhxpZmRUdoHFhGHUiQOjfRUVII2N2vr63Gxb
         hdNRBIDrIskjt001GiIlPv88IlX3TbJna8UpsH6HangQzwbsehz3PC/+iYpA2NCDWYRY
         5yI2gIAU+b8Bfb/B57MqUWwFyCdR/218R/qZ2lZbAM5SI3KZ5AWu07EdADhHGVHkcqL/
         ma67i47nJOmQB68zjQApwyS0/Tn/xw7aGqzU6U5iGpeuqnKmHr40kT3yJqyvGNC/p0jW
         Tzzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B3pJODeYlvkw6x9w1gXyVOilRHRZ3AjydpBMm26uujY=;
        b=e75H8ZzfHGPQNkIc96VUaxNQWGl6Or7y+zKCLzuncynT8WvyLKe+Btr20Bjpz+tt1X
         veYTvYQ/KWIfmZsoyE3u+Q4mLA/jAcRK9iMLz5vDnmh7jScW5BuFdT4zoJNUF1RJMCTJ
         Rxt0XGwqXxcQbENLr3YYyzja6+8ojJ0rJMAdmBiRgQmB1cDYcY/wYQsD8CfjiTdCZxgX
         izMGLoOTL+7V2iVHjt0/3yfAzniKakuQJG1gpUqF+ItjjcUlnOMkumoUjIQYaV5IowUr
         96UDt/otODplCWERMehSWZz4+dN/l3ljd20fgRX+eqQh2qXiaCYnFL5SQ6xGX1rtvFuU
         XkIQ==
X-Gm-Message-State: APjAAAXjk+7tjZwVXEoO4NKJGtK+DIqCrWva+aK7lUcboo3KKVZz7zuM
        5XftOGRTBI2afJ378uNswVxciS1xzbI=
X-Google-Smtp-Source: APXvYqyTfzQOTcYlWy+rqvFJ/HqgyOE+iZCl4xThcXJy2lDLG8fIHjmfuQ3wini8X232kAU0bi6BFQ==
X-Received: by 2002:a63:dc41:: with SMTP id f1mr14791000pgj.119.1576448027310;
        Sun, 15 Dec 2019 14:13:47 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1133::1117? ([2620:10d:c090:180::1d25])
        by smtp.gmail.com with ESMTPSA id s1sm2598601pgv.87.2019.12.15.14.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2019 14:13:46 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] io_uring: allow unbreakable links" failed
 to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org, asml.silence@gmail.com,
        carter.li@eoitek.com
Cc:     stable@vger.kernel.org
References: <15764077414946@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6f68d1db-127c-522e-dd83-8a0d6c2529fd@kernel.dk>
Date:   Sun, 15 Dec 2019 15:13:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <15764077414946@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/19 4:02 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Might just be better to drop this from the 5.4 pile, unless Pavel
is motivated to backport it. Even if it throws a lot of rejects, most
of the hunks are trivial. Only one that requires a bit of thinking is
the one that deals with link issue.

-- 
Jens Axboe

