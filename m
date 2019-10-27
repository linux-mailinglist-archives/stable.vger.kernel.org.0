Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D452CE64F4
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 19:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfJ0S6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 14:58:19 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:41201 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbfJ0S6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 14:58:19 -0400
Received: by mail-pl1-f178.google.com with SMTP id t10so4216793plr.8
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 11:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cJU5imAEZyt4+q1gm4tVRCDcsVbPsmJmiOQ/UuC7BEs=;
        b=oqB8HYyh7fGQ1g9I62jgen6Dd1qqZR+57YRyLH44EAu7ZTiAIskmsMnw2vBVDmrfam
         RkRTqyAfQbynL6VGKbRCKoF0biiWT9WdCzVVYwTAS3KmLtIP/7EVPv4ubz09HbeeUM/v
         luBIk4CQ2wTdQrV489kqxmab4AyKMWp2vZSq1T/V05qzMxGfFbW7apEwaK27/L91MROV
         AwRo2/Bd0bXcZsLJd9Slmff+pzuQMc68aYyjlQXwP7gxivYrQAlHbpI8kS7kLadu8BgU
         P0wKDBienPBmUDQoeovMW36kADSyz36FgFYI/1JtVmLjrIIOK+b8CCxpRGYFEnuIXgN7
         a9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cJU5imAEZyt4+q1gm4tVRCDcsVbPsmJmiOQ/UuC7BEs=;
        b=XuAzfCruBtGvb2X+MXyRj/6TPeWmDu1+j9sgq9u7GVkAZspJblqmqrH+2+BHOXdDKS
         25YYRjouO9F7BcPan1IYG8AHWiEvICyBWWbW99Ugv0NiGK3gKPzhrgVtG5HpQCEQpqZe
         AT+M8LWIv7T1vrksowbS6ON8wPLQNG6sFPIvmfyfJuTr+VCnV+c0XR1WnUOOB8wssHAn
         i6RV4lhbpp15ZKhOlH3CMbYoc33QWc3Ge76f8h1uZjE+hRWcznVK3j93MPMoqCVOXirO
         kvstW4naczyVaRnCjbe1T4YPUER4Z9O3y9MLkPXTz6OiT9rzNsb7VO7PG0MZ34jAbPAl
         2xIw==
X-Gm-Message-State: APjAAAUQ9Alwmw+ZARaLm7rDvGtO135V4bK6yE7llt2brR+cm8hXbc55
        vSlE0CvGtirQom23UZVxkeq+EYPO8oAWxg==
X-Google-Smtp-Source: APXvYqyStzRB6Iwo/Js25G7vc3lDp+d23Rq+cB8Yu7OSyMdZjN7vmdQwaWA1BYFGawZorGViMfqjtw==
X-Received: by 2002:a17:902:d915:: with SMTP id c21mr15237028plz.264.1572202697517;
        Sun, 27 Oct 2019 11:58:17 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id v25sm8025825pfn.78.2019.10.27.11.58.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 11:58:16 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: fix up O_NONBLOCK handling for
 sockets" failed to apply to 5.3-stable tree
To:     gregkh@linuxfoundation.org, zeba.hrvoje@gmail.com
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <1572191635100175@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <da7d616b-a7e1-5cf5-5b38-75ecf8843ccb@kernel.dk>
Date:   Sun, 27 Oct 2019 12:58:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1572191635100175@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 9:53 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.3-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I can fix this up, but I probably need to see Sasha's queue first for
the io_uring patches. I need to base it against that.

-- 
Jens Axboe

