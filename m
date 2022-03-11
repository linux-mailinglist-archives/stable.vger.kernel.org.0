Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03ADD4D5703
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 01:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbiCKA5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 19:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiCKA5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 19:57:48 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3181A3604;
        Thu, 10 Mar 2022 16:56:46 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id q7-20020a7bce87000000b00382255f4ca9so6590910wmj.2;
        Thu, 10 Mar 2022 16:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=arlN1T8xScWpujBipjQ/WuveNzL1sgp98ejFbHOQoZw=;
        b=GotwGQv+CPNN+7EgWbzhA7Gg5qnTBS0bbk3/Iyg8joKuOUlIvMxXSvR0Wv//jgDsaF
         uZXGSfL2lnnYsf969lSETRYz/Yvi+mS8S6E/qzb22k8BBXubQ2m2tI/LXME1BwjYI3yu
         yfXXsxf+//emSsu5bSvSM5QTv4dt6UhMVjQueh0P8SMRkneKIe4bMDRhtN/+xZgPYRw5
         ITKvctpxicWGEt0HqRiImrIRvUEIcidQmeE6DGbyhSG9r4AD1agelgMJzTOCiS+mFF+J
         GTJwDGctl5KI+MY4n+O8OgrGBJDfcOLRGwR/PCotPr1fvfbtXOGPKaEWdZH1ZSwr6Cjm
         3uzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=arlN1T8xScWpujBipjQ/WuveNzL1sgp98ejFbHOQoZw=;
        b=B/rrLbrTOAlBPCIDp3F9QnO4BieaYQ6uBb6X4GMZEpASmAGI3LuKjHZe1a/OAHLBE2
         BJs5aoRKK5N+mNUg2Rd+X2So0ysg1fze2fcyzPtPbAMEe0JW5CAtNZdaMKQgHC+BwAS7
         l/8CeH9Om1VJVYsrgwsMMzjGJmWn6qFm4QoNJrGzRtWzxev9cnNPj8gijZJrfOTIG5Mt
         jrKxBEgZTfU5RrNHep5nSZ1h4KXcZRwBuWOEszIV7WPXqNmfGSgJAb7W66Enjn4wi9Uk
         260E3Rh8PxU/JtXOJBDByLL1+42+PfvxWhIjDx5jcw+7b7L72TUipJS7NmDhGkOVfdAp
         anWA==
X-Gm-Message-State: AOAM531iodpB3XXH25iGDHX/jAOnLG/EI+Ycm+caPWGdEQqF/vNB+N39
        8iFfpagXm/6r0qCdcAGjFkw=
X-Google-Smtp-Source: ABdhPJxqX5NdwYh+IQDZktyCaJmXe5rUFG0Btr3+u36XQGEF/oAY5tGWtykbYmuj7nLWMKsTydryCQ==
X-Received: by 2002:a05:600c:19cc:b0:389:d0a8:d3ab with SMTP id u12-20020a05600c19cc00b00389d0a8d3abmr8537563wmq.57.1646960205111;
        Thu, 10 Mar 2022 16:56:45 -0800 (PST)
Received: from [192.168.2.202] (p5487b56d.dip0.t-ipconnect.de. [84.135.181.109])
        by smtp.gmail.com with ESMTPSA id o7-20020a5d6707000000b001f067c7b47fsm8525427wru.27.2022.03.10.16.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 16:56:44 -0800 (PST)
Message-ID: <09f244d8-2601-5828-3ba8-c429a887ba4c@gmail.com>
Date:   Fri, 11 Mar 2022 01:56:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] ACPI: battery: Add device HID and quirk for Microsoft
 Surface Go 3
Content-Language: en-US
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220213154920.142816-1-luzmaximilian@gmail.com>
From:   Maximilian Luz <luzmaximilian@gmail.com>
In-Reply-To: <20220213154920.142816-1-luzmaximilian@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/13/22 16:49, Maximilian Luz wrote:
> For some reason, the Microsoft Surface Go 3 uses the standard ACPI
> interface for battery information, but does not use the standard PNP0C0A
> HID. Instead it uses MSHW0146 as identifier. Add that ID to the driver
> as this seems to work well.
> 
> Additionally, the power state is not updated immediately after the AC
> has been (un-)plugged, so add the respective quirk for that.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>

Hi, any comments/status on this?
