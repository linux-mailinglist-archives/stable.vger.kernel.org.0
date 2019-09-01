Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD46A4B77
	for <lists+stable@lfdr.de>; Sun,  1 Sep 2019 21:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfIATre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Sep 2019 15:47:34 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41424 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728610AbfIATre (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Sep 2019 15:47:34 -0400
Received: by mail-io1-f67.google.com with SMTP id j5so25113357ioj.8;
        Sun, 01 Sep 2019 12:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=SbdrgYp0JCHIooetwhrkmJbqHt7Ynh9WyJyH/5s8HFY=;
        b=iq7HAjADfR30U8TZiKa30vuN13zoW56e66tic3tp67xASs6vF3W7/fWYrmbu6fukPo
         3GWpHj8JbIfDExwsc0dQ8dLEMG427ASQ5AknR5mVIP9t1zkK8ARPhq6Xutl9SDyLYuaW
         76rjS5QlfmlMycx5QmvIW83CULPRA6Ay5sIrSXz9uUuoA1GQADCWMc2b9dixprxfbr8y
         iHgX4ZzXrUN8S6iuQpkJOdwVF26XHs8Dyn66+O4c+bZkK3WJLogP/SiYJ3qdp2ZbrcAK
         XWGCI+PKLutG4TnUUD7IO7WuJwQRu0Vifz5ylO6yRMhp7ffa2Eh1j2r/TZxYoz6SszKr
         uTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=SbdrgYp0JCHIooetwhrkmJbqHt7Ynh9WyJyH/5s8HFY=;
        b=hJzFomLwJ1mCi6Sh9/4hZYrKdOC/DGfsr8F4POhaIFKtyX4cgfOzRKC+4uEkxMuQiy
         hR9bNQJZwQMqJ3by+/gIfWENDEY3TadThnd+XlPlEwmeIvF6YiBZD/kY1z1iI4SCb/xT
         d5ENs5GsdnSeyWfpFHxpeEP+j8N2sm7sKV200mz3f10tvEO3lKISjjEOWzzACl2pjpCI
         GWdbQ2QP0DmG0PWWJgmfuXTkPBhDs/L0Bv6Zg7rx1mrka0bSXphjCWjwd19OIxFmDEdj
         liK+xNBCvc/aRdi7o0S+/mISvLHx27FdCIbFjv8SnKR05sDuZWrhl7OGfy6ZbUhat9yi
         6TLg==
X-Gm-Message-State: APjAAAXb4bxdirKOXBXbVHLCJ/QVUoXOy+F/9DrBU8+6+ys9r59eHvs0
        GqlcbRwk7VQgmbEXlWTP/Xr1+raGDLgbpw==
X-Google-Smtp-Source: APXvYqy8f8YinGvWsit9QhIOq7PWNlq2g3epAM3mBvqvUkEX1+GOMQnwyq4TmcMvy/QDPDOCDK3eTg==
X-Received: by 2002:a6b:e609:: with SMTP id g9mr10225310ioh.7.1567367253028;
        Sun, 01 Sep 2019 12:47:33 -0700 (PDT)
Received: from [10.164.9.36] (cos-128-210-107-27.science.purdue.edu. [128.210.107.27])
        by smtp.gmail.com with ESMTPSA id r138sm17696679iod.59.2019.09.01.12.47.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Sep 2019 12:47:32 -0700 (PDT)
Subject: Re: [PATCH 2/2] Fix a stack buffer overflow bug in check_input_term
To:     carnil@debian.org
Cc:     stable@vger.kernel.org, mathias.payer@nebelwelt.net,
        perex@perex.cz, tiwai@suse.com, gregkh@linuxfoundation.org,
        wang6495@umn.edu, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
References: <20190830214730.27842-1-benquike@gmail.com>
 <20190901130028.GB23334@eldamar.local>
From:   Hui Peng <benquike@gmail.com>
Message-ID: <d80f1fba-8bf5-58e2-1801-5ac2308b5d4e@gmail.com>
Date:   Sun, 1 Sep 2019 15:47:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190901130028.GB23334@eldamar.local>
Content-Type: multipart/mixed;
 boundary="------------5C362557DFF1DBD4FF087E3A"
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------5C362557DFF1DBD4FF087E3A
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit


On 9/1/19 9:00 AM, Salvatore Bonaccorso wrote:
> Hi Hui,
>
> On Fri, Aug 30, 2019 at 05:47:29PM -0400, Hui Peng wrote:
>> `check_input_term` recursively calls itself with input from
>> device side (e.g., uac_input_terminal_descriptor.bCSourceID)
>> as argument (id). In `check_input_term`, if `check_input_term`
>> is called with the same `id` argument as the caller, it triggers
>> endless recursive call, resulting kernel space stack overflow.
>>
>> This patch fixes the bug by adding a bitmap to `struct mixer_build`
>> to keep track of the checked ids and stop the execution if some id
>> has been checked (similar to how parse_audio_unit handles unitid
>> argument).
>>
>> CVE: CVE-2018-15118
> Similar to the previous one, this should be CVE-2019-15118 as far I
> can tell.

Same here: CVE id updated.

Can you apply it to  v4.4.190 and v4.14.141?

Thanks.

>
> Regards,
> Salvatore

--------------5C362557DFF1DBD4FF087E3A
Content-Type: text/x-patch;
 name="0002-Fix-a-stack-buffer-overflow-bug-in-check_input_term.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-Fix-a-stack-buffer-overflow-bug-in-check_input_term.pat";
 filename*1="ch"

From f5e478c4807b16f49c00316fb80485562b84340a Mon Sep 17 00:00:00 2001
From: Hui Peng <benquike@gmail.com>
Date: Fri, 30 Aug 2019 16:20:41 -0400
Subject: [PATCH 2/2] Fix a stack buffer overflow bug in check_input_term

`check_input_term` recursively calls itself with input from
device side (e.g., uac_input_terminal_descriptor.bCSourceID)
as argument (id). In `check_input_term`, if `check_input_term`
is called with the same `id` argument as the caller, it triggers
endless recursive call, resulting kernel space stack overflow.

This patch fixes the bug by adding a bitmap to `struct mixer_build`
to keep track of the checked ids and stop the execution if some id
has been checked (similar to how parse_audio_unit handles unitid
argument).

CVE: CVE-2019-15118

Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
Signed-off-by: Hui Peng <benquike@gmail.com>
---
 sound/usb/mixer.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 10ddec76f906..e24572fd6e30 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -81,6 +81,7 @@ struct mixer_build {
 	unsigned char *buffer;
 	unsigned int buflen;
 	DECLARE_BITMAP(unitbitmap, MAX_ID_ELEMS);
+	DECLARE_BITMAP(termbitmap, MAX_ID_ELEMS);
 	struct usb_audio_term oterm;
 	const struct usbmix_name_map *map;
 	const struct usbmix_selector_map *selector_map;
@@ -709,15 +710,24 @@ static int get_term_name(struct mixer_build *state, struct usb_audio_term *iterm
  * parse the source unit recursively until it reaches to a terminal
  * or a branched unit.
  */
-static int check_input_term(struct mixer_build *state, int id,
+static int __check_input_term(struct mixer_build *state, int id,
 			    struct usb_audio_term *term)
 {
 	int err;
 	void *p1;
+	unsigned char *hdr;
 
 	memset(term, 0, sizeof(*term));
-	while ((p1 = find_audio_control_unit(state, id)) != NULL) {
-		unsigned char *hdr = p1;
+	for (;;) {
+		/* a loop in the terminal chain? */
+		if (test_and_set_bit(id, state->termbitmap))
+			return -EINVAL;
+
+		p1 = find_audio_control_unit(state, id);
+		if (!p1)
+			break;
+
+		hdr = p1;
 		term->id = id;
 		switch (hdr[2]) {
 		case UAC_INPUT_TERMINAL:
@@ -732,7 +742,7 @@ static int check_input_term(struct mixer_build *state, int id,
 
 				/* call recursively to verify that the
 				 * referenced clock entity is valid */
-				err = check_input_term(state, d->bCSourceID, term);
+				err = __check_input_term(state, d->bCSourceID, term);
 				if (err < 0)
 					return err;
 
@@ -764,7 +774,7 @@ static int check_input_term(struct mixer_build *state, int id,
 		case UAC2_CLOCK_SELECTOR: {
 			struct uac_selector_unit_descriptor *d = p1;
 			/* call recursively to retrieve the channel info */
-			err = check_input_term(state, d->baSourceID[0], term);
+			err = __check_input_term(state, d->baSourceID[0], term);
 			if (err < 0)
 				return err;
 			term->type = d->bDescriptorSubtype << 16; /* virtual type */
@@ -811,6 +821,15 @@ static int check_input_term(struct mixer_build *state, int id,
 	return -ENODEV;
 }
 
+
+static int check_input_term(struct mixer_build *state, int id,
+			    struct usb_audio_term *term)
+{
+	memset(term, 0, sizeof(*term));
+	memset(state->termbitmap, 0, sizeof(state->termbitmap));
+	return __check_input_term(state, id, term);
+}
+
 /*
  * Feature Unit
  */
-- 
2.17.1


--------------5C362557DFF1DBD4FF087E3A--
