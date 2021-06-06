Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8216339CFEE
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 18:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFFQGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 12:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhFFQGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 12:06:44 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CB1C061766;
        Sun,  6 Jun 2021 09:04:40 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id r13so8391748wmq.1;
        Sun, 06 Jun 2021 09:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dps3SYyPvrpPDaumkd4g4ZpYXHif5pvKl1r5pTSaVxo=;
        b=RFTyE8I7lCbX9/t8ccQmosQTtQ2z07aWs7rWnhtg2w0y/0hF/F8v9tdFufa1GS+vi/
         Bf7aOtDV0AnYdcUy0Aidy8c89/g4ozvTxRmBshLbCR04VZ7DpZaGpeP+NWw6Dzwmxj9w
         J0cfoeiUmhpZe3mNmax/hjq+21Bx9e0TExqUwPcr5hzUBiBwx1ZcPzaaiAKq12NCoeym
         Z+7YOoGuThBYwfTHDaTflJMBBJqrCiOSTI51vpahatYR2bZBpzIkldGa0c/Jk8TWuyiC
         IoMtbGSQSUjT6iIcWq6uexcqAfjHtC4/FZQd6tomdF+kGRuuWpNPd8Dv3QmrqSEd2+NJ
         tq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dps3SYyPvrpPDaumkd4g4ZpYXHif5pvKl1r5pTSaVxo=;
        b=k1PnpPHkFCHbyi3F93quXEV4rD5cmTrkQsMZYWaLqdBU/aiZI2jrQhLWk7Ib0r/lnm
         CsRH1eY5LR3NTAza1OiesV56CNSQvkOZmbrytYdAdaXRfKFw40D/yFxt1pt5y7jRoRGL
         9yQO+V/hKpo1afWCo0EpK5vRU0meTTJez70a2V4lkhflfwlF25sf8lY0nfhCal5v7kFd
         y6ykOKetSQUaS5ssDbNwvQrWELrW+LKJbjT3jPEo2EMxHGIoKAlBtW9ow0Xx/BCCRaGo
         IXXyYtFea1mZtG20NrX3mTATlHB0QJhGRoDO4s/aIhfIjMWA8vAehVqU6QYT1DVmAUvx
         HhsQ==
X-Gm-Message-State: AOAM531wg560W57IVVL82XtRwj+GuHUMnPCVDIbuRinpXAQ1Vf8YvaHe
        cRYQGUP4Qyg0EgXMhquR1PrU6APfD/MtsA==
X-Google-Smtp-Source: ABdhPJw1zXx5x4rCWVUin281MFlfYrTZRfNIchXpWQrBVFOHppcRsER4RZcjRIUMGQIRr4r6/9EYpA==
X-Received: by 2002:a1c:d5:: with SMTP id 204mr12833776wma.144.1622995478819;
        Sun, 06 Jun 2021 09:04:38 -0700 (PDT)
Received: from [192.168.178.196] ([171.33.179.232])
        by smtp.gmail.com with ESMTPSA id t4sm13074142wru.53.2021.06.06.09.04.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 09:04:38 -0700 (PDT)
Subject: Re: Backporting fix for #199981 to 4.19.y?
To:     Salvatore Bonaccorso <carnil@debian.org>, Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
 <YLiNrCFFGEmltssD@kroah.com> <5399984e-0860-170e-377e-1f4bf3ccb3a0@gmail.com>
 <YLiel5ZEcq+mlshL@kroah.com> <addc193a-5b19-f7f3-5f26-cdce643cd436@gmail.com>
 <YLpJyhTNF+MLPHCi@kroah.com> <YLzAw27CQpdEshBl@eldamar.lan>
From:   =?UTF-8?Q?Lauren=c8=9biu_P=c4=83ncescu?= <lpancescu@gmail.com>
Message-ID: <3f78a7b2-1b5a-17d2-b862-09fbb53fa409@gmail.com>
Date:   Sun, 6 Jun 2021 18:04:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YLzAw27CQpdEshBl@eldamar.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Salvatore, Greg,

On 6/6/21 2:34 PM, Salvatore Bonaccorso wrote:
> Instead of doing a specific backport, maybe it is enough to pick
> a46393c02c76 ("ACPI: probe ECDT before loading AML tables regardless
> of module-level code flag") frst on 4.19.y and then the mentioned fix
> b1c0330823fe ("ACPI: EC: Look for ECDT EC after calling
> acpi_load_tables()").

Many thanks for looking into this. I cherry-picked 
d737f333b211361b6e239fc753b84c3be2634aaa and 
b1c0330823fe842dbb34641f1410f0afa51c29d3 on linux-4.19.y, they indeed 
apply cleanly as Salvatore wrote. I also compiled and tested the kernel, 
the battery is correctly displayed as discharging when unplugged, with a 
7.5 hours remaining as expected.

Does it still make sense for me to resubmit my patch with the "commit 
<full SHA1 hash> upstream." comment fixed? I would trust upstream more 
than me making one commit look reasonable while missing the other commit 
it was based on. Greg, what would you prefer?

Best regards,
Laurențiu
