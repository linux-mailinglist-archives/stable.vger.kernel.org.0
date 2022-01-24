Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A8949AA1D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243288AbiAYDc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1321192AbiAYDP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 22:15:58 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0B7C0E9B97;
        Mon, 24 Jan 2022 14:48:44 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id h12so17807796pjq.3;
        Mon, 24 Jan 2022 14:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2U/8DYGL090LEe2kk8stQI2Ud1/LbI8mVv8nBxOTVk0=;
        b=SCy31hux4wYZUjl1mQCGsAYnmGP8MS09esRtEf0uAgEGq/0+PpvSSeQug7QuEemUJ5
         K9mym8A2R42TPh4uSLcWwice1TqlW0N/bYhBTM35LB0lJ5WqbypcnhaIbpXuBY+mZhR1
         bN7GCWDrY8N8GymuQfO+l+OWYGAns/glHxGrlr1a/i4wF1vyZeomj9fG2hQqGgMOy2Mv
         eWZTJm7gUgyv4ZKLJ3Ce0gijKUw+mE3mLN0wx7O3ENBplcak93gcJLuo7k6CvCgoVHKx
         D/Td5yU0zvLN+fQ2scGZ+kEVMbWs2/OZ2m3/NZM8m5uX8zrI+xJy8smyvMtrwjaLIo9x
         DytQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2U/8DYGL090LEe2kk8stQI2Ud1/LbI8mVv8nBxOTVk0=;
        b=baaCKqVzFUZLEPUzZqHCITmmiyU3/LyJsAeh6/04A+PIZ9zf2Dt9h3PRWYWOEk/PSY
         BRa7mHm5t20Rn1yqvQpSNcc5/0JkVBmdfZn8J1bRMFoaD+zSKb5kRNtTBlRmQvx0FyUG
         1xWVxRRi0uMlC2qb1xCJ1rf4AbTKsTEBgN/yrdn826hqUaaSqwWPspYyY1QbWPpmODLD
         2iRU95tYgxAX/BZauW5WaTKw7m0Y8lNdB5p529TVV72F/wB8JBF7iThIvy+r8TC6+y1F
         xXwhWPrtM2JTBKC+rZE+hVOt0cnLt234R/SZwjq+nvViQtV/9WFcgLTp1/HryfRutl5j
         SV7Q==
X-Gm-Message-State: AOAM532sZAM72yv7wO/pjaQtyV01KGKJmul07F2g//SLD2UuFXJZ2t3o
        bc+PcTKQrX0sS+VUKyGXffp3V2WYErE=
X-Google-Smtp-Source: ABdhPJwoETm2C6v0ZHW+1FJIIwDKXjxr/4H1UbB5BOgnodoIZ3vFd/wSBUnk7Z1O0NQkwBZTBamYaQ==
X-Received: by 2002:a17:90a:9a7:: with SMTP id 36mr485057pjo.154.1643064524350;
        Mon, 24 Jan 2022 14:48:44 -0800 (PST)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id nu7sm342266pjb.30.2022.01.24.14.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 14:48:44 -0800 (PST)
Message-ID: <ba541d48-826c-3d39-b3e1-05642fa6edd6@gmail.com>
Date:   Tue, 25 Jan 2022 07:48:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.16 0728/1039] scripts: sphinx-pre-install: Fix ctex
 support on Debian
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <sashal@kernel.org>
References: <20220124184125.121143506@linuxfoundation.org>
 <20220124184149.801920838@linuxfoundation.org>
From:   Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <20220124184149.801920838@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, 24 Jan 2022 19:41:57 +0100,
Greg Kroah-Hartman wrote:
> From: Mauro Carvalho Chehab <mchehab@kernel.org>
> 
> [ Upstream commit 87d6576ddf8ac25f36597bc93ca17f6628289c16 ]
> 
> The name of the package with ctexhook.sty is different on
> Debian/Ubuntu.
> 
> Reported-by: Akira Yokosawa <akiyks@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> Tested-by: Akira Yokosawa <akiyks@gmail.com>
> Link: https://lore.kernel.org/r/63882425609a2820fac78f5e94620abeb7ed5f6f.1641429634.git.mchehab@kernel.org
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This "Fix" is against upstream commit 7baab965896e ("scripts:
sphinx-pre-install: add required ctex dependency") which is
also new to v5.17-rc1.

So I don't think this is worth backporting to stable branches.

        Thanks, Akira

> ---
>  scripts/sphinx-pre-install | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/sphinx-pre-install b/scripts/sphinx-pre-install
> index 288e86a9d1e58..61a79ce705ccf 100755
> --- a/scripts/sphinx-pre-install
> +++ b/scripts/sphinx-pre-install
> @@ -369,6 +369,9 @@ sub give_debian_hints()
>  	);
>  
>  	if ($pdf) {
> +		check_missing_file(["/usr/share/texlive/texmf-dist/tex/latex/ctex/ctexhook.sty"],
> +				   "texlive-lang-chinese", 2);
> +
>  		check_missing_file(["/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"],
>  				   "fonts-dejavu", 2);
>  
