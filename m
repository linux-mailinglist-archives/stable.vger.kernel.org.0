Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B7F1678CF
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgBUIxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:53:08 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43817 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbgBUIxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 03:53:08 -0500
Received: by mail-lj1-f194.google.com with SMTP id a13so1345978ljm.10
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 00:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pli85ohNA/og0VJfc2xmRcDgbVQCJX2DMRFfxLC1lCo=;
        b=SKpx/2ZuiKkRpWPnM+fdMnUfH/1CWpaeL8ePgtiYuwhrwzmB1TFT4XUksx+g9p8Hhk
         9Dj8q8n+scFnhEKxpnYBwII+cwHMCMcbEkr+2sSvCAGlgCpRrV1sX82PTYb9/icFk5EB
         CqcDcJd4tjqtcLXGxuQeGtLQjsGnkrj4eOWBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pli85ohNA/og0VJfc2xmRcDgbVQCJX2DMRFfxLC1lCo=;
        b=S7RFFQaujECB/X+LkTqZy8uzeadi7RFF3wJmEzS9tslx85SckPXHRPARtrOgO5N40b
         SJeE0AZjCmjzyyVLAz8SFFWAx0OEzlGVvTSf4EJwcndzdGdHemr47w9aKIUHvFKlLUn8
         4TIvaQMFOcqaJZ4PruVx4irWBPIkymuZnwcaYGimoAJQWQ3uVs8048shUZwaefzEZlK/
         Qqt65UzJpZqlY63wl87wt+geLQFGiWOAsdND0jKm0u3xrhVEvaKuMpCNCHNFKqqyrpjx
         JDk2wfjQw8G8wI6ipJnex0VJnk/CepCNkw10AuMPcnJSipYXN166T6pllEnqHPIVxhSI
         oGBQ==
X-Gm-Message-State: APjAAAVI5a2GHCsEb/an1YG0ubw/+G0FbmHMiFBMXIU6zLNJrueC/y+F
        NHPd6vxH6Zkr5Z1L4Yc4syxIuQ==
X-Google-Smtp-Source: APXvYqwIGnTTkpy4hzgv3Y2gZfesWshq2JaICvZBSAjOOd4Fk0gSpD+Lu2S2/NbLD3zeKA4s0+thEQ==
X-Received: by 2002:a05:651c:1045:: with SMTP id x5mr21872452ljm.266.1582275186349;
        Fri, 21 Feb 2020 00:53:06 -0800 (PST)
Received: from [172.16.11.50] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id a9sm1281307lfk.23.2020.02.21.00.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 00:53:05 -0800 (PST)
Subject: Re: Patch "soc: fsl: qe: change return type of cpm_muram_alloc() to
 s32" has been added to the 5.5-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200221012743.D5A0E208E4@mail.kernel.org>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <89ccc850-54af-aaec-4a9e-330dcb814ca7@rasmusvillemoes.dk>
Date:   Fri, 21 Feb 2020 09:53:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221012743.D5A0E208E4@mail.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/02/2020 02.27, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     soc: fsl: qe: change return type of cpm_muram_alloc() to s32
> 
> to the 5.5-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      soc-fsl-qe-change-return-type-of-cpm_muram_alloc-to-.patch
> and it can be found in the queue-5.5 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Isn't that what I did when I replied to the AUTOSEL mail a week ago?

https://lore.kernel.org/stable/a920b57f-ad9e-5c25-3981-0462febd952a@rasmusvillemoes.dk/

The TL;DR is the last part of the middle paragraph "... I think they
should not be added to any -stable kernel."

Rasmus
