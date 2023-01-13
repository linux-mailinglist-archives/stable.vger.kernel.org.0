Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10353668BC1
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 06:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbjAMFvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 00:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239157AbjAMFuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 00:50:09 -0500
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8206878E;
        Thu, 12 Jan 2023 21:50:08 -0800 (PST)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-15ed38a9b04so2641922fac.8;
        Thu, 12 Jan 2023 21:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HqNxxa4ScNJGjxk7klGYORSloYPx8oE76dAzC61Lnkg=;
        b=p4ddV0JuptdZOehR2aLRBaoQqTdPD82gOV9LZfuAEKpNKMcBxwrZIcQuogwViTgMHf
         Jgg5sacoH+a8c/lEPE4PCRU3aSEANr/xUDTlDdztqdTmEdrECVJv5r98E+beMgmg/Nph
         9fv3pqdaituhLGakYuu/PCNVr1vINH7F52iEKkgZE8PgA0ApTfTQWgzA5k330/AGnyLt
         CWhlJsPXVlOEzj4fmU4wabll/fhGDG+GNLG7bFQlkIXtu+SODzkJg3/VlKiXWDxVTNmZ
         Ada24r17+7v8SsFi0xMRF98HiHWRFa/bzV2NKz9mLeNND2spHpXhu9kcrq5Et8WP1971
         wR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HqNxxa4ScNJGjxk7klGYORSloYPx8oE76dAzC61Lnkg=;
        b=G73BK4HA64xoubMq7H4O9XHpUihokHmkmdYlwn4l961iJJZzWea4SPKB+9n7zgWgH1
         pzGUYjxYEX73/QYLIhbFa0LUUxZNnCprOXshGx5Esz6Cd6M9bJxmqzm/3jV2FyOzFaFT
         2JIYGrGaK73mi3el0+dbaH+e60WUBogVarFaYnWEhb9ne2+WqTFIgxFua3p4AYzgzrMs
         wZF4KNX0K+8b4zenglLWptuQBM38uK2ankbbYiuKGeNTjUQHAsc1eNnYNNIsWQgJxCVV
         MgKoj9bn/TaOaK5RrqtShO00JtLO++FuxFDrNuMa6c+qmrEv1JtJleO8wWEd9HdW0akK
         jruw==
X-Gm-Message-State: AFqh2krcjam6UQdkr2afjzx6OTTx8T13R3AC6DX+cI7jHh6ZIxREnrca
        HSYDda0I3Fz5GFfW3Tuqcsw=
X-Google-Smtp-Source: AMrXdXvrPax+02d4muwq+NZ+MgOLBQt9PlOqphLu5Zn2AQymj45+jD1po2E+sja4vkq+7XpsFzCFUw==
X-Received: by 2002:a05:6870:9c8a:b0:143:6254:7e6b with SMTP id pq10-20020a0568709c8a00b0014362547e6bmr27157996oab.11.1673589007469;
        Thu, 12 Jan 2023 21:50:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id el35-20020a056870f6a300b0014474019e50sm9926735oab.24.2023.01.12.21.50.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 21:50:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 12 Jan 2023 21:50:05 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
Message-ID: <20230113055005.GA1591011@roeck-us.net>
References: <20230112135524.143670746@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 12, 2023 at 02:45:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 475 pass: 475 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
