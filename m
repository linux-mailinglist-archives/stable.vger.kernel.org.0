Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36ED8421879
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 22:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236402AbhJDUhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 16:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbhJDUhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 16:37:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59155C061745;
        Mon,  4 Oct 2021 13:35:51 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j4so744392plx.4;
        Mon, 04 Oct 2021 13:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OnyVh3YM9+h5qjQ+SPARi4pkk/NFSkFftgqlwnUrr88=;
        b=XakMi6ZrByxC54yKQ2CEdJFoGoHpDcOB95rafrzHY69x51Tq5Pd05lYGJ57f2r8VIY
         AHMR6jsWiQW6oqeU6A/+xVcE6we4wHAxyMp3rxvHR/airXvj430ex94xi3cvYRXigHAb
         s8/eyssYNz/PM44KeN44qLQRpVDSOpYFyNoZJTuZsj1QgPLWWyvLgmxRrDTu5N9guLY1
         b3Bkm94yl0pg9yV8xEGp5ROZuekCAm/if3DhgfYNvVAj0TM2Z8/cf1jJ6hzH3UBWpHQ5
         buZcdNdKAyMphxFeemDZw0Hx75Y4hTnDvx0RlNWj7ft/esTQIiEUYA1DoIStROiKoh+o
         C2uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OnyVh3YM9+h5qjQ+SPARi4pkk/NFSkFftgqlwnUrr88=;
        b=Y/249M5yAh/QJ/tImdBeQkpYfVJQVqzSeU7xERQOHyGVrCUWV69PKhJS7hmusE3V9u
         6UrTMAOvV54GKci5XR8aWNAZS++XqdsfnFL/GuFvjZ643XGrfPJ7F9koOTpQ3NmvldDo
         sp66vfzn6QhfAT2KMOfGDzcTjKV8C+5Xq6srsGMQ+Q4FVx4Ghm/C/oIsO9wmTO8Fmnkk
         4YRLgq2wyxvdFnLdufy5Q9x8ytab4titAfqRuqQf20lDHV6FB1cGcp9cgpjylbHxOLmM
         zQBi2cCeoz1MVNivrHoEjJqvuW1LD4Fr4dFgzzRyXdOcTbhn5pkbd3Q6l7e7LcD6iESo
         HyEw==
X-Gm-Message-State: AOAM531XKdhPp+XKqH9zn/9GXarnKw9jPG8jzCRqgcclintujWRf89Sd
        h4u5gpDawRWDZneU1sN40Fs=
X-Google-Smtp-Source: ABdhPJykj2aLi97u20gsFG4+nhd8Nvt7pYxNEmoAcaiBbsUWrSCXxA8FDVc0g+8dNfVw1Re4Jzk8Xw==
X-Received: by 2002:a17:90a:b105:: with SMTP id z5mr38008411pjq.64.1633379750837;
        Mon, 04 Oct 2021 13:35:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s22sm5925583pfg.137.2021.10.04.13.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 13:35:50 -0700 (PDT)
Subject: Re: [PATCH 5.4 29/56] net: phy: bcm7xxx: request and manage GPHY
 clock
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
References: <20211004125030.002116402@linuxfoundation.org>
 <20211004125030.918133685@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2098a161-58c2-c3d8-0c4b-8ff0c20df934@gmail.com>
Date:   Mon, 4 Oct 2021 13:35:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211004125030.918133685@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 5:52 AM, Greg Kroah-Hartman wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> [ Upstream commit ba4ee3c053659119472135231dbef8f6880ce1fb ]
> 
> The internal Gigabit PHY on Broadcom STB chips has a digital clock which
> drives its MDIO interface among other things, the driver now requests
> and manage that clock during .probe() and .remove() accordingly.
> 
> Because the PHY driver can be probed with the clocks turned off we need
> to apply the dummy BMSR workaround during the driver probe function to
> ensure subsequent MDIO read or write towards the PHY will succeed.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this patch from the queue, this is not a bug fix for the 5.4
branch. If you would like me to send a patch for "net: phy: bcm7xxx:
Fixed indirect MMD operations", please let me know.
-- 
Florian
