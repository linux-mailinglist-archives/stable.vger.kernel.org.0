Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4AC6D85E9
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 20:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjDESY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 14:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjDESY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 14:24:26 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176254226;
        Wed,  5 Apr 2023 11:24:22 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-17aa62d0a4aso39527321fac.4;
        Wed, 05 Apr 2023 11:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680719059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ONtXHsFdkNYgP1HOTNA0FlfkBGs3b4xV19x0hQRzSms=;
        b=YpYX0GN+Nh/RoB4ClA83wZO9sfkDDFUDB8RQcRJh1glosn/bCLWQAcVwr6TBF56CWg
         1gMrOHy/J+eTvX2+IoXBRsWADsXrHrPrU2jsNETWnrY+r59FFY8wyPas/SGegRvZjN0s
         56x+ZNkGRMJz+jDbANPbKi54y7tryHoZ8xYDVlU2jyjSSrpSf6bU4Vp9ujUOrkXc/Njx
         +nlVwTFRxOvR3Ww+CMkYOwZAmZrD4Q8790oXKn90GpNsWLcOoRLUVznuKg7eJTeJeL8M
         u21kIWubNqGi+epoWyxyURJ6LtJvM7Q/UbSmRFLnOqs7X6czOwdFHFxlWczw0Y3Jhno+
         Y2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680719059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ONtXHsFdkNYgP1HOTNA0FlfkBGs3b4xV19x0hQRzSms=;
        b=Gqzy9b4Z+008TkIaduJICWjrz249WKJPEjrz0KKJorH8iDSa397QdRA2AkgehN7pU5
         ctVtYR9yE/U8JtG/lGo0mDA5iz02QalpXp9F8oA/0Ol8HSH6QZLH8HzmL+XJVckle6XZ
         SwNjH5nx6NJPcZcycnNWfI8wOcNwvY40UhHjyNOw5HjHHadtz7Tc21Hivc8lAsBsq0An
         A2flWTMibyHN5HU70pEFHVvc0DLvdyU5a6L84y1bFAzAaVQvOuJb7r4ZkI4WDby85UnF
         c8I/VgtHI0TGyYsK6qx7/E3eGlIiUS3fke+NVPhRsCRzRtgccu6r4P0pc8lUJR5zWl4L
         JzIA==
X-Gm-Message-State: AAQBX9dEc30VjPesBe5GHk4Ng3FGtN4bZCCvlg7KmRdY8pMCHMYZLnK9
        kSvkeQMP4F2eFIX/b3CbpRg=
X-Google-Smtp-Source: AKy350bDmas/yzxcH3Kf/5PqXkUJUvVJpjI1WNx8Mz5HkO6lYyL07ItMMKVTA08EYa7t1nW8ThCyag==
X-Received: by 2002:a05:6870:2181:b0:177:a15a:4d5e with SMTP id l1-20020a056870218100b00177a15a4d5emr4487368oae.37.1680719059618;
        Wed, 05 Apr 2023 11:24:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id vi17-20020a0568710d9100b001803597b4cesm6075364oab.55.2023.04.05.11.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 11:24:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 Apr 2023 11:24:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
Message-ID: <b1ee46c3-7a3a-492b-8547-3d608082d78c@roeck-us.net>
References: <20230405100309.298748790@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 12:03:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
