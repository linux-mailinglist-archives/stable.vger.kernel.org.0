Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B548308B83
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 18:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhA2R1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 12:27:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232496AbhA2RZy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 12:25:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611941066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1tJEDpVaTU2o7pEzEYi/Itw24bwaC7NiGn/22B7qnc4=;
        b=FxJLjFZbOMYun0Xzb6wLVUBRr5pgeklEGdVzyiLgQ4Urwejh7wsGGHqjlJnAojRLTYQfsO
        +QGs+M9E7d2P3gks4Nk0IK755ZQBqXoGbBzrzZZT8OF0/W5c66ef2VeK9WRRBiq6k5QTNm
        F6f5vu9WGsElZYi+3l+ZbcLPiLWGORo=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-sNyJtDYdM_qLTb-NyMUslw-1; Fri, 29 Jan 2021 12:24:24 -0500
X-MC-Unique: sNyJtDYdM_qLTb-NyMUslw-1
Received: by mail-il1-f199.google.com with SMTP id g3so8223934ild.4
        for <stable@vger.kernel.org>; Fri, 29 Jan 2021 09:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:message-id:in-reply-to
         :references:mime-version;
        bh=1tJEDpVaTU2o7pEzEYi/Itw24bwaC7NiGn/22B7qnc4=;
        b=jp2/PW6gDEI6ovt1MUfZDayZPLGUfq9mGp6Yu8bi/IXVM0inAlaY5QE4u7RCIMmO8o
         6I2JpA8pgJASMl6xO1voGUYqNsh5pJDJCCqQfpojGGyzmpA3ulEN41SJB9Se+UFvpQQW
         BDg4mwOhK3Hd0jKB7bepqZ2CXZUVcL5935NFjRjcfkvwg3UHnOAh0FS30C5033vJ++hY
         bHxtj2rEH/iPsm705pAWl/gA7uTUMg3dDtZl4B5+wWaV3STYoVAaw7pdE4JOpN/VLikJ
         KCpTobOYsXPmSs2sGy2kI4ei7oTq9s4yQfIWt+ja84yXSRugTxaa5AWGUR1eVcCXNHc5
         sgmQ==
X-Gm-Message-State: AOAM5338rnlsgoMQtYbiHiuF+B8LnoQWhoVEquB/kyXdc+yc/YiPRg24
        t9XMHHnjYqszo+YB+E9FFpKftnUALRlm6XkEpb/ijkC8b5eUwdPNUVJ6T4C6N2z5jkE/cg9vWEk
        EhAbQVqo/eszyrk44
X-Received: by 2002:a05:6638:229b:: with SMTP id y27mr4572000jas.136.1611941063554;
        Fri, 29 Jan 2021 09:24:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxBQCa/aQwAwI0WBJb/kQp4EcDUYeQ7uixWQ+zr7FFHIFR0qu+Poa5+gr/i329TB8Xg1vOo1g==
X-Received: by 2002:a05:6638:229b:: with SMTP id y27mr4571989jas.136.1611941063408;
        Fri, 29 Jan 2021 09:24:23 -0800 (PST)
Received: from chargestone-cave ([2607:9000:0:57::8e])
        by smtp.gmail.com with ESMTPSA id b16sm4761308ile.32.2021.01.29.09.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 09:24:22 -0800 (PST)
Date:   Fri, 29 Jan 2021 11:24:16 -0600
From:   Michael Catanzaro <mcatanzaro@redhat.com>
Subject: Re: [REGRESSION] "ALSA: HDA: Early Forbid of runtime PM" broke
 =?UTF-8?Q?my=0D=0A?= laptop's internal audio
To:     Takashi Iwai <tiwai@suse.de>
Cc:     "N, Harshapriya" <harshapriya.n@intel.com>,
        alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
        kai.vehmanen@intel.com, stable@vger.kernel.org
Message-Id: <GOHPNQ.RTPVHYRR9NQ62@redhat.com>
In-Reply-To: <s5hft2jlnt4.wl-tiwai@suse.de>
References: <EM1ONQ.OL5CFJTBEBBW@redhat.com>
        <BY5PR11MB430713319F12454CF71A1E73FDB99@BY5PR11MB4307.namprd11.prod.outlook.com>
        <U3BPNQ.P8Q6LYEGXHB5@redhat.com> <s5hsg6jlr4q.wl-tiwai@suse.de>
        <9ACPNQ.AF32G3OJNPHA3@redhat.com> <IECPNQ.0TZXZXWOZX8L2@redhat.com>
        <8CEPNQ.GAG87LR8RI871@redhat.com> <s5hft2jlnt4.wl-tiwai@suse.de>
X-Mailer: geary/3.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 5:17 pm, Takashi Iwai <tiwai@suse.de> wrote:
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -2217,8 +2217,6 @@ static const struct snd_pci_quirk 
> power_save_denylist[] = {
>  	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
>  	SND_PCI_QUIRK(0x1043, 0x8733, "Asus Prime X370-Pro", 0),
>  	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
> -	SND_PCI_QUIRK(0x1558, 0x6504, "Clevo W65_67SB", 0),
> -	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
>  	SND_PCI_QUIRK(0x1028, 0x0497, "Dell Precision T3600", 0),
>  	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
>  	/* Note the P55A-UD3 and Z87-D3HP share the subsys id for the HDA 
> dev */

Hi,

This patch works fine on my laptop. I have no clue whether that means 
it's really safe to remove the quirk. I've never noticed any clicking 
noise myself, but I understand it has been a problem for other System76 
laptops.

Michael


