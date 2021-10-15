Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D62542F572
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 16:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240274AbhJOOeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 10:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240258AbhJOOeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 10:34:04 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0D6C061570;
        Fri, 15 Oct 2021 07:31:58 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id r7so26903938wrc.10;
        Fri, 15 Oct 2021 07:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XJNN4VdZAiBc08MqPjE+ShgOHpagetvy69mkQhuA4io=;
        b=io3QGmebI2Ns3aTAQHR3LLlM25zz2mepPC9bXphxxD78NgI31V7FyK1zzcPL+RYExb
         P8gxwMNouoV0r4F3D4YAywUMqdg2wyS0B1Uwn6IJu5Q4VgK++axUkAcTAswa9gONYSXK
         cGFamPykxuLZ/YmX6wvVngTbyHEYm0PggpkYI6neZewSlBWhW7fbxYAzrb8LdZrQpC0N
         AU9d51il0oT7c79E4inzJYZKBlR3ZSHMkLeHCbmcqxeDDNbxirEN36K7KmmJj1WY9Tv4
         FaOTeaLUu5KvbSBMiOJaGGzgBrje0wsbgn6LDAvsfcITiyevHTS2I/Ol1Zgi/ONNw/RH
         nxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XJNN4VdZAiBc08MqPjE+ShgOHpagetvy69mkQhuA4io=;
        b=6OsfxuCANXHQgHOGO3aurvGbxtHnxDuUoyYQVGcWljuXBxS1mqFLq1a7j7o+NfgbJG
         BpEh/8hxFolHR9ZyvNFKJHJpkUM+rsfZ8De+kO1TixagdpDcz9LLT9CWkKDPM7YUzu7s
         iDJhCmyElkqPD5XUA/lVjeM64EqTwMjdLuw4vSaPpYgoQVZ+CegYnPvCeMGq8sYhI6nJ
         xTBjpOowMbgFNxNZqTnV5iD4BbTrLm3H4oXLe/qgh94fPFSZ0Z/OfJ7syTShb2h+95BL
         at2qQNE8R1JTnlhWgQkKyYio1ZiRBHEHXv2BtRgNe/WY4IpOaSC9sNZFbuNocJ1jJWhV
         qMDw==
X-Gm-Message-State: AOAM533zMIWX9fA312/UK9kG2YcJcYR4S/4/WEYGmOMStD7lISrLm+PC
        1AFaQtj4Ub2edzLR0weL5hw=
X-Google-Smtp-Source: ABdhPJzDeq5w/SbEClmsjQvoPPtV4GcUF5wDmWV/1Its98p6hrpLQFFJNuyZ5Jqw7RDKpsGmqZPKgQ==
X-Received: by 2002:a05:6000:1565:: with SMTP id 5mr14681250wrz.305.1634308316736;
        Fri, 15 Oct 2021 07:31:56 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id g2sm5099641wrb.20.2021.10.15.07.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 07:31:56 -0700 (PDT)
Date:   Fri, 15 Oct 2021 15:31:54 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/16] 5.4.154-rc1 review
Message-ID: <YWmQ2l3RBEctI5mM@debian>
References: <20211014145207.314256898@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014145207.314256898@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Oct 14, 2021 at 04:54:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.154 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 16 Oct 2021 14:51:59 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 65 configs -> no new failure
arm (gcc version 11.2.1 20211012): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/266


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

