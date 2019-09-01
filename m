Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5426FA4980
	for <lists+stable@lfdr.de>; Sun,  1 Sep 2019 14:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfIAM6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Sep 2019 08:58:14 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36324 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728756AbfIAM6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Sep 2019 08:58:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id p13so11968095wmh.1;
        Sun, 01 Sep 2019 05:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UxrLHy0xZer5ID4RHyuCqHzVGteGB4HlcmZdUjqBSL4=;
        b=mFFi1AKPSaWngSR9jtj9CgHSiMvJGrF/gJcubSZhAcKoIP8k1Tn8h0Xb2H4MMpoY98
         ATkbzsIdx1azRsSUQ70wuqo1zjiARoeps830lySXrbXba0w/4YFfdVhXcwZWkp0fwtZ6
         4WglBbXxLbyMehj5WsfIYCts15phqU9Ikqg/BP4/TfHTzcM2JNPQJypm7uNUOziVH0sZ
         fXFLOcK+r3mR7aLL1ySTmKoDMh11++IJL8l6Zqo6fsPJK95dJqStyWxcu8GDibJGBIRl
         JWlw3CgAMpfVSNAYHeq22BCm/95o+gxuBq72xJamkbYhxobYL6BUwc31VcC7CDbf30pO
         kV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=UxrLHy0xZer5ID4RHyuCqHzVGteGB4HlcmZdUjqBSL4=;
        b=t4TwZcwUgeqOariipRNDuQNkUzdmZCWcaS6cDkh05G+dz+iSgX0r4KVXde1li3yh1j
         nME+s169KuKcNYYioJj4stPVQYkqjbI6x4sBOwvFPKSK6eALCQ9PMbXjm7WNoJ+MiSIV
         9H4NGrK/j0Zhb3Gr5Y97ELAfW1aGChyMqnJf+aI3PZ7R4/Rk1ypc3MLLsw0RzTw3QtwG
         0myFIIguKRmi5tAPTGhNs3MYNOa/zVewX8lpT2xaSXD1ToHbF2yYS0YfepkBnKeb8j9D
         mUVhDSDfXia5YXlcrNlPKnNuQ38BSpiAV2mlHQAUnZHeZRy/sMluz4xCS/GZcWNVrU+I
         TMVw==
X-Gm-Message-State: APjAAAXnTwWVRJsq+stAV2uEYYSHi8vqmwX4GrGo82yJA+VjQsdGiNg4
        Zn4VbICbhwIEyBr+13A0liSBcx+lAts=
X-Google-Smtp-Source: APXvYqwpCH+B/lBvHkPsK4oranhfJRg2I6GN/bqGm9Vi9ZAArUYI1ZCHKIDT0o2hYlbk+wWuHH2+QQ==
X-Received: by 2002:a7b:cb8e:: with SMTP id m14mr30808692wmi.10.1567342691150;
        Sun, 01 Sep 2019 05:58:11 -0700 (PDT)
Received: from eldamar (host85-134-dynamic.30-79-r.retail.telecomitalia.it. [79.30.134.85])
        by smtp.gmail.com with ESMTPSA id r190sm15294524wmf.0.2019.09.01.05.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2019 05:58:09 -0700 (PDT)
Date:   Sun, 1 Sep 2019 14:58:09 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Hui Peng <benquike@gmail.com>
Cc:     stable@vger.kernel.org,
        Mathias Payer <mathias.payer@nebelwelt.net>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wenwen Wang <wang6495@umn.edu>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Fix an OOB bug in parse_audio_mixer_unit
Message-ID: <20190901125809.GA23334@eldamar.local>
References: <20190830214649.27761-1-benquike@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830214649.27761-1-benquike@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 30, 2019 at 05:46:49PM -0400, Hui Peng wrote:
> The `uac_mixer_unit_descriptor` shown as below is read from the
> device side. In `parse_audio_mixer_unit`, `baSourceID` field is
> accessed from index 0 to `bNrInPins` - 1, the current implementation
> assumes that descriptor is always valid (the length  of descriptor
> is no shorter than 5 + `bNrInPins`). If a descriptor read from
> the device side is invalid, it may trigger out-of-bound memory
> access.
> 
> ```
> struct uac_mixer_unit_descriptor {
> 	__u8 bLength;
> 	__u8 bDescriptorType;
> 	__u8 bDescriptorSubtype;
> 	__u8 bUnitID;
> 	__u8 bNrInPins;
> 	__u8 baSourceID[];
> }
> ```
> 
> This patch fixes the bug by add a sanity check on the length of
> the descriptor.
> 
> CVE: CVE-2018-15117

FWIW, the correct CVE id should be probably CVE-2019-15117 here.

But there was already a patch queued and released in 5.2.10 and
4.19.68 for this issue (as far I can see; is this correct?)

Regards,
Salvatore
