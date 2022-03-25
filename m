Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279374E7DEA
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiCYXPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 19:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbiCYXPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 19:15:14 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D1137BF5;
        Fri, 25 Mar 2022 16:13:37 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so9819029pjq.2;
        Fri, 25 Mar 2022 16:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=S2TUHjJcp/oGaKnVbGDY3RcwhDwH+pqo2GZBOrqWFEg=;
        b=UCO13osbHSEnD2cPKGAmcgTXPH00HJ035FKfH0KYWOPtnOZUhVt8TgVeIps/VlMDNX
         6jpM3rMjztL2SbSFHvNreuc/Aj7K/52xeO53NRToZVMBAjK4ouee0AqnkKy+Xr33noIF
         YSL+5eA6fzm7jHZu9vCzsVY1nxRO0nbGkVnh/ybWs18ZsmevPAJuX+Q1PGZoy82SmsmR
         MbOv3mx6G0tklwXGgWylE2OK/3LYZ5O1hJ3KENTonMcz3MPCyb6PiC+ZLoZkXATPt7M8
         0PgfAhMlhB6v00cCKaa/NIhlbnzmvvuGNAisY9u6yau2nclYAhbgx4XbZMQs9DaKqFk3
         +i+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=S2TUHjJcp/oGaKnVbGDY3RcwhDwH+pqo2GZBOrqWFEg=;
        b=0//GmsTMM9HegbvV2L3rQthLwT2MQ2BKeK9vfOB8PXTCQgzpnuwG08ZzMMZzxahh7J
         TlLwjDyMhYTOC4hvJ/5v4N0doquKXhVAqPuonWCW0yyiKlI0xxjZTYrOx5i9CoFZr+NI
         mJwhmxJ9j1lTj9IgxQI0iYYlfWkb7PX+k+JLLc0ZyGpvEbbI0iX3qXs71uKcXIWtDETy
         aH/o9LhvicjQn1UVAorODglID1u2t+nPd6cUBm5lI/bUN2UPzU4j9ypVBjgK2Q7AFw/8
         b4Nw8PzmmV0WONAYwti/vmZWRWdc9AvcHSKiLBjbKwCsN2lBtALtiBkB6odBT3uWW8hg
         zY5A==
X-Gm-Message-State: AOAM53307yELvvcjUwZCxY4r+yWq7SxrFUgAT4gICF0hlRZ2GoD2E4T9
        UqOx88f/N2zryuAiz0QhsU7Hq0rXsjJE0o+2FY0=
X-Google-Smtp-Source: ABdhPJy+fK9c0T3iDayz3GJQO6mqoFKFCCKEB3pOzj4VwOPcLscrQGYeMrczctLIzJPLkiCLQ3xVVA==
X-Received: by 2002:a17:902:9b95:b0:151:533b:9197 with SMTP id y21-20020a1709029b9500b00151533b9197mr14332534plp.66.1648250016335;
        Fri, 25 Mar 2022 16:13:36 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id o17-20020a639a11000000b0038160e4a2f7sm6810795pge.48.2022.03.25.16.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 16:13:35 -0700 (PDT)
Message-ID: <623e4c9f.1c69fb81.b1147.48c5@mx.google.com>
Date:   Fri, 25 Mar 2022 16:13:35 -0700 (PDT)
X-Google-Original-Date: Fri, 25 Mar 2022 23:13:29 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
Subject: RE: [PATCH 5.16 00/37] 5.16.18-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 16:14:10 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.18 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.18-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

