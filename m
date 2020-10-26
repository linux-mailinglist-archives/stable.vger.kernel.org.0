Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D71E298835
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 09:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771551AbgJZIUv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 04:20:51 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:33358 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1769297AbgJZIUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 04:20:51 -0400
Received: by mail-ej1-f66.google.com with SMTP id c15so12130325ejs.0
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 01:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QC0ppXrfrDPlEIwMtnYs+F8FFyNAmmn3ZcNGwnx7I1c=;
        b=HTm0M1Mj7kP8F5CAaiV3cToyq2+VnnuOw4PZY6wIuxQbVrB9AMJ6CCCKLgVYyX5zkF
         xXbpsUCAs4Lz4+bvKcNB7ZRd+FLMSlpeQgoqyErFbNs0UD8IuUGu0SSOKC7ruWBj/cJG
         VUiRXHccMIBKOCvd1cLECsrsUAGOzSvqQHN/rH7Flmznscy+him6txicGQkx3Pd/8jBp
         ugQRdoQbPfk6yIZDHEv7uC8/4jhYOcJphVvU+cMWlYdYT5uB5SrOyYcpmOlbX0kH/5I4
         VdqhAAd5KyhXaWxLHt6ew7cZgtFBjMYo2lKNFBjvHlU9JDnjyF4X8QLJpHQCYq+B4raj
         54EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QC0ppXrfrDPlEIwMtnYs+F8FFyNAmmn3ZcNGwnx7I1c=;
        b=EMnEc1MS9e8Q0b07UpAjofAWqroW0UV07E3F3Fu91+aHe/XXtROoejiS1NXEslVxx2
         AE6EXqfzzFGUbpipb4SFi1D4pkqN7e+LhpbaejrNIGyOdQTRDvK9Y5FCNPTbHpdNEXM9
         +AobdA9J7lmCbGQn4mp4SmiOy0r32SJn7J1WwEemXBhYmExqiP4s0XVRfdjC/A9Tqhgy
         M7bTbkmzPD7TyzSzq3p7LWz0Y+ud4wOLh9IVzF2ZfxE3/t2+zUFSXk7vtmjfYG8hQuL2
         IL+RRJo1/O8XXgHIjr4Of2NFWSc07AE0UPRCo+9OEZ/5Qurd1/GPWA+pMDMvfumdIp2s
         pWSg==
X-Gm-Message-State: AOAM532WB5Vgw/iGp8LnCLZps8Nh/WnWEslnM7p9NkWJnT8Ox+1ZsQ1S
        vTGZCjCoUApjfaJfi7C0G+FMzAVpz4V7at8j
X-Google-Smtp-Source: ABdhPJygm6sEv7aOyG5DWQTq5aAG7+rAP5Pjxl0eLTbN1CzlHLal59R8Q9yTmwUAXzV2bppmJQVcBw==
X-Received: by 2002:a17:907:382:: with SMTP id ss2mr15101980ejb.544.1603700448664;
        Mon, 26 Oct 2020 01:20:48 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:886:ce5d:dbbc:a8])
        by smtp.gmail.com with ESMTPSA id ks17sm5327907ejb.41.2020.10.26.01.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2020 01:20:48 -0700 (PDT)
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
References: <20201026051850.8F51D206A1@mail.kernel.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: Patch "selftests: mptcp: depends on built-in IPv6" has been added
 to the 5.9-stable tree
Message-ID: <1de2bf78-4b47-21b0-9d56-3c8063cdf4bb@tessares.net>
Date:   Mon, 26 Oct 2020 09:20:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201026051850.8F51D206A1@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 26/10/2020 06:18, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>      selftests: mptcp: depends on built-in IPv6

Thank you for backporting this patch.

(...)

>      Fixes: 010b430d5df5 ("mptcp: MPTCP_IPV6 should depend on IPV6 instead of selecting it")

This patch is not really needed because AFAICS this commit here above 
has not been backported to v5.9. It is only in v5.10-rc1.

(...)

> diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
> index 8df5cb8f71ff9..741a1c4f4ae8f 100644
> --- a/tools/testing/selftests/net/mptcp/config
> +++ b/tools/testing/selftests/net/mptcp/config
> @@ -1,4 +1,5 @@
>   CONFIG_MPTCP=y
> +CONFIG_IPV6=y
>   CONFIG_MPTCP_IPV6=y

But you can also keep this patch, it doesn't hurt: without this commit 
010b430d5df5 ("mptcp: MPTCP_IPV6 should depend on IPV6 instead of 
selecting it"), CONFIG_MPTCP_IPV6=y selects CONFIG_IPV6=y. In other 
words, adding "CONFIG_IPV6=y" here in the selftests config is redundant 
if you don't have this commit 010b430d5df5 but not wrong.

Note that if you also want to backport this commit 010b430d5df5 ("mptcp: 
MPTCP_IPV6 should depend on IPV6 instead of selecting it"), you will 
need commit 0ed37ac586c0 ("mptcp: depends on IPV6 but not as a module") 
as well.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
