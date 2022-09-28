Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113085ED299
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 03:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiI1BVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 21:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiI1BVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 21:21:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A031D1114E4;
        Tue, 27 Sep 2022 18:20:59 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so413600pjs.4;
        Tue, 27 Sep 2022 18:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=ajbZ5HLZ06pdOvTQdSBVXgUUdflpfaQz4rHKEcbISDs=;
        b=MB+JvcZLZg+LYRnOF7BRRIOHCBabBXOyXsUOJFpfbN6UlaaVulajD/16XTC6IlGtUY
         BvE0yyDiFIP1OO4PXTezj30k0ucq7yMDvoUgAWtOqYPPc2JI0naNyYQWADwG8JCUc9aw
         ENKtlcr8W6ZBJz78DPoVwZku9EfnbicQa2rY2TZSvekStZot8mWhl3VEzjNxKSTw9NQe
         AKluJJ56qUL3N4owkW2C+CFZCS26mZ98OKI4DkXoDu3UFH55nInNS9JFNiKBR8hcv82a
         T9hRd5fJ2PQvS3kTdxsv1pCj3sb/wVUrghM3RGnBkqca9V+KYLlYsxPCG2foi0p1yVBR
         K7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ajbZ5HLZ06pdOvTQdSBVXgUUdflpfaQz4rHKEcbISDs=;
        b=S2sf7iijrobrxbFe1tgjXDANwemOpANcElL2KnOMuSfD4G/iyND2KG7mO80bGi6D06
         mBk6/zr8uNIDbvvh2PI/vXieWpNa/FoQ7J7J+l9jjZGHXSZbwYly9lceEZ+m8lz1P88+
         By+K2k0a8P5qE8tUstiHbZBaQPsz9pvCX/yzqoCRna0Phs4HjWbY/OIOopvQf6RmgAQL
         bu00jI17DiTnYqdmt8cqVp7cpU0BvmHtHdnczx0SrduucLPge6jRTY0dibAXLLGh8sed
         XdstF/bS0u9Uw0XCKzC8VmsBG7mUJ95xf2UfKPRKKqxzJWoDAHMArWjq0dx9hKe/yPZX
         wQ0A==
X-Gm-Message-State: ACrzQf0Q+ykioQCNtgbvbbnh/6ahc746qNMb68eo2eRezoeW8bv7LQeE
        C3bXOnDaKCRBeR1SG9Vtw4g=
X-Google-Smtp-Source: AMsMyM7k9ekvqClkMI8lSb4Yt5lstl5lCk7CIw7/r5FKW1dXF9SlX18bHGL2Smqdjpe+O2dASB+fvw==
X-Received: by 2002:a17:902:c941:b0:177:e69a:a517 with SMTP id i1-20020a170902c94100b00177e69aa517mr29994541pla.144.1664328059116;
        Tue, 27 Sep 2022 18:20:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y63-20020a626442000000b0053b9e5d365bsm2459398pfb.216.2022.09.27.18.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 18:20:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Sep 2022 18:20:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/143] 5.15.71-rc2 review
Message-ID: <20220928012057.GF1700196@roeck-us.net>
References: <20220926163551.791017156@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163551.791017156@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 06:37:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.71 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 486 pass: 486 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
