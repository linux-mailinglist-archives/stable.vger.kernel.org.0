Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 525C6149ABA
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 14:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgAZNVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 08:21:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35259 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726275AbgAZNVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 08:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580044877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jsfHSZG1zHv4p6C/vlcY9hc5HBtWKr/hh4heHf9QvrI=;
        b=SOJ528lynIyJZyGBcZVmytL5O58a1vIkTC46kSTb388zOoaZaKnD3xXufrblNM7VwyQA0K
        ndE0EO3AtWUtwEjG1Bho1cQHb2UaiHvH48Tz//fTykk3Xb4eirQLI5mL9mdct13POjF4Gu
        0rvCywM62M97tVIdsxA4OfREcSNwaco=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-rblMxaM2MRmNvgRrbJ31uw-1; Sun, 26 Jan 2020 08:21:15 -0500
X-MC-Unique: rblMxaM2MRmNvgRrbJ31uw-1
Received: by mail-wm1-f70.google.com with SMTP id s25so669742wmj.3
        for <stable@vger.kernel.org>; Sun, 26 Jan 2020 05:21:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jsfHSZG1zHv4p6C/vlcY9hc5HBtWKr/hh4heHf9QvrI=;
        b=YLc1HOwym74ESS4tJOhDZzkVbNkn6F7mdq939MlKufpVSb9U/A2Ndv8q8gAIcUYkAN
         5nvqRinpAHZatTVHWujX7bdpMaYPnUhqzH+BLwdnuxxRaxrdIjmhje+eOdbG/FtRiVJV
         eUM0YK7VRpSUVsCAeR/umZ6q2IfauK//oUYUWOiTRtrwC5eFPuqaLfvPB4SOqNW793kF
         YeiBR3MK/CdOIiZbRI/kDh34cxVu7qQLY/a8Hn6gYGN/kZawliEUa2KGfxmafHzNiZpr
         2UxO2NHdWVgOa6b6BWbkbUDp9LhAy9Ws1o7vtIN7hmf46NpKUYBdynvrOvJ7lvPmUUWS
         lDHQ==
X-Gm-Message-State: APjAAAXfTCPAD2+QzVSmVGSWF0rB7sHk7wFlgfS3VuYS7uPLev88ENqY
        OSHHeWN95mHRnOUdnLVMYTlfzKwF7lg6y2EwDtGTixr04Rtc3y3jVRH0hb8Y5kUJ0eHnLpS5ZNf
        yxxOqd0dPr+cW5NE5
X-Received: by 2002:a5d:438c:: with SMTP id i12mr15170247wrq.196.1580044873750;
        Sun, 26 Jan 2020 05:21:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqwOLjBhFohwN74d32YNsRXrTSPDHEUg9f7VcJVfW0oQG9NOzzjXvBJ78yjkvgoTpZKr+CrySw==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr15170229wrq.196.1580044873506;
        Sun, 26 Jan 2020 05:21:13 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id x18sm16447490wrr.75.2020.01.26.05.21.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 05:21:12 -0800 (PST)
Subject: Re: [PATCH] ALSA: hda: Add Clevo W65_67SB the power_save blacklist
To:     Sasha Levin <sashal@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        Jaroslav Kysela <perex@perex.cz>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org
References: <20200125181021.70446-1-hdegoede@redhat.com>
 <20200126013827.72B4D20709@mail.kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <9c716170-f021-9f42-12ff-36afd4e9bc0c@redhat.com>
Date:   Sun, 26 Jan 2020 14:21:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200126013827.72B4D20709@mail.kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 26-01-2020 02:38, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.4.14, v4.19.98, v4.14.167, v4.9.211, v4.4.211.
> 
> v5.4.14: Build OK!
> v4.19.98: Build OK!
> v4.14.167: Failed to apply! Possible dependencies:
>      38d9c12c0a6d ("ALSA: hda: Add Gigabyte P55A-UD3 and Z87-D3HP to the power_save blacklist")
>      5cb6b5fc013e ("ALSA: hda: Add 2 more models to the power_save blacklist")
>      b529ef2464ad ("ALSA: hda: Add Clevo W35xSS_370SS to the power_save blacklist")
>      dd6dd5365404 ("ALSA: hda: Add Intel NUC7i3BNB to the power_save blacklist")
>      f91f1806530d ("ALSA: hda: Add Intel NUC5i7RY to the power_save blacklist")
> 
> v4.9.211: Failed to apply! Possible dependencies:
>      38d9c12c0a6d ("ALSA: hda: Add Gigabyte P55A-UD3 and Z87-D3HP to the power_save blacklist")
>      5cb6b5fc013e ("ALSA: hda: Add 2 more models to the power_save blacklist")
>      b529ef2464ad ("ALSA: hda: Add Clevo W35xSS_370SS to the power_save blacklist")
>      dd6dd5365404 ("ALSA: hda: Add Intel NUC7i3BNB to the power_save blacklist")
>      f91f1806530d ("ALSA: hda: Add Intel NUC5i7RY to the power_save blacklist")
> 
> v4.4.211: Failed to apply! Possible dependencies:
>      38d9c12c0a6d ("ALSA: hda: Add Gigabyte P55A-UD3 and Z87-D3HP to the power_save blacklist")
>      5cb6b5fc013e ("ALSA: hda: Add 2 more models to the power_save blacklist")
>      b529ef2464ad ("ALSA: hda: Add Clevo W35xSS_370SS to the power_save blacklist")
>      dd6dd5365404 ("ALSA: hda: Add Intel NUC7i3BNB to the power_save blacklist")
>      f91f1806530d ("ALSA: hda: Add Intel NUC5i7RY to the power_save blacklist")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Just adding it to 4.19.98 and 5.4 (and 5.5) is fine.
Regards,

Hans

