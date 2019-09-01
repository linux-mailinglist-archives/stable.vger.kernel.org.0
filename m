Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A64A4B6E
	for <lists+stable@lfdr.de>; Sun,  1 Sep 2019 21:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbfIATnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Sep 2019 15:43:16 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33321 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbfIATnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Sep 2019 15:43:16 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so25229987iog.0;
        Sun, 01 Sep 2019 12:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=h/xjXgWosxdQaufj8AvjAxM/bIsZfFnrMq3dRFuLwdo=;
        b=rsad0/GCrnmZBp+UqxkKeFhd+h4i8NsbZcCGhY5zMeScdAsZb304z8Bd6RyWpB+MS/
         92TkFv+KKtGYjfzlG862KUhWmkzp6ZIOdOb3QyYGt/iU6+UeDnDjVhwxVtZ46dNl/E6K
         YiP9zUUCcH+AcbIgMkZWCkVqaXa4fkTXkCm6h8Xz1wPWQsJwoa3KNPLUnDO1OIYJn30z
         im29DPjenTE/jFCe59EygMa4COZIg5RPWN+N954jeDQE3jkc3u1h7SIwsc+wyb7OYQiR
         6r25cQwlG/MpXOOgrbSZoi2hPdnYjXeVEAYZ7h2EHyAGQPZvmW0I9fFLeP9gBCJg6Vg/
         Qkpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=h/xjXgWosxdQaufj8AvjAxM/bIsZfFnrMq3dRFuLwdo=;
        b=DZth8YDOqBbDwC3BZyWOWesx1xCV82YCdAAtXQ5F9P8VO2utx1JA3c38PC3Izu/zIf
         3lV1ZGwH0zyvOPB4BIx8tL19+wwJ3iTgrUsH6V5qWqefDEpQ3ZVQw/R35b/GUNG3SFQ2
         26t0wD6ovcIt1ByeaRURcgBTL0tkQWEyUCMalbaNkIso6iE9+N0Bx9Mlc5vup6nuotVO
         tYDwZGd0EXNWZMJTfMl1WQCKCbBe6xtpq7mHLcjAwm02TgwCrM3ArDEyZz7AA1GQTfL9
         Rp9R4o7Rt5DRGaBnaehnkNTbtOceq7OCfuD6FnJMWd/N12bvWVq+MUoqK803TuoTq+/2
         ipLQ==
X-Gm-Message-State: APjAAAUOI5RsKpFVwIdBbSOd2mnaknfvUnRJstoLzVZZs7DRlCnWIb4M
        AABRy0PNYsJRh5DuTyx4ltsgVfBMVM9FUw==
X-Google-Smtp-Source: APXvYqxGMt/XakV/ALegVpXkS8Go/WyaRTvdNdzYT5jhXUlyuq5uVic+caEkoIfyzyIn3KFzzSYw4Q==
X-Received: by 2002:a5e:9805:: with SMTP id s5mr10833814ioj.195.1567366995067;
        Sun, 01 Sep 2019 12:43:15 -0700 (PDT)
Received: from [10.164.9.36] (cos-128-210-107-27.science.purdue.edu. [128.210.107.27])
        by smtp.gmail.com with ESMTPSA id l13sm13688122iob.73.2019.09.01.12.43.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Sep 2019 12:43:14 -0700 (PDT)
Subject: Re: [PATCH 1/2] Fix an OOB bug in parse_audio_mixer_unit
To:     carnil@debian.org
Cc:     stable@vger.kernel.org, mathias.payer@nebelwelt.net,
        perex@perex.cz, tiwai@suse.com, gregkh@linuxfoundation.org,
        wang6495@umn.edu, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
References: <20190830214649.27761-1-benquike@gmail.com>
 <20190901125809.GA23334@eldamar.local>
