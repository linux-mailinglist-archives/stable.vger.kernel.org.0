Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A2746D2E8
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhLHMJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhLHMJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 07:09:29 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FF0C061746;
        Wed,  8 Dec 2021 04:05:57 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id k37so5227416lfv.3;
        Wed, 08 Dec 2021 04:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WBqTn91DshTm+EF7h4CWYhAUdvliMN1/YG7EIZemZ/A=;
        b=hC7KXTCq18inK8j/wksZ8jk/R0Jn1EVYKEjxi8PhAlPDhDWvamWsADzhKyxUK24M7r
         64AnzN9j+c3KdoF24P/p0+2fNjgiEtiL2j7l2Yhkpkkj5S8vO0Pq5g5HrHrFT9JngQ5O
         W6TMzBmSxZAfBjetJMD+jcape9iTT1TRtdfPzSWY6Gz3GTG2w173DwOGi3Srg1/ZoFGg
         jCBfyxbpbDapehEblZJN+AhuYjdDmxRvH82LV5pr/CoVX2leC03F2Hmqpimt3ZZTT7Eh
         g2w2P+OvDKPxFHjEmb2B3NYdedix4iF3t2OSi5buom7RX1Fk14htuGrAKbALtzc4klOO
         jEdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WBqTn91DshTm+EF7h4CWYhAUdvliMN1/YG7EIZemZ/A=;
        b=2FURFxspTjDK6bjS44wDbwGM+uXBc+ctF1mWk/AFyl89sBZdRJIRaJ00btyktNpAH+
         3nWtE4etSNI9cdBR+3fmT779OhDJbRtelRRVKyXGd8C0UvCaZYtbnOBIwriMhycBOUxy
         CzffiSkcoIxswTxBQTB+GeAW2Ptr9AQJiqfDQ8Y9Q7KdELz8hPg3WI008Kxz1xNJ0Vqi
         aWJ4qRynLZc9xcDFycjtaB/f37kWBpKM1yOTlgZJHc7tsVrMuZiL8GWjucL7Q3spKNdY
         Gz1/KR2kwwwwLc5qetFyNDgRf2FkK8YFy7nfTVpZpPw1nnUJGn9xUfP+OtlYVUTeuKV+
         6lbA==
X-Gm-Message-State: AOAM533Asuk3DLYjvz4eIYPXbX4xMhL6vZjAJ1H3UNnCorfIBJx5Ur2g
        eDOj+D1rYSNTAw3GngzTweU=
X-Google-Smtp-Source: ABdhPJwRAoidBQuHR+uavIg6rJVFE4uuyU2sNZRE3wZOa/3r0nA9fKFSbBYkuJLzyDryl1L7J2lJwA==
X-Received: by 2002:ac2:4e98:: with SMTP id o24mr37516701lfr.639.1638965155879;
        Wed, 08 Dec 2021 04:05:55 -0800 (PST)
Received: from [192.168.2.145] (94-29-46-111.dynamic.spd-mgts.ru. [94.29.46.111])
        by smtp.googlemail.com with ESMTPSA id j20sm269214lfh.190.2021.12.08.04.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 04:05:55 -0800 (PST)
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, thierry.reding@gmail.com,
        perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>, robh+dt@kernel.org
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
 <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
 <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
 <5d441571-c1c2-5433-729f-86d6396c2853@gmail.com>
 <f32cde65-63dc-67f8-ded8-b58ea5e89f4e@nvidia.com>
 <95cc7efa-251c-690b-9afa-53ee9e052c34@gmail.com>
 <148fba18-5d14-d342-0eb9-4ff224cc58ad@nvidia.com>
 <3b0de739-7866-3886-be9c-a853c746f8b7@gmail.com>
 <73d04377-9898-930b-09db-bb6c4b3eb90a@nvidia.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <ad388f5e-6f60-cf78-8510-87aec8524e33@gmail.com>
Date:   Wed, 8 Dec 2021 15:05:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <73d04377-9898-930b-09db-bb6c4b3eb90a@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

08.12.2021 08:22, Sameer Pujar пишет:
> 
> 
> On 12/7/2021 11:32 PM, Dmitry Osipenko wrote
>> If display is already active, then shared power domain is already
>> ungated.
> 
> If display is already active, then shared power domain is already
> ungated. HDA reset is already applied during this ungate. In other
> words, HDA would be reset as well when display ungates power-domain.

Now, if you'll reload the HDA driver module while display is active,
you'll get a different reset behaviour. HDA hardware will be reset on
pre-T186, on T186+ it won't be reset.

Please make v2 using devm_reset_control_bulk_get_exclusive(), skipping
the non-existent reset, or move the workaround to the BPMP driver like I
suggested in the other reply.
