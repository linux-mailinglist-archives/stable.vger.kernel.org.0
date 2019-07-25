Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A19274A11
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 11:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfGYJiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 05:38:08 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45096 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGYJiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 05:38:08 -0400
Received: by mail-ed1-f67.google.com with SMTP id x19so43699260eda.12
        for <stable@vger.kernel.org>; Thu, 25 Jul 2019 02:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v3yV3pd1s8RaXICkrukozs+VRYmxmtUuo0nvuua3Zyc=;
        b=W16Xpfd66fQ9aH2cDrVq11rLsn1LBTndcedKC4fPUGebhftFWwKzXahIF6iZFKu/8W
         mamLNmotmoL+vj2ILKuejF8Ee8Ojaj+rXNVa99fpLHSCmoXXYBaSHuTjscYZvpsjK/O2
         tIgT5PMmzMZrCGjEf7Hj58Y1vvoWAWbhdoRXY1UDo51GszJWOESPevMH34ADthbgb1/s
         PX6zoR7ENWdLTqPG9aZzlHIFTAU1dm2E/636gkfcEhtJr0xpjaLi2ptjhBQeVdCGvUyJ
         B89YCbCei0yMRpowJKNgB+IZ6BCtgu2WcTouCT+0e1LiBIYMcEOcQvCfBX0S9oehzxGZ
         ia/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=v3yV3pd1s8RaXICkrukozs+VRYmxmtUuo0nvuua3Zyc=;
        b=l7aKrglCknK9IiGBWv0LVyJsgllL7wjfheh7CH0sKCynf6VvTrdA0GhGUGhD7mZ1mp
         n8ryRjl9u0FZzlbCubOsIYKqH3f2jVJIr6ucmu6ulVOa1L4fpeP8nesb2h2Q9KnqxQ7Z
         bS3WnOkJmQ++FnF2usFbuyb9gRlJP/kVwutkev7VAepdhsZLx/saxuA58uSFjUftGvX2
         2nO2KERFOsmNjw5bFGnVK6u2c5n9HER3a2nuMQGM7YH8QUPj1/M6l0RgTGli5y9CuNSw
         1XwzCevinc04gVV2uQKIXsKoC4zJfM9+vyhyX3NnLA8KZBQlccLKDnIuBEqjFxBVKXR1
         ty6Q==
X-Gm-Message-State: APjAAAVXSZ1aifl3HNI9l+sHbTqJ4RSJwoWcBf2jnlW/fObjkIoxVc9T
        nknbrXq+8+rdh8JucctLaq4uOeCK+Se3AQ==
X-Google-Smtp-Source: APXvYqxF8iLqHAFM61CJyHx6uciBUODsRS7Ix23TQnIfRMBZC/Acy9WVsZu224vXe3+g/48u9zrgiQ==
X-Received: by 2002:a50:cd91:: with SMTP id p17mr77081440edi.35.1564047485848;
        Thu, 25 Jul 2019 02:38:05 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (hag0-main.tessares.net. [87.98.252.165])
        by smtp.gmail.com with ESMTPSA id w24sm13701420edb.90.2019.07.25.02.38.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 02:38:05 -0700 (PDT)
Subject: Re: [PATCH 0/3] Backport request for v4.14 to fix KASAN issues
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, asmadeus@codewreck.org
References: <20190724205557.30913-1-matthieu.baerts@tessares.net>
 <20190725041818.GB4099@sasha-vm>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Openpgp: preference=signencrypt
Autocrypt: addr=matthieu.baerts@tessares.net; keydata=
 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
 fQpO7wDE/Q==
Message-ID: <7f6ec725-862a-230e-bfff-a6e9d303715c@tessares.net>
Date:   Thu, 25 Jul 2019 11:38:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725041818.GB4099@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

Thank you for your reply!

On 25/07/2019 06:18, Sasha Levin wrote:
> On Wed, Jul 24, 2019 at 10:55:54PM +0200, Matthieu Baerts wrote:

(...)

>> Could it then be possible to also backport these three commits please?
> 
> Matthieu, Dominique,
> 
> Thank you for chasing this down. I've queued these commits for 4.14 and
> 4.9.
Thank you for having queued these commits for 4.14 and 4.9!

>> The three commits apply without any issues. I followed the documention
>> to propose these three commits to stable, the Option 3.
>> Just for me for next time: is it easier for you to propose the patches
>> like I did or to only mention the SHA from Linus GIT tree?
> 
> Unless you have to modify the commits to backport them, just listing
> the hashes is preferred.

Good to know. I will do that next time!

Cheers,
Matt
-- 
Matthieu Baerts | R&D Engineer
matthieu.baerts@tessares.net
Tessares SA | Hybrid Access Solutions
www.tessares.net
1 Avenue Jean Monnet, 1348 Louvain-la-Neuve, Belgium
