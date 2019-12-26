Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D535E12AC4C
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 14:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfLZNCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 08:02:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52107 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725954AbfLZNCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Dec 2019 08:02:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577365355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5aEamWq7nLWLZ8ATUMzi/DS0XmBcftQ/KkilQfpBaX4=;
        b=dtDjNuCZIC5Jt8ODSlShMgn1vZlDGAEd/KJVfY6qmsnEoD6/GAxCUQ8GRD7lM87t7hQH/O
        L/1FqnkVMaN5Iiref3P8124A5hLdMjiGvNEY2pa1LZqjYf3uzwJplEwvoZP4lrSMjVKq6T
        5TrkGS4AHx0jCZnQcTLhhG4n4Qp53RU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-wZ3VrRBPMPinMesvs13Ebw-1; Thu, 26 Dec 2019 08:02:33 -0500
X-MC-Unique: wZ3VrRBPMPinMesvs13Ebw-1
Received: by mail-wr1-f70.google.com with SMTP id r2so10192431wrp.7
        for <stable@vger.kernel.org>; Thu, 26 Dec 2019 05:02:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5aEamWq7nLWLZ8ATUMzi/DS0XmBcftQ/KkilQfpBaX4=;
        b=CLnUBtWTOC39s1yIOwjvYuiq5et9XUCsEaiywAzmZU2/fOjZjmkKsWb/FrMegdLhan
         2awzH57O9IYMRn1ad0nnVxRhfXoaE0G57hGVB7tGRfkn6yZV+Smda2+X43wtkqyJ5NFb
         VRLGmWm5bclmgUiWQ0azuoDTs+kaDCd0n/GCJEjEqsK/f+ZA7mU9Gba7Z67mX9Od8sHY
         Xmlh71kuCTBdASDAfKg+mPuVzbNjx3l4mZmm832VuOCrYXqfhmgWp/Ppbj8IdhQG5Dip
         A+VPbF25ukYBnfapory5538gCCNnFrFaYrC/t/l3/2JnN6Y6sSwxeEcnXRL6HkEznPqz
         PakA==
X-Gm-Message-State: APjAAAXcg//drce4eSKaZPQ/lQLpL6tY0ZtHnYFs90ndVM+HSlsx82s4
        HZVR4A/z98IEWKPyyZ1bm4o/tam6rkqQnjX+8kVsm1eJqLSTiF2WSgf447xNBf0j2yPafCPM9mX
        4IVTa/D+Wmw3jVWml
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr47527854wrx.304.1577365352155;
        Thu, 26 Dec 2019 05:02:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqxWvVTiX30mgHFVy5MoJjlKqVEzL3gxNEqM+bSe/fg2yubRgZOSstgjb30m0GS7jPb2rSBJDA==
X-Received: by 2002:a05:6000:12c9:: with SMTP id l9mr47527833wrx.304.1577365351990;
        Thu, 26 Dec 2019 05:02:31 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id o129sm8511008wmb.1.2019.12.26.05.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 05:02:31 -0800 (PST)
Subject: Re: [PATCH] ACPI: video: Do not export a non working backlight
 interface on MSI MS-7721 boards
To:     Sasha Levin <sashal@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>
Cc:     linux-acpi@vger.kernel.org, stable@vger.kernel.org
References: <20191217190811.638607-1-hdegoede@redhat.com>
 <20191225235530.C65AD20838@mail.kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <72606fb0-58dd-a415-b14d-b65ed53d3965@redhat.com>
Date:   Thu, 26 Dec 2019 14:02:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191225235530.C65AD20838@mail.kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 26-12-2019 00:55, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.4.5, v5.3.18, v4.19.90, v4.14.159, v4.9.206, v4.4.206.
> 
> v5.4.5: Build OK!
> v5.3.18: Build OK!
> v4.19.90: Build OK!
> v4.14.159: Build OK!
> v4.9.206: Failed to apply! Possible dependencies:
>      1f59ab2783ae ("ACPI / video: Add force_none quirk for Dell OptiPlex 9020M")
>      d37efb79bc1c ("ACPI / video: Add quirks for the Dell Precision 7510")
> 
> v4.4.206: Failed to apply! Possible dependencies:
>      1f59ab2783ae ("ACPI / video: Add force_none quirk for Dell OptiPlex 9020M")
>      d37efb79bc1c ("ACPI / video: Add quirks for the Dell Precision 7510")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

This fix is mostly cosmetical (it hides a non working brightness control
in various desktop environments) so just backporting this to the kernels
where it cleanly applies is fine.

Regards,

Hans

