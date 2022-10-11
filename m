Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B481A5FB75F
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiJKPeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiJKPdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:33:10 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB2511C258;
        Tue, 11 Oct 2022 08:22:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id l1so13472848pld.13;
        Tue, 11 Oct 2022 08:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0pjEyusNlUHButloHOL1cIYkEB9+mxrOU7C6OaQWaiA=;
        b=XxO4ngT5naH4u56bjTr2LkVvIKFys1hAj8hsacDNMPUWBbhGlKbAKgxOREzHsQlhrE
         /vmOwurvrmNF7tisft7R3P3Xs2Pm3Da2RGVWPevQgBwXGKsaGln5C7mj0YGDk0g96TXw
         GteyZlTslUF4/BtE0oIllj/Y/LM6sVZYniAKAPsCpnxWt94S3NVu3Doo+ldkgyZ5gSSd
         Y/Hy6TICWk/RoRD9cCjPCA/9mr83Yu8jN0QSQSEfHakbh5G/BFzAo/nQbR3JbYs6UvYT
         oX1+2kmZgAUa4yysl0SyAn+9yNqsBcWL+HOjgANUp7XQAWdeJj16G8shIFCHehs26ygl
         yICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0pjEyusNlUHButloHOL1cIYkEB9+mxrOU7C6OaQWaiA=;
        b=Woh+YWQgGqT/1zxSIkDQxWZZFGTSprpBsTy9w/MAbb8vz/A6FyPn3h6p+MPNtFzjHk
         e1Z1sejWljvYJsxi4afVb93GI7Rqt8O5zi7+k3EkzxuIuR7NF+w0Q05CVzfDbqoUYM2v
         vxo/uQX1EjqAWstq458z+/7UnBbeLriZP24pXf1OKaTbXG2y0i55P6lsegW3SSy2gjbL
         XbbTHMlq4Sc7xdkwwx9gPafaoX2dRVCmGwZCOBmg+fEdharQZhsYINauZn3v4Nau70ey
         /TMW/3o68tYboyXiNvm1Mi5CKfye56CQ6cnUXOok4Yi26tz8Kv7xd0Bi0WgNvATLFBTy
         sm3Q==
X-Gm-Message-State: ACrzQf3lGgoCbt6XAU9I1vKX9e1qYzYqlBZtbPbkZ3NVVf0XFBVA4Uyj
        81jwKfGmPt8rZwxIgMt18lY=
X-Google-Smtp-Source: AMsMyM4lHvQn2Nu43BbszQmSeteMUuTiyaoqniX0iM2g3CkD0jYxqax+eUg0t6JDKy5qoGCVWMmsEw==
X-Received: by 2002:a17:903:2342:b0:17c:ae18:1c86 with SMTP id c2-20020a170903234200b0017cae181c86mr24194093plh.5.1665501755115;
        Tue, 11 Oct 2022 08:22:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902684700b001769e6d4fafsm8733413pln.57.2022.10.11.08.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 08:22:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 11 Oct 2022 08:22:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 00/46] 5.19.15-rc2 review
Message-ID: <20221011152233.GB3994805@roeck-us.net>
References: <20221010191212.200768859@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010191212.200768859@linuxfoundation.org>
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

On Mon, Oct 10, 2022 at 09:12:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 490 pass: 490 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
