Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139DF645C8B
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiLGO2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiLGO2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:28:19 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC16358BEF;
        Wed,  7 Dec 2022 06:27:54 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id c129so20946967oia.0;
        Wed, 07 Dec 2022 06:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vtPX/PeXD/CT3jETn94lbUFp/CKvHFvwMs0e36odJZQ=;
        b=KqIcB13Vh7JZpRWe/CFunigv5/0N9QhsbuUVVPh0iOIKb81oXQ+zUzXkIAMTr35hWW
         EAIBvcY0lMfV2AvQiiC48lQvNvYxcAY//h+wA7qJ0lGPjaeEzy2NRDARFxbHFL1kp3KJ
         qJ9zJ6e7IDkKFwHdLhqixRE/x4Hrh1NsW7c3h8tF19Q4t+IJCQC8g5IbUdsHwiocwWBA
         MJir1IYTyizzDVassFlAC8EoViBcbh7VMbbzponKT4uCIkoyUpabPOM+H1lCLPyXpQ64
         v4l2UU4ErcKSP/2krgV+6C0b+PkTRIm0dO3uu4GBKA1VN9YtxY+yPDSdeefPKRRut2+r
         ByoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vtPX/PeXD/CT3jETn94lbUFp/CKvHFvwMs0e36odJZQ=;
        b=tbdBbAclAZKa53vWZYT1WrJGOdd2Fk94m2ro4V/JpFx5n+R8Ldmn87Wh/wBJZbYegI
         BZjF7bbXK8xUq4DWVW/Y9s3ve5nUDpP5Z2rBj0pw2qCCIOp+wk3cmTZ6mN21bJBMa1FE
         ApG8ZHnmntf3zHbryHPxKjWMNazw5vNCbTBsmBRdBkk4fylRkfIs56CRZU7Zw8iV0dui
         UqHC2Z1R2Wyrd3A3jdjVR6HLgJzCTgXtAnhQ6mDbWeNOb9F/CJXWTlczY1ViFUjD0fKS
         +TYXHg4LyWQ2lK4FeHLZDvgq1IRPF6R9EafRo/yt8dk2Wfr6PAX1Z8HQ3WKrnAMNFbmo
         RzsQ==
X-Gm-Message-State: ANoB5pm/aKEF/KEnZ3QDsI/MdqkaWqzuNhpWAeJQNf1yBXXvkUYtKopM
        DWGj/FlEon+lxs0JksKh9to=
X-Google-Smtp-Source: AA0mqf7QIRnirBgGVxMO0y16NszEEI8vdPkjJNUa0yuqyoT3FBCqgdmWBmJyfI39/5Y4AdBs6VDHZQ==
X-Received: by 2002:a05:6808:1584:b0:35a:774e:d352 with SMTP id t4-20020a056808158400b0035a774ed352mr35544840oiw.193.1670423274021;
        Wed, 07 Dec 2022 06:27:54 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v188-20020a4a7cc5000000b004a066f9a7b4sm8977711ooc.34.2022.12.07.06.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:27:53 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 7 Dec 2022 06:27:52 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/125] 6.0.12-rc3 review
Message-ID: <20221207142752.GG319836@roeck-us.net>
References: <20221206163445.868107856@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163445.868107856@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 05:39:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