From:   Hui Peng <benquike@gmail.com>
Message-ID: <df31a1f9-623a-aff6-fa7c-01eba3fd0f63@gmail.com>
Date:   Sun, 1 Sep 2019 15:43:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190901125809.GA23334@eldamar.local>
Content-Type: multipart/mixed;
 boundary="------------C17843906CF228CD9BE7D7BA"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------C17843906CF228CD9BE7D7BA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit


On 9/1/19 8:58 AM, Salvatore Bonaccorso wrote:
> On Fri, Aug 30, 2019 at 05:46:49PM -0400, Hui Peng wrote:
>> The `uac_mixer_unit_descriptor` shown as below is read from the
>> device side. In `parse_audio_mixer_unit`, `baSourceID` field is
>> accessed from index 0 to `bNrInPins` - 1, the current implementation
>> assumes that descriptor is always valid (the length  of descriptor
>> is no shorter than 5 + `bNrInPins`). If a descriptor read from
>> the device side is invalid, it may trigger out-of-bound memory
>> access.
>>
>> ```
>> struct uac_mixer_unit_descriptor {
>> 	__u8 bLength;
>> 	__u8 bDescriptorType;
>> 	__u8 bDescriptorSubtype;
>> 	__u8 bUnitID;
>> 	__u8 bNrInPins;
>> 	__u8 baSourceID[];
>> }
>> ```
>>
>> This patch fixes the bug by add a sanity check on the length of
>> the descriptor.
>>
>> CVE: CVE-2018-15117
> FWIW, the correct CVE id should be probably CVE-2019-15117 here.

Yes, the CVE id was wrong. I have updated it in the attached patch.

> But there was already a patch queued and released in 5.2.10 and
> 4.19.68 for this issue (as far I can see; is this correct?)

Yes, it should have been fixed in those branches.

But google asked me to back port it to v4.4.190 and v4.14.141.

I have mentioned it in one previous email, but it was blocked by vger
because it was sent in html format.

Can you apply it to these 2 versions? (it applies to both versions)

Thanks.

> Regards,
> Salvatore

--------------C17843906CF228CD9BE7D7BA
Content-Type: text/x-patch;
 name="0001-Fix-an-OOB-bug-in-parse_audio_mixer_unit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Fix-an-OOB-bug-in-parse_audio_mixer_unit.patch"

From 09942398a53bbe730264b782673890d4a54068d0 Mon Sep 17 00:00:00 2001
From: Hui Peng <benquike@gmail.com>
Date: Fri, 30 Aug 2019 16:11:00 -0400
Subject: [PATCH 1/2] Fix an OOB bug in parse_audio_mixer_unit

The `uac_mixer_unit_descriptor` shown as below is read from the
device side. In `parse_audio_mixer_unit`, `baSourceID` field is
accessed from index 0 to `bNrInPins` - 1, the current implementation
assumes that descriptor is always valid (the length  of descriptor
is no shorter than 5 + `bNrInPins`). If a descriptor read from
the device side is invalid, it may trigger out-of-bound memory
access.

```
struct uac_mixer_unit_descriptor {
	__u8 bLength;
	__u8 bDescriptorType;
	__u8 bDescriptorSubtype;
	__u8 bUnitID;
	__u8 bNrInPins;
	__u8 baSourceID[];
}
```

This patch fixes the bug by add a sanity check on the length of
the descriptor.

CVE: CVE-2019-15117

Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
Signed-off-by: Hui Peng <benquike@gmail.com>
---
 sound/usb/mixer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 1f7eb3816cd7..10ddec76f906 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1628,6 +1628,7 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
 	int pin, ich, err;
 
 	if (desc->bLength < 11 || !(input_pins = desc->bNrInPins) ||
+	    desc->bLength < sizeof(*desc) + desc->bNrInPins ||
 	    !(num_outs = uac_mixer_unit_bNrChannels(desc))) {
 		usb_audio_err(state->chip,
 			      "invalid MIXER UNIT descriptor %d\n",
-- 
2.17.1


--------------C17843906CF228CD9BE7D7BA--
