Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABAF44AA96F
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 15:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380140AbiBEOaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 09:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380134AbiBEOaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 09:30:16 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E3DC061346;
        Sat,  5 Feb 2022 06:30:15 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id c19so1861654wrb.10;
        Sat, 05 Feb 2022 06:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Rr7SNuJfyvTmd1gk6T6DH2dcNvpgXi8j5vUG2bS0No=;
        b=RPf1kcAJ6QsiFXoggZLbCsneowz21qYzWHUsO9zQoynTSoO9GxLSY6aDCZrO6JN+nX
         BOJX7iW51iGpOIMSXO7woDvbszCZVqykVm4Ks0lZfAjh9QLrveNQvSMdR72zIWxmAjKY
         UUUb7vnnb001Nu6tHRoWtZWvnCNWTBQ7EDaw2tlQzjWRweK4OBsU/OagXGX2+S1cBFRZ
         /9XMt2LAqCTaaW3FjmaVkjSS2OsJKhHKKr0vs3FexGU0nizlG8GBzq/5Q+/2Tw5Z6O3F
         tDaGJvVTuv1/e8V9agoi5kVGEnVRhk/bcETXzbGrTsRelMMhgGQ2NyZUvxyhuJocEpUA
         3hsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Rr7SNuJfyvTmd1gk6T6DH2dcNvpgXi8j5vUG2bS0No=;
        b=jyU+6Q/JJm5k++YUN6yDJDPOxJdrqQFVGrj9x0sSpUB0a1FjGyVRkwb2aWeyfz4c9W
         PFyVWOIVCLJLqQdP+jAYWQEOaMMoRDuuMJIFXhPVySzuU/2NU80zVZheYrGUq63euBV9
         gpcarQNdHJs/Ifp94IPkzUS903ZrLmgzq6cbjou8lcqp6bq0PRV6ZPw/Q3ARaJFi2yW9
         MZv07eCk96DEGrXxdXIwpiwmwMYWacIoTlGB5P3TuYpNmeoQe4h2i0CyEP0JgmJx2+3B
         IKdhpMnKp94aZ637eWHGDe3a7FX+/Kw1Uj/n3MIeiKHXp98ESczDYCE/KNJCfpfmWCYP
         ChuA==
X-Gm-Message-State: AOAM53264bBvYiwkbeelo4TBNItNfLfUOxm5DND/+pZqq3PxjV7FOyNo
        DVoNgMUH5aQe+cSDylfTfcM=
X-Google-Smtp-Source: ABdhPJzNU3pC58ny2TBLTrgK+qKNtoTPBOWCsIiiyeylZXg0KVDh2oCmISGJKkHtXrRp/J/QO6F2KA==
X-Received: by 2002:a5d:6acf:: with SMTP id u15mr3200888wrw.483.1644071414432;
        Sat, 05 Feb 2022 06:30:14 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id l14sm39220wrs.55.2022.02.05.06.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 06:30:14 -0800 (PST)
Date:   Sat, 5 Feb 2022 14:30:12 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/25] 5.10.97-rc1 review
Message-ID: <Yf6J9D/OdjvgrFm5@debian>
References: <20220204091914.280602669@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Feb 04, 2022 at 10:20:07AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.97 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 63 configs -> no new failure
arm (gcc version 11.2.1 20220121): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/707
[2]. https://openqa.qa.codethink.co.uk/tests/711


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

