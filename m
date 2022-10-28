Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB033610EEC
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 12:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiJ1Kpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 06:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiJ1KpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 06:45:19 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E9F5603B;
        Fri, 28 Oct 2022 03:45:18 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id f7so1604977edc.6;
        Fri, 28 Oct 2022 03:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dLBIpFQFCCtDMk9X0sNN1QNG1NRCfa2VZ76WZoXVN48=;
        b=WIQtlKrVQQvFqiZh2ZIpzJ86Lr7Ta42awBU4887QoCC6Qzci9x+zzXRUQbV1I1SBSN
         pa28C4Y5gkSwYV8laCGq2Vxo5Ddt4FGYbicK96dvPFwbcpJwqAuU7XLsiszpLRV8rv0W
         EXzPbGiLQD2CWF72epKrqouEeXD7YUx/gzIJcifvCOjIAXpUleTOBRbxgAwsncf9gQWS
         4nrnZg6h9+zHMZpNPRGltlnNJ4nt59ZpTWOd0bFzpPzaHwoy7nJBtKlkNIjJ+LR3mx4P
         LJrjt7UIL13xRKnYkAvxStf76ldZwK82CU6FA+Diwx39LGc6pE68TC5X/lX6/1b0bGte
         ltpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dLBIpFQFCCtDMk9X0sNN1QNG1NRCfa2VZ76WZoXVN48=;
        b=gXf3NmO4f5gatZmOvMUgGXxdUg534suJYjc0ztgFS53GI0v+RS9JXuvowL25H/W6dX
         0V8s7W8T3xfn/19TBFMKG+SRBZKWyx8JHQT/aKXqNdOXfWqXC9EHAG3xt226wxNpDVid
         hr4P9vctKOEjSNmMUOL7S0BzSb9wQsnHoqH9HLIu9ZNr4ykUNKhbrKE3VL+TrSUJRek4
         zuygpwUCcohmDEv0d0V5vqXZop2FcNVHxz+cbjPGhmjDGqIB/wz4fJMliJYnCKzFAgb+
         KIUolaYZ2H+wNmb/E0DYDE5uvSjpC1A4yRdtbIysoiNsPOSK8GLGHKlf3Ry9Be9AYgm1
         P/AQ==
X-Gm-Message-State: ACrzQf3gIBBZpQMQaIT3SeHxCtV9Jbd5iIZrOaOrnWI6CbtY04JJM0ee
        uUwU+aq6ZLg4GkrJNWlYKrmq1MVytwjSy2mViO4=
X-Google-Smtp-Source: AMsMyM4w0QCenQ++V8j+5NeFA/LOJ+bayADVUZ9D9fNJZ7vJxlu/zVyjRBGmFkXy5Y3ctkb31tMUNn2pxqKfGt768Oc=
X-Received: by 2002:aa7:d80a:0:b0:462:2c1c:8716 with SMTP id
 v10-20020aa7d80a000000b004622c1c8716mr16462827edq.185.1666953916705; Fri, 28
 Oct 2022 03:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <20221027165054.917467648@linuxfoundation.org> <Y1uxn8/y6AjCu4UU@debian>
In-Reply-To: <Y1uxn8/y6AjCu4UU@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Fri, 28 Oct 2022 11:44:40 +0100
Message-ID: <CADVatmPTjngRzhkMRbRCU=Ca89AtJxsDWnPKLm9Ec-5Chp5E3Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/79] 5.15.76-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 28, 2022 at 11:40 AM Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Thu, Oct 27, 2022 at 06:54:58PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.76 release.
> > There are 79 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.

<snip>

>
>
> 2) Already reported by others:
> /bin/sh: 1: ./scripts/pahole-flags.sh: Permission denied

Ignore the "pahole-flags.sh: Permission denied" please, its only in 5.10.y


-- 
Regards
Sudip
