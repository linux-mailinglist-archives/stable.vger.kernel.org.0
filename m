Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F13474684
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 16:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbhLNPea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 10:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbhLNPe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 10:34:28 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3688FC061574;
        Tue, 14 Dec 2021 07:34:28 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id u3so37573946lfl.2;
        Tue, 14 Dec 2021 07:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m/qW6OJTq+PZMI2TVoFARae55ogXm1E7P0dFW1QTwws=;
        b=EFQ3vqV+R8neb78NOg2W1d/+0znWSMA8y3MxU6ojmqf0dH1fgOK9iO8zQD9UJ4OA0N
         Asz9VV2IMp0dtwlEvwCZezbmiosrhe8h7T2SJnx79NEtnKqGF8QHE6llglwGUz5wYvqz
         Wrxd3OHTMFpD148w8gP4dKSmEFlPP83Ok/fGQBxXecb4+c0u2o0klPZGS0Zds4cMK6rt
         vFaL4CaBZRvFpU04prw4VTWMcm8bBQohFwIaAEklLB/orovPO9Mz/2bUd5c7BwToFiR4
         t59/inKbGK+L+Vx55dQWtRFuO8/NxVgGHoA567QqNGBQzIYzWSx/iNET4fNMLdzY/7LJ
         6C/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m/qW6OJTq+PZMI2TVoFARae55ogXm1E7P0dFW1QTwws=;
        b=V0rYhgLKV4s2qhU0ym0y8Q74KYvIyJzqZ/vxUp+2U9IC9TF/1yuYhg7+YJKTc5CC/X
         wYaNCYPTrZz8BKU9NgEbGArvmpj8atHt2j6miQNMay364nauTKz9iKxsQjHxXn2gkyaa
         Bgx3wM901xRGUmlC1rH6G39lCZTdGClWl4BDDNcRMY0JfIcsTp4HPFE2d13YBtN/KpYL
         ge4/5f9lu6NG9ekfUIAcUVMKyala/dsN+bH7qOsnYd+WHZokiPdggHxfiCEoamB9v9cJ
         UMpEXWrVKfYNh+p0CoUULxoeoJdlsAHHPiZjB8n5oZygZJ+CHYyLjlAdv6zpnyVjqXQe
         zyPQ==
X-Gm-Message-State: AOAM533+fsVzZcY8npKshY6ba1fP7UId82xlS2rxAOqN/WBR8q0ehs+U
        RkuZLRPbsZxLDScKl7DEDQU=
X-Google-Smtp-Source: ABdhPJzwtl22wgbOJNUiLRvzjqIzb84KHkq1ypWVWnAF32iWfkeJGaGZLEBcU+zP+CWTwxWsKtRnog==
X-Received: by 2002:a19:c350:: with SMTP id t77mr5415981lff.152.1639496066375;
        Tue, 14 Dec 2021 07:34:26 -0800 (PST)
Received: from [192.168.2.145] (94-29-63-156.dynamic.spd-mgts.ru. [94.29.63.156])
        by smtp.googlemail.com with ESMTPSA id g27sm14872lfe.55.2021.12.14.07.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 07:34:26 -0800 (PST)
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Sameer Pujar <spujar@nvidia.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, thierry.reding@gmail.com,
        perex@perex.cz, jonathanh@nvidia.com, alsa-devel@alsa-project.org,
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
 <ad388f5e-6f60-cf78-8510-87aec8524e33@gmail.com>
 <50bf5a83-051e-8c12-6502-aabd8edd0a72@nvidia.com>
 <7230ad0b-2b04-4f1b-b616-b7d98789ded0@gmail.com>
 <48f891bc-d8f6-2634-6dd1-6ea4f14ae6a3@nvidia.com>
 <0761f6f2-27f8-4e1a-fabc-9d319f465a9e@gmail.com>
 <s5hv8zr9s5a.wl-tiwai@suse.de>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <b7ad34b4-02be-00ed-05e2-12ea31ababb2@gmail.com>
Date:   Tue, 14 Dec 2021 18:34:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <s5hv8zr9s5a.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

14.12.2021 17:29, Takashi Iwai пишет:
>> I'm also wondering whether snd_power_change_state() should be moved into
>> RPM callbacks and whether this function does anything practically useful
>> on Tegra at all.
> This call is mostly for ALSA core stuff, and not necessarily
> reflecting the exact device power state.  The major role is for
> controlling / blocking the device accesses at the system
> suspend/resume, so it's correct to set only in the system
> suspend/resume callbacks, not in runtime PM.
> 

Thank you for the clarification.
