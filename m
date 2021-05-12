Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF8937B97B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhELJow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:44:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELJov (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620812623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VdYOZ511BdKbG564alFzriety1IRDTMZXU/KewTbRTE=;
        b=Rgvx23mc5gLiqilYwgbf8oodUr0/K48jyIbfCVSa4R80Ag0Rc0KX70ATtMdAaQVESxxRAR
        ogdygjckvix/PtfPIfNHxXgHyz6bdH9BmnAoqrhOQLmLWpoNSJxZswKWBOUdcjd56gq5gH
        pgrtXzz1oqo7GxHI81Qe8iPN7TZh+u0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-0Ak8y7z9NImNvjU_7iYlZg-1; Wed, 12 May 2021 05:43:42 -0400
X-MC-Unique: 0Ak8y7z9NImNvjU_7iYlZg-1
Received: by mail-ed1-f72.google.com with SMTP id h18-20020a05640250d2b029038cc3938914so836544edb.17
        for <stable@vger.kernel.org>; Wed, 12 May 2021 02:43:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VdYOZ511BdKbG564alFzriety1IRDTMZXU/KewTbRTE=;
        b=pOuttaXFlQhpU+Z5m6T182HVxN02V11zsfwFOVTOtUUXIYihsOtEFowDA52soY+CJP
         HBEJpPjNXk+a4q+ZQWJoDfETB8rs3t2+g/qraWg9rsu/9v00hMKAnQjvkWFot69dGKE8
         qFb04oek8TxhFR2vbA0lsGB7acshejfVBbRnOaX0BMgm2wiSSPcSr0QTV9lAq1UhAI5o
         5g1kFcFgLGJzefTv7RGaLGby/JLGWOpJ4uNIQExC5WydzEpccQoY4hnPQVPufjuQDNdT
         3F+PXtChhgTBE/vTOlu7CKB9HXRbFYnj//VgPJtnvDvQNZ4bu1XVQiv9+Us98MfEQdDF
         9cdw==
X-Gm-Message-State: AOAM533btUzwsGrSg+deCqxwSF/sUZ1s/FpIuuZqPsFj1V8D2z3P8yQ5
        RAHik1yLxcuJMgOl9wRuy+PVHxdNUK4jK5EJ5MYqA46b6cAkEQNXviG1dNW7phF0z4csemill6R
        avYjD+t3Y1X+OqdZtERsvl67AlWczV/aVotmDSmSEGOGvVMZA6g0wcGVgkPS4DhBiH+u7
X-Received: by 2002:a17:906:1e15:: with SMTP id g21mr36699514ejj.241.1620812620793;
        Wed, 12 May 2021 02:43:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyITFp/t2Kr+CDMY/y1KiEWBh2vzQzeQ5k8MSegvdpesfmuCrUVM3GLfUShTherTJVk0AsgYg==
X-Received: by 2002:a17:906:1e15:: with SMTP id g21mr36699498ejj.241.1620812620626;
        Wed, 12 May 2021 02:43:40 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id g9sm13673961ejo.8.2021.05.12.02.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 02:43:39 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] platform/x86: intel-vbtn: Stop reporting
 SW_DOCK events" failed to apply to 5.12-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <162080946671117@kroah.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <39b030b4-314f-1271-52df-2df629a81f7d@redhat.com>
Date:   Wed, 12 May 2021 11:43:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <162080946671117@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 5/12/21 10:51 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.12-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This is already in 5.12, but then as commit 538d2dd0b9920334e6596977a664e9e7bac73703
that is the hash it has on my pdx86/fixes branch, where I cherry picked
it from my pdx86/for-next branch.

The 2728f39dfc720983e2b69f0f1f0c403aaa7c346f hash you tried to
cherry-pick is from my pdx86/for-next branch and so this same change
showed up (again) in 5.13-rc1 under this hash, sorry about the confusion.

Regards,

Hans






> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 2728f39dfc720983e2b69f0f1f0c403aaa7c346f Mon Sep 17 00:00:00 2001
> From: Hans de Goede <hdegoede@redhat.com>
> Date: Sun, 21 Mar 2021 17:35:13 +0100
> Subject: [PATCH] platform/x86: intel-vbtn: Stop reporting SW_DOCK events
> 
> Stop reporting SW_DOCK events because this breaks suspend-on-lid-close.
> 
> SW_DOCK should only be reported for docking stations, but all the DSDTs in
> my DSDT collection which use the intel-vbtn code, always seem to use this
> for 2-in-1s / convertibles and set SW_DOCK=1 when in laptop-mode (in tandem
> with setting SW_TABLET_MODE=0).
> 
> This causes userspace to think the laptop is docked to a port-replicator
> and to disable suspend-on-lid-close, which is undesirable.
> 
> Map the dock events to KEY_IGNORE to avoid this broken SW_DOCK reporting.
> 
> Note this may theoretically cause us to stop reporting SW_DOCK on some
> device where the 0xCA and 0xCB intel-vbtn events are actually used for
> reporting docking to a classic docking-station / port-replicator but
> I'm not aware of any such devices.
> 
> Also the most important thing is that we only report SW_DOCK when it
> reliably reports being docked to a classic docking-station without any
> false positives, which clearly is not the case here. If there is a
> chance of reporting false positives then it is better to not report
> SW_DOCK at all.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Link: https://lore.kernel.org/r/20210321163513.72328-1-hdegoede@redhat.com
> 
> diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
> index 8a8017f9ca91..3fdf4cbec9ad 100644
> --- a/drivers/platform/x86/intel-vbtn.c
> +++ b/drivers/platform/x86/intel-vbtn.c
> @@ -48,8 +48,16 @@ static const struct key_entry intel_vbtn_keymap[] = {
>  };
>  
>  static const struct key_entry intel_vbtn_switchmap[] = {
> -	{ KE_SW,     0xCA, { .sw = { SW_DOCK, 1 } } },		/* Docked */
> -	{ KE_SW,     0xCB, { .sw = { SW_DOCK, 0 } } },		/* Undocked */
> +	/*
> +	 * SW_DOCK should only be reported for docking stations, but DSDTs using the
> +	 * intel-vbtn code, always seem to use this for 2-in-1s / convertibles and set
> +	 * SW_DOCK=1 when in laptop-mode (in tandem with setting SW_TABLET_MODE=0).
> +	 * This causes userspace to think the laptop is docked to a port-replicator
> +	 * and to disable suspend-on-lid-close, which is undesirable.
> +	 * Map the dock events to KEY_IGNORE to avoid this broken SW_DOCK reporting.
> +	 */
> +	{ KE_IGNORE, 0xCA, { .sw = { SW_DOCK, 1 } } },		/* Docked */
> +	{ KE_IGNORE, 0xCB, { .sw = { SW_DOCK, 0 } } },		/* Undocked */
>  	{ KE_SW,     0xCC, { .sw = { SW_TABLET_MODE, 1 } } },	/* Tablet */
>  	{ KE_SW,     0xCD, { .sw = { SW_TABLET_MODE, 0 } } },	/* Laptop */
>  	{ KE_END }
> 

